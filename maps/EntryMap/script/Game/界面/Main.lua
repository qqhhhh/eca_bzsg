local MAIN = New 'LocalUILogic' ('游戏主界面')

MAIN:bind_unit_attr('玩家信息栏.玩家状态栏.血条底板.血条', '当前值', '生命')
MAIN:bind_unit_attr('玩家信息栏.玩家状态栏.血条底板.血条', '最大值', '最大生命')
MAIN:bind_unit_attr('玩家信息栏.玩家状态栏.血条底板.蓝条', '当前值', '魔法')
MAIN:bind_unit_attr('玩家信息栏.玩家状态栏.血条底板.蓝条', '最大值', '最大魔法')

local M = {}

---@param playerData table
function M.Enter(playerData)
    local ui = y3.ui.get_ui(playerData.player, '游戏主界面')
    M.SetBaseInfo(ui,playerData.heroUnit)
    M.SetItemInfo(ui)
    ui:get_child('伤害统计.1.名字'):set_text(playerData.player:get_name())
    ui:set_visible(true);
end

---comment
---@param ui UI
---@param unit Unit
function M.SetBaseInfo(ui,unit)
    local key = unit:get_key();
    local unitData = y3.game.get_table("英雄数据")
    local ImgData = y3.game.get_table("流派信息")
    ui:get_child('玩家信息栏.玩家头像区域.头像底框.头像'):set_image(y3.unit.get_icon_by_key(key))
    M.SetUiTip(ui:get_child('玩家信息栏.玩家头像区域.头像底框.被动技能.被动技能'),{type = '技能', index = 2})
    M.SetUiTip(ui:get_child('玩家信息栏.玩家头像区域.头像底框.大招技能.大招技能'),{type = '技能', index = 1})
    M.SetUiTip(ui:get_child('玩家信息栏.情义技能.情义底图.情谊2'),{type = '技能', index = 4})
    M.SetUiTip(ui:get_child('玩家信息栏.情义技能.情义底图.情谊1'),{type = '技能', index = 3})
    for index, value in ipairs(unitData) do
        if value['资源ID'] == key then
            for i = 1, 2, 1 do
                if value['流派'..i] and #value['流派'..i] > 0 then
                    ui:get_child('玩家信息栏.玩家头像区域.流派'..i):set_visible(true)
                    ui:get_child('玩家信息栏.玩家头像区域.流派'..i):set_image(ImgData[value['流派'..i]]['图标'])
                    M.SetUiTip(ui:get_child('玩家信息栏.玩家头像区域.流派'..i),{type = '流派', index = ImgData[value['流派'..i]]})
                else
                    ui:get_child('玩家信息栏.玩家头像区域.流派'..i):set_visible(false)
                end
            end
        end
    end
    ui:get_child('玩家信息栏.玩家状态栏.信息.攻击图标.攻击数值'):set_text(math.max(unit:get_attr('物理攻击','实际'),unit:get_attr('法术攻击','实际')) .. "")
    ui:get_child('玩家信息栏.玩家状态栏.信息.闪避图标.闪避数值'):set_text(unit:get_attr('躲避率','实际') .. "")
    ui:get_child('玩家信息栏.玩家状态栏.信息.攻击间隙图标.攻击间隙数值'):set_text(unit:get_attr('攻击间隔','实际') .. "")
    ui:get_child('玩家信息栏.玩家状态栏.信息.暴击图标.暴击数值'):set_text(unit:get_attr('暴击率','实际') .. "")

    ui:get_child('自身金钱.金钱'):set_text(math.floor(unit:get_owner():get_attr("gold"))..'')
    unit:get_owner():event('玩家-属性变化',function (trg, data)
        y3.ui.get_ui(data.player, '游戏主界面.自身金钱.金钱'):set_text(math.floor(unit:get_owner():get_attr("gold"))..'')
    end)

    ui:get_child('右边栏.LV.等级数'):set_text('Lv.' .. unit:get_level())
    unit:event('单位-升级',function (trg, data)
        y3.ui.get_ui(data.unit:get_owner(), '游戏主界面.右边栏.LV.等级数'):set_text('Lv.' .. data.unit:get_level())
    end)

    M.RefashExp(unit:get_owner())
end

function M.SetUiTip(ui,data)
    ui:add_event('鼠标-移入','显示TIP',data)
    ui:add_event('鼠标-移出','关闭TIP')
end

