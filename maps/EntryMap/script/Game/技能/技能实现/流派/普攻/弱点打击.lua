--这里的数字就是物编里技能的ID
local M = y3.object.ability[134278073]

function M.on_add(ability)
    local owner = ability:get_owner()
    ability:bindGC(owner:event('单位-造成伤害时',function (trg, data)
        if not data.damage_instance:is_missed() and data.is_normal_hit then
            local probability = ability:kv_load('攻击概率%','integer')
            local random = GameAPI.get_random_int(1,100)
            if random < probability then
                local recovery = ability:kv_load('易伤层数'..ability:get_level(),'integer')
                local buffId = ability:kv_load('触发效果','integer')
                data.target_unit:add_buff({
                    key = buffId,
                    source = owner,
                    ability = ability,
                    time = -1,
                    pulse = 3,
                    stacks = recovery
                    })
                print('触发易伤'..recovery)
            end
        end
    end))
end
