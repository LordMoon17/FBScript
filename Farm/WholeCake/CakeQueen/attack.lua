local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local replicatorNoYield = ReplicatedStorage:WaitForChild("ReplicatorNoYield")
local replicator = ReplicatedStorage:WaitForChild("Replicator")

local M1_BURST_COUNT = 5
local M1_BURST_INTERVAL = 0.12
local M1_CYCLE_COOLDOWN = 4
local ABILITY_ORDER = {
    {name = "RocGun", cooldown = 13, range = 3.5, windup = 0.06},
    {name = "RocGatling", cooldown = 17, range = 3.0, windup = 0.08},
    {name = "RedRoc", cooldown = 35, range = 4.0, windup = 0.08},
}

local function getBossRoot()
    local boss = Workspace:FindFirstChild("Cake Queen", true)
    if not boss or not boss:IsA("Model") then
        return nil
    end

    return boss:FindFirstChild("HumanoidRootPart")
        or boss:FindFirstChild("PrimaryPart")
        or boss:FindFirstChildWhichIsA("BasePart")
end

local function getCharacterHumanoidAndRoot()
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    return character:FindFirstChildOfClass("Humanoid"), character:FindFirstChild("HumanoidRootPart")
end

local function alignToTarget(hrp, targetRoot, range)
    local targetPosition = targetRoot.Position - (targetRoot.CFrame.LookVector * (range or 3))
    hrp.CFrame = CFrame.lookAt(targetPosition, targetRoot.Position)
end

local function castAbility(hrp, targetRoot, ability)
    alignToTarget(hrp, targetRoot, ability.range)
    task.wait(ability.windup or 0.05)
    replicatorNoYield:FireServer("Nika", ability.name, {})
end

if getgenv().CakeQueenAttackRunning then
    return
end

getgenv().CakeQueenAttackRunning = true

task.spawn(function()
    local nextAbilityTimes = {}
    local nextM1Cycle = 0

    while getgenv().CakeQueenFarmEnabled and getgenv().CakeQueenAttackRunning do
        local bossRoot = getBossRoot()
        local humanoid, hrp = getCharacterHumanoidAndRoot()

        if bossRoot and humanoid and hrp and humanoid.Health > 0 then
            local now = os.clock()

            if now >= nextM1Cycle then
                for _ = 1, M1_BURST_COUNT do
                    pcall(function()
                        hrp.CFrame = CFrame.lookAt(hrp.Position, bossRoot.Position)
                        replicator:InvokeServer("Core", "M1", {})
                    end)
                    task.wait(M1_BURST_INTERVAL)
                end
                nextM1Cycle = now + M1_CYCLE_COOLDOWN
            end

            for index, ability in ipairs(ABILITY_ORDER) do
                if now >= (nextAbilityTimes[index] or 0) then
                    pcall(function()
                        castAbility(hrp, bossRoot, ability)
                    end)
                    nextAbilityTimes[index] = now + ability.cooldown
                    task.wait(0.05)
                end
            end
        end

        task.wait(0.05)
    end

    getgenv().CakeQueenAttackRunning = false
end)

print("Ataque a Cake Queen activado")
