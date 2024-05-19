local Selector = require 'Game.技能.技能实现.SkillSelector'

local M = y3.object.ability[905002]

function M.on_cast_shot(ability, cast)
    local owner = ability:get_owner();
    local projectileId = ability:kv_load('投射物ID','integer')
    local radius = ability:kv_load('投射物距离','integer')
    local count = ability:kv_load("额外攻击次数",'integer') + 1
    ability:get_owner():set_facing(cast:get_angle(),0.01)
    y3.timer.count_loop(0.3,count,function (timer, count)
        local dummy = y3.projectile.create {
            key    = projectileId,
            target = owner:get_point(),
            time = 3,
        }
        dummy:mover_line({
            angle = owner:get_facing(),
            distance = radius,
            speed = 1000,
            ability = ability,
            unit = owner,
            hit_radius = 100,
            hit_type = 1,
            on_remove = function ()
                dummy:remove()
            end,
            on_hit = function (self, unit)
                owner:damage {
                    target = unit,
                    type = '物理',
                    damage = ability:kv_load('造成伤害','integer'),
                    ability = ability, -- 关联技能
                    no_miss = true,    -- 必定命中
                    text_type = 'physics',
                    particle = ability:kv_load('命中特效','integer'), -- 特效
                }
            end,
        })
    end)
end

function M.on_cast_start(ability, cast)
    local owner = ability:get_owner()
    if owner then
        local atk = ability:kv_load('每点攻击力释放','integer')
        local count = math.floor(owner:get_attr("物理攻击",'实际') / atk)
        ability:kv_save("额外攻击次数",count)
        print('一气斩额外次数：' .. count)
        owner:play_animation(ability:kv_load('攻击动作','string'), 1.0 + count, 0.0, -1.0, true, true)
    end
end

return M