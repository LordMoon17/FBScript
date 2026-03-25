-- ============================================
-- Kaido Farm - Test Flow
-- Archivo temporal para probar TP + Gear5 bug
-- ============================================
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

print("Iniciando test de TP + Gear5 bug...")
loadScript("https://raw.githubusercontent.com/LordMoon17/FBScript/main/Farm/Kaido/ubication.lua")
