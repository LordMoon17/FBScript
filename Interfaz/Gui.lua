-- ============================================
-- Fruit Battlegrounds - GUI
-- ============================================
local Players = game:GetService("Players")
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

local guiName = "FBTools"
local CoreGui = game:GetService("CoreGui")

if CoreGui:FindFirstChild(guiName) then
    CoreGui[guiName]:Destroy()
end

if LocalPlayer.PlayerGui:FindFirstChild(guiName) then
    LocalPlayer.PlayerGui[guiName]:Destroy()
end

local gui = Instance.new("ScreenGui")
gui.Name = guiName
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local success = pcall(function()
    gui.Parent = CoreGui
end)

if not success then
    gui.Parent = LocalPlayer.PlayerGui
end

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 200)
frame.Position = UDim2.new(0, 10, 0.5, -100)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
title.BorderSizePixel = 0
title.Text = "FB Tools"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 14
title.Font = Enum.Font.GothamBold
title.Parent = frame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 8)
titleCorner.Parent = title

local farmLabel = Instance.new("TextLabel")
farmLabel.Size = UDim2.new(1, -20, 0, 20)
farmLabel.Position = UDim2.new(0, 10, 0, 38)
farmLabel.BackgroundTransparency = 1
farmLabel.Text = "FARM"
farmLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
farmLabel.TextSize = 11
farmLabel.Font = Enum.Font.GothamBold
farmLabel.Parent = frame

local kaidoFarm = false

local kaidoBtn = Instance.new("TextButton")
kaidoBtn.Size = UDim2.new(1, -20, 0, 30)
kaidoBtn.Position = UDim2.new(0, 10, 0, 62)
kaidoBtn.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
kaidoBtn.BorderSizePixel = 0
kaidoBtn.Text = "Kaido: OFF"
kaidoBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
kaidoBtn.TextSize = 13
kaidoBtn.Font = Enum.Font.GothamBold
kaidoBtn.Parent = frame

local kaidoCorner = Instance.new("UICorner")
kaidoCorner.CornerRadius = UDim.new(0, 6)
kaidoCorner.Parent = kaidoBtn

local testBtn = Instance.new("TextButton")
testBtn.Size = UDim2.new(1, -20, 0, 30)
testBtn.Position = UDim2.new(0, 10, 0, 98)
testBtn.BackgroundColor3 = Color3.fromRGB(60, 90, 150)
testBtn.BorderSizePixel = 0
testBtn.Text = "Test TP + Bug"
testBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
testBtn.TextSize = 13
testBtn.Font = Enum.Font.GothamBold
testBtn.Parent = frame

local testCorner = Instance.new("UICorner")
testCorner.CornerRadius = UDim.new(0, 6)
testCorner.Parent = testBtn

local dummyTestEnabled = false

local dummyBtn = Instance.new("TextButton")
dummyBtn.Size = UDim2.new(1, -20, 0, 30)
dummyBtn.Position = UDim2.new(0, 10, 0, 134)
dummyBtn.BackgroundColor3 = Color3.fromRGB(140, 90, 40)
dummyBtn.BorderSizePixel = 0
dummyBtn.Text = "Dummy Test: OFF"
dummyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
dummyBtn.TextSize = 13
dummyBtn.Font = Enum.Font.GothamBold
dummyBtn.Parent = frame

local dummyCorner = Instance.new("UICorner")
dummyCorner.CornerRadius = UDim.new(0, 6)
dummyCorner.Parent = dummyBtn

kaidoBtn.MouseButton1Click:Connect(function()
    kaidoFarm = not kaidoFarm

    if kaidoFarm then
        kaidoBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
        kaidoBtn.Text = "Kaido: ON"
        getgenv().KaidoFarmEnabled = true
        loadScript("https://raw.githubusercontent.com/LordMoon17/FBScript/main/Rejoin/Join.Lua")
        loadScript("https://raw.githubusercontent.com/LordMoon17/FBScript/main/Farm/Kaido/check.lua")
        print("Kaido Farm activado")
    else
        kaidoBtn.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
        kaidoBtn.Text = "Kaido: OFF"
        getgenv().KaidoFarmEnabled = false
        print("Kaido Farm desactivado")
    end
end)

testBtn.MouseButton1Click:Connect(function()
    loadScript("https://raw.githubusercontent.com/LordMoon17/FBScript/main/Farm/Kaido/test_kaido_flow.lua")
    print("Test de Kaido ejecutado")
end)

dummyBtn.MouseButton1Click:Connect(function()
    dummyTestEnabled = not dummyTestEnabled

    if dummyTestEnabled then
        dummyBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
        dummyBtn.Text = "Dummy Test: ON"
        getgenv().DummyTestEnabled = true
        loadScript("https://raw.githubusercontent.com/LordMoon17/FBScript/main/Test/test_dummy_flow.lua")
        print("Test de dummy activado")
    else
        dummyBtn.BackgroundColor3 = Color3.fromRGB(140, 90, 40)
        dummyBtn.Text = "Dummy Test: OFF"
        getgenv().DummyTestEnabled = false
        print("Test de dummy desactivado")
    end
end)
