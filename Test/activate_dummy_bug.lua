-- ============================================
-- Dummy Cycle - Activate Gear5 Bug
-- ============================================
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
local replicator = ReplicatedStorage:WaitForChild("Replicator")
local DRUM_TIMINGS = {1.916, 2.116, 2.050, 2.233}
local RESET_WAIT = 0.5
local REJOIN_WAIT = 12

if getgenv().DummyBugRunning then
    return
end

getgenv().DummyBugRunning = true

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

task.spawn(function()
    for press = 1, 4 do
        local ok, err = pcall(function()
            replicator:InvokeServer("Nika", "DrumsofLiberation", {})
        end)

        if not ok then
            warn("Error activando DrumsofLiberation dummy: " .. tostring(err))
            getgenv().DummyBugRunning = false
            return
        end

        print("Dummy Drums " .. press .. "/4")
        task.wait(DRUM_TIMINGS[press] or DRUM_TIMINGS[#DRUM_TIMINGS])
    end

    local ok, err = pcall(function()
        replicator:InvokeServer("Nika", "Gear5", {})
    end)

    if not ok then
        warn("Error activando Gear5 dummy: " .. tostring(err))
        getgenv().DummyBugRunning = false
        return
    end

    getgenv().DummyGear5Ready = true
    print("Gear5 dummy activado, reiniciando...")
    task.wait(RESET_WAIT)

    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.Health = 0
    end

    task.wait(REJOIN_WAIT)

    local mainMenu = LocalPlayer.PlayerGui.UI.MainMenu
    repeat
        task.wait(0.2)
    until mainMenu.Visible or getgenv().DummyCycleEnabled == false

    if getgenv().DummyCycleEnabled then
        loadScript("https://raw.githubusercontent.com/LordMoon17/FBScript/main/Rejoin/Join.Lua")
    end

    task.wait(1)
    getgenv().DummyBugRunning = false
end)
