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
    {name = "RocGun", cooldown = 13, range = 3.5, windup = 0.06},
    {name = "RocGatling", cooldown = 17, range = 3.0, windup = 0.08},
    {name = "RedRoc", cooldown = 35, range = 4.0, windup = 0.08},
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

local function getCycleDummyRoot()
    local target = getgenv().DummyCycleTarget
    if not target or not target.Parent or not target:IsA("Model") or target.Name ~= TARGET_NAME then
        return nil
    end

    local humanoid = target:FindFirstChildOfClass("Humanoid")
    local root = target:FindFirstChild("HumanoidRootPart")
        or target:FindFirstChild("PrimaryPart")
        or target:FindFirstChildWhichIsA("BasePart")

    if humanoid and humanoid.Health > 0 and root then
        return root
    end

    return nil
end

local function getCharacterHumanoidAndRoot()
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    return character:FindFirstChildOfClass("Humanoid"), character:FindFirstChild("HumanoidRootPart")
end

local function alignToTarget(hrp, targetRoot, range)
    local distance = range or 3
    local targetPosition = targetRoot.Position - (targetRoot.CFrame.LookVector * distance)
    hrp.CFrame = CFrame.lookAt(targetPosition, targetRoot.Position)
end

local function castAbility(hrp, targetRoot, ability)
    alignToTarget(hrp, targetRoot, ability.range)
    task.wait(ability.windup or 0.05)
    replicatorNoYield:FireServer("Nika", ability.name, {})
end

if getgenv().DummyAttackRunning then
    return
end

getgenv().DummyAttackRunning = true

task.spawn(function()
    local nextAbilityTimes = {}
    local nextM1Cycle = 0

    while (getgenv().DummyTestEnabled or getgenv().DummyCycleEnabled) and getgenv().DummyAttackRunning do
        local humanoid, hrp = getCharacterHumanoidAndRoot()
        local dummyRoot = nil
        if hrp then
            if getgenv().DummyCycleEnabled then
                dummyRoot = getCycleDummyRoot()
            else
                dummyRoot = getNearestDummyRoot(hrp.Position)
            end
        end

        if humanoid and hrp and humanoid.Health > 0 and dummyRoot then
            local now = os.clock()

            if now >= nextM1Cycle then
                for _ = 1, M1_BURST_COUNT do
                    pcall(function()
                        hrp.CFrame = CFrame.lookAt(hrp.Position, dummyRoot.Position)
                        replicator:InvokeServer("Core", "M1", {})
                    end)
                    task.wait(M1_BURST_INTERVAL)
                end
                nextM1Cycle = now + M1_CYCLE_COOLDOWN
            end

            for index, ability in ipairs(ABILITY_ORDER) do
                if now >= (nextAbilityTimes[index] or 0) then
                    pcall(function()
                        castAbility(hrp, dummyRoot, ability)
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
