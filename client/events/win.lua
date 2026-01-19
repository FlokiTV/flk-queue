local showWinner = false

RegisterNetEvent(Event('win'), function()
    showWinner = true
    SetTimeout(2500, function()
        showWinner = false
    end)
    Citizen.CreateThread(function()
        while showWinner do
            Citizen.Wait(5)
            DrawTextCustom(0.5, 0.4, 'YOU WIN!', 3.0,
                { r = 95, g = 255, b = 156, a = 255 }, 4, true)
        end
    end)
end)
