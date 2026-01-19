local showStatus = false

RegisterCommand('status', function()
    if showStatus then
        showStatus = false
    else
        showStatus = true
        Citizen.CreateThread(function()
            while showStatus do
                Citizen.Wait(5)
                DrawTextCustom(0.01, 0.35, 'Queue: ' .. StatusData.queueCount, 0.5,
                    { r = 255, g = 255, b = 255, a = 255 }, 4, false)
                DrawTextCustom(0.01, 0.38, 'Matches: ' .. StatusData.matchesCount, 0.5,
                    { r = 255, g = 255, b = 255, a = 255 }, 4, false)
            end
        end)
    end
end, false)