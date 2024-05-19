--这里的数字就是物编里技能的ID
local M = y3.object.ability[200002]

function M.on_upgrade(ability)
    print('技能等级变化:'..ability:get_name())
    --获得技能持有者，用于增减属性
    local owner = ability:get_owner()
    --获得技能等级
    local level = ability:get_level()

    local dodge = ability:kv_load("闪避", 'integer')
    local result = owner:get_attr('躲避率','实际')
    local add = math.floor(result/dodge) * ability:kv_load("lv" .. level, 'integer')

    local save_add = 0
    if ability:kv_has('无形狂暴增加爆伤') then
        save_add = ability:kv_load('无形狂暴增加爆伤','integer')
        owner:add_attr('暴击伤害', -save_add)
    end

    owner:add_attr('暴击伤害', add)
    ability:kv_save('无形狂暴增加爆伤',add)

    print('原始暴击伤害:'..owner:get_attr('暴击伤害'))

    --获得当前技能等级应该增加的攻击力
    print('提升暴击伤害:'..add)
end

function M.on_lose(ability)
    print('失去技能:'..ability:get_name())
    local owner = ability:get_owner()
    local add = 0;
    if ability:kv_has('无形狂暴增加爆伤') then
        add = ability:kv_load('无形狂暴增加爆伤','integer')
    end
    if add > 0 then
        print('减少暴击:'..add)
        owner:set_attr('暴击伤害', -add)
    end
end