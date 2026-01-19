# Queue System

[Ler em Português](README.pt-br.md)

This resource provides a simple queue and match management system for FiveM.

## How it Works


https://github.com/user-attachments/assets/cd9243d5-4d9e-42f7-b7c0-73af733f89d2


### Queue

- Players can join or leave the queue using the `/queue` command.
- The system manages players in a list, waiting for enough participants to start a match.
- When a player enters the queue, the system checks if there are enough players to create a new match.

### Match Management

- When a match starts, players are teleported to a predefined location and their routing bucket is set to isolate the match.
- The system continuously monitors the health of the players in the match.
- If a player's health drops to a critical level (is considered dead), they are declared the loser.
- The other player is declared the winner, and the match ends.
- After the match, players are returned from the isolated bucket.
- The system then updates the general statistics (`queueCount` and `matchesCount`).

## Commands

- `/queue`: Joins or leaves the queue.
- `/status`: Shows the current number of players in the queue and active matches.
- `/bucket`: (Debug) Shows the player's current routing bucket.

## Technical Decisions

### `Event` Function

In `shared/utils.lua`, the `Event(name)` function is used to standardize event names by adding a prefix (`Config.eventPrefix`).

**Reasoning:**

- **Avoids Conflicts:** It prevents event name collisions with other resources on the server. By using a unique prefix (e.g., `flk-queue:`), we ensure our events are unique.
- **Maintainability:** If we need to change the event prefix for any reason, we only need to modify it in one place (`Config.eventPrefix`), and it will be updated across the entire resource.
- **Readability:** It makes the code cleaner and more readable, as it's clear which events belong to this resource.

### `Queue.lua` Architecture

The `server/libs/Queue.lua` file is designed as a class using metatables to provide an object-oriented structure.

**Data Structures:**

- `self.queue` (table as a list): A table used as a FIFO (First-In, First-Out) list to maintain the order of players who join the queue. This ensures fairness, as players who join first will be the first to enter a match.
- `self.inQueue` (table as a hash map): A table used for quick lookups (O(1) complexity on average) to check if a player is already in the queue. This is much more efficient than iterating through the `self.queue` list every time a check is needed.

**Key Methods:**

- `Queue:add(userId)`: Adds a player to both `self.queue` and `self.inQueue`. After adding, it calls `_tryCreateMatch()` to check if a new match can be started.
- `Queue:remove(userId)`: Removes a player from both data structures.
- `Queue:_tryCreateMatch()`: A private method that checks if there are enough players in the queue to meet `self.maxPlayers`. If so, it removes the required number of players from the front of the queue and creates a new match with them.

### `Match.lua` Architecture

The `server/libs/Match.lua` file is also designed as a class and is responsible for managing the lifecycle of a single match.

**Global Management:**

- `matches` (table): A global list that holds all active match instances.
- `playersMatch` (table): A global hash map for quick lookups to find the `matchId` a player is in. This allows for efficient checks (e.g., `isPlayerInMatch`).
- A global `CreateThread` runs a continuous loop, calling the `tick()` method on every active match. This allows each match to have its own logic running periodically (e.g., checking player health).

**Match Lifecycle:**

- `Match.new(players, cfg)`: Creates a new match instance. It assigns a unique `matchId`, saves the original state of each player (`setPlayerData`), and moves them to an isolated routing bucket (`Config.bucketOffset + self.matchId`) to prevent interference from other players on the server.
- `Match:stop()`: Ends the match. It removes the match from the global `matches` list, and most importantly, restores the players' original state (`resetPlayerData`), including their health, armor, coordinates, and original routing bucket.
- `Match:setPlayerData(playerId)` / `Match:resetPlayerData(playerId)`: These methods are crucial for ensuring a non-disruptive experience. They save a player's state before the match starts and restore it after the match ends, making the transition seamless.

## Future Improvements

This resource has a solid foundation, but there are many opportunities for expansion:

- **Multiple Queue Types:** Implement a system to manage different queues, each with its own set of rules, such as:
  - Different game modes (e.g., 1v1, 2v2, 5v5, capture the flag).
  - Different maps or locations for matches.
  - Specific weapon loadouts.

- **NUI Interface:** Create a user-friendly NUI (web-based UI) to:
  - List all available queues and their current player counts.
  - Allow players to join or leave queues with a button click.
  - Display match statistics and leaderboards.

- **Password-Protected Queues:** Add the ability to create private queues protected by a password, allowing players to organize private matches with friends.

- **Rating/MMR System:** Implement an ELO or MMR (Matchmaking Rating) system to create more balanced matches based on player skill.

- **Spectator Mode:** Allow players to spectate ongoing matches.
