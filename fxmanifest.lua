fx_version 'cerulean'
author 'Floki'
description 'Queue system'
version '1.0.0'
game 'gta5'

shared_scripts {
    'config.lua',
    'shared/utils.lua'
}

server_scripts {
    'server/utils.lua',
    'server/libs/Match.lua',
    'server/libs/Queue.lua',
    'server/main.lua'
}

client_scripts {
    'client/utils.lua',
    'client/events/**.lua',
    'client/main.lua'
}
