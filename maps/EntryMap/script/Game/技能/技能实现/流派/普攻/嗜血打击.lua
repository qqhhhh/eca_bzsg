--这里的数字就是物编里技能的ID
local M = y3.object.ability[134224778]

function M.on_add(ability)
    local owner = ability:get_owner()
    ability:bindGC(owner:event('单位-造成伤害时',function (trg, data)
        if not data.damage_instance:is_missed() and data.is_normal_hit then
            local up_atk = ability:kv_load('提升攻击力'..ability:get_level(),'integer')
            local up_atk_max = ability:kv_load('提升攻击力上限'..ability:get_level(),'integer')
            local save_atk = 0
            if ability:kv_has('嗜血打击加攻') then
                save_atk = ability:kv_load('嗜血打击加攻','integer')
            end
            if save_atk + up_atk > up_atk_max then
                up_atk = up_atk_max - save_atk
            end
            if up_atk > 0 then
                ability:kv_save('嗜血打击加攻',save_atk+up_atk)
                ability:get_owner():add_attr('物理攻击',up_atk,'增益')
                print('嗜血打击加攻' .. up_atk)
                print('当前总攻击' .. ability:get_owner():get_attr('物理攻击','实际'))
            end
        end
    end))

    y3.game:event_on('战斗回合结束',function ()
        local add_atk = 0
        if ability:kv_has('嗜血打击加攻') then
            add_atk = ability:kv_load('嗜血打击加攻','integer')
            ability:get_owner():add_attr('物理攻击',-add_atk,'增益')
            ability:kv_save('嗜血打击加攻',0)
        end
        print('减少嗜血打击加攻:' .. -add_atk)
        print('当前总攻击' .. ability:get_owner():get_attr('物理攻击','实际'))
    end)
end
