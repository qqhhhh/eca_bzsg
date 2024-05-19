local Selector = require 'Game.技能.技能实现.SkillSelector'

--这里的数字就是物编里技能的ID
local M = y3.object.ability[200012]

function M.on_add(ability)
    local owner = ability:get_owner()
    ability:bindGC(owner:event('单位-造成伤害时',function (trg, data)
        if data.damage_instance:is_critical() then
            local damage = ability:kv_load('暴击伤害' .. ability:get_level(),'number') * data.damage
            if damage <= 1 then
                damage = 1
            end
            local radius = ability:kv_load('圆形半径', 'integer')
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
            print('爆炸攻击'..damage)
        end
    end))
end
