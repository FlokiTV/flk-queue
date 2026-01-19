Config = {}

Config.eventPrefix = 'queue' -- Prefix for events
Config.matchTickMs = 200     -- Tick interval for matches in milliseconds
Config.maxPlayers = 2        -- Maximum number of players per match
Config.bucketOffset = 1000   -- Offset for bucket IDs

-- Spawns for matches
Config.spawns = {
    { coords = vector3(-1285.3945, -450.8088, 103.4655), heading = 34.0079 },
    { coords = vector3(-1305.8623, -418.2008, 103.4656), heading = 215.3134 }
}
