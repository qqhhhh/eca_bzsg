require 'Game.技能.技能实现.Init'
require 'Game.Player'
local game_battle = require 'Game.战场.Battle'
local game_enum = require 'Game.enum'
local ui_select_hero = require "Game.界面.SelectHero"
local ui_selcet_battle = require 'Game.界面.SelectBattle'
local ui_main = require 'Game.界面.Main'

local M = {}

M.GamePlayerData = {}
M.state = game_enum.Gametate.init
---comment
---@param player Player
function M.Init(player)
    if player and player:get_state() == 1 then
        M.GamePlayerData[player.id] = New 'GamePlayer' (player)
        ui_selcet_battle.Enter(player)
        M.state = game_enum.Gametate.select_hero
    end
end

function M.InitEvent()
    y3.game:event_on('战役选择',function (trigger,...)
        local players = M.GamePlayerData
        for index, value in pairs(players) do
            if value then
                ui_selcet_battle.SelectBattleVisible(value.player,false)
                ui_select_hero.Enter(value.player)
            end
        end
        local battleData = ...
        game_battle.Init(battleData.selectBattleData,battleData.selectLevel)
    end)
end

---comment
---@param rounds integer
function M.GoldRevenue(rounds)
    for key, value in pairs(M.GamePlayerData) do
        value:GoldRevenue(rounds)
    end
end

function M.PauseAll()
    for key, value in pairs(M.GamePlayerData) do
        value:Pause()
    end
end

function M.ResetAll()
    for key, value in pairs(M.GamePlayerData) do
        value:Reset()
    end
end

function M.PlayAll()
    for key, value in pairs(M.GamePlayerData) do
        value:Play()
    end
end

function M.AliveCount()
    local count = 0
    for index, value in pairs(M.GamePlayerData) do
        if value.heroUnit:is_alive() then
            count = count + 1
        end
    end
    return count
end

function M.AddSkill(playerId, skillData)
    return M.GamePlayerData[playerId]:AddSkill(skillData)
end

---comment
---@param playerId integer
---@param slotType y3.Const.AbilityType | y3.Const.AbilityTypeAlias 技能类型
---@param slot integer 技能位
---@return Ability? ability 技能
function M.GetSkill(playerId,slotType,slot)
    return M.GamePlayerData[playerId]:GetSkill(slotType,slot)
end

---comment
---@param playerId integer
---@param slotType y3.Const.AbilityType | y3.Const.AbilityTypeAlias 技能类型
---@param id py.AbilityKey 物编id
---@return Ability? ability 技能
function M.FindSkill(playerId,slotType,id)
    return M.GamePlayerData[playerId]:FindSkill(slotType,id)
end

function M.IsFreeSkill(playerId)
    return M.GamePlayerData[playerId]:IsFreeSkill()
end

function M.CheckFreeSkill(playerId)
    return M.GamePlayerData[playerId]:CheckFreeSkill()
end

function M.UseFreeSkill(playerId)
    return M.GamePlayerData[playerId]:UseFreeSkill()
end

function M.ReducedPriceRefresh(playerId,price)
    return M.GamePlayerData[playerId]:ReducedPriceRefresh(price)
end

function M.FreeRefreshSkillCount(playerId)
    return M.GamePlayerData[playerId]:FreeRefreshSkillCount()
end

function M.UserFreeRefreshSkill(playerId)
    return M.GamePlayerData[playerId]:UserFreeRefreshSkill()
end

function M.SkillEffectBegin()
    for key, value in pairs(M.GamePlayerData) do
        value:EffectBegin()
    end
end

function M.SkillEffectEnd()
    for key, value in pairs(M.GamePlayerData) do
        value:EffectEnd()
    end
end

---comment
---@param playerId integer
---@param slotIndex integer
---@param slotType y3.Const.ShiftSlotTypeAlias
---@return unknown
function M.GetItem(playerId,slotIndex,slotType)
    return M.GamePlayerData[playerId]:GetItem(slotIndex,slotType)
end

function M.SetestUnit(playerId,unitdata)
    if M.GamePlayerData[playerId] then
        M.GamePlayerData[playerId]:SeletUnitData(unitdata)
    end
end

y3.timer.loop(1, function (timer, count)
    if M.state == game_enum.Gametate.select_hero then
        local players = M.GamePlayerData
        for index, value in pairs(players) do
            if value.heroTableData == nil or value.selectHeroOver == nil or value.selectHeroOver == false then
                return
            end
        end
        for index, value in pairs(players) do
            value:SelectHero()
            ui_select_hero.SelectHeroVisible(value.player,false)
            ui_main.Enter(value)
        end
        M.state = game_enum.Gametate.battle
        game_battle.Step();
    end
end)

-- y3.game:event('键盘-按下', y3.const.KeyboardKey['SPACE'], function ()
--     game_ui.SelectHeroVisible(1,false)
--     M.players[1]:SelectHero(134274912)
-- end)

y3.game:event('界面-消息', '开始战役', function (trg, data)
    local aa = 0
    ---ui_select_hero.Init(data.player)
end)

y3.game:event_on('战斗回合结束',function (trigger,rounds)
    for key, value in pairs(M.GamePlayerData) do
        local ui = y3.ui.get_ui(value.player, '游戏主界面.回合数.地图.波数')
        ui:set_text('第' .. rounds .. '波')
    end
end)

return M