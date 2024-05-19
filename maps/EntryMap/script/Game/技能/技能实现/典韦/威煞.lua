--这里的数字就是物编里技能的ID
local M = y3.object.ability[905001]

function M.on_add(ability)
    local owner = ability:get_owner()
    ability:kv_save('攻击次数',0)
    ability:kv_save('威煞伤害',0)
    ability:bindGC(owner:event('单位-造成伤害前',function (trg, data)
        if data.is_normal_hit and not data.damage_instance:is_missed() then
            local maxCount = ability:kv_load('充能次数','integer')
            local curCount = ability:kv_load('攻击次数','integer')
            if curCount >= maxCount then
                ability:kv_save('攻击次数',0)
                
                local addDamage = math.floor((owner:get_attr('最大生命','实际') - owner:get_hp()) * ability:kv_load('损失生命','number'))
                
                ability:kv_save('威煞伤害',addDamage)
                print('威煞充能：'..addDamage)
            else
                local addDamage = ability:kv_load('威煞伤害','integer')
                if addDamage > 0 then
                    local damage = ability:kv_load('附加伤害','integer')
                    local oldDamage = data.damage
                    --data.damage_instance():set_missed(false)
                    data.damage_instance():set_damage(damage + addDamage + oldDamage)
                    ability:kv_save('威煞伤害',0)
                    print('威煞造成伤害：'..damage + addDamage + oldDamage)
                else
                    curCount = curCount + 1
                    ability:kv_save('攻击次数',curCount)
                end
            end
        end
    end))
end
