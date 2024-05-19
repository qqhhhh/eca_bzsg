--这里的数字就是物编里技能的ID
local M = y3.object.ability[134266331]

function M.on_add(ability)
    local owner = ability:get_owner()
    ability:bindGC(owner:event('单位-造成伤害时',function (trg, data)
        if not data.damage_instance:is_missed() and data.is_normal_hit then
            local probability = ability:kv_load('每次攻击触发概率%','integer')
            local random = GameAPI.get_random_int(1,100)
            if random < probability then
                local recovery = ability:kv_load('回复生命值'..data.ability:get_level(),'integer')
                data.source_unit:add_hp(recovery)
                print('回复生命值'..recovery)
            end
        end
    end))
end
