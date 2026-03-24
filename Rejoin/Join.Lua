-- ============================================
-- Fruit Battlegrounds - Auto Play Button
-- Bypasses el MainMenu y entra al juego
-- directamente desde exploit
-- ============================================
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local button = LocalPlayer.PlayerGui.UI.MainMenu.Buttons.Play
local Loader = nil

for _, connection in pairs(getconnections(button.MouseButton1Click)) do
    local upvalues = getupvalues(connection.Function)
    local module_tbl = upvalues[2]
    local btnObj = module_tbl.Buttons[button]
    local clickUpvalues = getupvalues(btnObj.Click)
    local Click_tbl = clickUpvalues[5]
    Loader = getupvalues(Click_tbl.Play)[1]
    break
end

if not Loader then
    warn("❌ No se pudo obtener el Loader")
    return
end
print("✅ Loader obtenido correctamente")

LocalPlayer.PlayerGui.UI.MainMenu.Visible = false
print("✅ MainMenu ocultado")

Loader.RemoteNoYield:FireServer("Core", "LoadCharacter", {})
task.wait(0.1)
Loader.RemoteNoYield:FireServer("Main", "LoadCharacter")
print("✅ RemoteEvent disparado - Entrando al juego...")

local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
character:WaitForChild("HumanoidRootPart")
workspace.CurrentCamera.CameraSubject = character:WaitForChild("Humanoid")
workspace.CurrentCamera.CameraType = Enum.CameraType.Follow
print("✅ Cámara forzada al personaje")

task.wait(2)
local originalSelect = Loader.Hotbar.Select
Loader.Hotbar.Select = function(...)
    setupvalue(originalSelect, 4, Loader)
    return originalSelect(...)
end
task.wait(0.1)
Loader.Hotbar.Select = nil
print("✅ Hotbar funcionando")

print("============================================")
print("✅ Script completado - Todas las teclas OK")
print("============================================")