local M = {}

---@param playerData table
function M.Enter(playerData)
    local ui = y3.ui.get_ui(playerData.player, '结算失败界面')
    ui:set_visible(true);
end

return M;