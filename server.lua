restrictedVehicles = {}

-- refresh from time to time server and client

MySQL.Async.execute("CREATE TABLE IF NOT EXISTS `personal_vehicles` (`spawncode` VARCHAR(255) NOT NULL , PRIMARY KEY (`spawncode`)) ENGINE = InnoDB;", {})
MySQL.Async.execute("CREATE TABLE IF NOT EXISTS `personal_access` (`spawncode` VARCHAR(255) NOT NULL , `userid` VARCHAR(255) NOT NULL , `rank` VARCHAR(5) NOT NULL ) ENGINE = InnoDB;", {})

function registerVehicleOwner(spawncode)
    MySQL.Async.fetchAll("SELECT * FROM `personal_access` WHERE spawncode = @spawncode AND rank = 'ONR'", {["@spawncode"] = spawncode}, function(result2)
        if next(result2) == nil then
            restrictedVehicles[GetHashKey(spawncode)] = {spawncode, "N/A"}
        else
            restrictedVehicles[GetHashKey(spawncode)] = {spawncode, result2[1]["userid"]}
        end
    end)
end

RegisterServerEvent("dptrust:allowedtouse", function(hash)
    local src = source
    if restrictedVehicles[hash] ~= nil then
        discord = getUserDiscordId(src)
        local function cb(rank)
            if rank ~= "N/A" then
                TriggerClientEvent("dptrust:allowedtousecb", src, hash, true)
            else
                TriggerClientEvent("dptrust:allowedtousecb", src, hash, false)
            end
        end
        getUserVehicleRank(restrictedVehicles[hash][1], discord, cb)
    end
end)

Citizen.CreateThread(function()
    while true do
        restrictedVehicles = {}
        MySQL.Async.fetchAll("SELECT * FROM `personal_vehicles`", {}, function(result)
            for k,v in pairs(result) do
                registerVehicleOwner(v["spawncode"])
            end
        end)
        Citizen.Wait(1000*60*Config.serverThreshold)
    end
end)

function addVehicleRestricted(spawncode)
    registerVehicleOwner(spawncode)
end

function removeVehicleRestricted(spawncode)
    if restrictedVehicles[GetHashKey(spawncode)] ~= nil then
        restrictedVehicles[GetHashKey(spawncode)] = nil
    end
end

function getInGameUserByDiscordId(id)
    for a, g in pairs(GetPlayers()) do
        for d, b in pairs(GetPlayerIdentifiers(g)) do
            if string.find(b, "discord:") then
                if string.gsub(b, "discord:", "") == id then
                    return g
                end
            end
        end
    end
    return 0
end

function uncacheUser(src, spawncode)
    if src ~= 0 then
        TriggerClientEvent("dptrust:resetvehiclecache", src, spawncode)
    end
end

function getUserDiscordId(src)
    for k,v in pairs(GetPlayerIdentifiers(src)) do
        if string.find(v, "^discord:") then
            return string.gsub(v, "discord:", "")
        end
    end
end

function getUserVehicleRank(spawncode, discordid, cb)
    MySQL.Async.fetchAll("SELECT * FROM `personal_access` WHERE userid = @id AND spawncode = @spawncode", {["@id"] = discordid, ["@spawncode"] = spawncode}, function(result)
        if next(result) == nil then
            cb("N/A")
        else
            cb(result[1]["rank"])
        end
    end)
end

function userCanEditVehicle(spawncode, src, cb)
    if IsPlayerAceAllowed(src, Config.adminPermission) then
        cb(true)
    else
        MySQL.Async.fetchAll("SELECT * FROM `personal_access` WHERE userid = @id AND spawncode = @spawncode", {["@id"] = getUserDiscordId(src), ["@spawncode"] = spawncode}, function(result)
            if next(result) == nil then
                cb(false)
            else
                cb(result[1]["rank"] == "MGR" or result[1]["rank"] == "ONR")
            end
        end)
    end
end

function isVehicle(spawncode, cb)
    MySQL.Async.fetchAll("SELECT * FROM `personal_vehicles` WHERE spawncode = @spawncode", {["@spawncode"] = spawncode}, function(result)
        cb(next(result) ~= nil)
    end)
end

function doesUserHaveAccessToVehicle(spawncode, discord, cb)
    MySQL.Async.fetchAll("SELECT * FROM `personal_access` WHERE spawncode = @spawncode AND userid = @userid", {["@spawncode"] = spawncode, ["@userid"] = discord}, function(result)
        cb(next(result) ~= nil)
    end)
