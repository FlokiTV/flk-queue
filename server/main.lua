QueueManager = Queue.new({
    maxPlayers = 2,
    onStart = function(match)
        print('Match created with id: ' .. match.matchId)
        local player1 = match.players[1]
        local player2 = match.players[2]
        local player1Ped = NetworkGetEntityFromNetworkId(player1)
        local player1Source = NetworkGetEntityOwner(player1Ped)
        local player2Ped = NetworkGetEntityFromNetworkId(player2)
        local player2Source = NetworkGetEntityOwner(player2Ped)
        TriggerClientEvent('queue:fadeOut', player1Source, 500)
        TriggerClientEvent('queue:fadeOut', player2Source, 500)
        Citizen.Wait(500)
        SetPlayerRoutingBucket(tostring(player1Source), match.matchId)
        SetPlayerRoutingBucket(tostring(player2Source), match.matchId)
        Citizen.Wait(200)
        SetEntityCoords(player1Ped, -1285.3945, -450.8088, 103.4655, true, false, false, true)
        SetEntityCoords(player2Ped, -1305.8623, -418.2008, 103.4656, true, false, false, true)
        SetEntityHeading(player1Ped, 34.0079)
        SetEntityHeading(player2Ped, 215.3134)
        Citizen.Wait(500)
        TriggerClientEvent('queue:fadeIn', player1Source, 500)
        TriggerClientEvent('queue:fadeIn', player2Source, 500)
    end,
    onStop = function(match)
        print('Match ended with id: ' .. match.matchId)
    end,
    onTick = function(match)
        local players = match.players
        local loser = false
        for _, player in ipairs(players) do
            local playerPed = NetworkGetEntityFromNetworkId(player)
            local playerSource = NetworkGetEntityOwner(playerPed)
            local isDead = GetEntityHealth(playerPed) <= 101
            if isDead then
                loser = player
                TriggerClientEvent('queue:lose', playerSource)
            end
        end
        -- if loser, send message to winner
        if loser then
            local winner = players[1] == loser and players[2] or players[1]
            local playerPed = NetworkGetEntityFromNetworkId(winner)
            local playerSource = NetworkGetEntityOwner(playerPed)
            TriggerClientEvent('queue:win', playerSource)
            -- stop match if player is dead
            match:stop()
            QueueManager:syncStats()
        end
    end
})

RegisterCommand('queue', function(source, args, rawCommand)
    local userId = source == 0 and args[1] or source
    local userPed = GetPlayerPed(userId)
    if userPed == 0 then
        Log(source, 'Invalid player ped')
        return
    end

    local nId = NetworkGetNetworkIdFromEntity(userPed)
    if Match.isPlayerInMatch(nId) then
        Log(source, 'You are already in a match')
        return
    end

    if QueueManager:isInQueue(nId) then
        QueueManager:remove(nId)
    else
        QueueManager:add(nId)
    end
end, false)

RegisterCommand('bucket', function(source, args, rawCommand)
    local userId = source == 0 and args[1] or source
    local bucket = GetPlayerRoutingBucket(tostring(userId))
    Log(source, 'bucket: ' .. bucket)
end, false)
