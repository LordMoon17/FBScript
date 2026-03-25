local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
local replicator = ReplicatedStorage:WaitForChild("Replicator")
local DRUM_WAIT = 3
local GEAR5_WAIT = 3

if getgenv().Gear5BugRunning then
    return
end

getgenv().Gear5BugRunning = true

local function activateGear5Bug()
    for press = 1, 4 do
        local ok, err = pcall(function()
            replicator:InvokeServer("Nika", "DrumsofLiberation", {})
        end)

        if not ok then
            warn("Error activando DrumsofLiberation: " .. tostring(err))
            getgenv().Gear5BugRunning = false
            return
        end

        print("Drums " .. press .. "/4")
        task.wait(DRUM_WAIT)
    end

    task.wait(GEAR5_WAIT)

    local ok, err = pcall(function()
        replicator:InvokeServer("Nika", "Gear5", {})
    end)

    if not ok then
        warn("Error activando Gear5: " .. tostring(err))
        getgenv().Gear5BugRunning = false
        return
    end

    print("Gear5 activado, reiniciando...")
    task.wait(0.5)

    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.Health = 0
    end

    task.wait(1)
    getgenv().Gear5BugRunning = false
end

task.spawn(activateGear5Bug)
