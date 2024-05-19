--这里的数字就是物编里技能的ID
local M = y3.object.ability[220002]

function M.on_add(ability)
    local owner = ability:get_owner()
    ability:bindGC(owner:event('单位-造成伤害时',function (trg, data)
        if data.damage_instance:is_critical() then
            local hp = ability:kv_load('lv'..ability:get_level(),'number')
            local targetHp = data.target_unit:get_hp()
            print('目标生命' .. targetHp)
            local damage = math.floor(targetHp * hp)
            if damage < 1 then
                damage = 1
            end
            owner:damage({
                damage = damage,
                target = data.target_unit,
                type = '真实',
                text_type = 'physics',
            })
            print('命原爆破流失目标生命' .. damage)
        end
    end))
end
