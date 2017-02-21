package.path = package.path .. ";data/scripts/systems/?.lua"
package.path = package.path .. ";data/scripts/lib/?.lua"
require ("basesystem")
require ("utility")
require ("tradingoverview")

sellable = {}
buyable = {}

tradingData = nil

function onInstalled(seed, rarity)
	
end

function onUninstalled(seed, rarity)

end

function getName(seed, rarity)
    local prefix = ""
    if rarity.value == 0 then
        return "Basic Goods Monitor"%_t
    elseif rarity.value == 1 then
        return "Improved Goods Monitor"%_t
    elseif rarity.value == 2 then
        return "Advanced Goods Monitor"%_t
    elseif rarity.value == 3 then
        return "High-Tech Goods Monitor"%_t
    elseif rarity.value == 4 then
        return "Salesman's Goods Monitor"%_t
    elseif rarity.value == 5 then
        return "Ultra-Tech Goods Monitor"%_t
    end

    return "Goods Monitor"%_t
end

function getIcon(seed, rarity)
    return "data/textures/icons/cash.png"
end

function getPrice(seed, rarity)
	math.randomseed(seed)
    local price = (rarity.value + 2) * 4000 + 5000 * getInt(1, 5);
    return price * 2.5 ^ rarity.value
end

function getTooltipLines(seed, rarity)
    local lines = {}

    table.insert(lines, {ltext = "Displays location of goods."%_t, icon = "data/textures/icons/coins.png"})

    return lines
end

function getDescriptionLines(seed, rarity)
    local lines =
    {
        {ltext = "View location of goods in sectors visited."%_t}
    }

    return lines
end

function gatherData()

    local buyable = {}
    local player = Player();

    if player:hasScript("../systems/tradeoverview.lua") then

		local scripts = {"consumer.lua", "factory.lua", "tradingpost.lua"}

		for _, station in pairs({Sector():getEntitiesByType(EntityType.Station)}) do
		    for _, script in pairs(scripts) do

		        local results = {station:invokeFunction(script, "getSoldGoods")}
		        local callResult = results[1]

		        if callResult == 0 then -- call was successful, the station sells goods

		            for i = 2, #results do
		                local name = results[i];

		                local callOk, good = station:invokeFunction(script, "getGoodByName", name)
		                if callOk ~= 0 then print("getGoodByName failed: " .. callOk) end

		                local callOk, stock, maxStock = station:invokeFunction(script, "getStock", name)
		                if callOk ~= 0 then print("getStock failed" .. callOk) end

		                local callOk, price = station:invokeFunction(script, "getSellPrice", name, Faction().index)
		                if callOk ~= 0 then print("getSellPrice failed" .. callOk) end

		                table.insert(buyable, {good = good, price = price, stock = stock, maxStock = maxStock, station = station.title, titleArgs = station:getTitleArguments(), stationIndex = station.index, coords = vec2(Sector():getCoordinates())})
		            end
		        end
		    end
		else
				print(player:name .. " doesn't have a trade module.")
		end    
    end

    return buyable
end

function onSectorChanged()
    collectSectorData()
end

function collectSectorData()
    if tradingData then
        local buyable = gatherData()

--        print("gathered " .. #buyable .. " buyable goods from sector " .. tostring(vec2(Sector():getCoordinates())))

        tradingData:insert({buyable = buyable})

        analyzeSectorHistory()
    end
end