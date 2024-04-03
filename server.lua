MySQL.Async.execute("CREATE TABLE IF NOT EXISTS `personal_vehicles` (`spawncode` VARCHAR(255) NOT NULL , PRIMARY KEY (`spawncode`)) ENGINE = InnoDB;", {})
MySQL.Async.execute("CREATE TABLE IF NOT EXISTS `personal_access` (`spawncode` VARCHAR(255) NOT NULL , `userid` VARCHAR(255) NOT NULL , `rank` VARCHAR(5) NOT NULL ) ENGINE = InnoDB;", {})

RegisterServerEvent("dptrust:accesslistcallback", function()
    TriggerClientEvent("dptrust:accesslistcallbackresponse", source, {{"djisadojd", "USR"}, {"sjaidhasiduw", "MGR"}, {"sodohrwghhoq", "ONR"}})
end)

RegisterServerEvent("dptrust:loaddatacallback", function()
    TriggerClientEvent("dptrust:loaddatacallbackresponse", source, {
        myvehicles = {"spanw", "cod", "scott", "dan", "garrett"},
        trustedpersonals = {{"test", "2142595123129839", "MGR"},{"test", "2142595123129839", "ADM"},{"test", "2142595123129839", "USR"}},
        admin = true
    })
end)

RegisterServerEvent("dptrust:addbydiscordid", function(data)
    local spawncode = data["spawncode"]
    local discord = data["discordid"]
end)

RegisterServerEvent("dptrust:addbyid", function(data)
    local spawncode = data["spawncode"]
    local id = data["id"]
end)

RegisterServerEvent("dptrust:deletepersonal", function(data)
    local spawncode = data["spawncode"]
end)

RegisterServerEvent("dptrust:setrank", function(data)
    local spawncode = data["spawncode"]
    local discord = data["discordid"]
    local rank = data["rank"]
end)

RegisterServerEvent("dptrust:removeaccess", function(data)
    local spawncode = data["spawncode"]
    local discord = data["discordid"]
end)

RegisterServerEvent("dptrust:createpersonalvehicle", function(data)
    local spawncode = data["spawncode"]
    local discord = data["discordid"]
end)

RegisterServerEvent("dptrust:setpersonalowner", function(data)
    local spawncode = data["spawncode"]
    local discord = data["discordid"]
end)

RegisterServerEvent("dptrust:deletepersonaladmin", function(data)
    local spawncode = data["spawncode"]
end)

RegisterServerEvent("dptrust:gainadminaccess", function(data)
    local spawncode = data["spawncode"]
end)

RegisterServerEvent("dptrust:loseadminaccess", function(data)
    local spawncode = data["spawncode"]
end)