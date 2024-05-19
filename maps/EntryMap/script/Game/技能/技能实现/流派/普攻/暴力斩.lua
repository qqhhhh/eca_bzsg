--这里的数字就是物编里技能的ID
local M = y3.object.ability[134280688]

function M.on_add(ability)
    local owner = ability:get_owner()
    ability:bindGC(owner:event('单位-造成伤害时',function (trg, data)
        if data.is_normal_hit then
            local probability = ability:kv_load('触发概率','integer')
            local random = GameAPI.get_random_int(1,100)
            if ability:kv_has('必定触发') and ability:kv_load('必定触发','boolean') then
                print('上次暴力斩杀死敌人，此次必定触发')
                probability = 100
            end
            if random <= probability then
                local damage = ability:kv_load('暴力斩伤害'..ability:get_level(),'integer')
                owner:damage({
                    damage = damage,
                    target = data.target_unit,
                    type = '物理',
                    text_type = 'physics',
                    ability = ability
                })
                print('暴力斩造成伤害'..damage)
            end
        end
    end))
    ability:bindGC(owner:event('单位-造成伤害后',function (trg, data)
        if data.ability == ability then
            if not data.target_unit:is_alive() then
                ability:kv_save('必定触发',true)
                print('暴力斩杀死敌人')
            end
        end
    end))
end
