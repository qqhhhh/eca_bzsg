local M = y3.object.buff[134250685]

function M.on_add(buff)
end

function M.on_lose(buff)
    local skill = buff:get_ability()
    if skill then
        if skill:kv_has('已经增加的攻击') then
            skill:kv_save('已经增加的攻击',0)
        end
    end
end

return M