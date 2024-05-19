--这里的数字就是物编里技能的ID
local M = y3.object.ability[134225698]

function M.on_add(ability)
    local owner = ability:get_owner()

    ability:bindGC(owner:event('单位-造成伤害时',function (trg, data)
        local probability = ability:kv_load('每次攻击触发概率%','integer')
        local random = GameAPI.get_random_int(1,100)
        if random < probability then
            local recovery = ability:kv_load('获得怒火'..ability:get_level(),'integer')
            local buffId = ability:kv_load('触发效果','integer')
            data.unit:add_buff({
                key = buffId,
                source = data.unit,
                ability = ability,
                time = -1,
                pulse = 3,
                stacks = recovery
                })
            print('增加怒火层：'..recovery)
        end
    end))
end
