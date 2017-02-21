if onServer() then

function initialize()
    local dockables = {Sector():getEntitiesByComponent(ComponentType.DockingPositions)}

    for _, entity in pairs(dockables) do
        entity:addScriptOnce("entity/regrowdocks.lua")
    end

    Sector():addScriptOnce("sector/relationchanges.lua")
end

end
