StatusData = {
    queueCount = 0,
    matchesCount = 0,
    state = ''
}

RegisterNetEvent('queue:status', function(status)
    StatusData.queueCount = status.queueCount
    StatusData.matchesCount = status.matchesCount
end)

RegisterNetEvent('queue:state', function(state)
    StatusData.state = state.state
end)
