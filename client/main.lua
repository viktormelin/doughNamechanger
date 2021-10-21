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


if not Config.UseBTtarget then 
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
end

if Config.UseBTtarget then 
    local coordonate = {
        {Config.LocationNPC.x,Config.LocationNPC.y,Config.LocationNPC.z,"",Config.LocationNPC.heading,Config.LocationNPC.npchash,Config.LocationNPC.npcname},
      }
    Citizen.CreateThread(function()
    
        for _,v in pairs(coordonate) do
          RequestModel(GetHashKey(v[7]))
          while not HasModelLoaded(GetHashKey(v[7])) do
            Wait(1)
          end
      
          RequestAnimDict("mini@strip_club@idles@bouncer@base")
          while not HasAnimDictLoaded("mini@strip_club@idles@bouncer@base") do
            Wait(1)
          end
          ped =  CreatePed(4, v[6],v[1],v[2],v[3], 3374176, false, true)
          SetEntityHeading(ped, v[5])
          FreezeEntityPosition(ped, true)
          SetEntityInvincible(ped, true)
          SetBlockingOfNonTemporaryEvents(ped, true)
          TaskPlayAnim(ped,"mini@strip_club@idles@bouncer@base","base", 8.0, 0.0, -1, 1, 0, 0, 0, 0)
        end
      end)
    local NPC = {
        `cs_fbisuit_01`, -- Will have to be placed from config bt-target wont register if you put Config.LocationNPC.npcname in the ``.
    }
    
    exports['bt-target']:AddTargetModel(NPC, {
        options = {
            {
               
                event = "doughNameChanger:OpenNameChanger",
                icon = 'fas fa-dollar-sign',
                label = 'Change Name',
            },
        },
        job = {'all'},
        distance = 2.5
    })
    
    RegisterNetEvent("doughNameChanger:OpenNameChanger")
    AddEventHandler("doughNameChanger:OpenNameChanger", function()
        OpenNameChanger()
    end)
end

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