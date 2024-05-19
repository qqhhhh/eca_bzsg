--这里的数字就是物编里技能的ID
local M = y3.object.ability[134273535]

function M.on_add(ability)
    local owner = ability:get_owner()
    ability:bindGC(owner:event('单位-造成伤害时',function (trg, data)
        if data.is_normal_hit then
            local cd = ability:get_cd()
            if cd == 0 then
                ability:set_cd(ability:kv_load('冷却时间'..ability:get_level(),'number'))
                owner:stop_all_abilities()
                data.ability:set_cd(0)
                owner:cast(data.ability, data.target_unit)
                print('触发无畏')
            else
                print('无畏冷却ing')
            end 
        end
    end))
end