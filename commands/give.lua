package.path = package.path .. ";data/scripts/lib/?.lua"

function execute(sender, commandName, ...)
    local args = {...}

    local str = ""
    for i, v in pairs(args) do
        str = str .. v .. " "
    end

    

    return 0, "", ""
end

function getDescription()
    return "Give an item type to the user."
end

function getHelp()
    return "Give an item type to the user. Usage: /give This is a test"
end
