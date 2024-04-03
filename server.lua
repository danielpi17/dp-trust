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
    MySQL.Async.fetchAll("SELECT * FROM `personal_access` WHERE userid = @id AND spawncode = @spawncode", {"@id" = discordid, "@spawncode" = spawncode}, function(result)
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
        if rank == "MGR" || rank == "ONR" then
            return true
        else
            return false
        end
    end
end

RegisterServerEvent("dptrust:accesslistcallback", function(spawncode)
    if userCanEditVehicle(spawncode, source) then
        MySQL.Async.fetchall("SELECT * FROM `personal_access` WHERE spawncode = @spawncode", {"@spawncode" = spawncode}, function(result)
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
    MySQL.Async.fetchAll("SELECT * FROM `personal_access` WHERE userid = @userid", {"@userid", getUserDiscordId(src)}, function(result)
        myVehicles = {}
        trustedPersonals = {}
        admin = IsPlayerAceAllowed(src, Config.adminPermission)
        for k, v in pairs(result) do
            if v["rank"] == "ONR" then
                myVehicles.append(v["spawncode"])
            else
                MySQL.Async.fetchAll("SELECT * FROM `personal_access` WHERE spawncode = @spawncode AND rank = 'ONR'", {"@spawncode" = v["spawncode"]}, function(result2)
                    if next(result2) == nil then
                        trustedPersonals.append({v["spawncode"], "UNKOWN", v["rank"]})
                    else
                        trustedPersonals.append({v["spawncode"], result[0]["userid"], v["rank"]})
                    end
                end)
            end
        end

        TriggerClientEvent("dptrust:loaddatacallbackresponse", source, {
            myvehicles = myVehicles,
            trustedpersonals = trustedPersonals,
            admin = admin
        })
    end)
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