local replicatorNoYield = game:GetService("ReplicatedStorage"):WaitForChild("ReplicatorNoYield")
local UIS = game:GetService("UserInputService")
local player = game:GetService("Players").LocalPlayer

-- Desactivar el backpack/hotbar nativo de Roblox
game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false)

print("✅ HUD de Roblox eliminado")

local abilities = {
    [Enum.KeyCode.One]   = function() replicatorNoYield:FireServer("Nika", "RocGun", {}) end,
    [Enum.KeyCode.Two]   = function() replicatorNoYield:FireServer("Nika", "NeoRedHawk", {}) end,
    [Enum.KeyCode.Three] = function() replicatorNoYield:FireServer("Nika", "RocGatling", {}) end,
    [Enum.KeyCode.Four]  = function() replicatorNoYield:FireServer("Nika", "RedRoc", {}) end,
}

UIS.InputBegan:Connect(function(input, gp)
    if gp then return end
    if abilities[input.KeyCode] then
        pcall(abilities[input.KeyCode])
        print("✅ " .. tostring(input.KeyCode))
    end
end)

print("✅ Habilidades 1-4 bindeadas")