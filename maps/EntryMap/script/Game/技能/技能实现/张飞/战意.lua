--这里的数字就是物编里技能的ID
local M = y3.object.ability[902001]

function M.on_add(ability)
    local owner = ability:get_owner()
    ability:kv_save('累计次数',0)
    ability:bindGC(owner:event('单位-造成伤害时',function (trg, data)
        if data.damage_instance:is_critical() then
            local c_damage = ability:kv_load('增加暴击伤害','integer')
            local max_coun = ability:kv_load('最多次数','integer')
            local count = ability:kv_load('累计次数','integer');
            if count < max_coun then
                count = count + 1
                ability:kv_save('累计次数',count)
                owner:add_attr('暴击伤害',c_damage)
                print('张飞战役增加暴击伤害：' .. c_damage)
                print('张飞战役累计次数：' .. count)
            end
        else
            local c_damage = ability:kv_load('增加暴击伤害','integer')
            local count = ability:kv_load('累计次数','integer');
            if count > 0 then
                owner:add_attr('暴击伤害',-(count * c_damage))
                print('张飞战役减少暴击伤害：' .. count * c_damage)
            end
            ability:kv_save('累计次数',0)
        end
    end))
end
