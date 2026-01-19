Match = {}
Match.__index = Match

local matches = {}
local playersMatch = {}

-- -1285.3945, -450.8088, 103.4655, 34.0079
-- -1305.8623, -418.2008, 103.4656, 215.3134
function Match.new(players)
    local self = setmetatable({}, Match)
    self.players = players
    self.matchId = #matches + 1
    self.playerData = {}
    table.insert(matches, self)
    print('Match created with id: ' .. self.matchId)
    for _, player in ipairs(self.players) do
        playersMatch[player] = self.matchId
        self:setPlayerData(player)
    end

    return self
end

function Match:endMatch()
    for _, player in ipairs(self.players) do
        self:resetPlayerData(player)
        playersMatch[player] = nil
    end
end

--- Returns the number of created matches
--- @return number
function Match:getMatchesCount()
    return #matches
end

--- Checks whether the player is in a match
--- @param playerId number
--- @return boolean
function Match.isPlayerInMatch(playerId)
    return playersMatch[playerId] ~= nil
end

--- Saves the player's data
--- @param playerId number
function Match:setPlayerData(playerId)
    self.playerData[playerId] = {}
    local playerPed = NetworkGetEntityFromNetworkId(playerId)

    local playerHealth = GetEntityHealth(playerPed)
    local playerArmor = GetPedArmour(playerPed)

    local playerCoords = GetEntityCoords(playerPed)
    local playerHeading = GetEntityHeading(playerPed)
    self.playerData[playerId] = {
        health = playerHealth,
        armour = playerArmor,
        coords = playerCoords,
        heading = playerHeading
    }
end

--- Restores the player's data
--- @param playerId number
function Match:resetPlayerData(playerId)
    local playerData = self.playerData[playerId]
    if playerData then
        local playerPed = NetworkGetEntityFromNetworkId(playerId)
        SetEntityHealth(playerPed, playerData.health)
        SetPedArmour(playerPed, playerData.armour)
        SetEntityCoords(playerPed, playerData.coords[1], playerData.coords[2], playerData.coords[3], true, false, false,
        false)
        SetEntityHeading(playerPed, playerData.heading)
    end
end
