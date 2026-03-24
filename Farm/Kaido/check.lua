-- ============================================
-- Kaido Farm - Check Nika
-- Solo verifica y equipa Nika si es necesario
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

local function equipSlot(slotNumber)
    local button = LocalPlayer.PlayerGui.UI.MainMenu.Buttons.Spin
    for _, connection in pairs(getconnections(button.MouseButton1Click)) do
        local upvalues = getupvalues(connection.Function)
        local module_tbl = upvalues[2]
        local btnObj = module_tbl.Buttons[button]
        local clickUpvalues = getupvalues(btnObj.Click)
        local Click_tbl = clickUpvalues[5]
        local equipUpvalues = getupvalues(Click_tbl.EquipFruit)
        local shelf = equipUpvalues[2]
        shelf.Value = slotNumber
        local ok, err = pcall(function()
            Click_tbl.EquipFruit(btnObj, button)
        end)
        if ok then
            print("✅ Slot " .. slotNumber .. " equipado")
        else
            warn("❌ Error: " .. tostring(err))
        end
        break
    end
end

-- ============================================
-- MAIN
-- ============================================
local Loader = getLoader()
if not Loader then
    warn("❌ No se pudo obtener el Loader")
    return
end

local slotActual = Loader.MainFunctions:GetSlot(LocalPlayer)
print("🔍 Fruta equipada: " .. tostring(slotActual.Value))

if slotActual.Value ~= "Nika" then
    print("⚠️ Nika no equipada, reiniciando...")
    
    -- Matar personaje para volver al MainMenu
    local character = LocalPlayer.Character
    if character and character:FindFirstChild("Humanoid") then
        character.Humanoid.Health = 0
    end
    
    -- Esperar MainMenu
    local mainMenu = LocalPlayer.PlayerGui.UI.MainMenu
    repeat task.wait(0.5) until mainMenu.Visible
    print("✅ MainMenu visible")
    
    -- Equipar Nika
    equipSlot(1)
    task.wait(0.5)
    
    slotActual = Loader.MainFunctions:GetSlot(LocalPlayer)
    if slotActual.Value == "Nika" then
        print("✅ Nika equipada correctamente")
    else
        warn("❌ No se pudo equipar Nika")
        return
    end
else
    print("✅ Nika ya está equipada")
end

print("✅ Check completado")