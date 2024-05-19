--这里的数字就是物编里技能的ID
local M = y3.object.ability[134220179]

function M.on_add(ability)
    local owner = ability:get_owner()
    ability:bindGC(owner:event('单位-造成伤害前',function (trg, data)
        if data.is_normal_hit then
            local cd = ability:get_cd()
            if cd == 0 then
                ability:set_cd(ability:kv_load('CD时间','number'))
                ability:kv_save('无敌瞬斩次数',ability:kv_load('瞬间攻击','integer'))
                print('触发无敌瞬斩')
            else
                print('无敌瞬斩冷却ing')
            end 
        end
    end))

    ability:bindGC(owner:event('单位-造成伤害时',function (trg, data)
        if data.is_normal_hit then
            local attackCount = 0
            if ability:kv_has('无敌瞬斩次数') then
                attackCount = ability:kv_load('无敌瞬斩次数','integer')
            end
            if attackCount > 0 then
                ability:kv_save('无敌瞬斩次数',attackCount-1)
                owner:stop_all_abilities()
                data.ability:set_cd(0)
                owner:cast(data.ability, data.target_unit)
                print('触发无敌瞬斩剩余次数' .. attackCount-1)
            end
        end
    end))

    y3.game:event_on('战斗回合结束',function ()
        if ability:kv_has('无敌瞬斩次数') then
            ability:kv_save('无敌瞬斩次数',0)
        end
    end)
end