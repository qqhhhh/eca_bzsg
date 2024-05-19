local M = {}

M.Skills = New 'Pool'
M.SkillsByType = {}
function M.Init()
    M.Skills:clear()
    local data = y3.game.get_table("流派技能")
    for key, value in ipairs(data) do
        M.Skills:add(value)
        if #value['所属流派1'] > 0 then
            if M.SkillsByType[value['所属流派1']] == nil then
                M.SkillsByType[value['所属流派1']] = {}
            end
            table.insert(M.SkillsByType[value['所属流派1']],value)
        end
        if #value['所属流派2'] > 0 then
            if M.SkillsByType[value['所属流派2']] == nil then
                M.SkillsByType[value['所属流派2']] = {}
            end
            table.insert(M.SkillsByType[value['所属流派2']],value)
        end
        if #value['所属流派3'] > 0 then
            if M.SkillsByType[value['所属流派3']] == nil then
                M.SkillsByType[value['所属流派3']] = {}
            end
            table.insert(M.SkillsByType[value['所属流派3']],value)
        end
    end
end

---comment
---@return table[]
function M.GetSkills()
    return M.Skills:random_n(3)
end

---comment
---@return table
function M.RandomSkill()
    return M.Skills:random()
end

return M
