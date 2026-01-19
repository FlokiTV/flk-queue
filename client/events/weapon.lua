RegisterNetEvent('queue:weapon', function(weapon)
    local myselfPed = PlayerPedId()
    GiveWeaponToPed(myselfPed, GetHashKey(weapon), 100, false, true)
end)
