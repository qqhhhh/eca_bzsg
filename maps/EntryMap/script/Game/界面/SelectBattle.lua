require 'Game.界面.Friendship'
require 'Game.界面.SaveData'
require 'Game.界面.Achievement'
require 'Game.界面.Top'
local M = {}

M.selectBattleData = nil
M.selectLevel = 1;
M.MainPlayer = nil

---@param player Player
function M.Enter(player)
    if M.MainPlayer == nil then
        M.MainPlayer = player
    end
    local ui = y3.ui.get_ui(player, '进游戏界面')
    M.InitBattles(player);
    M.InitPlayerUi(player)

    if M.MainPlayer ~= player then
        ui:get_child('主界面.难度.进入游戏'):set_visible(false)
    end
    ui:set_visible(true);
end

---@param player Player
---@param show boolean
function M.SelectBattleVisible(player,show)
    local ui = y3.ui.get_ui(player, '进游戏界面')
    ui:set_visible(show);
end

---comment
---@param player Player
function M.InitPlayerUi(player)
    local self_player = player;
    local ui = y3.ui.get_ui(self_player, '进游戏界面')
    for i = 1, 4, 1 do
        local cur_player = y3.player.get_by_id(i)
        local playerUi = ui:get_child('主界面.其他成员.玩家' .. i);
        if playerUi then
            if cur_player and cur_player:get_state() == 1 then
                playerUi:get_child('名字'):set_text(cur_player:get_name())
                playerUi:get_child('头像'):set_image(cur_player:get_platform_icon())
                playerUi:set_visible(true)
            else
                playerUi:set_visible(false)
            end
        end
    end
end

---@param player Player
function M.InitBattles(player)
    local ui = y3.ui.get_ui(player, '进游戏界面')
    local data = y3.game.get_table("战役数据")
    if  data == nil then
        print("战役数据表格读取错误")
        return;
    end
    
    local list = ui:get_child('主界面.战役.战役列表')
    if  list == nil then
        print("主界面.战役.战役列表 UI控件错误")
        return;
    end

    for index, value in ipairs(data) do
        local curUi = y3.ui_prefab.create(player,'战役关卡',list):get_child()
        if curUi then
            curUi:get_child('背景图'):set_image(value['背景图ResID'])
            curUi:get_child('名字'):set_text(value['战场名字'])
            curUi:get_child('新'):set_visible(value['新关卡标记'])
            curUi:get_child('已通关'):set_visible(false)
            curUi:add_event('左键-点击',"选战役",value);
            if value['战场名字'] == "黄巾之乱" then
                curUi:get_child("敬请期待"):set_visible(false)
            end
        end
        if M.selectBattleData == nil then
            M.selectBattleData = value
        end
    end
    --M.RefashLevel()
end

function M.RefashLevel()
    if M.selectBattleData == nil then
        return
    end
    for i = 1, 4, 1 do
        local cur_player = y3.player.get_by_id(i)
        if cur_player then
            local ui = y3.ui.get_ui(cur_player, '进游戏界面')
            local battleSaveTable = y3.save_data.load_table(M.MainPlayer,1,false)
            local selectID = M.selectBattleData['战役地图ID']
            if battleSaveTable[selectID] == nil then
                battleSaveTable[selectID]  = {false,false,false,false,false,false,false,false,false,false}
                if selectID == 1 then
                    battleSaveTable[selectID][1] = true;
                    y3.save_data.save_table(M.MainPlayer,1,battleSaveTable)
                end
            end
            ui:get_child('主界面.难度.初级.初级按钮'):set_button_enable(battleSaveTable[selectID][1]);
            ui:get_child('主界面.难度.中级.中级按钮'):set_button_enable(battleSaveTable[selectID][2]);
            ui:get_child('主界面.难度.高级.高级按钮'):set_button_enable(battleSaveTable[selectID][3]);
            ui:get_child('主界面.难度.顶级.顶级按钮'):set_button_enable(battleSaveTable[selectID][4]);
            ui:get_child('主界面.难度.修罗.修罗按钮'):set_button_enable(battleSaveTable[selectID][5]);
            ui:get_child('主界面.难度.初级.已通关图标'):set_visible(battleSaveTable[selectID][6]);
            ui:get_child('主界面.难度.中级.已通关图标'):set_visible(battleSaveTable[selectID][7]);
            ui:get_child('主界面.难度.高级.已通关图标'):set_visible(battleSaveTable[selectID][8]);
            ui:get_child('主界面.难度.顶级.已通关图标'):set_visible(battleSaveTable[selectID][9]);
            ui:get_child('主界面.难度.修罗.已通关图标'):set_visible(battleSaveTable[selectID][10]);
            if battleSaveTable[selectID][1] == false then
                M.RefashLevelBtnState(cur_player,0)
            else
                M.RefashLevelBtnState(cur_player,1)
            end
            M.RefashLevelSelectUi(cur_player)
            if not ui:get_child('主界面.难度'):is_visible() then
                ui:get_child('主界面.难度'):set_pos(621,109)
                ui:get_child('主界面.难度'):set_visible(true)
                ui:get_child('主界面.难度.难度字底图'):set_visible(true)
                ui:get_child('主界面.难度.隐藏'):set_visible(true)
                ui:get_child('主界面.难度'):set_visible(true)
                ui:get_child('主界面.资料片'):set_visible(false)
            end
        end
    end
