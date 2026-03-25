-- ============================================
-- Fruit Battlegrounds - Auto Play Button
-- ============================================
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

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

local function hasKaidoInMap()
    local kaido = Workspace:FindFirstChild("Kaido", true)
    return kaido ~= nil
end

local function hasBossInMap(name)
    local boss = Workspace:FindFirstChild(name, true)
    return boss ~= nil
end

local function forceCameraToCharacter(character)
    local humanoid = character:WaitForChild("Humanoid")
    local camera = workspace.CurrentCamera

    for _ = 1, 10 do
        camera.CameraSubject = humanoid
        camera.CameraType = Enum.CameraType.Follow
        task.wait(0.2)
    end
end

local button = LocalPlayer.PlayerGui.UI.MainMenu.Buttons.Play
local Loader = nil

for _, connection in pairs(getconnections(button.MouseButton1Click)) do
    local upvalues = getupvalues(connection.Function)
    local moduleTbl = upvalues[2]
    local btnObj = moduleTbl.Buttons[button]
    local clickUpvalues = getupvalues(btnObj.Click)
    local clickTbl = clickUpvalues[5]
    Loader = getupvalues(clickTbl.Play)[1]
    break
end

if not Loader then
    warn("No se pudo obtener el Loader")
    return
end

print("Loader obtenido correctamente")

LocalPlayer.PlayerGui.UI.MainMenu.Visible = false
print("MainMenu ocultado")

Loader.RemoteNoYield:FireServer("Core", "LoadCharacter", {})
task.wait(0.1)
Loader.RemoteNoYield:FireServer("Main", "LoadCharacter")
print("RemoteEvent disparado, entrando al juego...")

local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
character:WaitForChild("HumanoidRootPart")
forceCameraToCharacter(character)
print("Camara forzada al personaje")

task.wait(2)
print("Personaje cargado correctamente")

loadScript("https://raw.githubusercontent.com/LordMoon17/FBScript/main/Habilidades%20bindeadas/nika_binds.lua")
print("Binds de Nika cargados")

if getgenv().KaidoFarmEnabled then
    loadScript("https://raw.githubusercontent.com/LordMoon17/FBScript/main/Farm/Kaido/death_recovery.lua")
    print("Recuperacion de muerte cargada")

    if hasKaidoInMap() then
        loadScript("https://raw.githubusercontent.com/LordMoon17/FBScript/main/Farm/Kaido/reengage_kaido.lua")
        print("Reenganche con Kaido cargado")
    end
end

if getgenv().WholeCakeFarmEnabled then
    loadScript("https://raw.githubusercontent.com/LordMoon17/FBScript/main/Farm/WholeCake/death_recovery.lua")
    print("Recuperacion de muerte Whole Cake cargada")

    if hasBossInMap("Katakuri") then
        loadScript("https://raw.githubusercontent.com/LordMoon17/FBScript/main/Farm/WholeCake/Katakuri/reengage.lua")
        print("Reenganche con Katakuri cargado")
    elseif hasBossInMap("Cake Queen") then
        loadScript("https://raw.githubusercontent.com/LordMoon17/FBScript/main/Farm/WholeCake/CakeQueen/reengage.lua")
        print("Reenganche con Cake Queen cargado")
    else
        loadScript("https://raw.githubusercontent.com/LordMoon17/FBScript/main/Farm/WholeCake/wait_wholecake.lua")
        print("Espera de Whole Cake cargada")
    end
elseif getgenv().KatakuriFarmEnabled then
    loadScript("https://raw.githubusercontent.com/LordMoon17/FBScript/main/Farm/WholeCake/Katakuri/death_recovery.lua")
    print("Recuperacion de muerte Katakuri cargada")

    if hasBossInMap("Katakuri") then
        loadScript("https://raw.githubusercontent.com/LordMoon17/FBScript/main/Farm/WholeCake/Katakuri/reengage.lua")
        print("Reenganche con Katakuri cargado")
    end
elseif getgenv().CakeQueenFarmEnabled then
    loadScript("https://raw.githubusercontent.com/LordMoon17/FBScript/main/Farm/WholeCake/CakeQueen/death_recovery.lua")
    print("Recuperacion de muerte Cake Queen cargada")

    if hasBossInMap("Cake Queen") then
        loadScript("https://raw.githubusercontent.com/LordMoon17/FBScript/main/Farm/WholeCake/CakeQueen/reengage.lua")
        print("Reenganche con Cake Queen cargado")
    end
end

if getgenv().DummyCycleEnabled then
    loadScript("https://raw.githubusercontent.com/LordMoon17/FBScript/main/Test/dummy_death_recovery.lua")
    print("Recuperacion de muerte dummy cargada")

    local success, hasDummy = pcall(function()
        for _, descendant in ipairs(Workspace:GetDescendants()) do
            if descendant:IsA("Model") and descendant.Name == "Respawn Dummy" then
                local humanoid = descendant:FindFirstChildOfClass("Humanoid")
                if humanoid and humanoid.Health > 0 then
                    return true
                end
            end
        end
        return false
    end)

    if success and hasDummy then
        loadScript("https://raw.githubusercontent.com/LordMoon17/FBScript/main/Test/ubication_dummy.lua")
        print("Reenganche con dummy cargado")
    else
        loadScript("https://raw.githubusercontent.com/LordMoon17/FBScript/main/Test/wait_dummy.lua")
        print("Espera de dummy cargada")
    end
end
