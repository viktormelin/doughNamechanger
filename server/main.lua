ESX = nil 
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local DiscordWebhook = ''

RegisterNetEvent('doughNamechanger:ChangeName')
AddEventHandler('doughNamechanger:ChangeName', function(firstname, lastname)
    local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = xPlayer.identifier
    if Config.Cost > 0 then 
        if xPlayer.getAccount(Config.Account).money >= Config.Cost then 
            xPlayer.removeAccountMoney(Config.Account, Config.Cost)
            MySQL.Async.execute('UPDATE users SET firstname = ?, lastname = ? WHERE identifier = ?', {firstname, lastname, identifier}, function(rowsAffected)
                xPlayer.showNotification('Your name was changed into ' .. firstname .. ' ' .. lastname)
                
                if Config.EnableLogs then 
                    local Message = '[**' .. identifier .. ' **|** ' .. GetPlayerName(xPlayer.source) .. '**] changed their name to **' .. firstname .. ' ' .. lastname .. '**'
                    DC_DiscordLog('NAMECHANGE', Message)
                end
            end)
        end
    end
end)

ESX.RegisterServerCallback('doughNamechanger:FetchName', function(playerId, callback)
    local xPlayer = ESX.GetPlayerFromId(playerId)
    local identifier = xPlayer.identifier
    MySQL.Async.fetchAll('SELECT firstname, lastname FROM users WHERE identifier = ?', {identifier}, function(result)
        callback(result[1].firstname, result[1].lastname)
    end)
end)

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