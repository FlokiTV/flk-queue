QueueManager = Queue.new()

local function logClient(source, data)
    if tonumber(source) == 0 then
        print(data)
    else
        TriggerClientEvent('queue:log', source, data)
    end
end

RegisterCommand('queue', function(source, args, rawCommand)
    local userId = source == 0 and args[1] or source
    local userPed = GetPlayerPed(userId)
    logClient(source, 'userId: ' .. userId)
    logClient(source, 'userPed: ' .. userPed)
    if userPed == 0 then
        logClient(source, 'Invalid player ped')
        return
    end

    local nId = NetworkGetNetworkIdFromEntity(userPed)
    logClient(source, 'userNetId: ' .. nId)
    logClient(source, 'isPlayerInMatch: ' .. (Match.isPlayerInMatch(nId) and 'true' or 'false'))
    if Match.isPlayerInMatch(nId) then
        logClient(source, 'You are already in a match')
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
                    logClient(playerSource, 'You lose!')
                    match:stop()
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
                logClient(playerSource, 'You win!')
            end
            print('')
        end
    end
end)
