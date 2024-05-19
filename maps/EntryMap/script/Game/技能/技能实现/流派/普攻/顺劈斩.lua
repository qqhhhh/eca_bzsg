--这里的数字就是物编里技能的ID
local M = y3.object.ability[134257178]

function M.on_upgrade(ability)
    print('技能等级变化:'..ability:get_name())
    local owner = ability:get_owner()
    local level = ability:get_level()
    --计算出上一级等级
    local last_level = level - 1

    local sub = 0
    if last_level > 0 then
        sub = ability:kv_load("增加攻击速度"..last_level, 'integer')
    end
    print('技能等级:'..level)
    
    --获得当前英雄攻速（包含上一级技能已经增加了的攻速）
    local asdp = owner:get_attr_bonus('攻击速度')
    print('原始攻速:'..asdp)

    --获得当前技能等级应该增加的攻速
    local add = ability:kv_load("增加攻击速度"..level, 'integer')
    print('提升攻速:'..add)

    --先减去上一级的攻击力，再加上这一级应该增加的攻击力
    asdp = asdp - sub + add

    --设置最终攻击力
    print('设置攻速:'..asdp)
    owner:set_attr('攻击速度',asdp,'增益')
end

function M.on_lose(ability)
    --技能失去后减去当前技能等级对应的攻击里
    print('失去技能:'..ability:get_name())
    local owner = ability:get_owner()
    local asdp = owner:get_attr_bonus('攻击速度')
    local add = ability:kv_load("增加攻击速度"..ability:get_level(), 'integer')
    print('减少攻速:'..add)
    asdp = asdp - add
    print('设置攻速:'..asdp)
    owner:set_attr('攻击速度',asdp,'增益')
end