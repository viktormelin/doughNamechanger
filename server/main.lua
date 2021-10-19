if Config.ESX then 
    ESX = nil 
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
else
    local QBCore = exports['qb-core']:GetCoreObject()
end

local DiscordWebhook = 'https://discord.com/api/webhooks/899383511235055616/MUqdxMt3OCQbWGv3A_Kvoy-RhFQidIGr6Ewgrp9qoKkCXJyMKaomVlXVkm0VZB8Go9kA'

RegisterNetEvent('doughNamechanger:ChangeName')
AddEventHandler('doughNamechanger:ChangeName', function(firstname, lastname)
    if Config.ESX then 
        local xPlayer = ESX.GetPlayerFromId(source)
        local identifier = xPlayer.identifier
        if xPlayer.getAccount(Config.Account).money >= Config.Cost then 
            xPlayer.removeAccountMoney(Config.Account, Config.Cost)
            MySQL.Async.execute('UPDATE users SET firstname = ?, lastname = ? WHERE identifier = ?', {firstname, lastname, identifier}, function(rowsAffected)
                xPlayer.showNotification('Your name was changed into ' .. firstname .. ' ' .. lastname)
                
                if Config.EnableLogs then 
                    local Message = '[**' .. identifier .. ' **|** ' .. GetPlayerName(xPlayer.source) .. '**] changed their name to **' .. firstname .. ' ' .. lastname .. '**'
                    DC_DiscordLog('NAMECHANGE', Message)
                end
            end)
        else
            xPlayer.showNotification('You cannot afford this!')
        end
    else
        local xPlayer = QBCore.Functions.GetPlayer(source)
        local identifier = xPlayer.PlayerData.license
        local citizenid = xPlayer.PlayerData.citizenid
        local money = xPlayer.PlayerData.money[Config.Account]
        if money >= Config.Cost then 
            xPlayer.Functions.RemoveMoney(Config.Account, Config.Cost)
            exports.oxmysql:scalar('SELECT charinfo FROM players WHERE license = ? AND citizenid = ?', {identifier, citizenid}, function(result)
                local charinfo = json.decode(result)
                charinfo.firstname = firstname
                charinfo.lastname = lastname
                local updated = json.encode(charinfo)
                local affectedRows = exports.oxmysql:updateSync('UPDATE players SET charinfo = ? WHERE license = ? AND citizenid = ?', {updated, identifier, citizenid})
                TriggerClientEvent('QBCore:Notify', QBCore.Functions.GetSource(identifier), 'You changed your name into ' .. firstname .. ' ' .. lastname)
                if Config.EnableLogs then 
                    local Message = '[**' .. identifier .. ' **|** ' .. GetPlayerName(QBCore.Functions.GetSource(identifier)) .. '**] changed their name to **' .. firstname .. ' ' .. lastname .. '**'
                    DC_DiscordLog('NAMECHANGE', Message)
                end
            end)
        else
            TriggerClientEvent('QBCore:Notify', QBCore.Functions.GetSource(identifier), 'You cannot afford this!')
        end
    end
end)

if Config.ESX then 
    ESX.RegisterServerCallback('doughNamechanger:FetchName', function(playerId, callback)
        local xPlayer = ESX.GetPlayerFromId(playerId)
        local identifier = xPlayer.identifier
        MySQL.Async.fetchAll('SELECT firstname, lastname FROM users WHERE identifier = ?', {identifier}, function(result)
            callback(result[1].firstname, result[1].lastname)
        end)
    end)
else
    QBCore.Functions.CreateCallback('doughNamechanger:FetchName', function(playerId, callback)
        local xPlayer = QBCore.Functions.GetPlayer(playerId)
        local identifier = xPlayer.PlayerData.license
        local citizenid = xPlayer.PlayerData.citizenid
        exports.oxmysql:scalar('SELECT charinfo FROM players WHERE license = ? AND citizenid = ?', {identifier, citizenid}, function(result)
            callback(result)
        end)
    end)
end

DC_DiscordLog = function(title, message)
    local timestamp = os.date("%d-%m-%Y %I:%M %p")
    local embeds = {{
        ["color"] = 3447003,
        ["title"] = title,
        ["description"] = message,
        ["footer"] = {
            ["text"] = 'doughCore Discord Handler | ' .. timestamp
        },
    }}

    PerformHttpRequest(DiscordWebhook, function(err, text, headers) end, 'POST', json.encode({username = 'doughCore', embeds = embeds, avatar_url = 'https://dough.land/u/4ktS6gQNqt.png'}), { ['Content-Type'] = 'application/json' })
end