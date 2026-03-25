local Workspace = game:GetService("Workspace")

if getgenv().KatakuriFarmEnabled == false then
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
    if getgenv().KatakuriWatcherConnection then
        getgenv().KatakuriWatcherConnection:Disconnect()
        getgenv().KatakuriWatcherConnection = nil
    end
end

local function getBossModel(instance)
    if not instance then
        return nil
    end

    local model = instance
    if not model:IsA("Model") then
        model = instance.Parent
    end

    if not model or not model:IsA("Model") or model.Name ~= "Katakuri" then
        return nil
    end

    local humanoid = model:FindFirstChildOfClass("Humanoid")
    if not humanoid or humanoid.Health <= 0 then
        return nil
    end

    return model
end

local function onBossDetected(model, source)
    if getgenv().KatakuriFarmEnabled == false then
        return
    end

    disconnectWatcher()
    print("Katakuri detectado por " .. tostring(source) .. ": " .. model:GetFullName())
    loadScript("https://raw.githubusercontent.com/LordMoon17/FBScript/main/Farm/WholeCake/Katakuri/ubication.lua")
end

for _, descendant in ipairs(Workspace:GetDescendants()) do
    local bossModel = getBossModel(descendant)
    if bossModel then
        onBossDetected(bossModel, "escaneo inicial")
        return
    end
end

disconnectWatcher()
getgenv().KatakuriWatcherConnection = Workspace.DescendantAdded:Connect(function(descendant)
    local bossModel = getBossModel(descendant)
    if bossModel then
        onBossDetected(bossModel, "Workspace.DescendantAdded")
    end
end)

print("Esperando a Katakuri...")
