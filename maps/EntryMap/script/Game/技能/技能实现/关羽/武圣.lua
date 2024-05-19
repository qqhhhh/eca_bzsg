local M = y3.object.ability[901001]


function M.on_add(ability)
    local owner = ability:get_owner()
    owner:event("单位-造成伤害时",function (trg, data)
        if data.is_normal_hit then
            data.unit:add_buff({
                key = 134228683,
                source = data.unit,
                ability = nil,
                time = 2,
                pulse = 1,
                stacks = 1,
                })
        end
    end)
    owner:event('单位-造成伤害前',function (trg, data)
        local buff = data.unit:find_buff(134228683)
        if buff then
            local damage = data.damage_instance:get_damage()
            damage = damage * (1 + 0.1 * buff:get_stack())
            data.damage_instance:set_damage(damage)
        end
    end)
end

function M.on_lose(ability)
end