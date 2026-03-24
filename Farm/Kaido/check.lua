-- ============================================
-- Kaido Farm - Check Nika
-- ============================================
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local function getLoader()
    local button = LocalPlayer.PlayerGui.UI.MainMenu.Buttons.Play
    for _, connection in pairs(getconnections(button.MouseButton1Click)) do
        local upvalues = getupvalues(connection.Function)
        local module_tbl = upvalues[2]
        local btnObj = module_tbl.Buttons[button]
        local clickUpvalues = getupvalues(btnObj.Click)
        local Click_tbl = clickUpvalues[5]
        return getupvalues(Click_tbl.Play)[1]
    end
end

local Loader = getLoader()
if not Loader then
    warn("❌ No se pudo obtener el Loader")
    return
end

local slotActual = Loader.MainFunctions:GetSlot(LocalPlayer)
print("🔍 Fruta equipada: " .. tostring(slotActual.Value))

if slotActual.Value ~= "Nika" then
    print("⚠️ Nika no equipada, reiniciando...")
    local character = LocalPlayer.Character
    if character and character:FindFirstChild("Humanoid") then
        character.Humanoid.Health = 0
    end
    
    -- Esperar MainMenu
    local mainMenu = LocalPlayer.PlayerGui.UI.MainMenu
    repeat task.wait(0.5) until mainMenu.Visible
    print("✅ MainMenu visible")
    
    -- Ejecutar select_nika.lua
    local function loadScript(url)
        local success, result = pcall(function() return game:HttpGet(url) end)
        if success and result then
            loadstring(result)()
        end
    end
    loadScript("https://raw.githubusercontent.com/LordMoon17/FBScript/main/Farm/Kaido/select_nika.lua")
else
    print("✅ Nika ya está equipada, continuando...")
end