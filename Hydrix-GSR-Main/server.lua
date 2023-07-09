local QBCore = exports['qb-core']:GetCoreObject()


-- Function to test for GSR
RegisterServerEvent('gsr:test')
AddEventHandler('gsr:test', function(targetID)
    local _source = source
    if targetID ~= nil then
        if GSRTab[targetID] ~= nil then
            TriggerClientEvent('chat:addMessage', _source, {args = {"System", "Player has GSR!"}})
        else
            TriggerClientEvent('chat:addMessage', _source, {args = {"System", "Player doesn't have GSR."}})
        end
    end
end)

-- Function to clean GSR
RegisterServerEvent('gsr:clean')
AddEventHandler('gsr:clean', function()
    local _source = source
    GSRTab[_source] = nil
end)

-- Function to mark player with GSR when gun is fired
RegisterServerEvent('baseevents:onPlayerShot')
AddEventHandler('baseevents:onPlayerShot', function()
    local _source = source
    GSRTab[_source] = tick()
end)


function sendToDisc(title, message)
    local embed = {}
    embed = {
        {
            ["color"] = 16711680, -- GREEN = 65280 --- RED = 16711680
            ["title"] = "**".. title .."**",
            ["description"] = "" .. message ..  "",
            ["footer"] = {
                ["text"] = 'GSR | TEST RESULTS',
            },
        }
    }
    -- Start
    -- TODO Input Webhook
    PerformHttpRequest(Config.Logging.webhook, 
    function(err, text, headers) end, 'POST', json.encode({username = 'Hydrix GSR Test', embeds = embed}), { ['Content-Type'] = 'application/json' })
  -- END
end

function ExtractIdentifiers(src)
    local identifiers = {
        steam = "",
        discord = "" 
    }

    --Loop over all identifiers
    for i = 0, GetNumPlayerIdentifiers(src) - 1 do
        local id = GetPlayerIdentifier(src, i)

        --Convert it to a nice table.
        if string.find(id, "steam") then
            identifiers.steam = id
        elseif string.find(id, "discord") then
            identifiers.discord = id
        end
    end

    return identifiers
end
