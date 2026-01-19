QueueManager = Queue.new({
    maxPlayers = 2,
    onStart = function(match)
        print('Match created with id: ' .. match.matchId)

        local spawns = {
            { coords = vector3(-1285.3945, -450.8088, 103.4655), heading = 34.0079 },
            { coords = vector3(-1305.8623, -418.2008, 103.4656), heading = 215.3134 }
        }

        for _, playerNetId in ipairs(match.players) do
            local playerSource = SourceFromNetId(playerNetId)
            TriggerClientEvent('queue:fadeOut', playerSource, 500)
        end

        Citizen.Wait(500)

        for i, playerNetId in ipairs(match.players) do
            local playerPed = NetworkGetEntityFromNetworkId(playerNetId)
            local playerSource = SourceFromNetId(playerNetId)
            local spawn = spawns[i]

            SetPlayerRoutingBucket(tostring(playerSource), match.matchId)
            TriggerClientEvent('queue:health', playerSource, 200)
            Citizen.Wait(200)
            SetEntityCoords(playerPed, spawn.coords.x, spawn.coords.y, spawn.coords.z, true, false, false, true)
            SetEntityHeading(playerPed, spawn.heading)
            TriggerClientEvent('queue:weapon', playerSource, 'WEAPON_PISTOL')
        end

        Citizen.Wait(500)

        for _, playerNetId in ipairs(match.players) do
            local playerSource = SourceFromNetId(playerNetId)
            TriggerClientEvent('queue:fadeIn', playerSource, 500)
        end
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
