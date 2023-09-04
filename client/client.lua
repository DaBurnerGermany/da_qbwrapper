Debug = true

QBCore = exports['qb-core']:GetCoreObject()


exports('getSharedObject', function()
    return QBCore
end)
exports('isESX', function()
    return GetResourceState('es_extended') == 'started'
end)
exports('isQB', function()
    return GetResourceState('qb-core') == 'started'
end)


local function EnumerateEntitiesWithinDistance(entities, isPlayerEntities, coords, maxDistance)
    local nearbyEntities = {}

    if coords then
        coords = vector3(coords.x, coords.y, coords.z)
    else
        local playerPed = ESX.PlayerData.ped
        coords = GetEntityCoords(playerPed)
    end

    for k, entity in pairs(entities) do
        local distance = #(coords - GetEntityCoords(entity))

        if distance <= maxDistance then
            nearbyEntities[#nearbyEntities + 1] = isPlayerEntities and k or entity
        end
    end

    return nearbyEntities
end



QBCore.UI = {}
QBCore.UI.HUD = {}
QBCore.UI.HUD.RegisteredElements = {}
QBCore.UI.Menu = {}
QBCore.UI.Menu.RegisteredTypes = {}
QBCore.UI.Menu.Opened = {}
QBCore.Game = {}
QBCore.Game.Utils = {}
QBCore.Scaleform = {}
QBCore.Scaleform.Utils = {}
QBCore.Streaming = {}

QBCore.IsPlayerLoaded = function()
    if Debug then 
        print("No QB-Core Native equivalent for ESX.IsPlayerLoaded")
    end
    return 
end 


QBCore.GetPlayerData = function()
    local PlayerData = QBCore.Functions.GetPlayerData()

    local job = {
        name = PlayerData.job.name,
        label = PlayerData.job.label,
        grade = PlayerData.job.grade.level,
        grade_name = PlayerData.job.grade.name,
        grade_salary = PlayerData.job.payment,
        isboss = PlayerData.job.isboss
    }

    PlayerData.job = job
    return PlayerData
end 
QBCore.SearchInventory = function (items, count)
    if Debug then 
        print("No QB-Core Native equivalent for ESX.SearchInventory")
    end 
    return
end 
QBCore.SetPlayerData = function (key, val)
    --QBCore:Player:SetPlayerData
end 
QBCore.Progressbar = function (message, length, Options)
    --todo
end 
QBCore.ShowNotification = function (message, type, length)
    QBCore.Functions.Notify(message)
end 
QBCore.TextUI = function (message, type)
    --todo
end 
QBCore.HideUI = function ()
    --todo
end 
QBCore.ShowAdvancedNotification = function (sender, subject, msg, textureDict, iconType, flash, saveToBrief, hudColorIndex)
    QBCore.Functions.Notify(msg)
end 
QBCore.ShowHelpNotification = function (msg, thisFrame, beep, duration)
    if msg~= nil then 
        SetTextComponentFormat('STRING')
        AddTextComponentString(msg)
        DisplayHelpTextFromStringLabel(0, 0, 1, -1)
    end 
end 
QBCore.ShowFloatingHelpNotification = function (msg, coords)
    QBCore.Functions.Notify(msg)
end 
QBCore.HashString = function (str)
    local format = string.format
    local upper = string.upper
    local gsub = string.gsub
    local hash = joaat(str)
    local input_map = format("~INPUT_%s~", upper(format("%x", hash)))
    input_map = gsub(input_map, "FFFFFFFF", "")

    return input_map
end 
QBCore.RegisterInput = function(command_name, label, input_group, key, on_press, on_release)

end 
QBCore.TriggerServerCallback = function(name, cb, ...)
    QBCore.Functions.TriggerCallback(name, cb, ...)
end 
QBCore.UI.HUD.SetDisplay = function(opacity)
end
QBCore.UI.HUD.RegisterElement = function(name, index, priority, html, data)
end
QBCore.UI.HUD.RemoveElement = function(name)
end
QBCore.UI.HUD.Reset = function()
end
QBCore.UI.HUD.UpdateElement = function(name, data)
end
QBCore.UI.Menu.RegisterType = function(type, open, close)
end
QBCore.UI.Menu.Open = function(type, namespace, name, data, submit, cancel, change, close)
end
QBCore.UI.Menu.Close = function(type, namespace, name)
end
QBCore.UI.Menu.CloseAll = function()
end
QBCore.UI.Menu.GetOpened = function(type, namespace, name)
end
QBCore.UI.Menu.GetOpenedMenus = function()
end
QBCore.UI.Menu.IsOpen = function(type, namespace, name)
end
QBCore.UI.ShowInventoryItemNotification = function(add, item, count)
end

function print_r(arr, indentLevel)
    local str = ""
    local indentStr = "#"

    if(indentLevel == nil) then
        print(print_r(arr, 0))
        return
    end

    for i = 0, indentLevel do
        indentStr = indentStr.."\t"
    end

    for index,value in pairs(arr) do
        if type(value) == "table" then
            str = str..indentStr..index..": \n"..print_r(value, (indentLevel + 1))
        else 
            str = str..indentStr..index..": "..value.."\n"
        end
    end
    return str
end


QBCore.GetWeaponLabel = function(weaponName)
    local weaponName = GetHashKey(weaponName)
    return QBCore.Shared.Weapons[weaponName].label
end

QBCore.Game.GetPedMugshot = function(ped, transparent)
    if not DoesEntityExist(ped) then return end
    local mugshot = transparent and RegisterPedheadshotTransparent(ped) or RegisterPedheadshot(ped)

    while not IsPedheadshotReady(mugshot) do
        Wait(0)
    end

    return mugshot, GetPedheadshotTxdString(mugshot)
end 

QBCore.Game.Teleport = function(entity, coords, cb)
    local vector = type(coords) == "vector4" and coords or type(coords) == "vector3" and vector4(coords, 0.0) or vec(coords.x, coords.y, coords.z, coords.heading or 0.0)

    if DoesEntityExist(entity) then
        RequestCollisionAtCoord(vector.xyz)
        while not HasCollisionLoadedAroundEntity(entity) do
            Wait(0)
        end

        SetEntityCoords(entity, vector.xyz, false, false, false, false)
        SetEntityHeading(entity, vector.w)
    end

    if cb then
        cb()
    end
end 
QBCore.Game.SpawnObject = function(object, coords, cb, networked)
    networked = networked == nil and true or networked

    CreateObject(object, coords.x, coords.y, coords.z, networked, false, true)
end 
QBCore.Game.SpawnLocalObject = function(object, coords, cb)
    CreateObject(object, coords.x, coords.y, coords.z, false, false, true)
end 
QBCore.Game.DeleteVehicle = function(vehicle)
    QBCore.Functions.DeleteVehicle(vehicle)
end 
QBCore.Game.DeleteObject = function(object)
    DeleteEntity(object)
end 
QBCore.Game.SpawnVehicle = function(vehicle, coords, heading, cb, networked)
    coords.w = heading
    QBCore.Functions.SpawnVehicle(vehicle, cb, coords, networked, false)
end 
QBCore.Game.SpawnLocalVehicle = function(vehicle, coords, heading, cb)
    coords.w = heading
    QBCore.Functions.SpawnVehicle(vehicle, cb, coords, false, false)
end 
QBCore.Game.IsVehicleEmpty = function(vehicle)
    local passengers = GetVehicleNumberOfPassengers(vehicle)
    local driverSeatFree = IsVehicleSeatFree(vehicle, -1)

    return passengers == 0 and driverSeatFree
end 
QBCore.Game.GetObjects = function()
    return GetGamePool('CObject')
end 
QBCore.Game.GetPeds = function(onlyOtherPeds)
    return QBCore.Functions.GetPeds()
end 
QBCore.Game.GetVehicles = function()
    return QBCore.Functions.GetVehicles()
end 
QBCore.Game.GetPlayers = function(onlyOtherPlayers, returnKeyValue, returnPeds)
    return QBCore.Functions.GetPlayers()
end 
QBCore.Game.GetClosestObject = function(coords, modelFilter)
    return QBCore.Functions.GetClosestObject(coords)
end 
QBCore.Game.GetClosestPed = function(coords, modelFilter)
    return QBCore.Functions.GetClosestPed(coords, modelFilter)
end 
QBCore.Game.GetClosestPlayer = function(coords)
    return QBCore.Functions.GetClosestPlayer(coords)
end 
QBCore.Game.GetClosestVehicle = function(coords, modelFilter)
    return QBCore.Functions.GetClosestVehicle(coords)
end 
QBCore.Game.GetPlayersInArea = function(coords, maxDistance)
    return EnumerateEntitiesWithinDistance(QBCore.Game.GetPlayers(true, true), true, coords, maxDistance)
end 
QBCore.Game.GetVehiclesInArea = function(coords, maxDistance)
    return EnumerateEntitiesWithinDistance(QBCore.Game.GetVehicles(), true, coords, maxDistance)
end 
QBCore.Game.IsSpawnPointClear = function(coords, maxDistance)
    return QBCore.Game.GetVehiclesInArea(coords, maxDistance) == 0
end 
QBCore.Game.GetClosestEntity = function(entities, isPlayerEntities, coords, modelFilter)
    local closestEntity, closestEntityDistance, filteredEntities = -1, -1, nil

    if coords then
        coords = vector3(coords.x, coords.y, coords.z)
    else
        local playerPed = ESX.PlayerData.ped
        coords = GetEntityCoords(playerPed)
    end

    if modelFilter then
        filteredEntities = {}

        for k, entity in pairs(entities) do
            if modelFilter[GetEntityModel(entity)] then
                filteredEntities[#filteredEntities + 1] = entity
            end
        end
    end

    for k, entity in pairs(filteredEntities or entities) do
        local distance = #(coords - GetEntityCoords(entity))

        if closestEntityDistance == -1 or distance < closestEntityDistance then
            closestEntity, closestEntityDistance = isPlayerEntities and k or entity, distance
        end
    end

    return closestEntity, closestEntityDistance
end 
QBCore.Game.GetVehicleInDirection = function()
    local playerPed = ESX.PlayerData.ped
    local playerCoords = GetEntityCoords(playerPed)
    local inDirection = GetOffsetFromEntityInWorldCoords(playerPed, 0.0, 5.0, 0.0)
    local rayHandle = StartExpensiveSynchronousShapeTestLosProbe(playerCoords, inDirection, 10, playerPed, 0)
    local numRayHandle, hit, endCoords, surfaceNormal, entityHit = GetShapeTestResult(rayHandle)

    if hit == 1 and GetEntityType(entityHit) == 2 then
        local entityCoords = GetEntityCoords(entityHit)
        return entityHit, entityCoords
    end

    return nil
end 
QBCore.Game.GetVehicleProperties = function(vehicle)
    return QBCore.Functions.GetVehicleProperties(vehicle)
end 
QBCore.Game.SetVehicleProperties = function(vehicle, props)
    QBCore.Functions.SetVehicleProperties(vehicle, props)
end 
QBCore.Game.DrawText3D = function(coords, text, size, font)
    QBCore.Functions.DrawText3D(coords.x, coords.y, coords.z, text)
end 
QBCore.Game.Utils.DrawText3D = function(coords, text, size, font)
    QBCore.Functions.DrawText3D(coords.x, coords.y, coords.z, text)
end 

QBCore.ShowInventory = function()
    if Debug then 
        print("No QB-Core Native equivalent for ESX.ShowInventory")
    end 
    return
end 


RegisterNetEvent('esx:onPlayerDeath', function(data)
    TriggerServerEvent("hospital:server:SetDeathStatus", true)
end)

RegisterNetEvent('esx:showNotification')
AddEventHandler('esx:showNotification', function(msg, type, length)
    if msg ~= nil then
        QBCore.ShowNotification(msg, type, length)    
    end
end)

RegisterNetEvent('esx:showAdvancedNotification')
AddEventHandler('esx:showAdvancedNotification',
    function(sender, subject, msg, textureDict, iconType, flash, saveToBrief, hudColorIndex)
        QBCore.ShowAdvancedNotification(sender, subject, msg, textureDict, iconType, flash, saveToBrief, hudColorIndex)
    end)


RegisterNetEvent('esx:showHelpNotification')
AddEventHandler('esx:showHelpNotification', function(msg, thisFrame, beep, duration)
    QBCore.ShowHelpNotification(msg, thisFrame, beep, duration)
end)



