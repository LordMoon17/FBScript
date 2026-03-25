local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local BOSS_SPAWN_CFRAME = CFrame.new(798.830017, -1024.45105, -2360.93896)
local SIDE_OFFSET = 8

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

local function getBossRoot()
    local boss = Workspace:FindFirstChild("Katakuri", true)
    if not boss then
        return nil, nil
    end

    if boss:IsA("Model") then
        local rootPart = boss:FindFirstChild("HumanoidRootPart")
            or boss:FindFirstChild("PrimaryPart")
            or boss:FindFirstChildWhichIsA("BasePart")

        if rootPart then
            return rootPart, boss
        end
    elseif boss:IsA("BasePart") then
        return boss, boss
    end

    return nil, nil
end

local function runGear5Bug()
    if getgenv().KatakuriGear5Ready then
        loadScript("https://raw.githubusercontent.com/LordMoon17/FBScript/main/Farm/WholeCake/Katakuri/follow.lua")
        return
    end

    task.wait(0.3)
    loadScript("https://raw.githubusercontent.com/LordMoon17/FBScript/main/Farm/WholeCake/Katakuri/activate_gear5_bug.lua")
end

local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")
local rootPart, boss = getBossRoot()

if rootPart then
    hrp.CFrame = rootPart.CFrame + (rootPart.CFrame.RightVector * SIDE_OFFSET)
    print("TP al lado de Katakuri completado: " .. tostring(boss:GetFullName()))
    runGear5Bug()
    return
end

local fallbackPosition = BOSS_SPAWN_CFRAME.Position + (BOSS_SPAWN_CFRAME.RightVector * SIDE_OFFSET)
hrp.CFrame = CFrame.new(fallbackPosition)
print("TP al lado del spawn de Katakuri completado")
runGear5Bug()
