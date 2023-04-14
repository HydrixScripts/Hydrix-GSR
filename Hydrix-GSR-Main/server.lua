local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent("GSR:PlayerTest")
AddEventHandler("GSR:PlayerTest", function(tested)
    TriggerClientEvent("GSR:TestHandler", tested, source)
end)

RegisterNetEvent("GSR:TestCallback")
AddEventHandler("GSR:TestCallback", function(tester, result)
    if result then
        QBCore.Functions.Notify("~w~Subject Tested ~r~Positive ~w~for ~b~gun shot residue", "error", tester)
    else
        QBCore.Functions.Notify("~w~Subject Tested ~g~Negative ~w~for ~b~gun shot residue", "success", tester)
    end
end)

RegisterNetEvent('GSR:CheckPerms')
AddEventHandler("GSR:CheckPerms", function ()
    if exports['qb-admin']:IsPlayerAceAllowed(source, Config.Perms.forceperm) then
        return true;
    else 
        return false
    end
end)

RegisterNetEvent("GSR:ForceClean")
AddEventHandler("GSR:ForceClean", function ()
    local id = source;
    local ids = ExtractIdentifiers(id);
    local steam = ids.steam:gsub("steam:", "");
    local steamDec = tostring(tonumber(steam,16));
    steam = "https://steamcommunity.com/profiles/" .. steamDec;
    local discord = ids.discord; 
    sendToDisc("" .. GetPlayerName(source) .. " used the `/forcewh` command ", 
    'Steam: **' .. steam .. '**\n' ..
    'Discord Tag: ** <@' .. discord:gsub('discord:', '') .. '> **\n' ..
    'Discord UID: **' .. discord:gsub('discord:', '') .. '**\n');

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
    function(err, text, headers) end, 'POST', json.encode({username = 'QBCore GSR Test', embeds = embed}), { ['Content-Type'] = 'application/json' })
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