Match = {}
Match.__index = Match

local matches = {}

function Match.new(players)
    local self = setmetatable({}, Match)
    self.players = players
    self.matchId = #matches + 1
    table.insert(matches, self)
    print('Match created')
    return self
end

--- Retorna quantidade de partidas criadas
--- @return number
function Match:getMatchesCount()
    return #matches
end