function M.SetItemInfo(ui)
    local itemUiRoot = ui:get_child('玩家信息栏.玩家状态栏.神器')
    for i = 1, 3, 1 do
        local curUi = itemUiRoot:get_child('神器'..i)
        M.SetUiTip(curUi,{type = '神器', index = i})
    end
    local secretUiRoot = ui:get_child('玩家信息栏.玩家状态栏.秘籍')
    for i = 1, 3, 1 do
        local curUi = secretUiRoot:get_child('秘籍'..i)
        M.SetUiTip(curUi,{type = '秘籍', index = i})
    end
end

---comment
---@param ui UI
---@param unit Unit
function M.SetAttarInfo(ui,unit)
    ui:get_child('玩家信息栏.玩家状态栏.信息.攻击图标.攻击数值'):set_text(math.max(unit:get_attr('物理攻击','实际'),unit:get_attr('法术攻击','实际')) .. "")
    ui:get_child('玩家信息栏.玩家状态栏.信息.闪避图标.闪避数值'):set_text(unit:get_attr('躲避率','实际') .. "")
    ui:get_child('玩家信息栏.玩家状态栏.信息.攻击间隙图标.攻击间隙数值'):set_text(unit:get_attr('攻击间隔','实际') .. "")
    ui:get_child('玩家信息栏.玩家状态栏.信息.暴击图标.暴击数值'):set_text(unit:get_attr('暴击率','实际') .. "")

    unit:event('单位-属性变化', '物理攻击', function (trg, data)
        local tempUi = y3.ui.get_ui(data.unit:get_owner(), '游戏主界面')
        tempUi:get_child('玩家信息栏.玩家状态栏.信息.攻击图标.攻击数值'):set_text(math.max(unit:get_attr('物理攻击','实际'),unit:get_attr('法术攻击','实际')) .. "")
    end)
    unit:event('单位-属性变化', '法术攻击', function (trg, data)
        local tempUi = y3.ui.get_ui(data.unit:get_owner(), '游戏主界面')
        tempUi:get_child('玩家信息栏.玩家状态栏.信息.攻击图标.攻击数值'):set_text(math.max(unit:get_attr('物理攻击','实际'),unit:get_attr('法术攻击','实际')) .. "")
    end)
    unit:event('单位-属性变化', '躲避率', function (trg, data)
        local tempUi = y3.ui.get_ui(data.unit:get_owner(), '游戏主界面')
        tempUi:get_child('玩家信息栏.玩家状态栏.信息.闪避图标.闪避数值'):set_text(unit:get_attr('躲避率','实际') .. "")
    end)
    unit:event('单位-属性变化', '攻击间隔', function (trg, data)
        local tempUi = y3.ui.get_ui(data.unit:get_owner(), '游戏主界面')
        tempUi:get_child('玩家信息栏.玩家状态栏.信息.攻击间隙图标.攻击间隙数值'):set_text(unit:get_attr('攻击间隔','实际') .. "")
    end)
    unit:event('单位-属性变化', '攻击间隔', function (trg, data)
        local tempUi = y3.ui.get_ui(data.unit:get_owner(), '游戏主界面')
        tempUi:get_child('玩家信息栏.玩家状态栏.信息.暴击图标.暴击数值'):set_text(unit:get_attr('暴击率','实际') .. "")
    end)
end

---comment
---@param player Player
---@param tpye string
---@param index integer
function M.ShowItmeTip(player,tpye,index)
    local ui = y3.ui.get_ui(player, '游戏主界面.TIPS')
    ui:set_follow_mouse(true)
    if tpye == '神器' then
        local item = _G_Game.GetItem(player.id,index,'物品栏')
        if item then
            ui:get_child('名字'):set_text(item:get_name())
            ui:get_child('描述'):set_text(item:get_description())
            ui:set_visible(true)
        end
    elseif tpye == '秘籍' then
        local item = _G_Game.GetItem(player.id,index,'背包栏')
        if item then
            ui:get_child('名字'):set_text(item:get_name())
            ui:get_child('描述'):set_text(item:get_description())
            ui:set_visible(true)
        end
    elseif tpye == '流派' then
        local ImgData = y3.game.get_table("流派信息")
        ui:get_child('名字'):set_text(index['key'])
        ui:get_child('描述'):set_text(index['描述'])
        ui:set_visible(true)
    elseif tpye == '技能' then
        local skill = _G_Game.GetSkill(player.id,'英雄',index)
        if skill then
            ui:get_child('名字'):set_text(skill:get_name())
            ui:get_child('描述'):set_text(skill:get_description())
            ui:set_visible(true)
        end
    end
end