end

RegisterServerEvent("dptrust:accesslistcallback", function(spawncode)
    local src = source
    userCanEditVehicle(spawncode, source, function(access)
        if access then
            MySQL.Async.fetchAll("SELECT * FROM `personal_access` WHERE spawncode = @spawncode", {["@spawncode"] = spawncode}, function(result)
                tempList = {}
                for k,v in pairs(result) do
                    table.insert(tempList, {v["userid"], v["rank"]})
                end
                TriggerClientEvent("dptrust:accesslistcallbackresponse", src, tempList)
            end)
        else
            TriggerClientEvent("dptrust:accesslistcallbackresponse", src, {})
        end
    end)
end)

RegisterServerEvent("dptrust:loaddatacallback", function()
    local src = source
    MySQL.Async.fetchAll("SELECT * FROM `personal_access` WHERE userid = @userid", {["@userid"] = getUserDiscordId(src)}, function(result)
        myVehicles = {}
        trustedPersonals = {}
        admin = IsPlayerAceAllowed(src, Config.adminPermission)

        for k, v in pairs(result) do            
            if v["rank"] == "ONR" then
                table.insert(myVehicles, v["spawncode"])
            else
                table.insert(trustedPersonals, {v["spawncode"], restrictedVehicles[GetHashKey(v["spawncode"])][2], v["rank"]})
            end
        end

        TriggerClientEvent("dptrust:loaddatacallbackresponse", src, {
            myvehicles = myVehicles,
            trustedpersonals = trustedPersonals,
            admin = admin
        })
    end)
end)

RegisterServerEvent("dptrust:addbydiscordid", function(data)
    local spawncode = data["spawncode"]
    local discord = data["discordid"]

    userCanEditVehicle(spawncode, source, function(access2)
        if access2 then
            doesUserHaveAccessToVehicle(spawncode, discord, function(access)
                if not access then
                    MySQL.Async.execute("INSERT INTO `personal_access` (spawncode, userid, rank) VALUES (@spawncode, @userid, 'USR')", {["@spawncode"] = spawncode, ["@userid"] = discord})
                    uncacheUser(getInGameUserByDiscordId(discord), spawncode)
                end
            end)
        end
    end)
end)
RegisterServerEvent("dptrust:addbyid", function(data)
    local spawncode = data["spawncode"]
    local id = tonumber(data["id"])
    
    userCanEditVehicle(spawncode, source, function(access2)
        if access2 then
            doesUserHaveAccessToVehicle(spawncode, getUserDiscordId(id), function(access)
                if not access then
                    MySQL.Async.execute("INSERT INTO `personal_access` (spawncode, userid, rank) VALUES (@spawncode, @userid, 'USR')", {["@spawncode"] = spawncode, ["@userid"] = getUserDiscordId(id)})
                    uncacheUser(id, spawncode)
                end
            end)
        end
    end)
end)

RegisterServerEvent("dptrust:deletepersonal", function(data)
    local spawncode = data["spawncode"]

    getUserVehicleRank(spawncode, getUserDiscordId(source), function(rank)
        if rank == "ONR" then
            MySQL.Async.execute("DELETE FROM `personal_access` WHERE spawncode = @spawncode", {["@spawncode"] = spawncode})
            MySQL.Async.execute("DELETE FROM `personal_vehicles` WHERE spawncode = @spawncode", {["@spawncode"] = spawncode})
            removeVehicleRestricted(spawncode)
        end
    end)
end)

RegisterServerEvent("dptrust:setrank", function(data)
    local spawncode = data["spawncode"]
    local discord = data["discordid"]
    local rank = data["rank"]
    
    userCanEditVehicle(spawncode, source, function(access2)
        if access2 then
            doesUserHaveAccessToVehicle(spawncode, discord, function(access)
                if access then
                    MySQL.Async.execute("UPDATE `personal_access` SET rank = @rank WHERE spawncode = @spawncode AND userid = @userid", {["@spawncode"]= spawncode, ["@userid"] = discord, ["@rank"] = rank})
                end
            end)
        end
    end)
end)

