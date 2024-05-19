local itemLogic = require 'Game.物品.ItemLogic'

---@class GamePlayer
---@field player Player
---@field heroTableData table
---@field skillInfo table
---@field selectHeroOver boolean
---@field freeSkill boolean
---@field heroUnit Unit
---@field statistic table
local M = Class 'GamePlayer'
M.type = 'GamePlayer'

function M:__init(player)
    self.player = player
    print('初始化玩家 ID:'.. tostring(player.id))
    self.player:event_on('确定选择英雄',function (trigger, ui)
        if M.heroTableData then
            M.selectHeroOver = true;
        end
    end)
    y3.camera.disable_camera_move(player)
    self:InitPlayerData()
    self:InitEvent()
end

function M:InitPlayerData()
    self.skillInfo = {
        回复 ={skills = {},exp = 0, lv = 1},
        怒火 ={skills = {},exp = 0, lv = 1},
        普攻 ={skills = {},exp = 0, lv = 1},
        护盾 ={skills = {},exp = 0, lv = 1},
        暴击 ={skills = {},exp = 0, lv = 1},
        生命 ={skills = {},exp = 0, lv = 1},
        大招 ={skills = {},exp = 0, lv = 1},
        冰霜 ={skills = {},exp = 0, lv = 1},
        毒 ={skills = {},exp = 0, lv = 1},
        闪避 ={skills = {},exp = 0, lv = 1},
        易伤 ={skills = {},exp = 0, lv = 1},
        护卫 ={skills = {},exp = 0, lv = 1},
    }
    self.statistic = {damage = 0}
    self.selectHeroOver = false
    if self.heroUnit then
        self.heroUnit:remove()
    end
    self.heroUnit = nil
end

function M:InitEvent()
    self.player:event_on('确定选择英雄',function (trigger, ui)
        if self.heroTableData then
            self.selectHeroOver = true;
        end
    end)
end

function M:SeletUnitData(data)
    self.heroTableData = data;
end

function M:SelectHero()
    self.heroUnit = self.player:create_unit(self.heroTableData['资源ID'], y3.point.get_point_by_res_id(10000+self.player.id), 180)
    self.heroUnit:event('单位-造成伤害后', function (trg, data)
        self.statistic.damage = self.statistic.damage - data.damage
        y3.ui.get_ui(self.player, '游戏主界面.伤害统计.1.伤害值'):set_text(self.statistic.damage.."")
    end)
    self.player:select_unit(self.heroUnit)
    y3.camera.enable_camera_move(self.player)
    return true
end

function M:Pause()
    self:EffectEnd()
    self.player:select_unit(self.heroUnit)
    --self.heroUnit.handle:api_set_is_sleeping(true)
    y3.camera.disable_camera_move(self.player)
end

function M:Play()
    self:EffectBegin()
    self.player:select_unit(self.heroUnit)
    --self.heroUnit.handle:api_set_is_sleeping(false)
    y3.camera.enable_camera_move(self.player)
end

---comment
---@param rounds integer
function M:GoldRevenue(rounds)
    if rounds == 1 then
        self.player:set("gold",300)
        print("第一回合奖励金钱" .. 300)
    else
        local base = 250
        local revenue = math.min(math.floor(self.player:get_attr("gold")/100) * 10, 100)
        self.player:add("gold",base+revenue)
        print('增加收入' .. base+revenue)
        itemLogic.日进斗金(self.heroUnit)
    end
    self.heroUnit:kv_save('吉星高照状态',0)
    itemLogic.分文不取初始化(self.heroUnit)
end

function M:Reset()
    if self.heroUnit then
        if not self.heroUnit:is_alive() then
            self.heroUnit:reborn(y3.point.get_point_by_res_id(10000+self.player.id))
        end
        self.heroUnit:set_point(y3.point.get_point_by_res_id(10000+self.player.id),false)
        self.heroUnit:set_hp(self.heroUnit:get_final_attr('hp_max'))
        self.heroUnit:set_mp(0)
    end
end

