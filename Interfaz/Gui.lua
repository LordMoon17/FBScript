-- ============================================
-- Fruit Battlegrounds - GUI
-- ============================================
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Función helper
local function loadScript(url)
    local res = request({Url = url, Method = "GET"})
    loadstring(res.Body)()
end

-- Ejecutar Join.Lua primero
loadScript("https://raw.githubusercontent.com/LordMoon17/FBScript/main/Rejoin/Join.Lua")

-- ============================================
-- GUI
-- ============================================
local gui = Instance.new("ScreenGui")
gui.Name = "FBTools"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = LocalPlayer.PlayerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 80)
frame.Position = UDim2.new(0, 10, 0.5, -40)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = frame

-- Título
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
title.BorderSizePixel = 0
title.Text = "⚔️ FB Tools"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 14
title.Font = Enum.Font.GothamBold
title.Parent = frame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 8)
titleCorner.Parent = title

-- Botón Auto Rejoin
local autoRejoin = false

local rejoinBtn = Instance.new("TextButton")
rejoinBtn.Size = UDim2.new(1, -20, 0, 30)
rejoinBtn.Position = UDim2.new(0, 10, 0, 38)
rejoinBtn.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
rejoinBtn.BorderSizePixel = 0
rejoinBtn.Text = "🔴 Auto Rejoin: OFF"
rejoinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
rejoinBtn.TextSize = 13
rejoinBtn.Font = Enum.Font.GothamBold
rejoinBtn.Parent = frame

local rejoinCorner = Instance.new("UICorner")
rejoinCorner.CornerRadius = UDim.new(0, 6)
rejoinCorner.Parent = rejoinBtn

-- ============================================
-- EVENTO BOTÓN AUTO REJOIN
-- ============================================
rejoinBtn.MouseButton1Click:Connect(function()
    autoRejoin = not autoRejoin

    if autoRejoin then
        rejoinBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
        rejoinBtn.Text = "🟢 Auto Rejoin: ON"
        loadScript("https://raw.githubusercontent.com/LordMoon17/FBScript/main/Rejoin/Auto_rejoin.Lua")
        print("✅ Auto Rejoin activado")
    else
        rejoinBtn.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
        rejoinBtn.Text = "🔴 Auto Rejoin: OFF"
        print("❌ Auto Rejoin desactivado")
    end
end)