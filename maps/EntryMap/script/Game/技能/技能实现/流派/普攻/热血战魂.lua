--这里的数字就是物编里技能的ID
local M = y3.object.ability[134245971]

function M.on_add(ability)
    local owner = ability:get_owner()
    ability:bindGC(owner:event('单位-造成伤害时',function (trg, data)
        if data.is_normal_hit then
            local up_asdp = ability:kv_load('每次攻速提升','integer')
            local up_asdp_max = ability:kv_load('最高提升','integer')
            local save_asdp = 0
            if ability:kv_has('热血战魂增加攻速') then
                save_asdp = ability:kv_load('热血战魂增加攻速','integer')
            end
            if save_asdp + up_asdp > up_asdp_max then
                up_asdp = up_asdp_max - save_asdp
            end
            if up_asdp > 0 then
                ability:kv_save('热血战魂增加攻速',save_asdp+up_asdp)
                ability:get_owner():add_attr('攻击速度',up_asdp,'增益')
                print('热血战魂增加攻速' .. up_asdp)
                print('当前攻速' .. ability:get_owner():get_attr('攻击速度','实际'))
            end
        end
    end))

    ability:bindGC(owner:event('单位-脱离战斗',function (trg, data)
        print(data.unit:get_name()..'脱离战斗')
        local add_asdp = 0
        if ability:kv_has('热血战魂增加攻速') then
            add_asdp = ability:kv_load('热血战魂增加攻速','integer')
            ability:get_owner():add_attr('攻击速度',-add_asdp,'增益')
            ability:kv_save('热血战魂增加攻速',0)
        end
        print('脱离战斗减少热血战魂增加攻速:' .. -add_asdp)
        print('当前攻速' .. ability:get_owner():get_attr('攻击速度','实际'))
    end))

    y3.game:event_on('战斗回合结束',function ()
        local add_asdp = 0
        if ability:kv_has('热血战魂增加攻速') then
            add_asdp = ability:kv_load('热血战魂增加攻速','integer')
            ability:get_owner():add_attr('攻击速度',-add_asdp,'增益')
            ability:kv_save('热血战魂增加攻速',0)
        end
        print('减少热血战魂增加攻速:' .. -add_asdp)
        print('当前攻速' .. ability:get_owner():get_attr('攻击速度','实际'))
    end)
end
