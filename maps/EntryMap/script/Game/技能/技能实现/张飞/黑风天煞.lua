local Selector = require 'Game.技能.技能实现.SkillSelector'

local M = y3.object.ability[902002]

function M.on_cast_shot(ability, cast)
    local owner = ability:get_owner();
    owner:set_facing(cast:get_angle(),0.01)
    local curAngle = owner:get_facing()
    y3.particle.create({
        type = ability:kv_load('播放特效','integer'),
        target = owner:get_point(),
        angle = curAngle,
        time = 3,
        height = 50,
        scale = 3
    })

    local targets = Selector.GetUnits(ability,cast)
    for index, value in ipairs(targets) do
        if owner:is_enemy(value) then
            owner:damage {
                target = value,
                type = '物理',
                damage = ability:get_float_attr('ability_damage'),
                ability = ability, -- 关联技能
                no_miss = true,    -- 必定命中
                text_type = 'physics',
                particle = ability:kv_load('命中特效','integer'), -- 特效
            }
        end
    end
end

function M.on_cast_start(ability, cast)
    local owner = ability:get_owner()
    if owner then
        owner:play_animation(ability:kv_load('攻击动作','string'), 1.0, 0.0, -1.0, false, true)
    end
end

function M.on_cast_finish(ability,cast)

end
return M