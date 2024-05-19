local game_enum = require 'Game.enum'
local game_skill = require 'Game.技能.SkillStore'
local game_enemy_pool = require 'Game.战场.EnemyPool'
local game_equip_pool = require 'Game.战场.EquipPool'

local ui_selectSkill = require 'Game.界面.SelectSkill'
local ui_selectEquip = require 'Game.界面.SelectEquip'
local ui_selectSecret = require 'Game.界面.SelectSecret'
local ui_victory = require 'Game.界面.Victory'
local ui_fail = require 'Game.界面.Fail'
local ui_main = require 'Game.界面.Main'

local skill = require 'Game.技能.技能实现.Init'

local M = {}
M.rounds = 1
M.State = game_enum.BattleState.init
M.enemyCount = 0

---comment
---@param stageData table
---@param level number
function M.Init(stageData,level)
    game_enemy_pool.Init(stageData,level,#_G_Game.GamePlayerData)
    game_equip_pool.Init()
    game_skill.Init()
end

function M.Step()
    if M.State == game_enum.BattleState.init then
        _G_Game.GoldRevenue(M.rounds)
        M.DoSelectSecret()
    elseif M.State == game_enum.BattleState.selectSkill then
        M.DoFightStage()
    elseif M.State == game_enum.BattleState.selectEquip then
        M.DoSelectSkillStage()
    elseif M.State == game_enum.BattleState.selectSecret then
        M.doSelectSkillEquip()
    elseif M.State == game_enum.BattleState.fight then
        if M.enemyCount <= 0 then
            M.DoFightEnd()
        end
    elseif M.State == game_enum.BattleState.fightEnd then
        M.DoSelectSecret()
    elseif M.State == game_enum.BattleState.fail then
        M.DoFail()
    elseif M.State == game_enum.BattleState.win then
        M.DoVictory()
    end
end

function M.DoFightEnd()
    M.rounds = M.rounds + 1
    M.State = game_enum.BattleState.fightEnd
    y3.game:event_notify('战斗回合结束',M.rounds)
    _G_Game.PauseAll();
    _G_Game.GoldRevenue(M.rounds)
    M.Step()
end

function M.DoSelectSkillStage()
    M.State = game_enum.BattleState.selectSkill
    M.SelectSkillCount = 0;
    for key, value in pairs(_G_Game.GamePlayerData) do
        ui_selectSkill.Enter(value.player,game_skill.GetSkills())
    end
end

function M.doSelectSkillEquip()
    M.State = game_enum.BattleState.selectEquip
    M.SelectEquipCount = 0;
    if M.rounds == 5 or M.rounds == 10 or M.rounds == 15 then
        for key, value in pairs(_G_Game.GamePlayerData) do
            ui_selectEquip.Enter(value,M.rounds)
        end
    else
        M.Step()
    end
end

function M.DoSelectSecret()
    M.State = game_enum.BattleState.selectSecret
    M.SelectSecretCount = 0;
    if M.rounds == 3 or M.rounds == 8 or M.rounds == 13 then
        for key, value in pairs(_G_Game.GamePlayerData) do
            ui_selectSecret.Enter(value,M.rounds)
        end
    else
        M.Step()
    end
end

function M.DoFightStage()
    M.State = game_enum.BattleState.fight
    y3.game:event_notify('开始战斗回合')
    _G_Game.ResetAll()
    _G_Game.PlayAll()
    M.enemyCount = game_enemy_pool.CreatEnemy(M.rounds)
    y3.game:event_notify('开始战斗回合-敌人初始化完成')
    if M.rounds == 10 or M.rounds == 20 or M.rounds == 25 then
        for key, value in pairs(_G_Game.GamePlayerData) do
            ui_main.ShowBossTip(value.player)
        end
    end
end

function M.DoVictory()
    for key, value in pairs(_G_Game.GamePlayerData) do
        ui_victory.Enter(value)
    end
end

function M.DoFail()
    for key, value in pairs(_G_Game.GamePlayerData) do
        ui_fail.Enter(value)
    end
end

y3.game:event('界面-消息', '选技能', function (trg, data)
    for key, value in pairs(_G_Game.GamePlayerData) do
        if data.player.id == value.player.id then
            local gold = data.player:get_attr('gold')
            local price = data.data['售价']
            if gold < price then
                return
            end
            local selectUi = data.ui:get_child('已选取')
            if not selectUi then
                return
            end
            if selectUi:is_visible() then
                return
            end
            if _G_Game.AddSkill(data.player.id,data.data) then
                data.player:add("gold",-price)
                selectUi:set_visible(true)
                if ui_selectSkill.SelectOver(data.player) then
                    ui_selectSkill.Enter(data.player,game_skill.GetSkills(),true)
                end
            end
        end
    end
end)

y3.game:event('界面-消息', '选装备', function (trg, data)
    for key, value in pairs(_G_Game.GamePlayerData) do
        if data.player.id == value.player.id then
            M.SelectEquipCount = M.SelectEquipCount + 1
            ui_selectEquip.SelectUiVisible(data.player,false)
            print('选择装备' .. data.data)
            value.heroUnit:add_item(data.data,'物品栏')
        end
    end
    if #_G_Game.GamePlayerData == M.SelectEquipCount then
        M.Step()
    end
end)

y3.game:event('界面-消息', '选秘籍', function (trg, data)
    for key, value in pairs(_G_Game.GamePlayerData) do
        if data.player.id == value.player.id then
            M.SelectSecretCount = M.SelectSecretCount + 1
            ui_selectSecret.SelectUiVisible(data.player,false)
            print('选择秘籍' .. data.data)
            value.heroUnit:add_item(data.data,'背包栏')
        end
    end
    if #_G_Game.GamePlayerData == M.SelectSecretCount then
        M.Step()
    end
end)

y3.game:event('界面-消息', '技能选择刷新', function (trg, data)
    if _G_Game.IsFreeSkill(data.player.id) then
        ui_selectSkill.Enter(data.player,game_skill.GetSkills(),true)
        _G_Game.UseFreeSkill(data.player.id)
    elseif _G_Game.FreeRefreshSkillCount(data.player.id) then
        ui_selectSkill.Enter(data.player,game_skill.GetSkills(),true)
        _G_Game.UserFreeRefreshSkill(data.player.id)
    else
        local gold = data.player:get_attr("gold")
        local maxGold = 20
        maxGold = _G_Game.ReducedPriceRefresh(data.player.id,maxGold)
        if gold >= maxGold then
            data.player:add('gold',-maxGold)
            ui_selectSkill.Enter(data.player,game_skill.GetSkills(),true)
        end
    end
end)

y3.game:event('界面-消息', '技能选择随机', function (trg, data)
    local gold = data.player:get_attr("gold")
    if gold >= 100 then
        data.player:add('gold',-100)
        _G_Game.AddSkill(data.player.id,game_skill.RandomSkill())
        ui_selectSkill.Enter(data.player,game_skill.GetSkills(),true)
    end
end)

y3.game:event('界面-消息', '技能选择锁定', function (trg, data)
    ui_selectSkill.Lock(data.player)
end)


y3.game:event('界面-消息', '技能选择准备', function (trg, data)
    ui_selectSkill.SelectHeroVisible(data.player,false)
    M.SelectSkillCount = M.SelectSkillCount + 1
    if #_G_Game.GamePlayerData == M.SelectSkillCount then
        M.Step()
    end
end)

-- y3.game:event('单位-受到伤害时',function (trg, data)
--     if data.unit:has_tag('杂兵') then
--         data.unit:mover_line({
--             speed = 5000,
--             angle = data.source_unit:get_point():get_angle_with(data.target_unit:get_point()),
--             distance = 100,
--         })
--     end
-- end)

y3.game:event('单位-死亡',function (trg, data)
    if data.unit:has_tag('召唤') then
        return;
    end

    if data.unit:get_owner() == y3.player.get_by_id(31) then
        M.enemyCount = M.enemyCount - 1;
        data.unit:remove()
    else
        if _G_Game.AliveCount() == 0 then
            M.State = game_enum.BattleState.fail
            M.Step()
            return
        end
    end

    if M.enemyCount == 0 then
        if M.rounds == 25 then
            M.State = game_enum.BattleState.win
        end
        M.Step()
    end
end)

return M;