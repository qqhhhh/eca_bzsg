--这里的数字就是物编里技能的ID
local M = y3.object.ability[134239381]

function M.on_add(ability)
    local owner = ability:get_owner()
    ability:bindGC(owner:event('单位-造成伤害时',function (trg, data)
        if data.damage_instance:is_critical() then
            local time = ability:kv_load('持续时间','integer')
            local addAtk = ability:kv_load('提升攻击','integer')
            local maxAtk = ability:kv_load('提升攻击上限'..ability:get_level(),'integer')
            local buffId = ability:kv_load('附加效果','integer')
            local saveAtk = 0
            if ability:kv_has('已经增加的攻击') then
                saveAtk = ability:kv_load('已经增加的攻击','integer')
            end
            if addAtk + saveAtk > maxAtk then
                addAtk = maxAtk - saveAtk
            end
            local buff = data.unit:find_buff(buffId)
            if buff then
                buff:set_time(time)
            else
                print('新加buff')
                print(ability:get_owner():get_attr("物理攻击",'实际'))
                buff = data.unit:add_buff({
                    key = ability:kv_load('附加效果','integer'),
                    source = data.unit,
                    ability = ability,
                    time = time,
                    })
            end

            if buff and addAtk > 0 then
                print('暴击触发新增攻击：' .. addAtk)
                print('增加前：' .. ability:get_owner():get_attr("物理攻击",'实际'))
                buff:bindGC(data.unit:add_attr_gc("物理攻击",addAtk,'增益'))
                ability:kv_save('已经增加的攻击',addAtk + saveAtk)
                print('增加后' .. ability:get_owner():get_attr("物理攻击",'实际'))
            end
        end
    end))
end
