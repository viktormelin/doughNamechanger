[![Discord][discord-shield]][discord-url]

## :pushpin: About this Script
![doughNamechanger-banner|512x256](https://dough.land/u/bor6xDKhil.png)

Simple Ui-based script for players to change name (firstname + lastname)

## :ledger: Requirements
* ESX (mysql-async) or QBCore (oxmysql)
* Do not change the name of the resource if you do not know how to edit the rest of the files

## :clipboard: Installation
1. Drag and Drop `doughNamechanger` into your resources folder
2. Add `ensure doughNamechanger` to your server.cfg

#### Change from QBCore to ESX
1. Script is by default set to use QBCore, if you wish to change it to use ESX edit `shared/config.lua` and set `Config.ESX = true`
2. Go into `fxmanifest.lua` and comment out the `@qb-core/import.lua` and uncomment the 3 files in `server_scripts {}`

#### Use BT-Target (https://forum.cfx.re/u/skellykat_gaming/summary)
1. Uncomment the lines in `fxmanifest.lua` that are marked
2. Change `Config.UseBTtarget = true`
3. Success! Should work now!

## :file_folder: Important Files
### config.lua
Easily add more locations and change cost
```sh
Config = {}

Config.ESX = false
Config.UseBTtarget = false

Config.Cost = 500
Config.Account = 'bank'
Config.EnableLogs = true

Config.EnableBlip = true
Config.BlipSprite = 480
Config.BlipColour = 17
Config.BlipScale = 0.65
Config.BlipLabel = 'Passport Agency'

Config.Locations = {
    vector3(299.6404, -579.6099, 43.2608)
}



-- If using BT-Target uncomment code below

-- Config.LocationNPC = {
--     x = 229.72,
--     y = -428.14,
--     z = 47.08,
--     heading = 341.33,
--     npcname = "cs_fbisuit_01",
--     npchash = 0x585C0B52,
-- }
```

### fxmanifest.lua
```sh
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
```



[discord-shield]: https://img.shields.io/badge/Discord-7289DA?style=for-the-badge&logo=discord&logoColor=white
[discord-url]: https://discord.gg/2MupXQMSWR
