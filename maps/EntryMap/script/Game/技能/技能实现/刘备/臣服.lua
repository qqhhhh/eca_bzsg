local enemyPool = require 'Game.战场.EnemyPool'

--这里的数字就是物编里技能的ID
local M = y3.object.ability[904001]

function M.on_add(ability)
    local owner = ability:get_owner()
    ability:bindGC(owner:event('单位-造成伤害时',function (trg, data)
        if data.is_normal_hit then
            local probability = ability:kv_load('触发概率','integer')
            local count = ability:kv_load('召唤数量','integer')
            local time = ability:kv_load('存活时间','integer')
            local random = GameAPI.get_random_int(1,100)
            if random <= probability then
                local call = enemyPool.enemy_die_pool:random_n(count)
                if #call > 0 then
                    for index, value in ipairs(call) do
                        local callUnit = y3.unit.create_unit(owner,value.id,owner:get_point(),owner:get_facing())
                        callUnit:set_level(value.level)
                        callUnit:add_tag('召唤')
                        y3.timer.wait(time, function (timer)
                            print('臣服召唤单位死亡:' .. callUnit:get_name())
                            callUnit:kill_by(callUnit)
                            callUnit:remove()
                        end)
                        print('臣服召唤单位:' .. callUnit:get_name())
                    end
                end
            end
        end
    end))
end
