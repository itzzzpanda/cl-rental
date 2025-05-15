function createPeds()
    if pedSpawned then return end

    for k, v in pairs(Config.Locations) do
        local current = type(v.ped) == "number" and v.ped or joaat(v.ped)

        RequestModel(current)
        while not HasModelLoaded(current) do
            Wait(0)
        end

        rentalPed[k] = CreatePed(0, current, v.coords.x, v.coords.y, v.coords.z - 1, v.coords.w, false, false)
        TaskStartScenarioInPlace(rentalPed[k], v.scenario, 0, true)
        FreezeEntityPosition(rentalPed[k], true)
        SetEntityInvincible(rentalPed[k], true)
        SetBlockingOfNonTemporaryEvents(rentalPed[k], true)
        if Config.Interactions.Target.Enabled and Config.Interactions.Target.ResourceName == 'qb-target' then
            exports['qb-target']:AddTargetEntity(rentalPed[k], {
                options = {
                    {
                        label = locale("target.open"),
                        icon = v.targetIcon,
                        action = function()
                            spawncarcoords = v.carspawn,
                            openRentMenu(Config[v.categorie])
                        end,
                    }
                },
                distance = 2.0
            })
        elseif Config.Interactions.Target.Enabled and Config.Interactions.Target.ResourceName == 'ox_target' then
            exports.ox_target:addLocalEntity(rentalPed[k], {
                {
                    label = locale("target.open"),
                    icon = v.targetIcon,
                    onSelect = function()
                        spawncarcoords = v.carspawn,
                        openRentMenu(Config[v.categorie])
                    end,
                    distance = 2.0
                }
            })
        elseif Config.Interactions.Target.Enabled and Config.Interactions.Target.ResourceName == 'custom' then
            print('The Target system you selected is not supported. Edit cl-rental > client > editable.lua > 43th line to add suport to custom one')
        end

        if Config.Interactions.TextUI.Enabled then
            lib.zones.box({
                coords = vec3(v.coords.x, v.coords.y, v.coords.z),
                size = vec3(1.5, 1.5, 1.5),
                debug = false,
                onEnter = function()
                    Config.Interactions.TextUI.Open(locale("textui.open"))
                end,
                inside = function()
                    if IsControlJustPressed(0, 38) then 
                        spawncarcoords = v.carspawn,
                        openRentMenu(Config[v.categorie])
                    end
                end,
                onExit = function()
                    Config.Interactions.TextUI.Close()
                end
            })
        end
    end

    pedSpawned = true
end


-- Function to generate a random plate number
-- @return A random plate number in the format LS99ABC
function GeneratePlate()
    local plate = 'LS' .. math.random(10, 99) .. string.char(math.random(65, 90)) .. string.char(math.random(65, 90)) .. string.char(math.random(65, 90))
    return plate
end