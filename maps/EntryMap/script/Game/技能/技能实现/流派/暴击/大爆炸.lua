local Selector = require 'Game.技能.技能实现.SkillSelector'

--这里的数字就是物编里技能的ID
local M = y3.object.ability[230003]

function M.on_add(ability)
    local owner = ability:get_owner()
    ability:bindGC(owner:event('单位-造成伤害时',function (trg, data)
        if data.damage_instance:is_critical() then
            local count = ability:kv_load('剩余次数','integer')
            if count > 0 then
                count = count - 1
                ability:kv_save('剩余次数',count)
                print('大爆炸剩余次数:' .. count)
                if count == 0 then
                    print('大爆炸触发')
                    local damage = ability:kv_load('伤害','integer')
                    local radius = ability:kv_load('范围半径','integer')
                    local distance = ability:kv_load('前方距离','integer')
                    local pos = y3.point.get_point_offset_vector(owner:get_point(),owner:get_facing(),distance)
                    local targets = Selector.GetUnitsByRoundAndPos(pos,radius)
                    for index, value in ipairs(targets) do
                        if value ~= owner then
                            owner:damage({
                                damage = damage,
                                target = value,
                                type = '物理',
                                text_type = 'physics',
                                ability = ability
                            })
                        end
                    end
                    ability:kv_save('剩余次数',ability:kv_load('触发次数','integer'))
                end
            end
        end
    end))

    y3.game:event_on('开始战斗回合',function ()
        ability:kv_save('剩余次数',ability:kv_load('触发次数','integer'))
    end)
end
