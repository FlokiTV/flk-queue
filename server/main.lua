QueueManager = Queue.new()

RegisterCommand('queue', function(source, args, rawCommand)
    local userId = source == 0 and args[1] or source
    local userPed = GetPlayerPed(userId)
    local nId = NetworkGetNetworkIdFromEntity(userPed)
    print('userId: ' .. nId)
    print('isPlayerInMatch: ' .. (Match.isPlayerInMatch(nId) and 'true' or 'false'))
    if Match.isPlayerInMatch(nId) then
        print('You are already in a match')
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
