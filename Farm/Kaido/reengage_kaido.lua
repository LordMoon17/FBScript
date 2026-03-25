-- ============================================
-- Kaido Farm - Reengage Kaido
-- ============================================
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local SIDE_OFFSET = 8

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

local function getKaidoRoot()
    local kaido = Workspace:FindFirstChild("Kaido", true)
    if not kaido or not kaido:IsA("Model") then
        return nil
    end

    return kaido:FindFirstChild("HumanoidRootPart")
        or kaido:FindFirstChild("PrimaryPart")
        or kaido:FindFirstChildWhichIsA("BasePart")
end

local function reengageKaido()
    local kaidoRoot = getKaidoRoot()
    if not kaidoRoot then
        return
    end

    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local hrp = character:WaitForChild("HumanoidRootPart")

    hrp.CFrame = CFrame.new(
        kaidoRoot.Position + (kaidoRoot.CFrame.RightVector * SIDE_OFFSET),
        kaidoRoot.Position
    )

    print("Reposicionado al lado de Kaido")
    task.wait(0.2)
    loadScript("https://raw.githubusercontent.com/LordMoon17/FBScript/main/Farm/Kaido/follow_kaido.lua")
end

reengageKaido()
