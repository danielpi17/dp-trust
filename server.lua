MySQL.Async.execute("CREATE TABLE IF NOT EXISTS `personal_vehicles` (`spawncode` VARCHAR(255) NOT NULL , PRIMARY KEY (`spawncode`)) ENGINE = InnoDB;", {})
MySQL.Async.execute("CREATE TABLE IF NOT EXISTS `personal_access` (`spawncode` VARCHAR(255) NOT NULL , `userid` VARCHAR(255) NOT NULL , `rank` VARCHAR(5) NOT NULL ) ENGINE = InnoDB;", {})

function getUserDiscordId(src)
    for k,v in pairs(GetPlayerIdentifiers(src)) do
        if string.find(v, "^discord:") then
            return string.gsub(v, "discord:", "")
        end
    end
end

function getUserVehicleRank(spawncode, discordid)
    MySQL.Async.fetchAll("SELECT * FROM `personal_access` WHERE userid = @id AND spawncode = @spawncode", {["@id"] = discordid, ["@spawncode"] = spawncode}, function(result)
        if next(result) == nil then -- if not in 
            return "N/A"
        else
            return result[0]["rank"]
        end
    end)
end

function userCanEditVehicle(spawncode, src)
    if IsPlayerAceAllowed(src, Config.adminPermission) then
        return true
    else
        rank = getUserVehicleRank(spawncode, getUserDiscordId(src))
        if rank == "MGR" or rank == "ONR" then
            return true
        else
            return false
        end
    end
end

function isVehicle(spawncode)
    MySQL.Async.fetchAll("SELECT * FROM `personal_vehicles` WHERE spawncode = @spawncode", {["@spawncode"] = spawncode}, function(result)
        return next(result) ~= nil
    end)
end

function doesUserHaveAccessToVehicle(spawncode, discord)
    MySQL.Async.fetchAll("SELECT * FROM `personal_access` WHERE spawncode = @spawncode AND userid = @userid", {["@spawncode"] = spawncode, ["@userid"] = discord}, function(result)
        return next(result) ~= nil
    end)
end

RegisterServerEvent("dptrust:vehiclespermittedserver", function()
    local src = source
    MySQL.Async.fetchAll("SELECT * FROM `personal_vehicles`", {}, function(result)
        allVehicles = {}
        for k, v in pairs(result) do
            allVehicles.append(v["spawncode"])
        end

        MySQL.Async.fetchAll("SELECT * FROM `personal_access` WHERE userid = @userid", {["@userid"] = getUserDiscordId(src)}, function(result2)
            for g, b in pairs(result2) do
                allVehicles.remove(b["spawncode"])
            end
            TriggerClientEvent("dptrust:vehiclespermitted", src, allVehicles)
        end)
    end)
end)

RegisterServerEvent("dptrust:accesslistcallback", function(spawncode)
    if userCanEditVehicle(spawncode, source) then
        MySQL.Async.fetchall("SELECT * FROM `personal_access` WHERE spawncode = @spawncode", {["@spawncode"] = spawncode}, function(result)
            tempList = {}
            for k,v in pairs(result) do
                tempList.append({v["userid"], v["rank"]})
            end
            TriggerClientEvent("dptrust:accesslistcallbackresponse", source, templist)
        end)
    else
        TriggerClientEvent("dptrust:accesslistcallbackresponse", source, {})
    end
end)

