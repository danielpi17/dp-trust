fx_version "cerulean"
game "gta5"

author "Daniel Pi"
description "FiveM Personal System"
version "0.1"

shared_scripts {
    "config.lua"
}

client_scripts {
    "client.lua"
}

server_scripts {
    "@oxmysql/lib/MySQL.lua",
    "server.lua"
}

ui_page "ui/ui.html"

files {
    "ui/ui.html",
    "ui/style.css",
    "ui/js/data.js",
    "ui/js/events.js",
    "ui/js/pages.js",
    "ui/js/updater.js"
}