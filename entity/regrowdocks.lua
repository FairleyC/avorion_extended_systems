
function getUpdateInterval()
    return 5 * 60
end

function initialize()

    if onServer() then
        regrow()
    end
end

function updateServer()
    regrow()
end


function regrow()
    local entity = Entity()

    local p, d, p2, d2 = entity:getDockingPositions()
    if p and p2 then return end

    local plan = Plan(entity.index)

    local highestZ = plan:getNthBlock(0)
    local lowestZ = highestZ
    local highestX = highestZ
    local lowestX = highestZ

    for i = 1, plan.numBlocks - 1 do
        local block = plan:getNthBlock(i)

        local box = block.box
        if box.upper.z > highestZ.box.upper.z then highestZ = block end
        if box.lower.z < lowestZ.box.lower.z then lowestZ = block end

        if box.upper.x > highestX.box.upper.x then highestX = block end
        if box.lower.x < lowestX.box.lower.x then lowestX = block end
    end

    if lowestZ.blockIndex ~= BlockType.Dock then
        placeDock(plan, lowestZ, vec3(0, 0, -1))
        return
    end

    if highestZ.blockIndex ~= BlockType.Dock then
        placeDock(plan, highestZ, vec3(0, 0, 1))
        return
    end

    if highestX.blockIndex ~= BlockType.Dock then
        placeDock(plan, highestX, vec3(1, 0, 0))
        return
    end

    if lowestX.blockIndex ~= BlockType.Dock then
        placeDock(plan, lowestX, vec3(-1, 0, 0))
        return
    end

end

function placeDock(plan, block, direction)
    local size = vec3(1, 1, 1)
    local position = block.box.center + (block.box.size * 0.5 * direction) + (size * 0.5 * direction)
    local orientation = MatrixLookUp(direction, vec3(0, 1, 0))
    plan:addBlock(position, size, block.index, -1, block.color, block.material, orientation, BlockType.Dock)
end



