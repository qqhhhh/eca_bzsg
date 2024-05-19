local Selector = require 'Game.技能.技能实现.SkillSelector'

local M = y3.object.ability[134253635]

function M.on_add(ability)
    local owner = ability:get_owner()
    ability:bindGC(owner:event('单位-造成伤害时',function (trg, data)
        if data.is_normal_hit then
            local probability = ability:kv_load('触发概率','integer')
            local random = GameAPI.get_random_int(1,100)
            if random <= probability then
                local damage = ability:kv_load('伤害','integer')
                local radius = ability:kv_load('半径', 'integer')
                local targets = Selector.GetUnitsByRound(owner,radius)
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
                print('暴力斩造成伤害'..damage)
            end
        end
    end))
end

return M