-- ============================================
-- Kaido - Ubicación y TP
-- ============================================
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Coordenadas de Kaido (actualizar cuando aparezca)
local KAIDO_POSITION = Vector3.new(0, 0, 0) -- Cambiar por coordenadas reales

local function tpToKaido()
    local character = LocalPlayer.Character
    if not character then
        warn("❌ No hay personaje")
        return
    end
    
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then
        warn("❌ No se encontró HumanoidRootPart")
        return
    end
    
    hrp.CFrame = CFrame.new(KAIDO_POSITION)
    print("✅ TP a Kaido completado")
end

tpToKaido()