---comment
---@param player Player
function M.RefashExp(player)
    for key, value in pairs(_G_Game.GamePlayerData) do
        if player.id == value.player.id then
            local UI = y3.ui.get_ui(value.player, '游戏主界面.右边栏')
            for key2, value2 in pairs(value.skillInfo) do
                if value2.exp == 0 then
                    UI:get_child(key2..'.图标'):set_image_color(57,57,57,1)
                else
                    UI:get_child(key2..'.图标'):set_image_color(255,255,255,1)
                end
                UI:get_child(key2..'.数值'):set_text(value2.exp..'/40')
                UI:get_child(key2..'.进度'):set_current_progress_bar_value(value2.exp/40)
            end
        end
    end
end

---comment
---@param player Player
---@param skillType string
function M.RefashSkillTip(player,skillType)
    local gamePlayer = _G_Game.GamePlayerData[player.id]
    local UI = y3.ui.get_ui(player, '游戏主界面.流派提示')
    local skillInfo = gamePlayer.skillInfo[skillType]
    if skillInfo then
        local list = UI:get_child('流派学习技能')
        if list then
            for key, value in pairs(list:get_childs()) do
                value:remove();
            end
            local ImgData = y3.game.get_table("流派信息")
            UI:get_child('流派信息底图.流派图标'):set_image(ImgData[skillType]['图标'])
            UI:get_child('流派信息底图.流派名字'):set_text(skillType)
            UI:get_child('流派信息底图.流派技能效果'):set_text(ImgData[skillType]['描述'])
            if skillInfo.exp < 4 then
                UI:get_child('流派信息底图.流派等级'):set_text('零级')
                UI:get_child('流派信息底图.下一等级需求'):set_text('(' .. skillInfo.exp .. '/4)')
            elseif skillInfo.exp < 10 then
                UI:get_child('流派信息底图.流派等级'):set_text('一级')
                UI:get_child('流派信息底图.下一等级需求'):set_text('(' .. skillInfo.exp .. '/10)')
            elseif skillInfo.exp < 20 then
                UI:get_child('流派信息底图.流派等级'):set_text('二级')
                UI:get_child('流派信息底图.下一等级需求'):set_text('(' .. skillInfo.exp .. '/20)')
            elseif skillInfo.exp < 40 then
                UI:get_child('流派信息底图.流派等级'):set_text('三级')
                UI:get_child('流派信息底图.下一等级需求'):set_text('(' .. skillInfo.exp .. '/40)')
            else
                UI:get_child('流派信息底图.流派等级'):set_text('四级')
                UI:get_child('流派信息底图.下一等级需求'):set_text('(' .. skillInfo.exp .. '/40)')
            end
            UI:get_child('规则'):set_text(ImgData[skillType]['释放规则'])

            for index, value in ipairs(skillInfo.skills) do
                local info_ui = y3.ui_prefab.create(player,'技能提示中的技能信息',list)
                info_ui:get_child('技能图标'):set_image(y3.ability.get_icon_by_key(value))
                info_ui:get_child('技能描述'):set_text(y3.ability.get_str_attr_by_key(value,'description'))
                info_ui:get_child('技能名字'):set_text(y3.ability.get_str_attr_by_key(value,'name'))
                info_ui:get_child('技能等级'):set_text('LV' .. gamePlayer.heroUnit:find_ability('隐藏',value):get_level())
            end
        end
    end
end

function M.ShowBossTip(player)
    local ui = y3.ui.get_ui(player, '游戏主界面')
    ui:get_child('敌将来袭'):set_visible(true)
    y3.timer.wait(2,function (timer)
        ui:get_child('敌将来袭'):set_visible(false)
    end)
end

y3.game:event_on('战斗回合结束',function (trigger,rounds)
    for key, value in pairs(_G_Game.GamePlayerData) do
        local ui = y3.ui.get_ui(value.player, '游戏主界面.回合数.地图.波数')
        ui:set_text('第' .. rounds .. '波')
    end
end)

y3.game:event('界面-消息', '选技能', function (trg, data)
    M.RefashExp(data.player)
end)

y3.game:event('界面-消息', '显示技能说明', function (trg, data)
    M.RefashSkillTip(data.player,data.ui:get_name())
    y3.ui.get_ui(data.player, '游戏主界面.流派提示'):set_visible(true)
end)

y3.game:event('界面-消息', '隐藏技能说明', function (trg, data)
    y3.ui.get_ui(data.player, '游戏主界面.流派提示'):set_visible(false)
end)

y3.game:event('界面-消息', '显示TIP', function (trg, data)
    M.ShowItmeTip(data.player,data.data.type,data.data.index)
end)

y3.game:event('界面-消息', '关闭TIP', function (trg, data)
    y3.ui.get_ui(data.player, '游戏主界面.TIPS'):set_follow_mouse(false)
    y3.ui.get_ui(data.player, '游戏主界面.TIPS'):set_visible(false)
end)


return M;