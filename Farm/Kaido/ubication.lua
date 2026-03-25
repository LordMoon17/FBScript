-- ============================================
-- Kaido - Ubicacion y TP
-- ============================================
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local KAIDO_SPAWN_CFRAME = CFrame.new(
    -3950.22607, 1604.94104, 313.729004,
    -4.37113883e-08, 0, 1,
    0, 1, 0,
    -1, 0, -4.37113883e-08
)
local SIDE_OFFSET = 8

local function getKaidoPosition()
    local kaido = Workspace:FindFirstChild("Kaido", true)
    if not kaido then
        return nil
    end

    if kaido:IsA("Model") then
        local rootPart = kaido:FindFirstChild("HumanoidRootPart")
            or kaido:FindFirstChild("PrimaryPart")
            or kaido:FindFirstChildWhichIsA("BasePart")

        if rootPart then
            return rootPart.Position, kaido
        end
    elseif kaido:IsA("BasePart") then
        return kaido.Position, kaido
    end

    return nil
end

local function runGear5Bug()
    task.wait(0.3)
    local success, result = pcall(function()
        return game:HttpGet("https://raw.githubusercontent.com/LordMoon17/FBScript/main/Farm/Kaido/Activate_gear5_bug.lua")
    end)

    if success and result then
        loadstring(result)()
    else
        warn("Error al cargar Activate_gear5_bug.lua: " .. tostring(result))
    end
end

local function tpToKaido()
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local hrp = character:WaitForChild("HumanoidRootPart")

    local position, kaido = getKaidoPosition()
    if kaido and kaido:IsA("Model") then
        local rootPart = kaido:FindFirstChild("HumanoidRootPart")
            or kaido:FindFirstChild("PrimaryPart")
            or kaido:FindFirstChildWhichIsA("BasePart")

        if rootPart then
            hrp.CFrame = rootPart.CFrame + (rootPart.CFrame.RightVector * SIDE_OFFSET)
            print("TP al lado de Kaido completado: " .. tostring(kaido:GetFullName()))
            runGear5Bug()
            return
        end
    end

    if not position then
        local fallbackPosition = KAIDO_SPAWN_CFRAME.Position + (KAIDO_SPAWN_CFRAME.RightVector * SIDE_OFFSET)
        hrp.CFrame = CFrame.new(fallbackPosition)
        print("TP al lado del spawn de Kaido completado")
        runGear5Bug()
        return
    end

    hrp.CFrame = CFrame.new(position + (KAIDO_SPAWN_CFRAME.RightVector * SIDE_OFFSET))
    print("TP cerca de Kaido completado: " .. tostring(kaido:GetFullName()))
    runGear5Bug()
end

tpToKaido()
