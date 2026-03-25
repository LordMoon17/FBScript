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
    if getgenv().WholeCakeDeathConnection then
        getgenv().WholeCakeDeathConnection:Disconnect()
        getgenv().WholeCakeDeathConnection = nil
    end
end

local function handleDeath()
    if getgenv().WholeCakeFarmEnabled == false
        or getgenv().KatakuriBugRunning
        or getgenv().CakeQueenBugRunning
        or getgenv().WholeCakeDeathRecoveryRunning
    then
        return
    end

    getgenv().WholeCakeDeathRecoveryRunning = true
    getgenv().KatakuriAttackRunning = false
    getgenv().CakeQueenAttackRunning = false

    task.spawn(function()
        task.wait(REJOIN_WAIT)

        local mainMenu = LocalPlayer.PlayerGui.UI.MainMenu
        repeat
            task.wait(0.2)
        until mainMenu.Visible or getgenv().WholeCakeFarmEnabled == false

        if getgenv().WholeCakeFarmEnabled then
            loadScript("https://raw.githubusercontent.com/LordMoon17/FBScript/main/Rejoin/Join.Lua")
        end

        task.wait(1)
        getgenv().WholeCakeDeathRecoveryRunning = false
    end)
end

local function bindCharacter(character)
    disconnectRecovery()
    local humanoid = character:FindFirstChildOfClass("Humanoid") or character:WaitForChild("Humanoid")
    getgenv().WholeCakeDeathConnection = humanoid.Died:Connect(handleDeath)
end

local currentCharacter = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
bindCharacter(currentCharacter)

if getgenv().WholeCakeCharacterAddedConnection then
    getgenv().WholeCakeCharacterAddedConnection:Disconnect()
end

getgenv().WholeCakeCharacterAddedConnection = LocalPlayer.CharacterAdded:Connect(function(character)
    if getgenv().WholeCakeFarmEnabled then
        bindCharacter(character)
    end
end)

print("Recuperacion por muerte Whole Cake activada")