---comment
---@param skillData table
---@return boolean
function M:AddSkill(skillData)
    local skillId = skillData.Skill_Type
    local skill = self.heroUnit:find_ability('隐藏',skillId)
    if skill then
        if skill:get_level() == GameAPI.get_ability_max_level(skill.handle) then
            return false
        end
        skill:add_level(1)
    else
        self.heroUnit:add_ability('隐藏',skillId)
    end
    print("选择技能：" .. GameAPI.get_ability_name_by_type(skillId))
    for i = 1, 3, 1 do
        local type = skillData['所属流派'..i]
        if self.skillInfo[type] then
            self.skillInfo[type].exp = self.skillInfo[type].exp + skillData['Exp']
            table.insert(self.skillInfo[type].skills,skillId)
            if self.skillInfo[type].exp == 4 or self.skillInfo[type].exp == 10 or self.skillInfo[type].exp == 20 or self.skillInfo[type].exp == 40 then
                self.skillInfo[type].lv = self.skillInfo[type].lv + 1
                self.heroUnit:add_level(1)
            end
        end
    end
    return true
end

---comment
---@param slotType y3.Const.AbilityType | y3.Const.AbilityTypeAlias 技能类型
---@param slotIndex integer 技能位
---@return Ability? ability 技能
function M:GetSkill(slotType, slotIndex)
    return self.heroUnit:get_ability_by_slot(slotType,slotIndex)
end

---comment
---@param slotType y3.Const.AbilityType | y3.Const.AbilityTypeAlias 技能类型
---@param id py.AbilityKey 物编id
---@return Ability?
function M:FindSkill(slotType,id)
    return self.heroUnit:find_ability(slotType,id)
end

---comment
---@return boolean
function M:IsFreeSkill()
    return self.heroUnit:kv_load('吉星高照状态','integer') == 1
end

function M:CheckFreeSkill()
    itemLogic.吉星高照(self.heroUnit)
end

function M:UseFreeSkill()
    self.heroUnit:kv_save('吉星高照状态',2)
    itemLogic.吉星高照(self.heroUnit)
end

---comment
---@param price integer
---@return integer
function M:ReducedPriceRefresh(price)
    if itemLogic.价廉物美(self.heroUnit) then
        return price - 10
    end
    return price
end

function M:FreeRefreshSkillCount()
    return itemLogic.分文不取(self.heroUnit)
end

function M:UserFreeRefreshSkill()
    local count = self.heroUnit:kv_load('分文不取次数','integer')
    count = count - 1
    self.heroUnit:kv_save('分文不取次数',count)
    itemLogic.分文不取(self.heroUnit)
end

---comment
---@param slotIndex integer
---@param slotType y3.Const.ShiftSlotTypeAlias
---@return Item?
function M:GetItem(slotIndex,slotType)
    return self.heroUnit:get_item_by_slot(slotType,slotIndex)
end

function M:GetStatisticDamage()
    return self.statistic.damage
end

function M:EffectBegin()
    self.effects = {}
    local skills = self.heroUnit:get_abilities_by_type(0)
    for index, value in pairs(skills) do
        local curSkill = _G_CSV.skill[value:get_key()]
        if curSkill then
            if curSkill.Effect_ID and curSkill.Effect_ID ~= 0 then
                local tempParticle = y3.particle.create({
                    type = curSkill.Effect_ID,
                    target = self.heroUnit,
                    socket = curSkill['特效绑定位置'],
                    follow_scale = true,
                })
                table.insert(self.effects,tempParticle)
                print("EffectBegin创建特效" .. curSkill.Effect_ID)
            end
            if curSkill.Effect_ID2 and curSkill.Effect_ID2 ~= 0 then
                local tempParticle = y3.particle.create({
                    type = curSkill.Effect_ID2,
                    target = self.heroUnit,
                    socket = curSkill['特效绑定位置2'],
                    follow_scale = true,
                })
                table.insert(self.effects,tempParticle)
                print("EffectBegin创建特效" .. curSkill.Effect_ID)
            end
        end
    end
end
function M:EffectEnd()
    for index, value in ipairs(self.effects) do
        value:remove()
    end
end