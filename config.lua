return {
    Debug = false  -- @boolean | Enable debug mode ( true / false )
    -------------# Core #-------------

    Core = {
        Name = 'QBCore',
        -- vRP
        -- QBCore
        -- ESX
        ResourceName = 'qb-core' -- Name of the Core Resource
        -- i.e vRP => vrp
        -- i.e QBCore => qb-core
        -- i.e ESX => es_extended
    },

    -------------# Interactions #-------------

    Database = {
        Autofix = true -- @boolean | Fix the database if problems appear into it
    },

    -------------# Interactions #-------------

    Interactions = {
        Target = {
            Enabled = true,
            ResourceName = 'ox_target'
            -- Curently supported : ox_target | qb-target
        },
        TextUI = {
            Enabled = false,
            Open = function(text)
                -- exports['qb-core']:DrawText(text) -- ( QBCore )
                -- exports['esx_textui']:TextUI(text, 'info') ( ESX )
                -- exports['okokTextUI']:Open(text, 'lightgreen', 'left')
            end,
            Close = function()
                -- exports['qb-core']:HideText() -- ( QBCore )
                -- exports['esx_textui']:HideUI() ( ESX )
                -- exports['okokTextUI']:Close() ( okokTextUI )
            end
        }
    },

    -------------# Vehicle Resources #-------------

    Vehicle = {
        SetFuel = function(plate, fuel) -- Set the vehicle fuel
            exports['cdn-fuel']:SetFuel(vehicle, fuel)
        end,
        VehicleKeys = {
            UseVehiclesKeys = true, -- @boolean | Do you want to use vehicle keys ?
            GiveVehicleKeys = function(plate)
                TriggerEvent('vehiclekeys:client:SetOwner', plate)
            end
        }
    },

    -------------# Vehicles in Rent Menu #-------------

    Rent = {
        Category = {
            { name = "Cars" },
            { name = "Motorcycles" },
        },
    
        Vehicles = {
       
            ["Cars"]  = {
                {name = "Sultan", price = 250 , model = "sultan" , img = "https://raw.githubusercontent.com/MericcaN41/gta5carimages/main/images/sultan.png" },
                {name = "Brioso R/A", price = 300 , model = "brioso" , img = "https://raw.githubusercontent.com/MericcaN41/gta5carimages/main/images/brioso.png" },
                {name = "Dilettante", price = 350 , model = "dilettante" , img = "https://raw.githubusercontent.com/MericcaN41/gta5carimages/main/images/dilettante.png" },
                {name = "Issi", price = 270 , model = "issi2" , img = "https://raw.githubusercontent.com/MericcaN41/gta5carimages/main/images/issi2.png" },
                {name = "Panto", price = 175 , model = "panto" , img = "https://raw.githubusercontent.com/MericcaN41/gta5carimages/main/images/panto.png" },
                {name = "Prairie", price = 330 , model = "prairie" , img = "https://raw.githubusercontent.com/MericcaN41/gta5carimages/main/images/prairie.png" },
                {name = "Rhapsody", price = 278 , model = "rhapsody" , img = "https://raw.githubusercontent.com/MericcaN41/gta5carimages/main/images/rhapsody.png" },
            },
    
            ["Motorcycles"] = {
                { name = "Double", price = 350 , model = "double" , img = "https://raw.githubusercontent.com/MericcaN41/gta5carimages/main/images/double.png" },
                { name = "Daemon", price = 400 , model = "daemon" , img = "https://raw.githubusercontent.com/MericcaN41/gta5carimages/main/images/daemon.png" },
                { name = "Diablous", price = 250 , model = "diablous" , img = "https://raw.githubusercontent.com/MericcaN41/gta5carimages/main/images/diablous.png"} ,
                { name = "FCR", price = 400 , model = "fcr" , img = "https://raw.githubusercontent.com/MericcaN41/gta5carimages/main/images/fcr.png" },
                { name = "Hakuchou", price = 450 , model = "hakuchou" , img = "https://raw.githubusercontent.com/MericcaN41/gta5carimages/main/images/hakuchou.png" },
                { name = "NightBlade", price = 500 , model = "nightblade" , img = "https://raw.githubusercontent.com/MericcaN41/gta5carimages/main/images/nightblade.png" },
                { name = "Vader", price = 400 , model = "vader" , img = "https://raw.githubusercontent.com/MericcaN41/gta5carimages/main/images/vader.png" },
            },
        },
    },

    -------------# Boats in Rent Menu #-------------
    Boat = {
        Category = {
            {name = "Boats"}
        },
    
        Vehicles = {
            ["Boats"]  = {
                {name = "Sea Shark", price = 350 , model = "seashark" , img = "https://r2.fivemanage.com/ZrUYLRK1lGQX9xgdwjNb3/seaashark.png"},
                {name = "Dinghy", price = 350 , model = "dinghy" , img = "https://r2.fivemanage.com/ZrUYLRK1lGQX9xgdwjNb3/dinghyy.png"},
                {name = "Jetmax", price = 350 , model = "jetmax" , img = "https://r2.fivemanage.com/ZrUYLRK1lGQX9xgdwjNb3/jetmaxx.png"},
                {name = "Marquis", price = 350 , model = "marquis" , img = "https://r2.fivemanage.com/ZrUYLRK1lGQX9xgdwjNb3/marquiis.png"},
                {name = "Speeder", price = 350 , model = "speeder" , img = "https://r2.fivemanage.com/ZrUYLRK1lGQX9xgdwjNb3/speederr.png"},
                {name = "Toro", price = 350 , model = "toro" , img = "https://r2.fivemanage.com/ZrUYLRK1lGQX9xgdwjNb3/toroo.png"},
                {name = "Long fin", price = 350 , model = "longfin" , img = "https://r2.fivemanage.com/ZrUYLRK1lGQX9xgdwjNb3/longfin.png"},
            }
        },
    },

    -------------# Locations for the Rent Menu #-------------

    Locations = {
        [1] = {
            label = 'Vehicle Rental',
            coords = vector4(-1039.58, -2731.22, 20.21, 208.71),
            carspawn = vector4(-1036.82, -2729.24, 19.44, 240.37),
            categorie = "Rent",
            ped = 'csb_sol',
            scenario = 'WORLD_HUMAN_STAND_MOBILE',
            showblip = true,
            blipsprite = 225,
            blipscale = 0.6,
            blipcolor = 2,

            -- If Target is Enabled otherwise, leave it alone
            radius = 1.5,
            targetIcon = 'fas fa-car'
        },
        [2] = {
            label = 'Boat Rental',
            coords = vector4(-806.81, -1497.1, 1.6, 114.24),
            carspawn = vector4(-806.59, -1504.73, -0.09, 124.98),
            categorie = "Boat",
            ped = 'csb_sol',
            scenario = 'WORLD_HUMAN_CLIPBOARD',
            showblip = true,
            blipsprite = 356,
            blipscale = 0.6,
            blipcolor = 5,

            -- If Target is Enabled otherwise, leave it alone
            radius = 1.5,
            targetIcon = 'fas fa-ship'
        },
    }
}