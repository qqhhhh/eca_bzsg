local enemyPool = require 'Game.战场.EnemyPool'

local M = y3.object.ability[903002]

function M.on_cast_shot(ability, cast)
    local owner = ability:get_owner();
    local dis = 9999999
    local target = nil
    for index, value in pairs(enemyPool.enemy_Group:pick()) do
        if value:is_alive() then
            local curDis = owner:get_point():get_distance_with(value:get_point())
            if curDis < dis then
                dis = curDis
                target = value
            end 
        end
    end
    if target then
        local dummy = y3.projectile.create {
            key    = ability:kv_load('投射物ID','integer'),
            target = target:get_point(),
            time = ability:kv_load('投射物存在时间','number'),
            height = 50
        }
        y3.particle.create({
            type = 134231819,
            target = target:get_point(),
            time = ability:kv_load('投射物存在时间','number')
        })
        dummy:mover_round({
            height = 50,
            target = target:get_point(),
            radius = 5,
            angle_speed = 500,
            hit_type = 1,
            hit_radius = ability:kv_load('投射物碰撞范围','integer'),
            hit_same = true,
            hit_interval = ability:kv_load('出伤间隔','number'),
            ability = ability,
            unit = owner,
            on_remove = function ()
                dummy:remove()
            end,
            on_hit = function (self, unit)
                owner:damage {
                    target = unit,
                    type = '法术',
                    damage = ability:kv_load('伤害','integer'),
                    ability = ability, -- 关联技能
                    no_miss = true,    -- 必定命中
                    text_type = 'magic',
                }
            end,
        })
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