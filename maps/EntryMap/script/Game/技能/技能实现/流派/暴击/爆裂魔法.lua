--这里的数字就是物编里技能的ID
local M = y3.object.ability[220001]

function M.on_add(ability)
    local owner = ability:get_owner()
    ability:bindGC(owner:event('单位-造成伤害前',function (trg, data)
        if not data.is_normal_hit then
            local cur_C = owner:get_attr("暴击率",'实际')
            local damage_C = owner:get_attr('暴击伤害','实际') / 2
            local skill_c = ability:kv_load('暴击率'..ability:get_level(),'number');
            cur_C = cur_C * skill_c
            print('爆裂魔法暴击率：'..cur_C)
            local random = GameAPI.get_random_int(1,100)
            if random <= cur_C then
                print('爆裂魔法修改伤害实例')
                local instance_damage = data.damage_instance:get_damage()
                print('暴击前：' .. instance_damage)
                instance_damage = instance_damage * (damage_C / 100)
                print('暴击后：' .. instance_damage)
                data.damage_instance:set_damage(instance_damage)
                data.damage_instance:set_critical(true)
            end
        end
    end))
end
