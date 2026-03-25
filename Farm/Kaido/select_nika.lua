-- ============================================
-- Kaido Farm - Select Nika
-- ============================================
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

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

local equipBtn = LocalPlayer.PlayerGui.UI.Fruits.Equip

for _, connection in pairs(getconnections(equipBtn.MouseButton1Click)) do
    local upvalues = getupvalues(connection.Function)
    local moduleTbl = upvalues[2]
    local btnObj = moduleTbl.Buttons[equipBtn]

    if btnObj then
        local clickUpvalues = getupvalues(btnObj.Click)
        local clickTbl = clickUpvalues[5]

        local Loader = getupvalues(clickTbl.EquipFruit)[3]
        Loader.Monetization.PlayerOwnsGamepass = function()
            return true
        end

        local shelf = getupvalues(clickTbl.EquipFruit)[2]
        shelf.Value = 1

        local ok, err = pcall(function()
            clickTbl.EquipFruit(btnObj, equipBtn)
        end)

        if ok then
            print("Nika equipada correctamente")
            LocalPlayer.PlayerGui.UI.Fruits.Visible = false
            task.wait(0.5)
            loadScript("https://raw.githubusercontent.com/LordMoon17/FBScript/main/Rejoin/Join.Lua")
        else
            warn("Error al equipar: " .. tostring(err))
        end
    end

    break
end
