QueueManager = Queue.new()

RegisterCommand('queue', function(source, args, rawCommand)
    local userId = source == 0 and args[1] or source

    print('userId: ' .. userId)
    print('isPlayerInMatch: ' .. (Match.isPlayerInMatch(userId) and 'true' or 'false'))
    if Match.isPlayerInMatch(userId) then
        print('You are already in a match')
        return
    end

    if QueueManager:isInQueue(userId) then
        QueueManager:remove(userId)
    else
        QueueManager:add(userId)
    end

    print('queueCount: ' .. QueueManager:getQueueCount())
    print('isInQueue: ' .. (QueueManager:isInQueue(userId) and 'true' or 'false'))
    print('matchesCount: ' .. Match:getMatchesCount())
end, false)
