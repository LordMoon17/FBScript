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
    return character, character:FindFirstChildOfClass("Humanoid"), character:FindFirstChild("HumanoidRootPart")
end

local function getBossModel()
    local boss = Workspace:FindFirstChild("Katakuri", true)
    if boss and boss:IsA("Model") then
        return boss
    end
    return nil
end

local function getBossRoot()
    local boss = getBossModel()
    if not boss then
        return nil
    end

    return boss:FindFirstChild("HumanoidRootPart")
        or boss:FindFirstChild("PrimaryPart")
        or boss:FindFirstChildWhichIsA("BasePart")
end

local function stopFollow()
    if getgenv().KatakuriFollowConnection then
        getgenv().KatakuriFollowConnection:Disconnect()
        getgenv().KatakuriFollowConnection = nil
    end
end

local function returnToWaitMode()
    if getgenv().KatakuriReturnToWaitRunning then
        return
    end

    getgenv().KatakuriReturnToWaitRunning = true
    stopFollow()
    getgenv().KatakuriAttackRunning = false
    getgenv().KatakuriGear5Ready = false
    task.wait(1)

    if getgenv().WholeCakeFarmEnabled then
        loadScript("https://raw.githubusercontent.com/LordMoon17/FBScript/main/Farm/WholeCake/wait_wholecake.lua")
    elseif getgenv().KatakuriFarmEnabled then
        loadScript("https://raw.githubusercontent.com/LordMoon17/FBScript/main/Farm/WholeCake/Katakuri/wait.lua")
    end

    getgenv().KatakuriReturnToWaitRunning = false
end

stopFollow()
loadScript("https://raw.githubusercontent.com/LordMoon17/FBScript/main/Farm/WholeCake/Katakuri/attack.lua")

getgenv().KatakuriFollowConnection = RunService.Heartbeat:Connect(function()
    if getgenv().KatakuriFarmEnabled == false then
        stopFollow()
        return
    end

    local character, humanoid, hrp = getCharacterParts()
    local bossModel = getBossModel()
    local bossRoot = getBossRoot()

    if not character or not humanoid or not hrp or humanoid.Health <= 0 then
        return
    end

    if not bossModel or not bossRoot then
        returnToWaitMode()
        return
    end

    local bossHumanoid = bossModel:FindFirstChildOfClass("Humanoid")
    if not bossHumanoid or bossHumanoid.Health <= 0 then
        if not getgenv().KatakuriKillNotified and getgenv().SendDiscordAlert then
            getgenv().KatakuriKillNotified = true
            getgenv().SendDiscordAlert(
                "katakuri_kill",
                "Katakuri Derrotado",
                "Katakuri fue derrotado correctamente.",
                5763719
            )
        end
        returnToWaitMode()
        return
    end

    local targetPosition = bossRoot.Position
        + (bossRoot.CFrame.RightVector * FOLLOW_OFFSET.X)
        + (bossRoot.CFrame.UpVector * FOLLOW_OFFSET.Y)
        + (bossRoot.CFrame.LookVector * FOLLOW_OFFSET.Z)

    if (hrp.Position - bossRoot.Position).Magnitude > FOLLOW_DISTANCE_LIMIT then
        hrp.CFrame = CFrame.new(targetPosition, bossRoot.Position)
        return
    end

    hrp.CFrame = hrp.CFrame:Lerp(CFrame.new(targetPosition, bossRoot.Position), 0.35)
end)

getgenv().KatakuriKillNotified = false
print("Seguimiento de Katakuri activado")
