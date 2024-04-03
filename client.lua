local isUiOpen = false

RegisterCommand("openui", function()
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
end)

RegisterKeyMapping("openui", "Open UI", "keyboard", "F3")

RegisterNuiCallback("exit", function(data, cb)
    isUiOpen = false
    SetNuiFocus(false, false)
    cb({})
end)

accessListCallback = 0
loadDataCallback = 0

RegisterNetEvent("dptrust:accesslistcallbackresponse", function(data)
    accessListCallback = data
end)

RegisterNetEvent("dptrust:loaddatacallbackresponse", function(data)
    loadDataCallback = data
end)

RegisterNuiCallback("accesslist", function(data, cb)
    accessListCallback = 0
    TriggerServerEvent("dptrust:accesslistcallback")
    repeat Citizen.Wait(0) until accessListCallback ~= 0
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