local showStatus = false
local statusData = {
    queueCount = 0,
    matchesCount = 0
}

RegisterNetEvent('queue:fadeIn', function(time)
    DoScreenFadeIn(time)
end)

RegisterNetEvent('queue:fadeOut', function(time)
    DoScreenFadeOut(time)
end)

RegisterNetEvent('queue:status', function(status)
    statusData = status
end)

RegisterNetEvent('queue:health', function(health)
    Revive()
    Citizen.Wait(100)
    SetEntityHealth(PlayerPedId(), health)
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
                DrawTextCustom(0.01, 0.35, 'Queue: ' .. statusData.queueCount, 0.5,
                    { r = 255, g = 255, b = 255, a = 255 }, 4, false)
                DrawTextCustom(0.01, 0.38, 'Matches: ' .. statusData.matchesCount, 0.5,
                    { r = 255, g = 255, b = 255, a = 255 }, 4, false)
            end
        end)
    end
end, false)

RegisterCommand("givepistol", function(source, args, rawCommand)
    local myselfPed = PlayerPedId()
    GiveWeaponToPed(myselfPed, GetHashKey('WEAPON_PISTOL'), 100, false, true)
end, false)
