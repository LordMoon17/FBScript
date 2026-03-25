-- ============================================
-- Dummy Cycle - Ubicacion y TP
-- ============================================
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local SIDE_OFFSET = 6

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

local function getDummyRoot()
    local target = getgenv().DummyCycleTarget
    if target and target.Parent and target:IsA("Model") then
        local humanoid = target:FindFirstChildOfClass("Humanoid")
        local root = target:FindFirstChild("HumanoidRootPart")
            or target:FindFirstChild("PrimaryPart")
            or target:FindFirstChildWhichIsA("BasePart")

        if target.Name == "Respawn Dummy" and humanoid and humanoid.Health > 0 and root then
            return root, target
        end
    end

    for _, descendant in ipairs(Workspace:GetDescendants()) do
        if descendant:IsA("Model") and descendant.Name == "Respawn Dummy" then
            local humanoid = descendant:FindFirstChildOfClass("Humanoid")
            local root = descendant:FindFirstChild("HumanoidRootPart")
                or descendant:FindFirstChild("PrimaryPart")
                or descendant:FindFirstChildWhichIsA("BasePart")

            if humanoid and humanoid.Health > 0 and root then
                getgenv().DummyCycleTarget = descendant
                return root, descendant
            end
        end
    end

    return nil, nil
end

local function runDummyStep()
    if getgenv().DummyGear5Ready then
        loadScript("https://raw.githubusercontent.com/LordMoon17/FBScript/main/Test/follow_dummy.lua")
        return
    end

    loadScript("https://raw.githubusercontent.com/LordMoon17/FBScript/main/Test/activate_dummy_bug.lua")
end

local function tpToDummy()
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local hrp = character:WaitForChild("HumanoidRootPart")
    local dummyRoot, dummyModel = getDummyRoot()

    if not dummyRoot then
        warn("No se encontro un Respawn Dummy valido")
        return
    end

    hrp.CFrame = CFrame.new(
        dummyRoot.Position + (dummyRoot.CFrame.RightVector * SIDE_OFFSET),
        dummyRoot.Position
    )
    print("TP al lado del dummy completado: " .. tostring(dummyModel:GetFullName()))
    runDummyStep()
end

tpToDummy()
