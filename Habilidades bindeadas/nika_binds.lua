local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")

local replicatorNoYield = ReplicatedStorage:WaitForChild("ReplicatorNoYield")

StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false)
print("HUD de Roblox eliminado")

local abilities = {
    [Enum.KeyCode.One] = function()
        replicatorNoYield:FireServer("Nika", "RocGun", {})
    end,
    [Enum.KeyCode.Two] = function()
        replicatorNoYield:FireServer("Nika", "NeoRedHawk", {})
    end,
    [Enum.KeyCode.Three] = function()
        replicatorNoYield:FireServer("Nika", "RocGatling", {})
    end,
    [Enum.KeyCode.Four] = function()
        replicatorNoYield:FireServer("Nika", "RedRoc", {})
    end,
}

if getgenv().NikaBindsConnection then
    getgenv().NikaBindsConnection:Disconnect()
end

getgenv().NikaBindsConnection = UIS.InputBegan:Connect(function(input, gp)
    if gp then
        return
    end

    local ability = abilities[input.KeyCode]
    if not ability then
        return
    end

    pcall(ability)
    print("Skill usada: " .. tostring(input.KeyCode))
end)

print("Habilidades 1-4 bindeadas")
