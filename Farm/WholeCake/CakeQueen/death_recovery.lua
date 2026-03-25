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
    if getgenv().CakeQueenDeathConnection then
        getgenv().CakeQueenDeathConnection:Disconnect()
        getgenv().CakeQueenDeathConnection = nil
    end
end

local function handleDeath()
    if getgenv().CakeQueenFarmEnabled == false or getgenv().CakeQueenBugRunning or getgenv().CakeQueenDeathRecoveryRunning then
        return
    end

    getgenv().CakeQueenDeathRecoveryRunning = true
    getgenv().CakeQueenAttackRunning = false

    task.spawn(function()
        task.wait(REJOIN_WAIT)

        local mainMenu = LocalPlayer.PlayerGui.UI.MainMenu
        repeat
            task.wait(0.2)
        until mainMenu.Visible or getgenv().CakeQueenFarmEnabled == false

        if getgenv().CakeQueenFarmEnabled then
            loadScript("https://raw.githubusercontent.com/LordMoon17/FBScript/main/Rejoin/Join.Lua")
        end

        task.wait(1)
        getgenv().CakeQueenDeathRecoveryRunning = false
    end)
end

local function bindCharacter(character)
    disconnectRecovery()
    local humanoid = character:FindFirstChildOfClass("Humanoid") or character:WaitForChild("Humanoid")
    getgenv().CakeQueenDeathConnection = humanoid.Died:Connect(handleDeath)
end

local currentCharacter = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
bindCharacter(currentCharacter)

if getgenv().CakeQueenCharacterAddedConnection then
    getgenv().CakeQueenCharacterAddedConnection:Disconnect()
end

getgenv().CakeQueenCharacterAddedConnection = LocalPlayer.CharacterAdded:Connect(function(character)
    if getgenv().CakeQueenFarmEnabled then
        bindCharacter(character)
    end
end)

print("Recuperacion por muerte Cake Queen activada")
