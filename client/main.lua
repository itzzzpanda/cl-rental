Core = nil
Config = require 'config'

pedSpawned = false
rentalPed = {}
spawncarcoords = nil

if Config.Core.Name == 'vRP' then
    Core = Proxy.getInterface("vRP")
elseif Config.Core.Name == 'QBCore' then
    Core = exports[Config.Core.ResourceName]:GetCoreObject()
elseif Config.Core.Name == 'ESX' then 
    Core = exports[Config.Core.ResourceName]:getSharedObject()
else
    print("The frmework " .. Config.Core.Name .. " is not supported. Check the README.MD to see the supported scripts")
end

lib.locale()

function openRentMenu(data)
    SendNUIMessage({
        action = "OPEN",
        data = data,
        locales = lib.getLocales()
    })
    SetNuiFocus(true, true)
end

function createCar(data)
    local playerPed = PlayerPedId()
    local coords    = spawncarcoordsnui
    local vehicle   = GetHashKey(data.carName)
    RequestModel(vehicle)

    while not HasModelLoaded(vehicle) do
        Citizen.Wait(0)
    end

    local vehicle = CreateVehicle(vehicle, spawncarcoords, 90.0, true, false)
    SetVehicleColours(vehicle, 12, 12)
    SetVehicleWindowTint(vehicle, 1)
    SetPedIntoVehicle(playerPed, vehicle, -1)
    GeneratePlate()
    SetVehicleNumberPlateText(vehicle,  GeneratePlate())
    local plate = GetVehicleNumberPlateText(vehicle) 
    Config.Vehicle.SetFuel(vehicle, 100)
    if Config.Vehicle.VehicleKeys.UseVehiclesKeys then 
        Config.Vehicle.VehicleKeys.GiveVehicleKeys(plate)
    end
    TriggerServerEvent('cl-rental:Server:createCar', data.carName, GetVehicleNumberPlateText(vehicle) , data.carDay)
end


function createBlips()
    if pedSpawned then return end

    for store in pairs(Config.Locations) do
        if Config.Locations[store].showblip then
            local StoreBlip = AddBlipForCoord(Config.Locations[store].coords.x, Config.Locations[store].coords.y, Config.Locations[store].coords.z)
            SetBlipSprite(StoreBlip, Config.Locations[store].blipsprite)
            SetBlipScale(StoreBlip, Config.Locations[store].blipscale)
            SetBlipDisplay(StoreBlip, 4)
            SetBlipColour(StoreBlip, Config.Locations[store].blipcolor)
            SetBlipAsShortRange(StoreBlip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentSubstringPlayerName(Config.Locations[store].label)
            EndTextCommandSetBlipName(StoreBlip)
        end
    end
end

function deletePeds()
    if not pedSpawned then return end
    for _, v in pairs(rentalPed) do
        DeletePed(v)
    end
    pedSpawned = false
end

-- Event Handlers --

if Config.Core.Name == 'QBCore' then
    RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
        createPeds()
        createBlips()
    end)
elseif Config.Core.Name == 'ESX' then
    RegisterNetEvent('esx:playerLoaded', function()
        createPeds()
        createBlips()
    end)
elseif Config.Core.Name == 'vRP' then 
    AddEventHandler('playerSpawned', function()
        createBlips()
        createPeds()
    end)
end        

AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    createBlips()
    createPeds()
end)

AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    deletePeds()
end)

---- NUI Callbacks ----

RegisterNUICallback('close', function()
    SetNuiFocus(false, false)
end)

RegisterNUICallback('rent', function(data)
    lib.callback('cl-rental:Server:Rent', false, function(status)
        if status then
            if Config.Core.Name == 'vRP' then
                Core.Notify(locale("success.paid", data.carPrice))
            elseif Config.Core.Name == 'QBCore' then
                Core.Functions.Notify(locale("success.paid", data.carPrice), 'success')
            elseif Config.Core.Name == 'ESX' then 
                Core.ShowNotification(locale("success.paid", data.carPrice), "success", 5000)
            end
            createCar(data)
        else
            if Config.Core.Name == 'vRP' then
                Core.Notify(locale("error.not_enough"))
            elseif Config.Core.Name == 'QBCore' then
                Core.Functions.Notify(locale("error.not_enough"), 'error')
            elseif Config.Core.Name == 'ESX' then 
                Core.ShowNotification(locale("error.not_enough"), "error", 5000)
            end
        end
    end, data)
end)
