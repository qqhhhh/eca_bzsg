local Selector = require 'Game.技能.技能实现.SkillSelector'

--这里的数字就是物编里技能的ID
local M = y3.object.ability[200013]

function M.on_add(ability)
    local owner = ability:get_owner()
    ability:bindGC(y3.timer.loop(1, function (timer, count)
        local enemyCount = ability:kv_load('敌人数量', 'integer')
        local up_cri = ability:kv_load('提高自身暴击率' .. ability:get_level(),'integer')
        local radius = ability:kv_load('索敌范围', 'integer')
        local max_cri = ability:kv_load('最高提高', 'integer')
        local targets = Selector.GetUnitsByRound(owner,radius)
        local curCount = 0
        for index, value in ipairs(targets) do
            if value:get_owner():get_id() == 31 then
                curCount = curCount + 1
            end
        end
        print('爆裂无双检索周围敌人数量：' .. curCount)
        local cur_cri = up_cri * math.floor(curCount/enemyCount)
        if cur_cri > max_cri then
            cur_cri = max_cri
        end

        if ability:kv_has('爆裂无双增加暴击率') then
            local save = ability:kv_load('爆裂无双增加暴击率','integer')
            owner:add_attr("暴击率",-save)
        end

        owner:add_attr("暴击率",cur_cri)
        ability:kv_save('爆裂无双增加暴击率',cur_cri)
        print('爆裂无双增加暴击率'..cur_cri)
    end))
end