end

---comment
---@param player Player
function M.RefashLevelSelectUi(player)
    local ui = y3.ui.get_ui(player, '进游戏界面.主界面.战役.战役列表')
    if ui == nil then
        return
    end
    local allBattleUi = ui:get_childs()
    for index, value in ipairs(allBattleUi) do
        if index == M.selectBattleData['战役地图ID'] then
            value:get_child('选中'):set_visible(true);
        else
            value:get_child('选中'):set_visible(false);
        end
    end
end

---comment
---@param player Player
---@param level number
function M.RefashLevelBtnState(player,level)
    local ui = y3.ui.get_ui(player, '进游戏界面')

    local selectLevelBtn = {}
    table.insert(selectLevelBtn,ui:get_child('主界面.难度.初级.初级选中框'))
    table.insert(selectLevelBtn,ui:get_child('主界面.难度.中级.中级选中框'))
    table.insert(selectLevelBtn,ui:get_child('主界面.难度.高级.高级选中框'))
    table.insert(selectLevelBtn,ui:get_child('主界面.难度.顶级.顶级选中框'))
    table.insert(selectLevelBtn,ui:get_child('主界面.难度.修罗.修罗选中框'))

    for index, value in ipairs(selectLevelBtn) do
        if index == level then
            value:set_visible(true)
        else
            value:set_visible(false)
        end
    end
end


y3.game:event('界面-消息', '选战役', function (trg, data)
    if M.MainPlayer ~= data.player then
        return
    end
    M.selectBattleData = data.data
    M.RefashLevel()
end)

y3.game:event('界面-消息', '难度选择1', function (trg, data)
    if M.MainPlayer ~= data.player then
        return
    end
    if M.selectBattleData == nil then
        return
    end
    for i = 1, 4, 1 do
        local cur_player = y3.player.get_by_id(i)
        if cur_player then
            M.RefashLevelBtnState(cur_player, 1)
        end
    end
end)
y3.game:event('界面-消息', '难度选择2', function (trg, data)
    if M.MainPlayer ~= data.player then
        return
    end
    if M.selectBattleData == nil then
        return
    end
    for i = 1, 4, 1 do
        local cur_player = y3.player.get_by_id(i)
        if cur_player then
            M.RefashLevelBtnState(cur_player, 2)
        end
    end
end)
y3.game:event('界面-消息', '难度选择3', function (trg, data)
    if M.MainPlayer ~= data.player then
        return
    end
    if M.selectBattleData == nil then
        return
    end
    for i = 1, 4, 1 do
        local cur_player = y3.player.get_by_id(i)
        if cur_player then
            M.RefashLevelBtnState(cur_player, 3)
        end
    end
end)
y3.game:event('界面-消息', '难度选择4', function (trg, data)
    if M.MainPlayer ~= data.player then
        return
    end
    if M.selectBattleData == nil then
        return
    end
    for i = 1, 4, 1 do
        local cur_player = y3.player.get_by_id(i)
        if cur_player then
            M.RefashLevelBtnState(cur_player, 4)
        end
    end
end)
y3.game:event('界面-消息', '难度选择5', function (trg, data)
    if M.MainPlayer ~= data.player then
        return
    end
    if M.selectBattleData == nil then
        return
    end
    for i = 1, 4, 1 do
        local cur_player = y3.player.get_by_id(i)
        if cur_player then
            M.RefashLevelBtnState(cur_player, 5)
        end
    end
end)

y3.game:event('界面-消息', '开始战役', function (trg, data)
    if M.selectBattleData == nil then
        return
    end
    if M.selectLevel == 0 then
        return
    end
    y3.game:event_notify('战役选择',{selectBattleData=M.selectBattleData,selectLevel=M.selectLevel})
end)

return M;