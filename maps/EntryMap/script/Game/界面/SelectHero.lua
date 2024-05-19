local M = {}

---@param player Player
function M.Enter(player)
    local ui = y3.ui.get_ui(player, '英雄选择界面')
    M.InitPlayerUi(player)
    ui:set_visible(true);
    M.RefashShowHero(player,'蜀',true);
end

---@param player Player
---@param show boolean
function M.SelectHeroVisible(player,show)
    local ui = y3.ui.get_ui(player, '英雄选择界面')
    ui:set_visible(show);
end

---comment
---@param player Player
function M.InitPlayerUi(player)
    local self_player = player;
    local ui = y3.ui.get_ui(self_player, '英雄选择界面')
    for i = 1, 4, 1 do
        local cur_player = y3.player.get_by_id(i)
        local playerUi = ui:get_child('组队信息.玩家' .. i);
        if playerUi then
            if cur_player and cur_player:get_state() == 1 then
                playerUi:get_child('玩家头像'):set_image(cur_player:get_platform_icon())
                playerUi:get_child('英雄头像'):set_visible(false)
                playerUi:set_visible(true)
            else
                playerUi:set_visible(false)
            end
        end
        M.RefashPlayerSelectHero(cur_player,y3.game.get_table("英雄数据")[1])
        _G_Game.SetestUnit(cur_player.id,y3.game.get_table("英雄数据")[1])
    end
end

---comment
---@param player Player
---@param heroData table
function M.RefashPlayerSelectHero(player,heroData)
    for i = 1, 4, 1 do
        local cur_player = y3.player.get_by_id(i)
        if cur_player then
            local ui = y3.ui.get_ui(cur_player, '英雄选择界面')
            local playerUi = ui:get_child('组队信息.玩家' .. player.id);
            if playerUi then
                if cur_player then
                    playerUi:get_child('英雄头像.名字'):set_text(heroData['英雄名字'])
                    playerUi:get_child('英雄头像'):set_image(heroData['头像资源ID'])
                    playerUi:get_child('英雄头像'):set_visible(true)
                else
                    playerUi:set_visible(false)
                end
            end
            ui:get_child('武将信息.人物立绘组.人物'):set_image(heroData['立绘'])
            ui:get_child('武将信息.人物立绘组.姓名'):set_text(heroData['英雄名字'])
            local unitData = y3.object.unit[heroData['资源ID']]
            if unitData then
                for i = 1, 2, 1 do
                    local curUi = ui:get_child('武将信息.技能'..i)
                    if curUi then
                        local skill_type = unitData.data.hero_ability_list[i-1][0]
                        local skill = y3.ability.get_by_id(skill_type)
                        curUi:get_child('技能图标'):set_image(y3.ability.get_icon_by_key(skill_type))
                        curUi:get_child('技能名'):set_text(y3.ability.get_str_attr_by_key(skill_type,'name'))
                        curUi:get_child('技能描述'):set_text(y3.ability.get_str_attr_by_key(skill_type,'description'))
                    end
                end
            end

            local friendSkillData = y3.game.get_table("情义技能")
            local friednSkillCount = 1
            ui:get_child('武将信息.情义技.情义技能1'):set_visible(false)
            ui:get_child('武将信息.情义技.情义技能2'):set_visible(false)
            for key, value in ipairs(friendSkillData) do
                for i = 1, 4, 1 do
                    local curUnit = value['单位' .. i]
                    if curUnit then
                        if curUnit == heroData['资源ID'] and value['Need_Skill'] == 0 then
                            local skillType = value['Skill_Type']
                            local curUi = ui:get_child('武将信息.情义技.情义技能'..friednSkillCount)
                            if curUi then
                                curUi:get_child('技能名'):set_text(y3.ability.get_str_attr_by_key(skillType,'name')) 
                                curUi:get_child('技能图标'):set_image(y3.ability.get_icon_by_key(skillType))
                                curUi:add_event('鼠标-移入','显示情义TIP',skillType)
                                curUi:add_event('鼠标-移出','关闭情义TIP')
                                curUi:set_visible(true)
                            end
                            friednSkillCount = friednSkillCount + 1
                        end
                    end
                end
            end

            local ImgData = y3.game.get_table("流派信息")
            for i = 1, 2, 1 do
                local key = '流派' .. i
                local factions = heroData[key]
                if factions and #factions > 0 then
                    ui:get_child('武将信息.人物立绘组.' .. key):set_image(ImgData[factions]['图标'])
                    ui:get_child('武将信息.人物立绘组.' .. key):set_visible(true)
                else
                    ui:get_child('武将信息.人物立绘组.' .. key):set_visible(false)
                end
            end
        end
    end
