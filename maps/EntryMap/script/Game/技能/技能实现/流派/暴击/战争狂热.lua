--这里的数字就是物编里技能的ID
local M = y3.object.ability[220004]

function M.on_add(ability)
    local owner = ability:get_owner()
    ability:bindGC(y3.timer.loop(1, function (timer, count)
        if owner:is_in_battle() then
            local save_c = 0;
            if ability:kv_has('增加暴击率') then
                save_c = ability:kv_load('增加暴击率','integer')
            end
            local max_c = ability:kv_load('最多提升'..ability:get_level(),'integer')
            if save_c < max_c then
                local add_c = ability:kv_load('每秒提升暴击率'..ability:get_level(),'integer')
                if add_c + save_c > max_c then
                    add_c = max_c - save_c
                end
                print('战争狂热增加暴击:' .. add_c)
                owner:add_attr("暴击率",add_c)
                ability:kv_save('增加暴击率',save_c + add_c)
            end
        else
            if ability:kv_has('增加暴击率') then
                local add_c = ability:kv_load('增加暴击率','integer')
                if add_c > 0 then
                    owner:add_attr('暴击率',-add_c)
                    print('战争狂热减少暴击率' .. add_c) 
                    ability:kv_save('增加暴击率',0)
                end
            end
        end
    end))
end
