local M = {}

---comment
---@param unit Unit
function M.日进斗金(unit)
    if unit:has_item_by_key(134221444) then
        unit:get_owner():add("gold",30)
        print('日进斗金+30')
    end
end

---comment
---@param unit Unit
---@return boolean
function M.吉星高照(unit)
    if unit:has_item_by_key(134228361) then
        local state = unit:kv_load('吉星高照状态','integer')
        if state == 0 then
            local probability = 45
            local random = GameAPI.get_random_int(1,100)
            if random <= probability then
                unit:kv_save('吉星高照状态',1)
                y3.ui.get_ui(unit:get_owner(),'技能选择.卡牌刷新组件.刷新.刷新按钮.刷新所需付费'):set_text('免费')
                print('触发本回合吉星高照')
                return true
            else
                print('吉星高照触发失敗')
            end
        elseif state == 1 then
            print('本回合吉星高照已经触发')
            return true
        elseif state == 2 then
            print('本回合吉星高照已经使用')
            y3.ui.get_ui(unit:get_owner(),'技能选择.卡牌刷新组件.刷新.刷新按钮.刷新所需付费'):set_text( '20')
            return false
        end
    end
    return false
end

function M.价廉物美(unit)
    if unit:has_item_by_key(134262000) then
        y3.ui.get_ui(unit:get_owner(),'技能选择.卡牌刷新组件.刷新.刷新按钮.刷新所需付费'):set_text('10')
        return true
    end
    return false
end

function M.分文不取(unit)
    if unit:has_item_by_key(134247724) then
        local count =  unit:kv_load('分文不取次数','integer')
        if count > 0 then
            y3.ui.get_ui(unit:get_owner(),'技能选择.卡牌刷新组件.刷新.刷新按钮.刷新所需付费'):set_text('免费')
            return true
        else
            if not M.价廉物美(unit) then
                y3.ui.get_ui(unit:get_owner(),'技能选择.卡牌刷新组件.刷新.刷新按钮.刷新所需付费'):set_text('20')
            end
        end
        print('分文不去次数：' .. count)
    end
    return false
end

function M.分文不取初始化(unit)
    if unit:has_item_by_key(134247724) then
        unit:kv_save('分文不取次数',25)
        y3.ui.get_ui(unit:get_owner(),'技能选择.卡牌刷新组件.刷新.刷新按钮.刷新所需付费'):set_text('免费')
    else
        unit:kv_save('分文不取次数',0)
        if not M.价廉物美(unit) then
            y3.ui.get_ui(unit:get_owner(),'技能选择.卡牌刷新组件.刷新.刷新按钮.刷新所需付费'):set_text('20')
        end
    end
end
return M
