--这里的数字就是物编里技能的ID
local M = y3.object.ability[230002]

function M.on_add(ability)
    local owner = ability:get_owner()
    ability:bindGC(owner:event('单位-造成伤害时',function (trg, data)
        if data.damage_instance:is_critical() then
            local probability = ability:kv_load('暴击概率%','integer')
            local random = GameAPI.get_random_int(1,100)
            if random <= probability then
                local damage = ability:kv_load('伤害','integer')
                local time = ability:kv_load('击晕','number')
                data.target_unit:add_buff({
                    key = ability:kv_load('眩晕状态','integer'),
                    source = owner,
                    ability = ability,
                    time = time,
                    })
                owner:damage({
                        damage = damage,
                        target = data.target_unit,
                        type = '真实',
                        text_type = 'real',
                        ability = ability
                    })
                print('触发暴力重击')
            end
        end
    end))
end
