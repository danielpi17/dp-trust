local isUiOpen = false

RegisterCommand("openui", function()
    isUiOpen = not isUiOpen
    if isUiOpen then
        SetNuiFocus(false, false)
    else
        SetNuiFocus(true, true)
    end
end)

RegisterKeyMapping("openui", "Open UI", "keyboard", "F1")

RegisterNuiCallback("test", function(data, cb)
    cb({})
    print(json.encode(data))
end)