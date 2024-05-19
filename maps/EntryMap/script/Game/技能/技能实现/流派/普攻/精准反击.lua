--这里的数字就是物编里技能的ID
local M = y3.object.ability[134234760]

function M.on_add(ability)
    local owner = ability:get_owner()
    ability:bindGC(owner:event('单位-受到伤害时',function (trg, data)
        local cd = ability:get_cd()
            if cd == 0 then
                ability:set_cd(ability:kv_load('冷却时间'..ability:get_level(),'number'))
                local castAbility = owner:find_ability('普通',201347498) --普攻
                if castAbility then
                    owner:stop_all_abilities()
                    castAbility:set_cd(0)
                    owner:cast(castAbility, data.source_unit)
                    print('触发精准反击')
                end

            else
                print('精准反击冷却ing')
            end
    end))
end