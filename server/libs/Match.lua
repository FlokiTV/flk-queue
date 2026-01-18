Match = {}
Match.__index = Match

function Match.new()
    local self = setmetatable({}, Match)
    print('Match created')
    return self
end
