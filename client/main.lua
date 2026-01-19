RegisterNetEvent('match:status', function(status)
    print('Queue count: ' .. status.queueCount)
    print('Matches count: ' .. status.matchesCount)
end)
