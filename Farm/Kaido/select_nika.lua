-- ============================================
-- Kaido Farm - Select Nika
-- ============================================
local equipBtn = game.Players.LocalPlayer.PlayerGui.UI.Fruits.Equip

for _, connection in pairs(getconnections(equipBtn.MouseButton1Click)) do
    local upvalues = getupvalues(connection.Function)
    local module_tbl = upvalues[2]
    local btnObj = module_tbl.Buttons[equipBtn]
    if btnObj then
        local clickUpvalues = getupvalues(btnObj.Click)
        local Click_tbl = clickUpvalues[5]
        
        local Loader = getupvalues(Click_tbl.EquipFruit)[3]
        Loader.Monetization.PlayerOwnsGamepass = function() return true end
        
        local shelf = getupvalues(Click_tbl.EquipFruit)[2]
        shelf.Value = 1
        
        local ok, err = pcall(function()
            Click_tbl.EquipFruit(btnObj, equipBtn)
        end)
        
        if ok then
            print("✅ Nika equipada correctamente")
        else
            warn("❌ Error al equipar: " .. tostring(err))
        end
        
        game.Players.LocalPlayer.PlayerGui.UI.Fruits.Visible = false
    end
    break
end