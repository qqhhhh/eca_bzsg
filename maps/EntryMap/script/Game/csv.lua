local M = {}

M.skill = {}

function M.Init()
    local data = y3.game.get_table("流派技能")
    for index, value in ipairs(data) do
        M.skill[value.Skill_Type] = value
    end
end

return M