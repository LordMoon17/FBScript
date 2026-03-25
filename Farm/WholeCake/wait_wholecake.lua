local Workspace = game:GetService("Workspace")

if getgenv().WholeCakeFarmEnabled == false then
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
    if getgenv().WholeCakeWatcherConnection then
        getgenv().WholeCakeWatcherConnection:Disconnect()
        getgenv().WholeCakeWatcherConnection = nil
    end
end

local function getBossModel(instance)
    if not instance then
        return nil, nil
    end

    local model = instance
    if not model:IsA("Model") then
        model = instance.Parent
    end

    if not model or not model:IsA("Model") then
        return nil, nil
    end

    if model.Name ~= "Katakuri" and model.Name ~= "Cake Queen" then
        return nil, nil
    end

    local humanoid = model:FindFirstChildOfClass("Humanoid")
    if not humanoid or humanoid.Health <= 0 then
        return nil, nil
    end

    return model, model.Name
end

local function routeBoss(model, bossName, source)
    if getgenv().WholeCakeFarmEnabled == false then
        return
    end

    disconnectWatcher()
    print("Whole Cake detecto a " .. bossName .. " por " .. tostring(source) .. ": " .. model:GetFullName())

    if bossName == "Katakuri" then
        loadScript("https://raw.githubusercontent.com/LordMoon17/FBScript/main/Farm/WholeCake/Katakuri/ubication.lua")
    else
        loadScript("https://raw.githubusercontent.com/LordMoon17/FBScript/main/Farm/WholeCake/CakeQueen/ubication.lua")
    end
end

for _, descendant in ipairs(Workspace:GetDescendants()) do
    local model, bossName = getBossModel(descendant)
    if model then
        routeBoss(model, bossName, "escaneo inicial")
        return
    end
end

disconnectWatcher()
getgenv().WholeCakeWatcherConnection = Workspace.DescendantAdded:Connect(function(descendant)
    local model, bossName = getBossModel(descendant)
    if model then
        routeBoss(model, bossName, "Workspace.DescendantAdded")
    end
end)

print("Esperando a Katakuri o Cake Queen...")
