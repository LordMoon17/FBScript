-- ============================================
-- Dummy Cycle - Death Recovery
-- ============================================
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer
local REJOIN_WAIT = 12

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

local function disconnectRecovery()
    if getgenv().DummyDeathConnection then
        getgenv().DummyDeathConnection:Disconnect()
        getgenv().DummyDeathConnection = nil
    end
end

local function handleDeath()
    if getgenv().DummyCycleEnabled == false or getgenv().DummyBugRunning or getgenv().DummyDeathRecoveryRunning then
        return
    end

    getgenv().DummyDeathRecoveryRunning = true
    getgenv().DummyAttackRunning = false

    task.spawn(function()
        task.wait(REJOIN_WAIT)

        local mainMenu = LocalPlayer.PlayerGui.UI.MainMenu
        repeat
            task.wait(0.2)
        until mainMenu.Visible or getgenv().DummyCycleEnabled == false

        if getgenv().DummyCycleEnabled then
            loadScript("https://raw.githubusercontent.com/LordMoon17/FBScript/main/Rejoin/Join.Lua")
        end

        task.wait(1)
        getgenv().DummyDeathRecoveryRunning = false
    end)
end

local function bindCharacter(character)
    disconnectRecovery()

    local humanoid = character:FindFirstChildOfClass("Humanoid") or character:WaitForChild("Humanoid")
    getgenv().DummyDeathConnection = humanoid.Died:Connect(handleDeath)
end

local currentCharacter = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
bindCharacter(currentCharacter)

if getgenv().DummyCharacterAddedConnection then
    getgenv().DummyCharacterAddedConnection:Disconnect()
end

getgenv().DummyCharacterAddedConnection = LocalPlayer.CharacterAdded:Connect(function(character)
    if getgenv().DummyCycleEnabled then
        bindCharacter(character)
    end
end)

print("Recuperacion por muerte dummy activada")
