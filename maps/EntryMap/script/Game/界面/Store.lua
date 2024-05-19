local M = {}

---@param playerData table
function M.Enter(playerData)
    local ui = y3.ui.get_ui(playerData.player, '')
    ui:set_visible(true);
end

---@param player Player
---@param show boolean
function M.SetVisible(player,show)
    local ui = y3.ui.get_ui(player, '')
    ui:set_visible(show);
end

y3.game:event('界面-消息', '打开商店', function (trg, data)
    
end)

return M;