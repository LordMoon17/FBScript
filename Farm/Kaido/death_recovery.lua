-- ============================================
-- Kaido Farm - Death Recovery
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
    if getgenv().KaidoDeathConnection then
        getgenv().KaidoDeathConnection:Disconnect()
        getgenv().KaidoDeathConnection = nil
    end
end

local function handleDeath()
    if getgenv().KaidoFarmEnabled == false then
        return
    end

    if getgenv().Gear5BugRunning then
        return
    end

    if getgenv().KaidoDeathRecoveryRunning then
        return
    end

    getgenv().KaidoDeathRecoveryRunning = true
    getgenv().KaidoAttackRunning = false

    task.spawn(function()
        task.wait(REJOIN_WAIT)

        local mainMenu = LocalPlayer.PlayerGui.UI.MainMenu
        repeat
            task.wait(0.2)
        until mainMenu.Visible or getgenv().KaidoFarmEnabled == false

        if getgenv().KaidoFarmEnabled then
            loadScript("https://raw.githubusercontent.com/LordMoon17/FBScript/main/Rejoin/Join.Lua")
        end

        task.wait(1)
        getgenv().KaidoDeathRecoveryRunning = false
    end)
end

local function bindCharacter(character)
    disconnectRecovery()

    local humanoid = character:FindFirstChildOfClass("Humanoid") or character:WaitForChild("Humanoid")
    getgenv().KaidoDeathConnection = humanoid.Died:Connect(handleDeath)
end

local currentCharacter = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
bindCharacter(currentCharacter)

if getgenv().KaidoCharacterAddedConnection then
    getgenv().KaidoCharacterAddedConnection:Disconnect()
end

getgenv().KaidoCharacterAddedConnection = LocalPlayer.CharacterAdded:Connect(function(character)
    if getgenv().KaidoFarmEnabled == false then
        return
    end

    bindCharacter(character)
end)

print("Recuperacion por muerte activada")
