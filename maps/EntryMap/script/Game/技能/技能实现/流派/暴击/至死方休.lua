--这里的数字就是物编里技能的ID
local M = y3.object.ability[230001]

function M.on_add(ability)
    local owner = ability:get_owner()
    ability:bindGC(owner:event('单位-造成伤害时',function (trg, data)
        if data.damage_instance:is_critical() then
            local count = ability:kv_load('剩余次数','integer')
            if count > 0 then
                count = count - 1
                ability:kv_save('剩余次数',count)
                print('至死方休剩余触发次数:' .. count)
                if count == 0 then
                    local add_cd = ability:kv_load('暴击伤害','integer')
                    owner:add_attr("暴击伤害",-add_cd)
                    local add_c = ability:kv_load('暴击率','integer')
                    owner:add_attr('暴击率',-add_c)

                    print('至死方休触发结束减少爆伤:' .. add_cd)
                    print('至死方休触发结束减少暴击:' .. add_c)
                end
            end
        end
    end))

    y3.game:event_on('开始战斗回合',function ()
        local add_cd = ability:kv_load('暴击伤害','integer')
        owner:add_attr("暴击伤害",add_cd)
        local add_c = ability:kv_load('暴击率','integer')
        owner:add_attr('暴击率',add_c)
        local count = ability:kv_load('暴击次数','integer')
        ability:kv_save('剩余次数',count)
        print('至死方休增加爆伤:' .. add_cd)
        print('至死方休增加暴击:' .. add_c)
        print('至死方休剩余触发次数:' .. count)
    end)
end
