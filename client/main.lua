if Config.ESX then 
    ESX = nil
    Citizen.CreateThread(function()
        while ESX == nil do
            TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
            Citizen.Wait(0)
        end

        while ESX.GetPlayerData().job == nil do
            Citizen.Wait(10)
        end
    end)

    RegisterNetEvent('esx:playerLoaded')
    AddEventHandler('esx:playerLoaded', function (xPlayer)
        ESX.PlayerData = xPlayer
    end)
else
    local QBCore = exports['qb-core']:GetCoreObject()
    local PlayerData = {}

    AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
        PlayerData = QBCore.Functions.GetPlayerData()
    end)
end



Citizen.CreateThread(function()
    if Config.EnableBlip then 
        for i=1, #Config.Locations, 1 do 
            local blip = AddBlipForCoord(Config.Locations[i])
            SetBlipSprite(blip, Config.BlipSprite)
            SetBlipDisplay(blip, 4)
            SetBlipScale(blip, Config.BlipScale)
            SetBlipColour(blip, Config.BlipColour)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName('STRING')
            AddTextComponentSubstringPlayerName(Config.BlipLabel)
            EndTextCommandSetBlipName(blip)
        end
    end
end)

Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(0)
        local letSleep = true
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        for i=1, #Config.Locations, 1 do 
            local distance = #(coords - Config.Locations[i])
            if distance < 7 then 
                letSleep = false
                DrawMarker(2, Config.Locations[i].x, Config.Locations[i].y, Config.Locations[i].z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 255, 255, 255, 222, false, false, false, true, false, false, false)
                if distance < 2.5 then 
                    Draw3DText(Config.Locations[i].x, Config.Locations[i].y, Config.Locations[i].z + 0.25, '~g~[E]~w~ - Open Namechanger')
                    if IsControlJustReleased(0, 38) then 
                        OpenNameChanger()
                    end
                end
            end
        end
        if letSleep then 
            Citizen.Wait(1000)
        end
    end
end)

OpenNameChanger = function()
    if Config.ESX then 
        ESX.TriggerServerCallback('doughNamechanger:FetchName', function(firstname, lastname)
            SetTimecycleModifier('hud_def_blur')
            SetNuiFocus(true, true)
            SendNUIMessage({
                display = true,
                firstname = firstname,
                lastname = lastname,
            })
        end)
    else
        QBCore.Functions.TriggerCallback('doughNamechanger:FetchName', function(result)
            local result = json.decode(result)
            local firstname = result.firstname
            local lastname = result.lastname
            SetTimecycleModifier('hud_def_blur')
            SetNuiFocus(true, true)
            SendNUIMessage({
                display = true,
                firstname = firstname,
                lastname = lastname,
            })
        end)
    end
end

RegisterNUICallback('ChangeName', function(data)
    local firstname = tostring(data.firstname)
    local lastname = tostring(data.lastname)
    if firstname and lastname then 
        TriggerServerEvent('doughNamechanger:ChangeName', firstname, lastname)
    else
        if Config.ESX then 
            ESX.ShowNotification('There was a error with your inputed values')
        else
            TriggerEvent('QBCore:Notify', 'There was a error with your inputed values')
        end
    end
end)

RegisterNUICallback('CloseDisplay', function(data)
    SetNuiFocus(false, false)
    SetTimecycleModifier('default')
end)

Draw3DText = function(x, y, z, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end