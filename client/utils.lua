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
