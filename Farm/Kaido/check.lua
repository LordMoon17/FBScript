-- ============================================
-- Kaido Farm - Check Nika
-- ============================================
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

if getgenv().KaidoFarmEnabled == false then
    return
end

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

local function getLoader()
    local playerGui = LocalPlayer:WaitForChild("PlayerGui")
    local ui = playerGui:WaitForChild("UI")
    local mainMenu = ui:WaitForChild("MainMenu")
    local buttons = mainMenu:WaitForChild("Buttons")
    local button = buttons:WaitForChild("Play")

    for _, connection in pairs(getconnections(button.MouseButton1Click)) do
        local ok, loader = pcall(function()
            local upvalues = getupvalues(connection.Function)
            local moduleTbl = upvalues[2]
            local btnObj = moduleTbl.Buttons[button]
            local clickUpvalues = getupvalues(btnObj.Click)
            local clickTbl = clickUpvalues[5]
            return getupvalues(clickTbl.Play)[1]
        end)

        if ok and loader then
            return loader
        end
    end

    return nil
end

local Loader = getLoader()
if not Loader then
    warn("No se pudo obtener el Loader")
    return
end

local slotActual = Loader.MainFunctions:GetSlot(LocalPlayer)
local frutaActual = slotActual and slotActual.Value or nil

print("Fruta equipada: " .. tostring(frutaActual))

if frutaActual == "Nika" then
    print("Nika ya esta equipada, continuando...")
    return
end

print("Nika no equipada, reiniciando para cambiar fruta...")

local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local humanoid = character:FindFirstChildOfClass("Humanoid")

if humanoid then
    humanoid.Health = 0
end

local mainMenu = LocalPlayer.PlayerGui.UI.MainMenu
repeat
    task.wait(0.5)
until mainMenu.Visible or getgenv().KaidoFarmEnabled == false

if getgenv().KaidoFarmEnabled == false then
    return
end

print("MainMenu visible, intentando equipar Nika...")
loadScript("https://raw.githubusercontent.com/LordMoon17/FBScript/main/Farm/Kaido/select_nika.lua")
