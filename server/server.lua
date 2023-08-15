Debug = true
QBCore = nil
QBCore = exports['qb-core']:GetCoreObject()


exports('getSharedObject', function()
    return QBCore
end)


QBCore.RegisterCommand = function(name, group, cb, allowConsole, suggestion)
    QBCore.Commands.Add(name, suggestion, cb, false, cb, group)
end 

QBCore.ClearTimeout = function(id)
    if PlayerDebug then 
        print("No QB-Core Native equivalent for ESX.ClearTimeout")
    end 
end 

QBCore.RegisterServerCallback = function(name, cb)
    QBCore.Functions.CreateCallback(name, cb)
end 

QBCore.Database = {
    ["users"] = {
        table = "players",
        key_column = "citizenid"
    }
}

QBCore.TriggerServerCallback = function(name, requestId, source,Invoke, cb, ...)
    QBCore.Functions.TriggerCallback(name, source, cb, ...)
end 

QBCore.SavePlayer = function(xPlayer, cb)
    xPlayer.Save()
end 

QBCore.SavePlayers = function()
    local xPlayers = QBCore.Functions.GetQBPlayers()

    for k, xPlayer in pairs(xPlayers) do 
        xPlayer.Save()
    end 
end 

QBCore.GetPlayers = function()
    return QBCore.Functions.GetPlayers()
end 