end

---@param player Player
---@param type string
---@param init? boolean
function M.RefashShowHero(player,type,init)
    local ui = y3.ui.get_ui(player, '英雄选择界面')
    local data = y3.game.get_table("英雄数据")
    if  data == nil then
        print("英雄数据表格读取错误")
        return;
    end
    
    local list = ui:get_child('选人头像部分.英雄选择')
    if  list == nil then
        print("英雄选择界面.选人头像部分.英雄选择 UI控件错误")
        return;
    end
    list:set_visible(false);
    ---清空旧数据
    for key, value in pairs(list:get_childs()) do
        value:remove();
    end

    local count = 0
    local selectRoot = nil
    for index, value in ipairs(data) do
        if value['势力'] == type then
            local index = count % 3
            count = count + 1
            if index == 0 then
                selectRoot = list:create_child('空节点')
            end
            if selectRoot then
                local beginX = -170
                local curUi = y3.ui_prefab.create(player,'选人头像',selectRoot):get_child()
                if curUi then
                    curUi:get_child('名字'):set_text(value['英雄名字'])
                    curUi:get_child('无法选择遮罩'):set_visible(false);
                    curUi:get_child('选中'):set_visible(false);
                    curUi:set_image(value['头像资源ID'])
                    curUi:get_child('选择'):add_event('左键-点击',"选英雄",value);
                    if init ~= nil and init then
                        curUi:get_child('选中'):set_visible(true)
                        init = false
                    end
                    curUi:set_pos(beginX + index * 220, 0);
                    local ImgData = y3.game.get_table("流派信息")
                    for i = 1, 2, 1 do
                        local key = '流派' .. i
                        local factions = value[key]
                        if factions and #factions > 0 then
                            curUi:get_child(key):set_image(ImgData[factions]['图标'])
                            curUi:get_child(key):set_visible(true)
                        else
                            curUi:get_child(key):set_visible(false)
                        end
                    end
                end
            end
        end
    end
    list:set_visible(true);
end

-- 接收UI事件
y3.game:event('界面-消息', '选择群', function (trg, data)
    M.RefashShowHero(data.player,'群')
end)
y3.game:event('界面-消息', '选择魏', function (trg, data)
    M.RefashShowHero(data.player,'魏')
end)
y3.game:event('界面-消息', '选择蜀', function (trg, data)
    M.RefashShowHero(data.player,'蜀')
end)
y3.game:event('界面-消息', '选择吴', function (trg, data)
    M.RefashShowHero(data.player,'吴')
end)
y3.game:event('界面-消息', '准备开始', function (trg, data)
    M.RefashShowHero(data.player,'吴')
end)

y3.game:event('界面-消息', '选英雄', function (trg, data)
    local ui = y3.ui.get_ui(data.player, '英雄选择界面')
    local list = ui:get_child('选人头像部分.英雄选择')
    if list then
        local roots = list:get_childs()
        for index, value in pairs(roots) do
            for index2, value2 in pairs(value:get_childs()) do
                local tempUi = value2:get_child('选择')
                if tempUi then
                    if tempUi.handle == data.ui.handle then
                        value2:get_child('选中'):set_visible(true)
                    else
                        value2:get_child('选中'):set_visible(false)
                    end
                end
            end
        end
    end

    M.RefashPlayerSelectHero(data.player,data.data)
    _G_Game.SetestUnit(data.player.id,data.data)
end)

y3.game:event('界面-消息', '确定英雄', function (trg, data)
    data.player:event_notify('确定选择英雄')
    --data.ui:set_button_enable(false)
end)

y3.game:event('界面-消息', '显示情义TIP', function (trg, data)
    local tips = y3.ui.get_ui(data.player, '英雄选择界面.TIPS')
    tips:set_follow_mouse(true)
    tips:get_child('名字'):set_text(y3.ability.get_str_attr_by_key(data.data,'name'))
    tips:get_child('描述'):set_text(y3.ability.get_str_attr_by_key(data.data,'description'))
    tips:set_visible(true)
end)

y3.game:event('界面-消息', '关闭情义TIP', function (trg, data)
    y3.ui.get_ui(data.player, '英雄选择界面.TIPS'):set_follow_mouse(false)
    y3.ui.get_ui(data.player, '英雄选择界面.TIPS'):set_visible(false)
end)

return M;