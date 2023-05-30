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

QBCore.Commands.Add(Config.TestGSR, "Test for GSR on nearby players.", {}, false, function(source, args)
    local playerCoords = GetEntityCoords(plyPed)
    QBCore.Functions.TriggerCallback('GSR:PlayerTest', function(result)
        if result then
            QBCore.Functions.Notify("GSR detected!", "error")
        else
            QBCore.Functions.Notify("No GSR detected.", "success")
        end
    end, playerCoords, gsrTestDistance)
end)

QBCore.Commands.Add(Config.cleargsr, "Clean GSR residue.", {}, false, function(source, args)
    if gsrPositive then
        QBCore.Functions.Notify("Cleaning...", "inform")
        Citizen.Wait(10000)
        local chance = math.random(1, 3)
        if chance ~= 1 then
            QBCore.Functions.Notify("Success! Residue was cleaned off.", "success")
            gsrTimer = 0
            gsrPositive = false
        else
            QBCore.Functions.Notify("Failed! Residue was not cleaned off.", "error")
            gsrTimer = Config.GSRAutoClean
            Citizen.CreateThread(GSRThreadTimer)
        end
    end
end)

QBCore.Commands.Add(Config.forceclean, "Force clean GSR residue.", {}, false, function(source, args)
    QBCore.Functions.TriggerServerCallback("GSR:PermCheck", function(result)
        if result then
            QBCore.Functions.Notify("Success! Residue was cleaned off.", "success")
            gsrTimer = 0
            gsrPositive = false
            TriggerServerEvent("GSR:ForceClean")
        else
            QBCore.Functions.Notify("Failed! You do not have permission to do that!", "error")
        end
    end)
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
