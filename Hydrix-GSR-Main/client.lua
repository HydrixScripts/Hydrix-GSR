local QBCore = exports['qb-core']:GetCoreObject()
local gsrTimer = 0
local gsrPositive = false
local plyPed = PlayerPedId()
local gsrTestDistance = 5
local Commands = {}
local tick = nil


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        plyPed = PlayerPedId()
        if IsPedSwimmingUnderWater(plyPed) then
            Citizen.Wait(10000)
            if gsrPositive then
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
        end
        if IsPedShooting(plyPed) then
            if gsrPositive then
                gsrTimer = Config.GSRAutoClean
            else
                gsrPositive = true
                gsrTimer = Config.GSRAutoClean
                Citizen.CreateThread(GSRThreadTimer)
            end
        end
    end
end)

RegisterNetEvent("GSR:PlayerTest")
AddEventHandler("GSR:PlayerTest", function(tested)
    TriggerClientEvent("GSR:TestHandler", tested, source)
end)

RegisterNetEvent("GSR:TestCallback")
AddEventHandler("GSR:TestCallback", function(tester, result)
    if result then
         TriggerClientEvent('chat:addMessage', _source, {args = {"System", "Player has GSR!"}})
    else
        QBCore.Functions.Notify("~w~Subject Tested ~g~Negative ~w~for ~b~gun shot residue", "success", tester)
    end
end)

RegisterNetEvent('GSR:CheckPerms')
AddEventHandler("GSR:CheckPerms", function()
    local source = source -- Get the source of the event
    local permissionSystem = Config.PermissionSystem -- Get the configured permission system from the config

    if permissionSystem == "ox_lib" then
        if exports.ox_lib:HasPermission(source, Config.Perms.forceperm) then
            TriggerClientEvent('GSR:PermsResponse', source, true)
        else
            TriggerClientEvent('GSR:PermsResponse', source, false)
        end
    elseif permissionSystem == "qb-admin" then
        if exports['qb-admin']:IsPlayerAceAllowed(source, Config.Perms.forceperm) then
            TriggerClientEvent('GSR:PermsResponse', source, true)
        else
            TriggerClientEvent('GSR:PermsResponse', source, false)
        end
    else
        -- Handle the case when an unsupported permission system is configured
        TriggerClientEvent('GSR:PermsResponse', source, false)
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


-- Define your cleanup function
local function cleanup()
    local currentTime = tick()
    for k, v in pairs(GSRTab) do
        if currentTime - v >= Config.GSRAutoClean then
            GSRTab[k] = nil
        end
    end
end

-- Function to repeatedly run the cleanup function
local function runCleanup()
    while true do
        cleanup()
        wait(60) -- Pause the script execution for 60 seconds
    end
end

-- Start running the cleanup function
runCleanup()
RegisterNetEvent("GSR:Not1fy")
AddEventHandler("GSR:Not1fy", function(notHandler)
    QBCore.Functions.Notify(notHandler, "inform")
end)

function GSRThreadTimer()
    while gsrPositive do
        Citizen.Wait(1000)
        if gsrTimer == 0 then
            gsrPositive = false
        else
            gsrTimer = gsrTimer - 1
        end
    end
end


function Notify(string) 
    SetNotificationTextEntry("STRING") 
    AddTextComponentString('~y~[Sloth_GSR] ' .. string) 
    DrawNotification(false, true) 
end
