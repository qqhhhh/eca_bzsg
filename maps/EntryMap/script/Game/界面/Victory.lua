local M = {}

---@param playerData table
function M.Enter(playerData)
    local ui = y3.ui.get_ui(playerData.player, '结算界面胜利')
    ui:set_visible(true);
end

return M;