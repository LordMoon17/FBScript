-- ============================================
-- Kaido Farm - Wait For Kaido
-- ============================================
local Workspace = game:GetService("Workspace")

if getgenv().KaidoFarmEnabled == false then
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
    if getgenv().KaidoWatcherConnection then
        getgenv().KaidoWatcherConnection:Disconnect()
        getgenv().KaidoWatcherConnection = nil
    end
end

local function getKaidoModel(instance)
    if not instance then
        return nil
    end

    local model = instance
    if not model:IsA("Model") then
        model = instance.Parent
    end

    if not model or not model:IsA("Model") then
        return nil
    end

    if model.Name ~= "Kaido" then
        return nil
    end

    local humanoid = model:FindFirstChildOfClass("Humanoid")
    if not humanoid or humanoid.Health <= 0 then
        return nil
    end

    return model
end

local function onKaidoDetected(model, source)
    if getgenv().KaidoFarmEnabled == false then
        return
    end

    disconnectWatcher()
    print("Kaido detectado por " .. tostring(source) .. ": " .. model:GetFullName())
    loadScript("https://raw.githubusercontent.com/LordMoon17/FBScript/main/Farm/Kaido/ubication.lua")
end

for _, descendant in ipairs(Workspace:GetDescendants()) do
    local kaidoModel = getKaidoModel(descendant)
    if kaidoModel then
        onKaidoDetected(kaidoModel, "escaneo inicial")
        return
    end
end

disconnectWatcher()
getgenv().KaidoWatcherConnection = Workspace.DescendantAdded:Connect(function(descendant)
    local kaidoModel = getKaidoModel(descendant)
    if kaidoModel then
        onKaidoDetected(kaidoModel, "Workspace.DescendantAdded")
    end
end)

print("Esperando a Kaido...")
