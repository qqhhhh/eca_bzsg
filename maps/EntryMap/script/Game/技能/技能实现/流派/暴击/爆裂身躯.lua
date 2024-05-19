--这里的数字就是物编里技能的ID
local M = y3.object.ability[200009]

function M.on_add(ability)
    y3.game:event_on('开始战斗回合',function ()
        local base_atk = ability:kv_load('开战前每点暴击率','integer')
        base_atk = ability:get_owner():get_attr('暴击率','实际') / base_atk
        local add_hp = ability:kv_load('lv'..ability:get_level(),'integer')
        local addHpMax = math.floor(base_atk * add_hp)
        ability:kv_save('已增加生命最大值',addHpMax)
        ability:get_owner():add_attr('最大生命',addHpMax,'增益')
        ability:get_owner():add_hp(addHpMax)
        print('增加最大生命:' .. addHpMax)
    end)

    y3.game:event_on('战斗回合结束',function ()
        local add_ph = 0
        if ability:kv_has('已增加生命最大值') then
            add_ph = ability:kv_load('已增加生命最大值','integer')
            ability:get_owner():add_attr('最大生命',-add_ph,'增益')
            ability:kv_save('已增加生命最大值',0)
        end
        print('减少最大生命:' .. -add_ph)
    end)
end
