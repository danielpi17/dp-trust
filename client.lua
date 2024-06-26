local isUiOpen = false
cantUse = {}
accessListCallback = 0
loadDataCallback = 0

RegisterCommand(Config.command, function()
    if isUiOpen then
        SetNuiFocus(false, false)
    else
        SetNuiFocus(true, true)
    end
    isUiOpen = not isUiOpen
    SendNUIMessage({
        type = "visibility",
        value = isUiOpen
    })
end, false)

RegisterKeyMapping(Config.command, "Open Trust System", "keyboard", Config.keybind)

Citizen.CreateThread(function()
    while true do
        cantUse = {}
        Citizen.Wait(1000*60*Config.clientThreshold)
    end
end)

Citizen.CreateThread(function()
    while true do
        pedVehicle = GetVehiclePedIsIn(PlayerPedId(), false)
        if GetPedInVehicleSeat(pedVehicle, -1) == PlayerPedId() then
            spawncode = GetEntityModel(pedVehicle)
            if cantUse[spawncode] == nil then
                vehicleAccess(spawncode)
            elseif cantUse[spawncode] == 0 then
                SetNotificationTextEntry("STRING")
                AddTextComponentString("~r~You can't drive this vehicle! Spawncode: "..spawncode)
                DrawNotification(false, false)
                TaskLeaveVehicle(PlayerPedId(), GetVehiclePedIsIn(PlayerPedId(), false), 16)
            end
        end
        Citizen.Wait(10)
    end
end)

function vehicleAccess(spawncode)
    cantUse[spawncode] = -1
    TriggerServerEvent("dptrust:allowedtouse", spawncode)
end

RegisterNetEvent("dptrust:allowedtousecb", function(spawncode, allowed)
    if allowed then
        cantUse[spawncode] = 1
    else
        cantUse[spawncode] = 0
    end
end)

RegisterNetEvent("dptrust:resetvehiclecache", function(spawncode)
    cantUse[GetHashKey(spawncode)] = nil
end)

RegisterNetEvent("dptrust:accesslistcallbackresponse", function(data)
    accessListCallback = data
end)

RegisterNetEvent("dptrust:loaddatacallbackresponse", function(data)
    loadDataCallback = data
end)

RegisterNuiCallback("exit", function(data, cb)
    isUiOpen = false
    SetNuiFocus(false, false)
    cb({})
end)

RegisterNuiCallback("accesslist", function(data, cb)
    accessListCallback = 0
    TriggerServerEvent("dptrust:accesslistcallback", data["spawncode"])
    repeat Citizen.Wait(1) until accessListCallback ~= 0
    cb(accessListCallback)
end)

RegisterNuiCallback("loaddata", function(data, cb)
    loadDataCallback = 0
    TriggerServerEvent("dptrust:loaddatacallback")
    repeat Citizen.Wait(0) until loadDataCallback ~= 0
    cb(loadDataCallback)
end)

RegisterNuiCallback("addbydiscordid", function(data, cb)
    TriggerServerEvent("dptrust:addbydiscordid", data)
    cb({})
end)

RegisterNuiCallback("addbyid", function(data, cb)
    TriggerServerEvent("dptrust:addbyid", data)
    cb({})
end)

RegisterNuiCallback("deletepersonal", function(data, cb)
    TriggerServerEvent("dptrust:deletepersonal", data)
    cb({})
end)

RegisterNuiCallback("setrank", function(data, cb)
    TriggerServerEvent("dptrust:setrank", data)
    cb({})
end)

RegisterNuiCallback("removeaccess", function(data, cb)
    TriggerServerEvent("dptrust:removeaccess", data)
    cb({})
end)

RegisterNuiCallback("createpersonalvehicle", function(data, cb)
    TriggerServerEvent("dptrust:createpersonalvehicle", data)
    cb({})
end)

RegisterNuiCallback("setpersonalowner", function(data, cb)
    TriggerServerEvent("dptrust:setpersonalowner", data)
    cb({})
end)

RegisterNuiCallback("deletepersonaladmin", function(data, cb)
    TriggerServerEvent("dptrust:deletepersonaladmin", data)
    cb({})
end)

RegisterNuiCallback("gainadminaccess", function(data, cb)
    TriggerServerEvent("dptrust:gainadminaccess", data)
    cb({})
end)

RegisterNuiCallback("loseadminaccess", function(data, cb)
    TriggerServerEvent("dptrust:loseadminaccess", data)
    cb({})
end)
