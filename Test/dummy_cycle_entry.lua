-- ============================================
-- Dummy Cycle - Entry Point
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

if getgenv().DummyCycleEnabled == false then
    return
end

print("Iniciando ciclo completo con Respawn Dummy...")
loadScript("https://raw.githubusercontent.com/LordMoon17/FBScript/main/Rejoin/Join.Lua")
loadScript("https://raw.githubusercontent.com/LordMoon17/FBScript/main/Test/wait_dummy.lua")
