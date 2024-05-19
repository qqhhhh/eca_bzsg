--这里的数字就是物编里技能的ID
local M = y3.object.ability[134246563]

function M.on_add(ability)
    local owner = ability:get_owner()
    ability:bindGC(owner:event('单位-造成伤害时',function (trg, data)
        if not data.damage_instance:is_missed() and data.is_normal_hit then
            local recovery = ability:kv_load('减少敌人攻击力%'..data.ability:get_level(),'integer')
            local buffId = ability:kv_load('触发效果','integer')
            data.target_unit:add_buff({
                key = buffId,
                source = data.unit,
                ability = ability,
                time = -1,
                pulse = 3,
                stacks = recovery
                })
            print('目标更新减攻:' .. data.target_unit:get_name() .. "-" ..recovery)
        end
    end))
end
