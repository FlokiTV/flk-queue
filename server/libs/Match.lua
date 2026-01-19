Match = {}
Match.__index = Match

local matches = {}
local matchId = 0
local playersMatch = {}

function Match.new(players, cfg)
    local self = setmetatable({}, Match)
    self.players = players
    matchId = matchId + 1
    self.matchId = matchId
    self.playerData = {}
    if cfg.onStart then
        self.onStart = cfg.onStart
    end
    table.insert(matches, self)

    for _, player in ipairs(self.players) do
        playersMatch[player] = self.matchId
        self:setPlayerData(player)
    end
    if self.onStart then
        self.onStart(self)
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
    local playerSource = NetworkGetEntityOwner(playerPed)

    local playerHealth = GetEntityHealth(playerPed)
    local playerArmor = GetPedArmour(playerPed)

    local playerCoords = GetEntityCoords(playerPed)
    local playerHeading = GetEntityHeading(playerPed)
    local playerBucket = GetPlayerRoutingBucket(tostring(playerSource))

    self.playerData[playerId] = {
        health = playerHealth,
        armour = playerArmor,
        coords = playerCoords,
        heading = playerHeading,
        bucket = playerBucket
    }
end

--- Restores the player's data
--- @param playerId number
function Match:resetPlayerData(playerId)
    local playerData = self.playerData[playerId]
    local playerPed = NetworkGetEntityFromNetworkId(playerId)
    local playerSource = NetworkGetEntityOwner(playerPed)
    if playerData == nil then return end
    TriggerClientEvent('queue:health', playerSource, playerData.health)
    -- Set player bucket
    SetPlayerRoutingBucket(tostring(playerSource), playerData.bucket)
    Citizen.Wait(1000)
    SetPedArmour(playerPed, playerData.armour)
    SetEntityCoords(playerPed, playerData.coords[1], playerData.coords[2], playerData.coords[3], true, false, false,
        true)
    SetEntityHeading(playerPed, playerData.heading)
end
