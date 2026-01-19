QueueManager = Queue.new({
    maxPlayers = 2,
    onStart = function(match)
        print('Match created with id: ' .. match.matchId)
        Log(-1, 'Match started with players: ' .. table.concat(match.players, ', '))
        local player1 = match.players[1]
        local player2 = match.players[2]
        local player1Ped = NetworkGetEntityFromNetworkId(player1)
        local player2Ped = NetworkGetEntityFromNetworkId(player2)
        SetEntityCoords(player1Ped, -1285.3945, -450.8088, 103.4655, true, false, false, true)
        SetEntityCoords(player2Ped, -1305.8623, -418.2008, 103.4656, true, false, false, true)
        SetEntityHeading(player1Ped, 34.0079)
        SetEntityHeading(player2Ped, 215.3134)
    end,
})

RegisterCommand('queue', function(source, args, rawCommand)
    local userId = source == 0 and args[1] or source
    local userPed = GetPlayerPed(userId)
    Log(source, 'userId: ' .. userId)
    Log(source, 'userPed: ' .. userPed)
    if userPed == 0 then
        Log(source, 'Invalid player ped')
        return
    end

    local nId = NetworkGetNetworkIdFromEntity(userPed)
    Log(source, 'userNetId: ' .. nId)
    Log(source, 'isPlayerInMatch: ' .. (Match.isPlayerInMatch(nId) and 'true' or 'false'))
    if Match.isPlayerInMatch(nId) then
        Log(source, 'You are already in a match')
        return
    end

    if QueueManager:isInQueue(nId) then
        QueueManager:remove(nId)
    else
        QueueManager:add(nId)
    end

    print('queueCount: ' .. QueueManager:getQueueCount())
    print('isInQueue: ' .. (QueueManager:isInQueue(nId) and 'true' or 'false'))
    print('matchesCount: ' .. Match:getMatchesCount())
end, false)

CreateThread(function()
    while true do
        Citizen.Wait(200)
        local runningMatches = Match:getRunningMatches()

        for _, match in ipairs(runningMatches) do
            local players = match.players
            local loser = false
            for _, player in ipairs(players) do
                local playerPed = NetworkGetEntityFromNetworkId(player)
                local playerSource = NetworkGetEntityOwner(playerPed)
                local isDead = GetEntityHealth(playerPed) <= 101
                -- stop match if player is dead
                if isDead then
                    loser = player
                    Log(playerSource, 'You lose!')
                    match:stop()
                    QueueManager:syncStats()
                end
            end
            -- if loser, send message to winner
            if loser then
                local winner = players[1] == loser and players[2] or players[1]
                local playerPed = NetworkGetEntityFromNetworkId(winner)
                local playerSource = NetworkGetEntityOwner(playerPed)
                print('Match ended ' .. match.matchId)
                print('loser: ' .. loser)
                print('winner: ' .. winner)
                print('')
                Log(playerSource, 'You win!')
            end
        end
    end
end)
