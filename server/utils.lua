function Log(source, data)
    if tonumber(source) == 0 then
        print(data)
    else
        TriggerClientEvent('queue:log', source, data)
    end
end

function SourceFromNetId(playerNetId)
    local playerPed = NetworkGetEntityFromNetworkId(playerNetId)
    local playerSource = NetworkGetEntityOwner(playerPed)
    return playerSource
end
