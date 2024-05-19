local M = y3.object.ability[134232612]

function M.on_cast_start(ability, cast)
    local asdp = ability:get_owner():get_attr("攻击速度",'实际') / 100
    ability:get_owner():play_animation(ability:kv_load('SpellAni','string'), asdp, 0.0, -1.0, false, false)
end

function M.on_cast_channel(ability,cast)
    local owner = ability:get_owner()
    local target = cast:get_target_unit()
    if target then
        local dummy = y3.projectile.create {
            key    = ability:kv_load('投射物ID','integer'),
            owner = owner,
            target = owner:get_point(),
            ability = ability,
            height = 50,
        }
        dummy:mover_target({
            target = target,
            speed = 1500,
            target_distance = 1,
            height = 50,
            face_angle = true,
            on_finish = function (self)
                owner:damage {
                    target = target,
                    type = '法术',
                    damage = owner:get_attr("法术攻击",'实际'),
                    ability = ability, -- 关联技能
                    text_type = 'magic',
                    particle = ability:kv_load('命中特效','integer'), -- 特效
                    socket = 'hit_point'
                }
            end,
            on_remove = function (self)
                dummy:remove();
            end
        })
    end
end

function M.on_cast_finish(ability,cast)
    ability:get_owner():stop_animation(ability:kv_load('SpellAni','string'))
end
return M