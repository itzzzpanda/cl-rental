fx_version 'bodacious'
game 'gta5'
lua54 'yes'

name 'cl-rental'
description 'Simple rent menu with UI inspired by Nopixel 4.0'
version '1.0.0'

ox_lib 'locale'

shared_script '@ox_lib/init.lua'

client_scripts {
    'client/editable.lua',
    'client/main.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua',
    'server/editable.lua'
}

ui_page "web/build/index.html"

escrow_ignore {
    'config.lua',
    'locales/*.json',
    'server/*.lua',
    'client/*.lua',
}

files {
    'locales/*.json',
    'config.lua',
    'web/build/**/*',
    "web/build/index.html"
}


dependency 'ox_lib'
dependency '/assetpacks'