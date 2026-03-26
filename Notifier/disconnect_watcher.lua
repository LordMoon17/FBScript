local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")

if getgenv().DisconnectWatcherLoaded then
    return
end

getgenv().DisconnectWatcherLoaded = true
getgenv().DisconnectWatchConnections = getgenv().DisconnectWatchConnections or {}

local LocalPlayer = Players.LocalPlayer

local function containsDisconnectText(text)
    local s = string.lower(tostring(text or ""))
    return s:find("disconnected", 1, true)
        or s:find("connection", 1, true)
        or s:find("error code", 1, true)
        or s:find("lost", 1, true)
        or s:find("reconnect", 1, true)
end

local function notifyDisconnect(reason)
    if getgenv().SendDiscordAlert then
        getgenv().SendDiscordAlert(
            "server_disconnect",
            "Server Disconnect",
            "Se detecto desconexion/error de servidor.\nMotivo: " .. tostring(reason),
            15158332
        )
    end
end

local function safeConnect(signal, fn)
    local ok, conn = pcall(function()
        return signal:Connect(fn)
    end)
    if ok and conn then
        table.insert(getgenv().DisconnectWatchConnections, conn)
    end
end

safeConnect(GuiService.ErrorMessageChanged, function(message)
    if containsDisconnectText(message) then
        notifyDisconnect(message)
    end
end)

safeConnect(LocalPlayer.OnTeleport, function(state)
    if state == Enum.TeleportState.Failed then
        notifyDisconnect("Teleport failed")
    end
end)

task.spawn(function()
    while true do
        task.wait(2)

        if getgenv().DiscordNotifyEnabled == false then
            continue
        end

        local ok, coreGui = pcall(function()
            return game:GetService("CoreGui")
        end)
        if not ok or not coreGui then
            continue
        end

        local promptGui = coreGui:FindFirstChild("RobloxPromptGui")
        if not promptGui then
            continue
        end

        local textFound = nil
        for _, descendant in ipairs(promptGui:GetDescendants()) do
            if descendant:IsA("TextLabel") and descendant.Visible then
                local txt = descendant.Text
                if containsDisconnectText(txt) then
                    textFound = txt
                    break
                end
            end
        end

        if textFound then
            notifyDisconnect(textFound)
        end
    end
end)

print("Watcher de desconexion cargado")
