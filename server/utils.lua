function Log(source, data)
    if tonumber(source) == 0 then
        print(data)
    else
        TriggerClientEvent('queue:log', source, data)
    end
end
