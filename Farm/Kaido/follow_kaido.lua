-- ============================================
-- Kaido Farm - Follow Kaido
-- ============================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local FOLLOW_OFFSET = Vector3.new(0, 2, -7)
local FOLLOW_DISTANCE_LIMIT = 30

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

local function stopFollow()
    if getgenv().KaidoFollowConnection then
        getgenv().KaidoFollowConnection:Disconnect()
        getgenv().KaidoFollowConnection = nil
    end
end

stopFollow()

getgenv().KaidoFollowConnection = RunService.Heartbeat:Connect(function()
    if getgenv().KaidoFarmEnabled == false then
        stopFollow()
        return
    end

    local character, humanoid, hrp = getCharacterParts()
    local kaidoRoot = getKaidoRoot()

    if not character or not humanoid or not hrp or not kaidoRoot then
        return
    end

    if humanoid.Health <= 0 then
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
