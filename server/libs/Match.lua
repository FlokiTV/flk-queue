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

--- Stops the match and restores the player's data
function Match:stop()
    for _, player in ipairs(self.players) do
        self:resetPlayerData(player)
        playersMatch[player] = nil
    end
    -- remove on matches table
    for i, match in ipairs(matches) do
        if match.matchId == self.matchId then
            table.remove(matches, i)
            break
        end
    end
end

--- Returns the players in the match
--- @return table
function Match.getPlayersInMatch()
    local players = {}
    for player, matchId in pairs(playersMatch) do
        if matchId ~= nil then
            table.insert(players, {
                playerId = player,
                matchId = matchId
            })
        end
    end
    return players
end

--- Returns the running matches
--- @return table
function Match:getRunningMatches()
    local runningMatches = {}
    for _, match in ipairs(matches) do
        if match.players then
            table.insert(runningMatches, match)
        end
    end
    return runningMatches
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
    local playerPed = NetworkGetEntityFromNetworkId(playerId)
    local playerSource = NetworkGetEntityOwner(playerPed)
    if playerData == nil then return end

    TriggerClientEvent('match:health', playerSource, playerData.health)
    Wait(200)
    SetPedArmour(playerPed, playerData.armour)
    SetEntityCoords(playerPed, playerData.coords[1], playerData.coords[2], playerData.coords[3], true, false, false,
        true)
    SetEntityHeading(playerPed, playerData.heading)
end
