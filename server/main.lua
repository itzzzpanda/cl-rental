Core = nil
local ped = nil
Config = require 'config'

if Config.Core.Name == 'vRP' then
    Tunnel = module("vrp", "lib/Tunnel")
    Proxy = module("vrp", "lib/Proxy")
    vRP = Proxy.getInterface("vRP")
    vRPClient = Tunnel.getInterface("vRP", GetCurrentResourceName())
elseif Config.Core.Name == 'QBCore' then
    Core = exports[Config.Core.ResourceName]:GetCoreObject()
elseif Config.Core.Name == 'ESX' then 
    Core = exports[Config.Core.ResourceName]:getSharedObject()
else
    print("The framework " .. Config.Core.Name .. " is not supported. Check the README.MD to see the supported scripts")
end

function CheckDate()
    if Config.Core.Name == 'vRP' then
        MySQL.Async.execute("DELETE FROM vrp_user_vehicles WHERE rentfinish < NOW()", {})
    elseif Config.Core.Name == 'ESX' then
        MySQL.Async.execute("DELETE FROM owned_vehicles WHERE rentfinish < NOW()", {})
    elseif Config.Core.Name == 'QBCore' then
        MySQL.Async.execute("DELETE FROM player_vehicles WHERE rentfinish < NOW()", {})
    end
end

RegisterServerEvent('cl-rental:Server:createCar', function(model, plate, day)
    CreateCar(source, model, plate, day)
end)

lib.callback.register('cl-rental:Server:Rent', function(source, data)
    if Config.Core.Name == 'vRP' then
        local Player = vRP.getUserId({source})
        if data.payType == 'cash' then
            if vRP.getMoney({source}) >= tonumber(data.carPrice) then
                vRP.tryPayment({source, tonumber(data.carPrice)})
                return true
            else 
                return false
            end
        else
            if vRP.getBankMoney({source}) >= tonumber(data.carPrice) then
                vRP.tryBankPayment({source, tonumber(data.carPrice)})
                return true
            else
                return false
            end
        end
    elseif Config.Core.Name == 'ESX' then
        local Player = Core.GetPlayerFromId(source)

        if data.payType == 'cash' then 
            if Player.getAccount('money').money >= tonumber(data.carPrice) then
                Player.removeMoney(tonumber(data.carPrice), 'Rented vehicle')
                return true
            else 
                return false
            end
        else
            if Player.getAccount('bank').money >= tonumber(data.carPrice) then           

                Player.removeAccountMoney('bank', tonumber(data.carPrice))
                return true
            else
                return false
            end
        end
    elseif Config.Core.Name == 'QBCore' then 
        local Player = Core.Functions.GetPlayer(source)
        if data.payType == "cash" then
            if Player.Functions.GetMoney(data.payType) >= tonumber(data.carPrice) then
                Player.Functions.RemoveMoney('cash', tonumber(data.carPrice))
                return true
            end
            return false
        else        
            if Player.PlayerData.money.bank >= tonumber(data.carPrice) then
                Player.Functions.RemoveMoney(data.payType, tonumber(data.carPrice))
                return true
            end
            return false
        end
    end
end)

------------- Checkers ---------------

AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() == resourceName) then 
        if ped ~= nil then
            DeletePed(ped)
        end

        TriggerEvent('pnRental:createPed')

        if Config.Core.Name == 'vRP' then
            MySQL.Async.execute("DELETE FROM vrp_user_vehicles WHERE rentfinish < NOW()", {})
        elseif Config.Core.Name == 'ESX' then
            MySQL.Async.execute("DELETE FROM owned_vehicles WHERE rentfinish < NOW()", {})
        elseif Config.Core.Name == 'QBCore' then
           MySQL.Async.execute("DELETE FROM player_vehicles WHERE rentfinish < NOW()", {})
        end

        if Config.Database.Autofix then
            AutoFixDatabase()
        end
        
        return
    end
end)

function AutoFixDatabase()
    local tableName = nil

    GetDatabaseName()

    if tableName then
       local query = "SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = ? AND COLUMN_NAME = 'rentfinish'"
        
        MySQL.query(query, {tableName}, function(result)
            if #result == 0 then
                print("[cl-rental] Column 'rentfinish' isn't present in table " .. tableName)

                local alterQuery = string.format("ALTER TABLE %s ADD rentfinish DATE NOT NULL DEFAULT '2999-06-01'", tableName)
                
                MySQL.update(alterQuery, {}, function()
                    print("[cl-rental] Column 'rentfinish' has been added to " .. tableName)
                end)
            end
        end)
    end
end

Citizen.CreateThread(function()
    while true do
        CheckDate()
        Wait(86400000)
    end
end)