local M = {}

---comment
---@param player Player
---@param skills table
---@param ignoreLock ?boolean
function M.Enter(player,skills,ignoreLock)
    local ui = y3.ui.get_ui(player, '技能选择')
    local data = y3.game.get_table("流派信息")
    local cunt = #skills
    for index, value in ipairs(skills) do
        local skillUi = ui:get_child('技能栏.技能'..index)
        if skillUi then
            GameAPI.del_ui_comp_event(skillUi.handle, y3.const.UIEventMap['左键-按下'], '选技能')
            if not skillUi:get_child('卡牌锁定'):is_visible() or ignoreLock then
                skillUi:set_image(value['图片_ID'])
                skillUi:get_child('已选取'):set_visible(false)
                skillUi:get_child('技能图标'):set_image(y3.ability.get_icon_by_key(value.Skill_Type))
                skillUi:get_child('技能描述'):set_text(M.SkillDesc(player.id,value.Skill_Type,GameAPI.get_ability_desc_by_type(value.Skill_Type)))
                skillUi:get_child('技能名'):set_text(GameAPI.get_ability_name_by_type(value.Skill_Type))
                for i = 1, 5, 1 do
                    if i <= value.Quality then
                        skillUi:get_child('技能等级'..i):set_image(134218167)
                    else
                        skillUi:get_child('技能等级'..i):set_image(134251776)
                    end
                end
                skillUi:get_child('价格'):set_text(value['售价'])
                skillUi:get_child('卡牌锁定'):set_visible(false)
                if #value['所属流派1'] > 0 then
                    skillUi:get_child('流派图标1'):set_image(data[value['所属流派1']]['图标'])
                    skillUi:get_child('流派图标1'):set_visible(true)
                else
                    skillUi:get_child('流派图标1'):set_visible(false)
                end
                if #value['所属流派2'] > 0 then
                    skillUi:get_child('流派图标2'):set_image(data[value['所属流派2']]['图标'])
                    skillUi:get_child('流派图标2'):set_visible(true)
                else
                    skillUi:get_child('流派图标2'):set_visible(false)
                end
                if #value['所属流派3'] > 0 then
                    skillUi:get_child('流派图标3'):set_image(data[value['所属流派3']]['图标'])
                    skillUi:get_child('流派图标3'):set_visible(true)
                else
                    skillUi:get_child('流派图标3'):set_visible(false)
                end
                skillUi:add_event('左键-按下','选技能',value)
            end
        end
    end
    _G_Game.CheckFreeSkill(player.id)
    _G_Game.ReducedPriceRefresh(player.id,20)
    ui:set_visible(true);
    y3.ui.get_ui(player, '游戏主界面.玩家信息栏'):set_visible(false)
end

---comment
---@param playerId integer
---@param skill_type py.AbilityKey
---@param desc string
---@return string
function M.SkillDesc(playerId,skill_type,desc)
    local maxLevel = y3.ability.get_int_attr_by_key(skill_type,'ability_max_level')
    local showLevel = 1
    local skill = _G_Game.FindSkill(playerId,'隐藏',skill_type)
    if skill then
        showLevel = math.min(skill:get_level()+1,maxLevel)
    end
    local date = nil
    local date2 = nil
    if maxLevel == 5 then
        date = {
            "%d+/%d+/%d+/%d+/%d+",
            "%d+%%/%d+%%/%d+%%/%d+%%/%d+%%",
            "%d+%.%d+/%d+%.%d+/%d+%.%d+/%d+%.%d+/%d+%.%d+",
            "%d+%.%d+%%/%d+%.%d+%%/%d+%.%d+%%/%d+%.%d+%%/%d+%.%d+%%",
        }
    elseif maxLevel == 3 then
        date = {
            "%d+/%d+/%d+",
            "%d+%%/%d+%%/%d+%%",
            "%d+%.%d+/%d+%.%d+/%d+%.%d+",
            "%d+%.%d+%%/%d+%.%d+%%/%d+%.%d+%%",
        }
    end
    if date == nil then
        return desc
    end

    local newDesc = desc
    while true do
        local begin,over = nil, nil
        for i = 1, 4, 1 do
            begin,over = string.find(newDesc, date[i])
            if begin ~= nil then
                break
            end
        end
        if begin == nil then
            break
        end
        local temp_begin = string.sub(newDesc, 1,begin-1)
        local temp = string.sub(newDesc, begin,over)
        local temp_end = ""
        if over+1 < newDesc:len() then
            temp_end = string.sub(newDesc, over+1)
        end
        if temp == nil then
            break
        end
        local split = M.split_string(temp, '/')
        if split[showLevel] then
            temp = split[showLevel]
        end
        newDesc = temp_begin .. temp .. temp_end
    end
    return newDesc
end

function M.split_string(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t = {}
    for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
        table.insert(t, str)
    end
    return t
end

---@param player Player
---@param show boolean
function M.SelectHeroVisible(player,show)
    local ui = y3.ui.get_ui(player, '技能选择')
    ui:set_visible(show);
    y3.ui.get_ui(player, '游戏主界面.玩家信息栏'):set_visible(not show)
end

---comment
---@param player Player
---@return boolean
function M.SelectOver(player)
    local ui = y3.ui.get_ui(player, '技能选择')
    for i = 1, 3, 1 do
        local lockUi = ui:get_child('技能栏.技能'..i .. '.已选取')
        if lockUi and not lockUi:is_visible() then
            return false
        end
    end
    return true
end

function M.Lock(player)
    local ui = y3.ui.get_ui(player, '技能选择')
    for i = 1, 3, 1 do
        local lockUi = ui:get_child('技能栏.技能'..i .. '.卡牌锁定')
        if lockUi then
            lockUi:set_visible(not lockUi:is_visible())
        end
    end
end
return M;