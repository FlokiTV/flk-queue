Queue = {}
Queue.__index = Queue

--- Creates a new queue
--- @param cfg table
--- @return table
function Queue.new(cfg)
    local self = setmetatable({}, Queue)
    self.cfg = {}

    -- FIFO order
    self.queue = {}

    -- quick lookup
    self.inQueue = {}

    -- max players in match
    self.maxPlayers = cfg.maxPlayers or 2

    if cfg.onStart then
        self.cfg.onStart = cfg.onStart
    end

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
        'queue:status',
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
    if #self.queue < self.maxPlayers then
        return
    end

    local players = {}
    for i = 1, self.maxPlayers do
        table.insert(players, table.remove(self.queue, 1))
    end

    for _, player in ipairs(players) do
        self.inQueue[player] = nil
    end

    local cfg = {}

    if self.cfg.onStart then
        cfg.onStart = self.cfg.onStart
    end

    Match.new(players, cfg)
end
