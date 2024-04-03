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

RegisterKeyMapping("openui", "Open UI", "keyboard", "F1")

RegisterNuiCallback("exit", function(data, cb)
    isUiOpen = false
    SetNuiFocus(false, false)
    cb({})
end)

RegisterNuiCallback("accesslist", function(data, cb)
    cb({{"djisadojd", "USR"}, {"sjaidhasiduw", "MGR"}, {"sodohrwghhoq", "ONR"}})
    print(json.encode(data))
end)

RegisterNuiCallback("addbydiscordid", function(data, cb)
    print(json.encode(data))
    cb({})
end)

RegisterNuiCallback("addbyid", function(data, cb)
    print(json.encode(data))
    cb({})
end)

RegisterNuiCallback("deletepersonal", function(data, cb)
    print(json.encode(data))
    cb({})
end)

RegisterNuiCallback("setrank", function(data, cb)
    print(json.encode(data))
    cb({})
end)

RegisterNuiCallback("removeaccess", function(data, cb)
    print(json.encode(data))
    cb({})
end)

RegisterNuiCallback("createpersonalvehicle", function(data, cb)
    print(json.encode(data))
    cb({})
end)

RegisterNuiCallback("setpersonalowner", function(data, cb)
    print(json.encode(data))
    cb({})
end)

RegisterNuiCallback("deletepersonal", function(data, cb)
    print(json.encode(data))
    cb({})
end)

RegisterNuiCallback("gainadminaccess", function(data, cb)
    print(json.encode(data))
    cb({})
end)

RegisterNuiCallback("loseadminaccess", function(data, cb)
    print(json.encode(data))
    cb({})
end)

RegisterNuiCallback("loaddata", function(data, cb)
    cb({
        myvehicles = {"spanw", "cod", "scott", "dan", "garrett"},
        trustedpersonals = {{"test", "2142595123129839", "MGR"},{"test", "2142595123129839", "ADM"},{"test", "2142595123129839", "USR"}},
        admin = true
    })
end)