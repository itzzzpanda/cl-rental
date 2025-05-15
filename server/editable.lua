--@param source | The player's server ID
--@param model | The model of the vehicle
--@param plate | The plate of the vehicle
--@param day | The number of days the vehicle will be rented
function CreateCar(source, model, plate, day)
    local currentDate = os.date('%Y-%m-%d')  
    local daysToAdd = day 
    local rentFinishDate = os.date('%Y-%m-%d', os.time() + daysToAdd * 24 * 60 * 60) 

    if Config.Core.Name == 'vRP' then
        local Player = vRP.getUserId({source})

        MySQL.insert.await('INSERT INTO vrp_user_vehicles ( user_id, vehicle, vehicle_plate, upgrades, vId, stage, rentfinish ) VALUES ( ?, ?, ?, ?, ?, ?, ? )', {
            Player,
            model,
            plate,
            json.encode(prop),
            1,
            0,
            rentFinishDate
        })
    elseif Config.Core.Name == 'ESX' then
        local xPlayer = Core.GetPlayerFromId(source) 

        MySQL.insert.await('INSERT INTO owned_vehicles (owner, plate, vehicle, type, stored, rentfinish) VALUES (?, ?, ?, ?, ?, ?)', {
            xPlayer.identifier,  
            plate,
            json.encode({model = model}),  
            'car',
            1, 
            rentFinishDate
        })
    elseif Config.Core.Name == 'QBCore' then
        local Player = Core.Functions.GetPlayer(source) 

        MySQL.insert.await('INSERT INTO player_vehicles (license, citizenid, vehicle, hash, mods, plate, state, rentfinish) VALUES (?, ?, ?, ?, ?, ?, ?, ?)', {
            Player.PlayerData.license,
            Player.PlayerData.citizenid,
            model, 
            GetHashKey(model),
            json.encode(prop),
            plate,
            0,
            rentFinishDate
        }) 
    end
end


--@param None
--@return The name of the database table for the AutoFix
function GetDatabaseName()
    if Config.Core.Name == 'QBCore' then
        return "player_vehicles"
    elseif Config.Core.Name == 'ESX' then
        return "owned_vehicles"
    elseif Config.Core.Name == 'vRP' then
        return "vrp_user_vehicles"
    end
end