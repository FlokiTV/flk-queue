StatusData = {
    queueCount = 0,
    matchesCount = 0
}

RegisterNetEvent('queue:status', function(status)
    StatusData = status
end)
