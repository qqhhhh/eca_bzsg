--这里的数字就是物编里技能的ID
local M = y3.object.ability[200011]

function M.on_add(ability)
    y3.game:event_on('开始战斗回合-敌人初始化完成',function ()
        local recovery = ability:kv_load('lv'..ability:get_level(),'integer')
        local units = y3.player.get_by_id(31):get_all_units():pick()
        for index, value in ipairs(units) do
            value:set_attr('暴击率',-recovery)
            print(value:get_name() .. '减少暴击率：' .. recovery)
        end
    end)
end
