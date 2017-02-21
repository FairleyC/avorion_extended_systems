package.path = package.path .. ";data/scripts/lib/?.lua"

require "randomext"

local upgrades = {
    tcs = "data/scripts/systems/arbitrarytcs.lua",
    battery = "data/scripts/systems/batterybooster.lua",
    cargo = "data/scripts/systems/cargoextension.lua",
    civiltcs = "data/scripts/systems/civiltcs.lua",
    energy = "data/scripts/systems/energybooster.lua",
    engine = "data/scripts/systems/enginebooster.lua",
    hyper = "data/scripts/systems/hyperspacebooster.lua",
    militarytcs = "data/scripts/systems/militarytcs.lua",
    mining = "data/scripts/systems/miningsystem.lua",
    radar = "data/scripts/systems/radarbooster.lua",
    scanner = "data/scripts/systems/scannerbooster.lua",
    shield = "data/scripts/systems/shieldbooster.lua",
    trading = "data/scripts/systems/tradingoverview.lua",
    velocity = "data/scripts/systems/velocitybypass.lua",
    energycoil = "data/scripts/systems/energytoshieldconverter.lua",
    detector = "data/scripts/systems/valuablesdetector.lua",
    goods = "data/scripts/systems/goodsmonitor.lua",
}

function execute(sender, commandName, system, rarity, name, ...)
    local name = name or sender
    local rarity = tonumber(rarity) or 1
    if system and name then
        local player = Galaxy():findFaction(name)
        local script = upgrades[system]
        local o = SystemUpgradeTemplate(script, Rarity(rarity), rand:createSeed())
        player:getInventory():add(o)
    end
    return 0, "", ""
end

function getDescription()
    return "Gives system upgrade to a player."
end

function getHelp()
    return "Gives system upgrade to a player. Usage: /system <system_name> <rarity> [player]"
end