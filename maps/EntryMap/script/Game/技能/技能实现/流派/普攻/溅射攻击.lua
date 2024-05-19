--这里的数字就是物编里技能的ID
local M = y3.object.ability[134232896]

function M.on_add(ability)
    local owner = ability:get_owner()
    ability:bindGC(owner:event('单位-造成伤害时',function (trg, data)
        if not data.damage_instance:is_missed() and data.is_normal_hit then
            local damage = ability:kv_load('伤害'..data.ability:get_level(),'integer')
            if damage > 0 then
                local units = y3.player.get_by_id(31):get_all_units():pick()
                local targetPos = data.target_unit:get_point()
                local distance = 99999
                local otherUnit = nil
                for index, value in ipairs(units) do
                    if value ~= data.target_unit then
                        local curDistance = value:get_point():get_distance_with(targetPos)
                        if curDistance < distance then
                            distance = curDistance
                            otherUnit = value
                        end
                    end
                end
                if otherUnit then
                    print('溅射成功：' .. otherUnit:get_name() .. ' 造成伤害：' .. damage)
                    owner:damage({
                        damage = damage,
                        target = otherUnit,
                        type = '物理',
                        text_type = 'physics'
                    })
                else
                    print('无溅射目标')
                end
            end
        end
    end))
end
