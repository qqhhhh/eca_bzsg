local Selector = require 'Game.技能.技能实现.SkillSelector'

local M = y3.object.ability[903001]


function M.on_add(ability)
    local owner = ability:get_owner()
    ability:bindGC(owner:event('单位-造成伤害时',function (trg, data)
        if data.damage_type == 1 then
            local probability = ability:kv_load('触发概率','integer')
            local random = GameAPI.get_random_int(1,100)
            if random <= probability then
                local dummy = y3.projectile.create {
                    key    = ability:kv_load('投射物ID','integer'),
                    owner = owner,
                    target = owner:get_point(),
                    ability = ability,
                    height = 50,
                }
                dummy:mover_target({
                    target = data.target_unit,
                    speed = 2000,
                    target_distance = 1,
                    height = 50,
                    face_angle = true,
                    on_finish = function (self)
                        local damage = ability:kv_load('伤害','integer')
                        local restore = ability:kv_load('回复生命%','number')
                        damage = damage + owner:get_attr("法术攻击",'实际')
                        owner:add_hp(damage*restore)
                        print('筹策回复生命'..damage*restore)
                        print('筹策造成伤害'..damage)
                        owner:damage {
                            target = data.target_unit,
                            type = '法术',
                            damage = damage,
                            ability = ability, -- 关联技能
                            text_type = 'magic'
                        }
                    end,
                    on_remove = function (self)
                        dummy:remove();
                    end
                })
            end
        end
    end))
end
return M