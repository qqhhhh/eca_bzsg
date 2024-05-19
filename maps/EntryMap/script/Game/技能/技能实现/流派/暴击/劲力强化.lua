--这里的数字就是物编里技能的ID
local M = y3.object.ability[200001]

function M.on_upgrade(ability)
    print('技能等级变化:'..ability:get_name())
    --获得技能持有者，用于增减属性
    local owner = ability:get_owner()
    --获得技能等级
    local level = ability:get_level()
    --计算出上一级等级
    local last_level = level - 1

    --如果上一级等级合法，那么需要先减去上一级的攻击力
    local sub = 0
    if last_level > 0 then
        --这里的 .. 是用来拼接字符串，最终目的是拼接成技能自定义属性中的key。 'lv' .. 本地变量（比如变量=1） .. '提升攻击力' 最终得到是 'lv1提升攻击力'
        sub = ability:kv_load("lv" .. last_level, 'integer')
    end
    print('技能等级:'..level)
    
    --获得当前英雄攻击力（包含上一级技能已经增加了的攻击力）
    local atk = owner:get_attr_base('暴击率')
    print('原始暴击:'..atk)

    --获得当前技能等级应该增加的攻击力
    local add = ability:kv_load("lv" .. level, 'integer')
    print('提升暴击:'..add)

    --先减去上一级的攻击力，再加上这一级应该增加的攻击力
    atk = atk - sub + add

    --设置最终攻击力
    print('设置暴击:'..atk)
    owner:set_attr('暴击率',atk)
end

function M.on_lose(ability)
    --技能失去后减去当前技能等级对应的攻击里
    print('失去技能:'..ability:get_name())
    local owner = ability:get_owner()
    local atk = owner:get_attr_base('暴击率')
    print('原始暴击:'..atk)
    local add = ability:kv_load("lv" .. ability:get_level(), 'integer')
    print('减少暴击:'..add)
    atk = atk - add
    print('设置暴击:'..atk)
    owner:set_attr('暴击率',atk)
end