QBCore.GetExtendedPlayers = function(key, val)
    local xPlayers = {}

    for k, v in pairs(QBCore.Functions.GetPlayers()) do
        if key then
            if (key == 'job' and v.job.name == val) or v[key] == val then
                xPlayers[#xPlayers + 1] = v
            end
        else
            xPlayers[#xPlayers + 1] = v
        end
    end
    return xPlayers
end 

QBCore.GetPlayerFromId = function(source)


    return QBCore.Functions.GetPlayer(source)
end 

QBCore.GetPlayerFromIdentifier = function(identifier)
    return QBCore.Functions.GetPlayerByCitizenId(identifier)
end 

QBCore.GetIdentifier = function(playerId)
    return QBCore.Functions.GetPlayer(source).PlayerData.citizenid
end 

QBCore.GetVehicleType = function(Vehicle, Player, cb)
    if PlayerDebug then 
        print("No QB-Core Native equivalent for ESX.GetVehicleType")
    end 
end 

QBCore.DiscordLog = function(name, title, color, message)
    if PlayerDebug then 
        print("No QB-Core Native equivalent for ESX.DiscordLog")
    end 
end 

QBCore.DiscordLogFields = function(name, title, color, fields)
    if PlayerDebug then 
        print("No QB-Core Native equivalent for ESX.DiscordLogFields")
    end 
end 

QBCore.RefreshJobs = function()
end 

QBCore.RegisterUsableItem = function(item, cb)
    QBCore.Functions.CreateUseableItem(item, cb)
end 

QBCore.UseItem = function(source, item, ...)
    QBCore.Functions.UseItem(source, item)
end 

QBCore.RegisterPlayerFunctionOverrides = function(index, overrides)
    if PlayerDebug then 
        print("No QB-Core Native equivalent for ESX.RegisterPlayerFunctionOverrides")
    end 
end 

QBCore.SetPlayerFunctionOverride = function(index)
    if PlayerDebug then 
        print("No QB-Core Native equivalent for ESX.RegisterPlayerFunctionOverrides")
    end 
end 

QBCore.GetItemLabel = function(item)
    return QBCore.Shared.items[item].label or ""
end 

QBCore.GetJobs = function()
    return QBCore.Shared.jobs
end 

QBCore.GetUsableItems = function()
    if PlayerDebug then 
        print("No QB-Core Native equivalent for ESX.GetUsableItems")
    end 
    return {}
end 

QBCore.CreatePickup = function(type, name, count, label, playerId, components, tintIndex)
    if PlayerDebug then 
        print("No QB-Core Native equivalent for ESX.CreatePickup. (gets done by qb-inventory)")
    end 
end 

QBCore.DoesJobExist = function(job, grade)
    if QBCore.Shared[job] and QBCore.Shared[job][grade] then 
        return true
    end 
    return false
end 

QBCore.IsPlayerAdmin = function(playerId)
    if PlayerDebug then 
        print("No QB-Core Native equivalent for ESX.IsPlayerAdmin.")
    end 
end 

QBCore.GetWeaponLabel = function(weaponName)
    local weaponName = GetHashKey(weaponName)
    return QBCore.Shared.Weapons[weaponName].label
end


RegisterNetEvent('esx:onPlayerSpawn')
AddEventHandler('esx:onPlayerSpawn', function()
    local _source = source
    TriggerClientEvent("QBCore:Client:OnPlayerLoaded", _source)
end)

RegisterNetEvent('esx:updateWeaponAmmo')
AddEventHandler('esx:updateWeaponAmmo', function(weaponName, ammoCount)
    local _source = source
    local xPlayer = QBCore.GetPlayerFromId(_source)
    xPlayer.updateWeaponAmmo(weaponName, ammoCount)
end)


RegisterNetEvent('esx:giveInventoryItem')
AddEventHandler('esx:giveInventoryItem', function(target, type, itemName, itemCount)
    local _source = source
    target.addInventoryItem(itemName, itemCount)
end)

RegisterNetEvent('esx:removeInventoryItem')
AddEventHandler('esx:removeInventoryItem', function(type, itemName, itemCount)
    local _source = source
    local xPlayer = QBCore.GetPlayerFromId(source)
    xPlayer.removeInventoryItem(itemName, itemCount)
end)

RegisterNetEvent('esx:useItem')
AddEventHandler('esx:useItem', function(itemName)
    local _source = source

    if(QBCore.Functions.HasItem(_source, itemName, 1)) then 
        QBCore.Functions.UseItem(_source, itemName)
    end 
end)

RegisterNetEvent('esx:onPickup')
AddEventHandler('esx:onPickup', function(pickupId)

end)

RegisterNetEvent('esx:setjob')
AddEventHandler('esx:setjob', function(job, grade)
    local _source = source
    local xPlayer = QBCore.GetPlayerFromId(_source)
    xPlayer.Functions.SetJob(job, grade)
end)


RegisterNetEvent('esx_society:withdrawMoney')
AddEventHandler('esx_society:withdrawMoney', function(societyName, amount)
    exports['qb-management']:RemoveMoney(society:gsub("society_",""), amount)
end)


--player Player Section


AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
      return
    end
    local Players = QBCore.GetPlayers()

    for k, v in pairs(Players) do
        local xPlayer = QBCore.GetPlayerFromId(v)
        QBCore_Server_PlayerLoaded(xPlayer)
    end
end)


AddEventHandler('QBCore:Server:PlayerLoaded', function(xPlayer)
    QBCore_Server_PlayerLoaded(xPlayer)
end)

function QBCore_Server_PlayerLoaded(xPlayer)
    local _source = xPlayer.PlayerData.source
    xPlayer.Functions.AddField("identifier", xPlayer.PlayerData.citizenid)
    xPlayer.Functions.AddField("job", xPlayer.PlayerData.job)
    xPlayer.Functions.AddField("setCoords", function()
        if PlayerDebug then 
            print("No QB-Core Native equivalent xPlayer.setCoords function from ESX.. Self builded function here..")
        end 
        local Ped = GetPlayerPed(_source)
        local vector = type(coords) == "vector4" and coords or type(coords) == "vector3" and vector4(coords, 0.0) or
        vec(coords.x, coords.y, coords.z, coords.heading or 0.0)
        SetEntityCoords(Ped, vector.xyz, false, false, false, false)
        SetEntityHeading(Ped, vector.w)
    end)
    xPlayer.Functions.AddField("updateCoords", function(coords)
        if PlayerDebug then 
            print("QB-Core has no equivalent xPlayer.updateCoords function from ESX")
        end
    end)


    xPlayer.Functions.AddField("getCoords", function(coords)
        if PlayerDebug then 
            print("QB-Core has no equivalent xPlayer.getCoords function from ESX")
        end
    end)

    xPlayer.Functions.AddField("kick", function(reason)
        QBCore.Functions.Kick(_source, reason, nil, nil)
    end)

    xPlayer.Functions.AddField("setMoney", function(amount)
        xPlayer.Functions.SetMoney('cash', amount, nil)
    end)

    xPlayer.Functions.AddField("getMoney", function()
        return xPlayer.Functions.GetMoney('cash')
    end)

    xPlayer.Functions.AddField("addMoney", function(amount, reason)
        xPlayer.Functions.AddMoney('cash', amount, reason)
    end)

    xPlayer.Functions.AddField("removeMoney", function(amount, reason)
        xPlayer.Functions.RemoveMoney('cash', amount, reason)
    end)

    xPlayer.Functions.AddField("getIdentifier", function()
        return xPlayer.identifier
    end)

    xPlayer.Functions.AddField("setGroup", function(newGroup)
        if PlayerDebug then 
            print("QB-Core has no equivalent xPlayer.setGroup function from ESX")
        end 
    end)

    xPlayer.Functions.AddField("getGroup", function()
        return QBCore.Functions.GetPermission()
    end)

    xPlayer.Functions.AddField("set", function(k, v)
        xPlayer.Functions.AddField(k, v)
    end)

    xPlayer.Functions.AddField("get", function(k)
        return xPlayer[k]
    end)

    xPlayer.Functions.AddField("getAccounts", function(minimal)
        local retval = {}
        for k, v in pairs(xPlayer.PlayerData.money) do
            retval[k] = {money = xPlayer.Functions.GetMoney(k) or 0}
        end

        return retval
    end)

    xPlayer.Functions.AddField("getAccount", function(account)
        return {money = xPlayer.Functions.GetMoney(account)}
    end)

    xPlayer.Functions.AddField("getInventory", function(minimal)
        return xPlayer.PlayerData.items
    end)

    xPlayer.Functions.AddField("getJob", function()
        return xPlayer.PlayerData.job
    end)

    xPlayer.Functions.AddField("getLoadout", function()
        if PlayerDebug then 
            print("QB-Core has no Native equivalent xPlayer.getLoadout function from ESX")
        end 
        return {}
    end)

    xPlayer.Functions.AddField("getName", function()
        return xPlayer.PlayerData.name
    end)

    xPlayer.Functions.AddField("setName", function(newName)
        if PlayerDebug then 
            print("QB-Core has no Native equivalent xPlayer.setName function from ESX")
        end
    end)

    xPlayer.Functions.AddField("setAccountMoney", function(accountName, money, reason)
        if accountName == 'money' then
            accountName = 'cash'
        end
        xPlayer.Functions.SetMoney(accountName, money, reason)
    end)

    xPlayer.Functions.AddField("addAccountMoney", function(accountName, money, reason)
        if accountName == 'money' then
            accountName = 'cash'
        end
        xPlayer.Functions.AddMoney(accountName, money, reason)
    end)

    xPlayer.Functions.AddField("removeAccountMoney", function(accountName, money, reason)
        if accountName == 'money' then
            accountName = 'cash'
        end
        xPlayer.Functions.RemoveMoney(accountName, money, reason)
    end)

    xPlayer.Functions.AddField("getInventoryItem", function(name, metadata)
        local gi = xPlayer.Functions.GetItemByName(name) or {count = 0}
        gi.count = gi.amount or 0
        return gi
    end)

    xPlayer.Functions.AddField("addInventoryItem", function(name, count, metadata, slot)
        xPlayer.Functions.AddItem(name, count, slot or false)
    end)

    xPlayer.Functions.AddField("removeInventoryItem", function(name, count, metadata, slot)
        xPlayer.Functions.RemoveItem(name, count, slot or false)
    end)

    xPlayer.Functions.AddField("setInventoryItem", function(name, count, metadata, slot)
        xPlayer.Functions.AddItem(name, count, slot or false)
    end)

    xPlayer.Functions.AddField("getWeight", function()
        return xPlayer.Player.GetTotalWeight
    end)

    xPlayer.Functions.AddField("getMaxWeight", function()
        if PlayerDebug then 
            print("QB-Core has no Native equivalent xPlayer.getMaxWeight function from ESX.. return 1000000")
        end 
        return 1000000
    end)

    xPlayer.Functions.AddField("canCarryItem", function()
        if PlayerDebug then 
            print("QB-Core has no Native equivalent xPlayer.canCarryItem function from ESX.. AddItem checks it!")
        end
        return true
    end)
    
    xPlayer.Functions.AddField("canSwapItem", function()
        if PlayerDebug then 
            print("QB-Core has no Native equivalent xPlayer.canSwapItem function from ESX.. AddItem checks it!")
        end
        return true
    end)

    xPlayer.Functions.AddField("setMaxWeight", function()
        if PlayerDebug then 
            print("QB-Core has no Native equivalent xPlayer.setMaxWeight function from ESX.. AddItem checks it!")
        end
        return true
    end)

    xPlayer.Functions.AddField("setJob", function(job, grade)
        xPlayer.Functions.SetJob(job, grade)
    end)

    xPlayer.Functions.AddField("addWeapon", function(weaponName, ammo)
        xPlayer.Functions.AddItem(weaponName, 1, false)

        if QBCore.Shared[weaponName] and QBCore.Shared.Weapons[weaponName].ammotype then 
            xPlayer.Functions.AddItem(QBCore.Shared.Weapons[weaponName].ammotype, ammo, false)
        end 
    end)

    xPlayer.Functions.AddField("addWeaponComponent", function(weaponName, weaponComponent)
        xPlayer.Functions.AddItem(weaponComponent, 1, false)
    end)

    xPlayer.Functions.AddField("addWeaponAmmo", function(weaponName, ammoCount)
        if QBCore.Shared[weaponName] and QBCore.Shared.Weapons[weaponName].ammotype then 
            xPlayer.Functions.AddItem(QBCore.Shared.Weapons[weaponName].ammotype, ammoCount, false)
        end 
    end)

    xPlayer.Functions.AddField("updateWeaponAmmo", function(weaponName, ammoCount)
        if PlayerDebug then 
            print("QB-Core has no Native equivalent xPlayer.updateWeaponAmmo function from ESX.")
        end
    end)

    xPlayer.Functions.AddField("setWeaponTint", function(weaponName, weaponTintIndex)
        if PlayerDebug then 
            print("QB-Core has no Native equivalent xPlayer.setWeaponTint function from ESX. (qb-weapons handles it)")
        end
    end)

    xPlayer.Functions.AddField("getWeaponTint", function(weaponName)
        if PlayerDebug then 
            print("QB-Core has no Native equivalent xPlayer.setWeaponTint function from ESX. (qb-weapons handles it)")
        end
    end)

    xPlayer.Functions.AddField("removeWeapon", function(weaponName)
        xPlayer.Functions.RemoveItem(weaponName, 1, false)
    end)

    xPlayer.Functions.AddField("removeWeaponComponent", function(weaponName, weaponComponent)
        xPlayer.Functions.RemoveItem(weaponComponent, 1, false)
    end)

    xPlayer.Functions.AddField("removeWeaponAmmo", function(weaponName, ammoCount)
        if QBCore.Shared[weaponName] and QBCore.Shared.Weapons[weaponName].ammotype then 
            xPlayer.Functions.RemoveItem(QBCore.Shared.Weapons[weaponName].ammotype, ammoCount, false)
        end 
    end)

    xPlayer.Functions.AddField("removeWeaponAmmo", function(weaponName, weaponComponent)
        QBCore.Functions.HasItem(_source, weaponComponent, 1)
    end)

    xPlayer.Functions.AddField("removeWeaponAmmo", function(weaponName)
        QBCore.Functions.HasItem(_source, weaponName, 1)
    end)

    xPlayer.Functions.AddField("hasItem", function(item, metadata)
        QBCore.Functions.HasItem(_source, item, 1)
    end)

    xPlayer.Functions.AddField("getWeapon", function(weaponName)
        if PlayerDebug then 
            print("QB-Core has no Native equivalent xPlayer.getWeapon function from ESX.")
        end
        return nil
    end)

    xPlayer.Functions.AddField("showNotification", function(msg)
        QBCore.Functions.Notify(_source, msg)
    end)

    xPlayer.Functions.AddField("showHelpNotification", function(msg, thisFrame, beep, duration)
        QBCore.Functions.Notify(_source, msg)
    end)

    xPlayer.Functions.AddField("triggerEvent", function(eventName, ...)
        TriggerClientEvent(eventName, _source, ...)
    end)
end 