RegisterServerEvent("dptrust:loaddatacallback", function()
    local src = source
    MySQL.Async.fetchAll("SELECT * FROM `personal_access` WHERE userid = @userid", {["@userid"] = getUserDiscordId(src)}, function(result)
        myVehicles = {}
        trustedPersonals = {}
        admin = IsPlayerAceAllowed(src, Config.adminPermission)
        for k, v in pairs(result) do
            if v["rank"] == "ONR" then
                myVehicles.append(v["spawncode"])
            else
                MySQL.Async.fetchAll("SELECT * FROM `personal_access` WHERE spawncode = @spawncode AND rank = 'ONR'", {["@spawncode"] = v["spawncode"]}, function(result2)
                    if next(result2) == nil then
                        trustedPersonals.append({v["spawncode"], "UNKOWN", v["rank"]})
                    else
                        trustedPersonals.append({v["spawncode"], result[0]["userid"], v["rank"]})
                    end
                end)
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

    if userCanEditVehicle(spawncode, source) then
        if not doesUserHaveAccessToVehicle(spawncode, discord) then
            MySQL.Async.execute("INSERT INTO `personal_access` (spawncode, userid, rank) VALUES (@spawncode, @userid, 'USR')", {["@spawncode"] = spawncode, ["@userid"] = discord})
        end
    end
end)
RegisterServerEvent("dptrust:addbyid", function(data)
    local spawncode = data["spawncode"]
    local id = tonumber(data["id"])
    
    if userCanEditVehicle(spawncode, source) then
        if not doesUserHaveAccessToVehicle(spawncode, getUserDiscordId(id)) then
            MySQL.Async.execute("INSERT INTO `personal_access` (spawncode, userid, rank) VALUES (@spawncode, @userid, 'USR')", {["@spawncode"] = spawncode, ["@userid"] = getUserDiscordId(id)})
        end
    end
end)

RegisterServerEvent("dptrust:deletepersonal", function(data)
    local spawncode = data["spawncode"]

    if getUserVehicleRank(spawncode, getUserDiscordId(source)) == "ONR" then
        MySQL.Async.execute("DELETE FROM `personal_access` WHERE spawncode = @spawncode", {["@spawncode"] = spawncode})
        MySQL.Async.execute("DELETE FROM `personal_vehicles` WHERE spawncode = @spawncode", {["@spawncode"] = spawncode})
    end
end)

RegisterServerEvent("dptrust:setrank", function(data)
    local spawncode = data["spawncode"]
    local discord = data["discordid"]
    local rank = data["rank"]
    
    if userCanEditVehicle(spawncode, source) then
        if doesUserHaveAccessToVehicle(spawncode, discord) then
            MySQL.Async.execute("UPDATE `personal_access` SET rank = @rank WHERE spawncode = @spawncode AND userid = @userid", {["@spawncode"]= spawncode, ["@userid"] = discord, ["@rank"] = rank})
        end
    end
end)

RegisterServerEvent("dptrust:removeaccess", function(data)
    local spawncode = data["spawncode"]
    local discord = data["discordid"]
    
    if userCanEditVehicle(spawncode, source) then
        if doesUserHaveAccessToVehicle(spawncode, discord) then
            MySQL.Async.execute("DELETE FROM `personal_access` WHERE spawncode = @spawncode AND userid = @userid", {["@spawncode"] = spawncode, ["@userid"] = discord})
        end
    end
end)

RegisterServerEvent("dptrust:createpersonalvehicle", function(data)
    local src = source
    local spawncode = data["spawncode"]
    local discord = data["discordid"]
    
    if IsPlayerAceAllowed(src, Config.adminPermission) then
        if not isVehicle(spawncode) then
            MySQL.Async.execute("INSERT INTO `personal_vehicles` (spawncode) VALUES (@spawncode)", {["@spawncode"] = spawncode})
            if doesUserHaveAccessToVehicle(spawncode, discord) then
                MySQL.Async.execute("INSERT INTO `personal_access` (spawncode, userid, rank) VALUES (@spawncode, @userid, 'ONR')", {["@spawncode"] = spawncode, ["@userid"] = discord})
            else
                MySQL.Async.execute("UPDATE `personal_access` SET rank = 'ONR' WHERE spawncode = @spawncode AND userid = @userid", {["@spawncode"] = spawncode, ["@userid"] = discord})
            end
        end
    end
end)

RegisterServerEvent("dptrust:setpersonalowner", function(data)
    local src = source
    local spawncode = data["spawncode"]
    local discord = data["discordid"]
    
    if IsPlayerAceAllowed(src, Config.adminPermission) then
        MySQL.Async.execute("DELETE FROM `personal_access` WHERE spawncode = @spawncode AND rank = 'ONR'", {["@spawncode"] = spawncode})
        if doesUserHaveAccessToVehicle(spawncode, discord) then
            MySQL.Async.execute("UPDATE `personal_access` SET rank = 'ONR' WHERE spawncode = @spawncode AND userid = @userid", {["@spawncode"] = spawncode, ["@userid"] = discord})
        else
            MySQL.Async.execute("INSERT INTO `personal_access` (spawncode, userid, rank) VALUES (@spawncode, @userid, 'ONR')", {["@spawncode"] = spawncode, ["@userid"] = discord})
        end
    end
end)

RegisterServerEvent("dptrust:deletepersonaladmin", function(data)
    local src = source
    local spawncode = data["spawncode"]
    
    if IsPlayerAceAllowed(src, Config.adminPermission) then
        MySQL.Async.execute("DELETE FROM `personal_access` WHERE spawncode = @spawncode", {["@spawncode"] = spawncode})
        MySQL.Async.execute("DELETE FROM `personal_vehicles` WHERE spawncode = @spawncode", {["@spawncode"] = spawncode})
    end
end)

RegisterServerEvent("dptrust:gainadminaccess", function(data)
    local src = source
    local spawncode = data["spawncode"]

    if IsPlayerAceAllowed(src, Config.adminPermission) then
        if doesUserHaveAccessToVehicle(spawncode, getUserDiscordId(src)) then
            MySQL.Async.execute("UPDATE `personal_access` SET rank = 'ADM' WHERE spawncode = @spawncode AND userid = @userid", {["@spawncode"] = spawncode, ["@userid"] = getUserDiscordId(src)})
        else
            MySQL.Async.execute("INSERT INTO `personal_access` (spawncode, userid, rank) VALUES (@spawncode, @userid, 'ADM')", {["@spawncode"] = spawncode, ["@userid"] = getUserDiscordId(src)})
        end
    end
end)

RegisterServerEvent("dptrust:loseadminaccess", function(data)
    local src = source
    local spawncode = data["spawncode"]
    
    if IsPlayerAceAllowed(src, Config.adminPermission) then
        MySQL.Async.execute("DELETE FROM `personal_access` WHERE spawncode = @spawncode AND userid = @userid", {["@spawncode"] = spawncode, ["@userid"] = getUserDiscordId(src)})
    end
end)