RegisterServerEvent("dptrust:removeaccess", function(data)
    local spawncode = data["spawncode"]
    local discord = data["discordid"]
    userCanEditVehicle(spawncode, source, function(access2)
        if access2 then
            doesUserHaveAccessToVehicle(spawncode, discord, function(access)
                if access then
                    MySQL.Async.execute("DELETE FROM `personal_access` WHERE spawncode = @spawncode AND userid = @userid", {["@spawncode"] = spawncode, ["@userid"] = discord})
                    uncacheUser(getInGameUserByDiscordId(discord), spawncode)
                end
            end)
        end
    end)
end)

RegisterServerEvent("dptrust:createpersonalvehicle", function(data)
    local src = source
    local spawncode = data["spawncode"]
    local discord = data["discordid"]
    
    if IsPlayerAceAllowed(src, Config.adminPermission) then
        isVehicle(spawncode, function(allowed)
            if not allowed then
                MySQL.Async.execute("INSERT INTO `personal_vehicles` (spawncode) VALUES (@spawncode)", {["@spawncode"] = spawncode})
                doesUserHaveAccessToVehicle(spawncode, discord, function(allowed2)
                    if allowed2 then
                        MySQL.Async.execute("UPDATE `personal_access` SET rank = 'ONR' WHERE spawncode = @spawncode AND userid = @userid", {["@spawncode"] = spawncode, ["@userid"] = discord})
                    else
                        MySQL.Async.execute("INSERT INTO `personal_access` (spawncode, userid, rank) VALUES (@spawncode, @userid, 'ONR')", {["@spawncode"] = spawncode, ["@userid"] = discord})
                    end
                    addVehicleRestricted(spawncode)
                end)
            end
        end)
    end
end)

RegisterServerEvent("dptrust:setpersonalowner", function(data)
    local src = source
    local spawncode = data["spawncode"]
    local discord = data["discordid"]
    
    if IsPlayerAceAllowed(src, Config.adminPermission) then
        MySQL.Async.execute("DELETE FROM `personal_access` WHERE spawncode = @spawncode AND rank = 'ONR'", {["@spawncode"] = spawncode})
        doesUserHaveAccessToVehicle(spawncode, discord, function(allowed)
            if allowed then
                MySQL.Async.execute("UPDATE `personal_access` SET rank = 'ONR' WHERE spawncode = @spawncode AND userid = @userid", {["@spawncode"] = spawncode, ["@userid"] = discord})
            else
                MySQL.Async.execute("INSERT INTO `personal_access` (spawncode, userid, rank) VALUES (@spawncode, @userid, 'ONR')", {["@spawncode"] = spawncode, ["@userid"] = discord})
            end
            registerVehicleOwner(spawncode)
            uncacheUser(getInGameUserByDiscordId(discord), spawncode)
        end)
    end
end)

RegisterServerEvent("dptrust:deletepersonaladmin", function(data)
    local src = source
    local spawncode = data["spawncode"]
    
    if IsPlayerAceAllowed(src, Config.adminPermission) then
        MySQL.Async.execute("DELETE FROM `personal_access` WHERE spawncode = @spawncode", {["@spawncode"] = spawncode})
        MySQL.Async.execute("DELETE FROM `personal_vehicles` WHERE spawncode = @spawncode", {["@spawncode"] = spawncode})
        removeVehicleRestricted(spawncode)
    end
end)

RegisterServerEvent("dptrust:gainadminaccess", function(data)
    local src = source
    local spawncode = data["spawncode"]

    if IsPlayerAceAllowed(src, Config.adminPermission) then
        doesUserHaveAccessToVehicle(spawncode, getUserDiscordId(src), function(allowed)
            if allowed then
                MySQL.Async.execute("UPDATE `personal_access` SET rank = 'ADM' WHERE spawncode = @spawncode AND userid = @userid", {["@spawncode"] = spawncode, ["@userid"] = getUserDiscordId(src)})
            else
                MySQL.Async.execute("INSERT INTO `personal_access` (spawncode, userid, rank) VALUES (@spawncode, @userid, 'ADM')", {["@spawncode"] = spawncode, ["@userid"] = getUserDiscordId(src)})
            end
            uncacheUser(src, spawncode)
        end)
    end
end)

RegisterServerEvent("dptrust:loseadminaccess", function(data)
    local src = source
    local spawncode = data["spawncode"]
    
    if IsPlayerAceAllowed(src, Config.adminPermission) then
        MySQL.Async.execute("DELETE FROM `personal_access` WHERE spawncode = @spawncode AND userid = @userid", {["@spawncode"] = spawncode, ["@userid"] = getUserDiscordId(src)})
        uncacheUser(src, spawncode)
    end
end)