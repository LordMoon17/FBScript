-- ============================================
-- Fruit Battlegrounds - Auto Rejoin
-- Detecta cuando aparece el MainMenu y
-- vuelve a entrar al juego automaticamente
-- ============================================
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

LocalPlayer.PlayerGui:WaitForChild("DeathScreen").Enabled = false

local mainMenu = LocalPlayer.PlayerGui.UI.MainMenu

-- Evitar conexiones duplicadas si se pulsa el botón múltiples veces
if getgenv().AutoRejoinConnection then
    getgenv().AutoRejoinConnection:Disconnect()
end

getgenv().AutoRejoinConnection = mainMenu:GetPropertyChangedSignal("Visible"):Connect(function()
    if getgenv().AutoRejoinEnabled == false then return end

    if mainMenu.Visible then
        task.wait(0.5)
        mainMenu.Visible = false

        local button = mainMenu.Buttons.Play
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

        if Loader then
    Loader.RemoteNoYield:FireServer("Core", "LoadCharacter", {})
    task.wait(0.1)
    Loader.RemoteNoYield:FireServer("Main", "LoadCharacter")

    task.wait(1) -- Esperar antes de buscar el personaje
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
    print("✅ Auto rejoin completado")
end
    end
end)

print("✅ Auto rejoin activado")