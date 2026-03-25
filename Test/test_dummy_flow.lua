-- ============================================
-- Dummy Test - Entry Point
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

if getgenv().DummyTestEnabled == false then
    return
end

print("Iniciando test con Respawn Dummy...")
loadScript("https://raw.githubusercontent.com/LordMoon17/FBScript/main/Test/follow_dummy.lua")
