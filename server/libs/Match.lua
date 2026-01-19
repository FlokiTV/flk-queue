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
    table.insert(matches, self)
    print('Match created with id: ' .. self.matchId)
    for _, player in ipairs(self.players) do
        playersMatch[player] = self.matchId
    end

    return self
end

--- Retorna quantidade de partidas criadas
--- @return number
function Match:getMatchesCount()
    return #matches
end

--- Verifica se o jogador está na partida
--- @param playerId number
--- @return boolean
function Match.isPlayerInMatch(playerId)
    return playersMatch[playerId] ~= nil
end