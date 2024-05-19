_G_Game = require 'Game.GameLogic'
_G_CSV = require 'Game.csv'
--require 'ECA_CALL_LUA'
--在开发模式下，将日志打印到游戏中
y3.config.log.toGame = y3.game.is_debug_mode()

y3.game:event('游戏-初始化', function (trg, data)
    -- _G_CSV.Init()
    -- for i = 1, 4, 1 do
    --     local player = y3.player.get_by_id(i);
    --     player:set_hostility(y3.player.get_by_id(31),true)
    --     if player:get_state() == 1 then
    --         _G_Game.Init(player)
    --     end
    -- end
    -- _G_Game.InitEvent()
end)