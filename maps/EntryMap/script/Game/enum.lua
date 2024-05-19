---@class GameEnum
local M = {}

--None
---@enum Game.GameState
M.Gametate = {
    init = 1,
    idle = 2,
    select_hero = 3,
    wait_battle = 4,
    battle = 5,
    battle_win = 6,
    battle_fail = 7,
};

M.BattleState = {
    init = 1,
    selectSkill = 2,
    selectEquip = 3,
    selectSecret = 4,
    fight = 5,
    fightEnd = 6,
    fail = 7,
    win = 8,
}
return M;