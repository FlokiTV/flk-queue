Queue = {}
Queue.__index = Queue

--- Creates a new queue
--- @return table
function Queue.new()
    local self = setmetatable({}, Queue)

    -- FIFO order
    self.queue = {}

    -- quick lookup
    self.inQueue = {}

    return self
end

---------------------------------------------------
-- PUBLIC METHODS
---------------------------------------------------

--- Adds a player to the queue
--- @param userId number
--- @return boolean, string
function Queue:add(userId)
    if self.inQueue[userId] then
        return false, 'O jogador já está na fila.'
    end

    table.insert(self.queue, userId)
    self.inQueue[userId] = true

    self:_tryCreateMatch()
    self:syncStats()

    return true, 'Jogador adicionado à fila com sucesso.'
end

--- Removes a player from the queue
--- @param userId number
--- @return boolean, string
function Queue:remove(userId)
    if not self.inQueue[userId] then
        return false, 'O jogador não está na fila.'
    end

    for i = 1, #self.queue do
        if self.queue[i] == userId then
            table.remove(self.queue, i)
            break
        end
    end

    self.inQueue[userId] = nil
    self:syncStats()

    return true, 'Jogador removido da fila com sucesso.'
end

--- Checks whether the player is in the queue
--- @param userId number
--- @return boolean
function Queue:isInQueue(userId)
    return self.inQueue[userId] == true
end

--- Returns the number of players in the queue
--- @return number
function Queue:getQueueCount()
    return #self.queue
end

--- Syncs stats with clients
function Queue:syncStats()
    TriggerClientEvent(
        'match:status',
        -1,
        {
            queueCount = self:getQueueCount(),
            matchesCount = Match:getMatchesCount()
        }
    )
end
---------------------------------------------------
-- INTERNAL METHODS (PRIVATE)
---------------------------------------------------

--- Tries to create a match
function Queue:_tryCreateMatch()
    if #self.queue < 2 then
        return
    end

    local players = {
        table.remove(self.queue, 1),
        table.remove(self.queue, 1)
    }

    self.inQueue[players[1]] = nil
    self.inQueue[players[2]] = nil

    Match.new(players)
end
