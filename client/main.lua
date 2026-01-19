RegisterNetEvent('match:status', function(status)
    print('Queue count: ' .. status.queueCount)
    print('Matches count: ' .. status.matchesCount)
end)

RegisterNetEvent('queue:log', function(data)
    print('[QUEUE]', data)
end)