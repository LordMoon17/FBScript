-- ============================================
-- Dummy Test - Follow Dummy
-- ============================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local FOLLOW_OFFSET = Vector3.new(0, 1.5, -4)
local FOLLOW_DISTANCE_LIMIT = 35
local TARGET_NAME = "Respawn Dummy"

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
        return nil, nil
    end

    return humanoid, hrp
end

local function getNearestDummyRoot(fromPosition)
    local nearestRoot = nil
    local nearestDistance = math.huge

    for _, descendant in ipairs(Workspace:GetDescendants()) do
        if descendant:IsA("Model") and descendant.Name == TARGET_NAME then
            local root = descendant:FindFirstChild("HumanoidRootPart")
                or descendant:FindFirstChild("PrimaryPart")
                or descendant:FindFirstChildWhichIsA("BasePart")
            local humanoid = descendant:FindFirstChildOfClass("Humanoid")

            if root and humanoid and humanoid.Health > 0 then
                local distance = (root.Position - fromPosition).Magnitude
                if distance < nearestDistance then
                    nearestDistance = distance
                    nearestRoot = root
                end
            end
        end
    end

    return nearestRoot
end

local function stopFollow()
    if getgenv().DummyFollowConnection then
        getgenv().DummyFollowConnection:Disconnect()
        getgenv().DummyFollowConnection = nil
    end
end

local function returnToWaitMode()
    if getgenv().DummyReturnToWaitRunning then
        return
    end

    getgenv().DummyReturnToWaitRunning = true
    stopFollow()
    getgenv().DummyAttackRunning = false
    getgenv().DummyGear5Ready = false
    task.wait(1)

    if getgenv().DummyCycleEnabled then
        loadScript("https://raw.githubusercontent.com/LordMoon17/FBScript/main/Test/wait_dummy.lua")
    end

    getgenv().DummyReturnToWaitRunning = false
end

stopFollow()
loadScript("https://raw.githubusercontent.com/LordMoon17/FBScript/main/Test/attack_dummy.lua")

getgenv().DummyFollowConnection = RunService.Heartbeat:Connect(function()
    if getgenv().DummyTestEnabled == false and getgenv().DummyCycleEnabled == false then
        stopFollow()
        return
    end

    local humanoid, hrp = getCharacterParts()
    if not humanoid or not hrp or humanoid.Health <= 0 then
        return
    end

    local dummyRoot = getNearestDummyRoot(hrp.Position)
    if not dummyRoot then
        if getgenv().DummyCycleEnabled then
            returnToWaitMode()
        end
        return
    end

    local targetPosition = dummyRoot.Position
        + (dummyRoot.CFrame.RightVector * FOLLOW_OFFSET.X)
        + (dummyRoot.CFrame.UpVector * FOLLOW_OFFSET.Y)
        + (dummyRoot.CFrame.LookVector * FOLLOW_OFFSET.Z)

    if (hrp.Position - dummyRoot.Position).Magnitude > FOLLOW_DISTANCE_LIMIT then
        hrp.CFrame = CFrame.new(targetPosition, dummyRoot.Position)
        return
    end

    hrp.CFrame = hrp.CFrame:Lerp(CFrame.new(targetPosition, dummyRoot.Position), 0.35)
end)

print("Seguimiento de dummy activado")
