local showStatus = false
local statusData = {
    queueCount = 0,
    matchesCount = 0
}

RegisterNetEvent('match:status', function(status)
    print('Queue count: ' .. status.queueCount)
    print('Matches count: ' .. status.matchesCount)
    statusData = status
end)

RegisterNetEvent('queue:log', function(data)
    print('[QUEUE]', data)
end)

RegisterCommand('status', function()
    if showStatus then
        showStatus = false
    else
        showStatus = true
        Citizen.CreateThread(function()
            while showStatus do
                Citizen.Wait(5)
                DrawTextCustom(0.01, 0.35, 'Queue count: \t' .. statusData.queueCount)
                DrawTextCustom(0.01, 0.37, 'Matches count: \t' .. statusData.matchesCount)
            end
        end)
    end
end, false)
