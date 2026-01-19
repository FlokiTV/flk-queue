QueueManager = Queue.new()

RegisterCommand('queue', function(source, args, rawCommand)
    local userId = source

    if QueueManager:isInQueue(userId) then
        QueueManager:remove(userId)
    else
        QueueManager:add(userId)
    end

    print(QueueManager:getQueueCount())
    print(QueueManager:isInQueue(userId))
end, false)
