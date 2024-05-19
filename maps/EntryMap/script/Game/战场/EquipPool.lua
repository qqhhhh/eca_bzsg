local M = {}
M.equips = {}
M.secrets = {}
function M.Init()
    local data = y3.game.get_table("选择装备数据")
    for key, value in pairs(M.equips) do
        Delete(value)
    end
    for key, value in pairs(M.secrets) do
        Delete(value)
    end
    for index, value in ipairs(data) do
        local rounds = value['出现回合']
        if value['所属类型'] == '秘籍' then
            if not M.secrets[rounds] then
                M.secrets[rounds] = New 'Pool'
                M.secrets[rounds]:clear()
            end
            M.secrets[rounds]:add(value['物品'])
        elseif value['所属类型'] == '装备' then
            if not M.equips[rounds] then
                M.equips[rounds] = New 'Pool'
                M.equips[rounds]:clear()
            end
            M.equips[rounds]:add(value['物品'])
        end
    end
end

---comment
---@param type string
---@param rounds integer
---@param count integer
---@return table
function M.RandomEquips(type,rounds,count)
    local curPool = nil
    if type == '秘籍' then
        curPool = M.secrets[rounds]
    elseif type == '装备' then
        curPool = M.equips[rounds]
    end
    if curPool == nil then
        return {}
    end
    return curPool:random_n(3)
end

return M;