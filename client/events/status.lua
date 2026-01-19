StatusData = {
    queueCount = 0,
    matchesCount = 0,
    state = ''
}

RegisterNetEvent(Event('status'), function(status)
    StatusData.queueCount = status.queueCount
    StatusData.matchesCount = status.matchesCount
end)

RegisterNetEvent(Event('state'), function(state)
    StatusData.state = state.state
end)
