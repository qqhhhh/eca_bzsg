
local M = y3.object.buff[134228683]


function M.on_add(buff)
    buff:event('效果-叠加',function (trg, data)
        data.buff:set_time(2)
    end)
end

function M.on_lose(ability)

end

return M