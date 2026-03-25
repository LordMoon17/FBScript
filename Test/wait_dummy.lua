-- ============================================
-- Dummy Cycle - Wait For Dummy
-- ============================================
local Workspace = game:GetService("Workspace")

if getgenv().DummyCycleEnabled == false then
    return
end

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

local function disconnectWatcher()
    if getgenv().DummyWatcherConnection then
        getgenv().DummyWatcherConnection:Disconnect()
        getgenv().DummyWatcherConnection = nil
    end
end

local function getDummyModel(instance)
    if not instance then
        return nil
    end

    local model = instance
    if not model:IsA("Model") then
        model = instance.Parent
    end

    if not model or not model:IsA("Model") or model.Name ~= "Respawn Dummy" then
        return nil
    end

    local humanoid = model:FindFirstChildOfClass("Humanoid")
    if not humanoid or humanoid.Health <= 0 then
        return nil
    end

    return model
end

local function onDummyDetected(model, source)
    if getgenv().DummyCycleEnabled == false then
        return
    end

    disconnectWatcher()
    getgenv().DummyCycleTarget = model
    print("Dummy detectado por " .. tostring(source) .. ": " .. model:GetFullName())
    loadScript("https://raw.githubusercontent.com/LordMoon17/FBScript/main/Test/ubication_dummy.lua")
end

for _, descendant in ipairs(Workspace:GetDescendants()) do
    local dummyModel = getDummyModel(descendant)
    if dummyModel then
        onDummyDetected(dummyModel, "escaneo inicial")
        return
    end
end

disconnectWatcher()
getgenv().DummyWatcherConnection = Workspace.DescendantAdded:Connect(function(descendant)
    local dummyModel = getDummyModel(descendant)
    if dummyModel then
        onDummyDetected(dummyModel, "Workspace.DescendantAdded")
    end
end)

print("Esperando a Respawn Dummy...")
