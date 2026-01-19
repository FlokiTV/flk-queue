--- Draws a text on the screen
--- @param x number
--- @param y number
--- @param text string
--- @param scale number
--- @param color table
--- @param font number
--- @param center boolean
function DrawTextCustom(x, y, text, scale, color, font, center)
    -- Defaults
    scale  = scale or 0.35
    font   = font or 0
    color  = color or { r = 255, g = 255, b = 255, a = 255 }
    center = center or false

    SetTextFont(font)
    SetTextProportional(false)
    SetTextScale(scale, scale)
    SetTextColour(color.r, color.g, color.b, color.a)
    SetTextCentre(center)
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x, y)
end

--- Revives the player ped
function Revive()
    DoScreenFadeOut(200) -- 1000 ms = 1 second
    while not IsScreenFadedOut() do
        Citizen.Wait(0)
    end

    local pos = GetEntityCoords(PlayerPedId(), false)
    local ped = PlayerPedId()
    SetEntityCoordsNoOffset(
        PlayerPedId(),
        pos.x,
        pos.y,
        pos.z,
        false,
        false,
        false
    )
    NetworkResurrectLocalPlayer(pos.x, pos.y, pos.z, 0, 5000, true)
    ResurrectPed(ped)
    SetEntityHealth(ped, GetEntityMaxHealth(ped))
    ClearPedBloodDamage(ped)
    RestorePlayerStamina(PlayerId(), 100.0)
    SetCanAttackFriendly(ped, true, true)
    NetworkSetFriendlyFireOption(true)
    ShutdownLoadingScreen()
    FreezeEntityPosition(ped, false)
    Citizen.Wait(1000)
    DoScreenFadeIn(200)
end
