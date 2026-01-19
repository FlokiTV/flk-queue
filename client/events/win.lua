local showWinner = false

RegisterNetEvent('queue:win', function()
    showWinner = true
    SetTimeout(5000, function()
        showWinner = false
    end)
    Citizen.CreateThread(function()
        while showWinner do
            Citizen.Wait(0)
            DrawTextCustom(0.5, 0.4, 'YOU WIN!', 3.0,
                { r = 95, g = 255, b = 156, a = 255 }, 4, true)
        end
    end)
end)
