local player = game:GetService("Players").LocalPlayer
local replicator = game:GetService("ReplicatedStorage"):WaitForChild("Replicator")
local UIS = game:GetService("UserInputService")

local pressCount = 0
local resetting = false

UIS.InputBegan:Connect(function(input, gp)
    if gp or resetting then return end
    if input.KeyCode == Enum.KeyCode.G then
        pressCount = pressCount + 1
        print("🎯 Press " .. pressCount .. "/5")
        
        local ok, err = pcall(function()
            if pressCount >= 5 then
                resetting = true
                replicator:InvokeServer("Nika", "Gear5", {})
                pressCount = 0
                print("⭐ Gear5 activado! Reiniciando en 0.5 segundos...")
                task.wait(0.5)
                player.Character.Humanoid.Health = 0
                print("✅ Reiniciado")
                task.wait(1)
                resetting = false
            else
                replicator:InvokeServer("Nika", "DrumsofLiberation", {})
                print("🥁 Drums " .. pressCount .. "/4")
            end
        end)
        if not ok then 
            print("❌ " .. tostring(err))
            resetting = false
        end
    end
end)

print("✅ G bindeada - Nika Awakening + Auto Reinicio")