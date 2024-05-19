local M = {}

M.BattleEnemyStage = {}
M.enemy_pool = New 'Pool'
M.enemy_die_pool = New 'Pool'
M.enemy_Group = y3.unit_group.create()
---comment
---@param stageData table
---@param level number
---@param playerCount number
function M.Init(stageData,level,playerCount)
    M.BattleEnemyStage = {}
    local enemyPoolName = stageData['刷怪表']
    if enemyPoolName then
        local enemyList = y3.game.get_table(enemyPoolName)
        if enemyList then
            for index, value in ipairs(enemyList) do
                local enemyPool = y3.game.get_table(value['刷怪池'])
                if enemyPool then
                    local enemyLevel = value['通用等级']
                    local enmeyCount = value['刷怪数量'] * playerCount
                    local completion = value['是否补全数量']
                    M.enemy_pool:clear();
                   for index2, value2 in ipairs(enemyPool) do
                        M.enemy_pool:add(value2['怪物'])
                        local curCount = value2['数量'] * playerCount
                        if curCount > 0 then
                            enmeyCount = enmeyCount - curCount
                            local curLevel = value2['独立等级']
                            if curLevel == 0 then
                                curLevel = enemyLevel
                            end
                            M.CreatAllEnemyStage(value2['怪物'],curCount,curLevel,index)
                        end
                   end
                   if completion then
                        for i = 1, enmeyCount, 1 do
                            M.CreatAllEnemyStage(M.enemy_pool:random(),1,enemyLevel,index)
                        end
                   end
                end
            end
        end
    end
end

function M.CreatAllEnemyStage(enemyId,count,level,Stage)
    M.enemy_die_pool:clear()
    if M.BattleEnemyStage[Stage] == nil then
        M.BattleEnemyStage[Stage] = {}
    end
    for i = 1, count, 1 do
        local data = {
            id = enemyId,
            level = level,
        }
        table.insert(M.BattleEnemyStage[Stage],data)
    end
end

---comment
---@param Stage number
---@return number
function M.CreatEnemy(Stage)
    local enemys = M.BattleEnemyStage[Stage]
    if enemys == nil then
        return 0
    end

    local enemyPlayer = y3.player.get_by_id(31)
    local index1 = math.floor(#enemys/3)
    local index2 = math.floor(#enemys/3) * 2
    local index3 = #enemys
    local waitTime = 1
    y3.timer.wait(waitTime, function (timer)
        for i = 1, index1, 1 do
            local curEnemy = y3.unit.create_unit(enemyPlayer,enemys[i].id,y3.point.get_point_by_res_id(10005),90)
            M.enemy_Group:add_unit(curEnemy)
            curEnemy:set_level(enemys.level)
            curEnemy:move_along_road(y3.road.get_road_by_res_id(10006),1,true,true,true)
            curEnemy:bindGC(curEnemy:event("单位-死亡", function (trg, data)
                M.enemy_die_pool:add({id=data.unit:get_key(),level=data.unit:get_level()})
                M.enemy_Group:remove_unit(curEnemy)
            end))
        end
    end)
    if index1 ~= 0 then
        waitTime = waitTime + 5
    end
    y3.timer.wait(waitTime, function (timer)
        for i = index1+1, index2, 1 do
            local curEnemy = y3.unit.create_unit(enemyPlayer,enemys[i].id,y3.point.get_point_by_res_id(10005),90)
            M.enemy_Group:add_unit(curEnemy)
            curEnemy:set_level(enemys.level)
            curEnemy:move_along_road(y3.road.get_road_by_res_id(10006),1,true,true,true)
            curEnemy:bindGC(curEnemy:event("单位-死亡", function (trg, data)
                M.enemy_die_pool:add({id=data.unit:get_key(),level=data.unit:get_level()})
                M.enemy_Group:remove_unit(curEnemy)
            end))
        end
    end)
    if index2 ~= 0 then
        waitTime = waitTime + 5
    end
    y3.timer.wait(waitTime, function (timer)
        for i = index2+1, index3, 1 do
            local curEnemy = y3.unit.create_unit(enemyPlayer,enemys[i].id,y3.point.get_point_by_res_id(10005),90)
            M.enemy_Group:add_unit(curEnemy)
            curEnemy:set_level(enemys.level)
            curEnemy:move_along_road(y3.road.get_road_by_res_id(10006),1,true,true,true)
            curEnemy:bindGC(curEnemy:event("单位-死亡", function (trg, data)
                M.enemy_die_pool:add({id=data.unit:get_key(),level=data.unit:get_level()})
                M.enemy_Group:remove_unit(curEnemy)
            end))
        end
    end)
    return #enemys
end

return M;