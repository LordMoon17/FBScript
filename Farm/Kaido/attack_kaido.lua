-- ============================================
-- Kaido Farm - Attack Kaido
-- ============================================
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
    {name = "RocGun", cooldown = 13},
    {name = "NeoRedHawk", cooldown = 15},
    {name = "RocGatling", cooldown = 17},
    {name = "RedRoc", cooldown = 35},
}

local function loadScript(url)
    local success, result = pcall(function()
        return game:HttpGet(url)
    end)

    if success and result then
        loadstring(result)()
    else
        warn("Error al cargar script: " .. tostring(result))
    end
end

local function getKaidoRoot()
    local kaido = Workspace:FindFirstChild("Kaido", true)
    if not kaido or not kaido:IsA("Model") then
        return nil
    end

    return kaido:FindFirstChild("HumanoidRootPart")
        or kaido:FindFirstChild("PrimaryPart")
        or kaido:FindFirstChildWhichIsA("BasePart")
end

local function getCharacterHumanoid()
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    return character:FindFirstChildOfClass("Humanoid")
end

if getgenv().KaidoAttackRunning then
    return
end

getgenv().KaidoAttackRunning = true

task.spawn(function()
    local nextAbilityTimes = {}
    local nextM1Cycle = 0

    while getgenv().KaidoFarmEnabled and getgenv().KaidoAttackRunning do
        local kaidoRoot = getKaidoRoot()
        local humanoid = getCharacterHumanoid()

        if kaidoRoot and humanoid and humanoid.Health > 0 then
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

    getgenv().KaidoAttackRunning = false
end)

print("Ataque a Kaido activado")
