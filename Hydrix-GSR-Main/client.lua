local QBCore = exports['qb-core']:GetCoreObject()
local gsrTimer = 0
local gsrPositive = false
local plyPed = PlayerPedId()
local gsrTestDistance = 5
local Commands = {}


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