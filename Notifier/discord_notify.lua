local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

if getgenv().DiscordNotifierLoaded then
    return
end

getgenv().DiscordNotifierLoaded = true
getgenv().DiscordNotifyCooldowns = getgenv().DiscordNotifyCooldowns or {}
if getgenv().DiscordNotifyEnabled == nil then
    getgenv().DiscordNotifyEnabled = true
end

local function resolveRequestFn()
    return request
        or http_request
        or (syn and syn.request)
        or (fluxus and fluxus.request)
end

local function sendDiscordAlert(eventKey, title, description, color)
    if not getgenv().DiscordNotifyEnabled then
        return false
    end

    local webhook = tostring(getgenv().DiscordWebhookURL or "")
    if webhook == "" then
        return false
    end

    local now = os.clock()
    local cooldownKey = tostring(eventKey or "default")
    local cooldowns = getgenv().DiscordNotifyCooldowns
    local last = cooldowns[cooldownKey]
    if last and (now - last) < 15 then
        return false
    end
    cooldowns[cooldownKey] = now

    local playerName = "Unknown"
    pcall(function()
        local lp = Players.LocalPlayer
        if lp then
            playerName = lp.Name
        end
    end)

    local embed = {
        title = title or "FB Farm Alert",
        description = description or "Evento detectado.",
        color = color or 16753920,
        footer = {
            text = "Player: " .. playerName,
        },
        timestamp = DateTime.now():ToIsoDate(),
    }

    local payload = HttpService:JSONEncode({
        username = "FB Farm Notifier",
        embeds = { embed },
    })

    local req = resolveRequestFn()
    if req then
        local ok = pcall(function()
            req({
                Url = webhook,
                Method = "POST",
                Headers = { ["Content-Type"] = "application/json" },
                Body = payload,
            })
        end)
        return ok
    end

    local ok = pcall(function()
        HttpService:PostAsync(webhook, payload, Enum.HttpContentType.ApplicationJson)
    end)
    return ok
end

getgenv().SendDiscordAlert = sendDiscordAlert
print("Discord notifier cargado")
