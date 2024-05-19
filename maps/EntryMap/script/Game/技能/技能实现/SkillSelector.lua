local M = {}

---comment
---@param ability Ability
---@param cast Cast
---@return Unit[]
function M.GetUnits(ability, cast)
    local unitys = {}
    if ability:get_skill_pointer() == y3.const.AbilityPointerType['SECTOR']then
        local selector = M.SectorSelector(ability,cast)
        unitys = selector:get():pick()
        Delete(selector)
    end
    return unitys
end

---comment
---@param ability Ability
---@param cast Cast
---@return Selector
function M.SectorSelector(ability, cast)
    local selector = y3.selector.create()
    local shape = y3.shape.create_sector_shape(ability:get_float_attr('ability_cast_range'),ability:get_float_attr('sector_angle'),cast:get_angle())
    selector:in_shape(ability:get_owner():get_point(),shape)
    return selector
end

---comment
---@param srcUnit Unit
---@param radius integer
---@return Unit[]
function M.GetUnitsByRound(srcUnit,radius)
    local selector = y3.selector.create()
    local shape = y3.shape.create_circular_shape(radius)
    selector:in_shape(srcUnit:get_point(),shape)
    local unitys = {}
    unitys = selector:get():pick()
    Delete(selector)
    return unitys
end

---comment
---@param pos Point
---@param radius integer
---@return Unit[]
function M.GetUnitsByRoundAndPos(pos,radius)
    local selector = y3.selector.create()
    local shape = y3.shape.create_circular_shape(radius)
    selector:in_shape(pos,shape)
    local unitys = {}
    unitys = selector:get():pick()
    Delete(selector)
    return unitys
end

return M