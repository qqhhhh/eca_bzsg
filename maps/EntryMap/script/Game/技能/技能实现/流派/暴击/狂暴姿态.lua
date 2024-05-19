--这里的数字就是物编里技能的ID
local M = y3.object.ability[220003]

function M.on_add(ability)
    local owner = ability:get_owner()
    ability:bindGC(owner:event('单位-造成伤害时',function (trg, data)
        if data.damage_instance:is_critical() then
            local time = ability:kv_load('持续时间','integer')
            local buffId = ability:kv_load('附加效果','integer')
            local buff = data.unit:find_buff(buffId)
            if buff then
                buff:set_time(time)
            else
                print('新加buff')
                print(ability:get_owner():get_attr("物理攻击",'实际'))
                local newBbuff = data.unit:add_buff({
                    key = ability:kv_load('附加效果','integer'),
                    source = data.unit,
                    ability = ability,
                    time = time,
                    })
                if newBbuff then
                    local c = ability:kv_load('暴击率%' .. ability:get_level(),'integer')
                    local c_damage = ability:kv_load('暴击伤害增加%' .. ability:get_level(),'integer')
                    print('狂暴姿态增加暴击：' .. c)
                    print('增加前：' .. ability:get_owner():get_attr("暴击率",'实际'))
                    newBbuff:bindGC(data.unit:add_attr_gc("暴击率",c,'增益'))
                    print('增加后:' .. ability:get_owner():get_attr("暴击率",'实际'))

                    print('狂暴姿态增加暴伤：' .. c_damage)
                    print('增加前：' .. ability:get_owner():get_attr("暴击伤害",'实际'))
                    newBbuff:bindGC(data.unit:add_attr_gc("暴击伤害",c_damage,'增益'))
                    print('增加后' .. ability:get_owner():get_attr("暴击伤害",'实际'))
                end
            end
        end
    end))
    ability:bindGC(owner:event("单位-受到伤害前", function (trg, data)
        if data.target_unit == owner then
            local buffId = ability:kv_load('附加效果','integer')
            if owner:find_buff(buffId) then
                local bear = ability:kv_load('被伤害增加%' .. ability:get_level(),'number')
                local oldDamage = data.damage_instance:get_damage()
                print('狂暴姿态原始伤害:'..oldDamage)
                local newDamage = oldDamage + oldDamage * bear
                print('狂暴姿态新伤害:'..newDamage)
                data.damage_instance:set_damage(newDamage)
            end
        end
    end))
end
