Queue = {}
Queue.__index = Queue

--- Cria uma nova fila
--- @return Queue
function Queue.new()
    local self = setmetatable({}, Queue)

    -- ordem FIFO
    self.queue = {}

    -- lookup rápido
    self.inQueue = {}

    return self
end

---------------------------------------------------
-- MÉTODOS PÚBLICOS
---------------------------------------------------

--- Adiciona um jogador à fila
--- @param userId number
--- @return boolean, string
function Queue:add(userId)
    if self.inQueue[userId] then
        return false, 'O jogador já está na fila.'
    end

    table.insert(self.queue, userId)
    self.inQueue[userId] = true

    self:_tryCreateMatch()
    self:_syncStats()

    return true, 'Jogador adicionado à fila com sucesso.'
end

--- Remove um jogador da fila
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
    self:_syncStats()

    return true, 'Jogador removido da fila com sucesso.'
end

--- Verifica se o jogador está na fila
--- @param userId number
--- @return boolean
function Queue:isInQueue(userId)
    return self.inQueue[userId] == true
end

--- Retorna quantidade de jogadores na fila
--- @return number
function Queue:getQueueCount()
    return #self.queue
end

---------------------------------------------------
-- MÉTODOS INTERNOS (PRIVATE)
---------------------------------------------------

--- Tenta criar uma partida
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

    Match.create(players)
end

--- Sincroniza estatísticas com os clientes
function Queue:_syncStats()
    TriggerClientEvent(
        'match:receiveStats',
        -1,
        self:getQueueCount(),
        Match.getMatchesCount()
    )
end
