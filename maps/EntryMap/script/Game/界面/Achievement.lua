local M = {}

---@param player Player
function M.Enter(player)
    local ui = y3.ui.get_ui(player, '成就')
    ui:set_visible(true);
end

---@param player Player
---@param show boolean
function M.SetVisible(player,show)
    local ui = y3.ui.get_ui(player, '成就')
    ui:set_visible(show);
end

y3.game:event('界面-消息', '关闭成就', function (trg, data)
    M.SetVisible(data.player,false)
end)

y3.game:event('界面-消息', '打开成就', function (trg, data)
    M.SetVisible(data.player,true)
end)

return M;