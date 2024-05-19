local equipPool = require 'Game.战场.EquipPool'

local M = {}

---comment
---@param playerData table
---@param rounds integer
function M.Enter(playerData,rounds)
    local ui = y3.ui.get_ui(playerData.player, '装备选择')
    local root = y3.ui.get_ui(playerData.player, '装备选择.装备')
    for key, value in pairs(root:get_childs()) do
        value:remove()
    end
    local equips = equipPool.RandomEquips('秘籍',rounds,3)
    local pos_x = {
        [1] = 634,
        [2] = 911,
        [3] = 1188,
    }
    for index, value in ipairs(equips) do
        local curUi = y3.ui_prefab.create(playerData.player,'道具卡牌',root)
        if curUi then
            curUi:get_child():set_pos(pos_x[index],575)
            curUi:get_child('卡牌内容.物品图片底图.物品图片'):set_image(y3.item.get_icon_id_by_key(value))
            curUi:get_child('卡牌内容.物品名称'):set_text(y3.item.get_name_by_key(value))
            curUi:get_child('卡牌内容.物品描述'):set_text(y3.item.get_description_by_key(value))
            curUi:get_child('卡牌内容'):add_event('左键-按下','选秘籍',value)
        end
    end
    ui:set_visible(true);
end

---@param player Player
---@param show boolean
function M.SelectUiVisible(player,show)
    local ui = y3.ui.get_ui(player, '装备选择')
    ui:set_visible(show);
end

return M;