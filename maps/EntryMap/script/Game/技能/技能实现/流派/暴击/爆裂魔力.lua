--这里的数字就是物编里技能的ID
local M = y3.object.ability[200004]

function M.on_add(ability)
    local owner = ability:get_owner()
    ability:bindGC(owner:event('单位-造成伤害时',function (trg, data)
        if data.damage_instance:is_critical() then
            owner:add_mp(ability:kv_load('lv'..ability:get_level(),'integer'))
            print('爆裂魔力增加MP：' .. ability:kv_load('lv'..ability:get_level(),'integer'))
        end
    end))
end
