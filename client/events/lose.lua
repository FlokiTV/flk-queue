local showLoser = false

RegisterNetEvent(Event('lose'), function()
    showLoser = true
    SetTimeout(2500, function()
        showLoser = false
    end)
    Citizen.CreateThread(function()
        while showLoser do
            Citizen.Wait(5)
            DrawTextCustom(0.5, 0.4, 'YOU LOSE!', 3.0,
                { r = 255, g = 95, b = 95, a = 255 }, 4, true)
        end
    end)
end)
