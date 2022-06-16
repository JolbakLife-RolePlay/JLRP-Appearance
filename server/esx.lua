local Framework = GetResourceState('JLRP-Framework'):find('start') and exports['JLRP-Framework']:GetFrameworkObjects()
if not Framework then return end

Framework = {
    GetPlayerFromId = Framework.GetPlayerFromId,
    GetExtendedPlayers = Framework.GetExtendedPlayers,
    RegisterServerCallback = Framework.RegisterServerCallback,
}

do
    local xPlayers = Framework.GetExtendedPlayers()

    for i = 1, #xPlayers do
        local xPlayer = xPlayers[i]
        Players[xPlayer.source] = xPlayer.citizenid
        TriggerClientEvent('ox_appearance:outfitNames', xPlayer.source, OutfitNames(xPlayer.citizenid))
    end
end

AddEventHandler('JLRP-Framework:playerLoaded', function(playerId, xPlayer)
    Players[playerId] = xPlayer.citizenid
    TriggerClientEvent('ox_appearance:outfitNames', playerId, OutfitNames(xPlayer.identifier))
end)

RegisterNetEvent('esx_skin:save', function(appearance)
    local citizenid = Players[source]
    MySQL.update('UPDATE users SET skin = ? WHERE citizenid = ?', { json.encode(appearance), citizenid })
end)

Framework.RegisterServerCallback('esx_skin:getPlayerSkin', function(source, cb)
    local xPlayer = Framework.GetPlayerFromId(source)
    local citizenid = Players[source]
    local appearance = MySQL.scalar.await('SELECT skin FROM users WHERE citizenid = ?', { citizenid })
    local jobSkin = {
        skin_male   = xPlayer.job.skin_male,
        skin_female = xPlayer.job.skin_female
    }

    cb(appearance ~= nil and json.decode(appearance) or nil, jobSkin)
end)
