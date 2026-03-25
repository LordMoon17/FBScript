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
    if getgenv().KatakuriDeathConnection then
        getgenv().KatakuriDeathConnection:Disconnect()
        getgenv().KatakuriDeathConnection = nil
    end
end

local function handleDeath()
    if getgenv().KatakuriFarmEnabled == false or getgenv().KatakuriBugRunning or getgenv().KatakuriDeathRecoveryRunning then
        return
    end

    getgenv().KatakuriDeathRecoveryRunning = true
    getgenv().KatakuriAttackRunning = false

    task.spawn(function()
        task.wait(REJOIN_WAIT)

        local mainMenu = LocalPlayer.PlayerGui.UI.MainMenu
        repeat
            task.wait(0.2)
        until mainMenu.Visible or getgenv().KatakuriFarmEnabled == false

        if getgenv().KatakuriFarmEnabled then
            loadScript("https://raw.githubusercontent.com/LordMoon17/FBScript/main/Rejoin/Join.Lua")
        end

        task.wait(1)
        getgenv().KatakuriDeathRecoveryRunning = false
    end)
end

local function bindCharacter(character)
    disconnectRecovery()
    local humanoid = character:FindFirstChildOfClass("Humanoid") or character:WaitForChild("Humanoid")
    getgenv().KatakuriDeathConnection = humanoid.Died:Connect(handleDeath)
end

local currentCharacter = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
bindCharacter(currentCharacter)

if getgenv().KatakuriCharacterAddedConnection then
    getgenv().KatakuriCharacterAddedConnection:Disconnect()
end

getgenv().KatakuriCharacterAddedConnection = LocalPlayer.CharacterAdded:Connect(function(character)
    if getgenv().KatakuriFarmEnabled then
        bindCharacter(character)
    end
end)

print("Recuperacion por muerte Katakuri activada")
