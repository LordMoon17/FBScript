-- ============================================
-- Kaido Farm - Follow Kaido
-- ============================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local FOLLOW_OFFSET = Vector3.new(0, 1.5, -4)
local FOLLOW_DISTANCE_LIMIT = 30

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

local function getCharacterParts()
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local hrp = character:FindFirstChild("HumanoidRootPart")

    if not humanoid or not hrp then
        return nil, nil, nil
    end

    return character, humanoid, hrp
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

local function getKaidoModel()
    local kaido = Workspace:FindFirstChild("Kaido", true)
    if kaido and kaido:IsA("Model") then
        return kaido
    end
    return nil
end

local function stopFollow()
    if getgenv().KaidoFollowConnection then
        getgenv().KaidoFollowConnection:Disconnect()
        getgenv().KaidoFollowConnection = nil
    end
end

local function returnToWaitMode()
    if getgenv().KaidoReturnToWaitRunning then
        return
    end

    getgenv().KaidoReturnToWaitRunning = true
    stopFollow()
    getgenv().KaidoAttackRunning = false
    getgenv().KaidoGear5Ready = false
    task.wait(1)

    if getgenv().KaidoFarmEnabled then
        loadScript("https://raw.githubusercontent.com/LordMoon17/FBScript/main/Farm/Kaido/wait_kaido.lua")
    end

    getgenv().KaidoReturnToWaitRunning = false
end

stopFollow()

loadScript("https://raw.githubusercontent.com/LordMoon17/FBScript/main/Farm/Kaido/attack_kaido.lua")

getgenv().KaidoFollowConnection = RunService.Heartbeat:Connect(function()
    if getgenv().KaidoFarmEnabled == false then
        stopFollow()
        return
    end

    local character, humanoid, hrp = getCharacterParts()
    local kaidoModel = getKaidoModel()
    local kaidoRoot = getKaidoRoot()

    if not character or not humanoid or not hrp then
        return
    end

    if humanoid.Health <= 0 then
        return
    end

    if not kaidoModel or not kaidoRoot then
        returnToWaitMode()
        return
    end

    local kaidoHumanoid = kaidoModel:FindFirstChildOfClass("Humanoid")
    if not kaidoHumanoid or kaidoHumanoid.Health <= 0 then
        returnToWaitMode()
        return
    end

    local targetPosition = kaidoRoot.Position
        + (kaidoRoot.CFrame.RightVector * FOLLOW_OFFSET.X)
        + (kaidoRoot.CFrame.UpVector * FOLLOW_OFFSET.Y)
        + (kaidoRoot.CFrame.LookVector * FOLLOW_OFFSET.Z)

    if (hrp.Position - kaidoRoot.Position).Magnitude > FOLLOW_DISTANCE_LIMIT then
        hrp.CFrame = CFrame.new(targetPosition, kaidoRoot.Position)
        return
    end

    hrp.CFrame = hrp.CFrame:Lerp(CFrame.new(targetPosition, kaidoRoot.Position), 0.35)
end)

print("Seguimiento de Kaido activado")
