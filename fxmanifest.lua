fx_version 'cerulean'
game 'gta5'

author '.dough#0001'
description 'Namechanger Ui'
version '1.1.0'

shared_scripts {
    '@qb-core/import.lua', -- ENABLE / DISABLE IF YOU USE QB-CORE
    'shared/config.lua'
}

server_scripts {
	-- '@async/async.lua',
	-- '@mysql-async/lib/MySQL.lua',
    -- '@es_extended/locale.lua',
    'server/main.lua',
}

client_scripts {
    'client/main.lua',
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/app.js',
}