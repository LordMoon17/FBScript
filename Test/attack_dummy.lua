-- ============================================
-- Dummy Test - Attack Dummy
-- ============================================
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local replicatorNoYield = ReplicatedStorage:WaitForChild("ReplicatorNoYield")
local replicator = ReplicatedStorage:WaitForChild("Replicator")
local TARGET_NAME = "Respawn Dummy"

local M1_BURST_COUNT = 5
local M1_BURST_INTERVAL = 0.12
local M1_CYCLE_COOLDOWN = 4
local ABILITY_ORDER = {
    {name = "RocGun", cooldown = 13},
    {name = "NeoRedHawk", cooldown = 15},
    {name = "RocGatling", cooldown = 17},
    {name = "RedRoc", cooldown = 35},
}

local function getNearestDummyRoot(fromPosition)
    local nearestRoot = nil
    local nearestDistance = math.huge

    for _, descendant in ipairs(Workspace:GetDescendants()) do
        if descendant:IsA("Model") and descendant.Name == TARGET_NAME then
            local root = descendant:FindFirstChild("HumanoidRootPart")
                or descendant:FindFirstChild("PrimaryPart")
                or descendant:FindFirstChildWhichIsA("BasePart")
            local humanoid = descendant:FindFirstChildOfClass("Humanoid")

            if root and humanoid and humanoid.Health > 0 then
                local distance = (root.Position - fromPosition).Magnitude
                if distance < nearestDistance then
                    nearestDistance = distance
                    nearestRoot = root
                end
            end
        end
    end

    return nearestRoot
end

local function getCharacterHumanoidAndRoot()
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    return character:FindFirstChildOfClass("Humanoid"), character:FindFirstChild("HumanoidRootPart")
end

if getgenv().DummyAttackRunning then
    return
end

getgenv().DummyAttackRunning = true

task.spawn(function()
    local nextAbilityTimes = {}
    local nextM1Cycle = 0

    while getgenv().DummyTestEnabled and getgenv().DummyAttackRunning do
        local humanoid, hrp = getCharacterHumanoidAndRoot()
        local dummyRoot = hrp and getNearestDummyRoot(hrp.Position) or nil

        if humanoid and hrp and humanoid.Health > 0 and dummyRoot then
            local now = os.clock()

            if now >= nextM1Cycle then
                for _ = 1, M1_BURST_COUNT do
                    pcall(function()
                        replicator:InvokeServer("Core", "M1", {})
                    end)
                    task.wait(M1_BURST_INTERVAL)
                end
                nextM1Cycle = now + M1_CYCLE_COOLDOWN
            end

            for index, ability in ipairs(ABILITY_ORDER) do
                if now >= (nextAbilityTimes[index] or 0) then
                    pcall(function()
                        replicatorNoYield:FireServer("Nika", ability.name, {})
                    end)
                    nextAbilityTimes[index] = now + ability.cooldown
                    task.wait(0.05)
                end
            end
        end

        task.wait(0.05)
    end

    getgenv().DummyAttackRunning = false
end)

print("Ataque a dummy activado")
