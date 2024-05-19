---@class ECAHelper
---@field call fun(name: '开始战斗回合', v1: integer)
---@field call fun(name: '初始化', v1: integer)

---@diagnostic disable-next-line: invisible
y3.eca.register_custom_event_impl('开始战斗回合', function (_, v1)
    y3.game.send_custom_event(1179699270, {
        ['回合数'] = v1
    })
end)

---@diagnostic disable-next-line: invisible
y3.eca.register_custom_event_impl('初始化', function (_, v1)
    y3.game.send_custom_event(1439767489, {
        ['playerId'] = v1
    })
end)
