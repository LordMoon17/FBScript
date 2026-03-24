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

local function enterGame(Loader)
    LocalPlayer.PlayerGui.UI.MainMenu.Visible = false
    LocalPlayer.PlayerGui:WaitForChild("DeathScreen").Enabled = false

    Loader.RemoteNoYield:FireServer("Core", "LoadCharacter", {})
    task.wait(0.1)
    Loader.RemoteNoYield:FireServer("Main", "LoadCharacter")

    task.wait(1)
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    character:WaitForChild("HumanoidRootPart")
    workspace.CurrentCamera.CameraSubject = character:WaitForChild("Humanoid")
    workspace.CurrentCamera.CameraType = Enum.CameraType.Follow

    task.wait(2)
    local originalSelect = Loader.Hotbar.Select
    Loader.Hotbar.Select = function(...)
        setupvalue(originalSelect, 4, Loader)
        return originalSelect(...)
    end
    task.wait(0.1)
    Loader.Hotbar.Select = nil
    print("✅ Entrado al juego")
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
    LocalPlayer.Character.Humanoid.Health = 0
    
    -- Esperar a que aparezca el MainMenu
    local mainMenu = LocalPlayer.PlayerGui.UI.MainMenu
    repeat task.wait(0.5) until mainMenu.Visible
    print("✅ MainMenu visible")
    
    -- Equipar Nika
    equipSlot(1)
    task.wait(0.5)
    
    -- Verificar
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

-- Entrar al juego
enterGame(Loader)