RegisterNetEvent(config.prefix.."RepairVehicle")
AddEventHandler(config.prefix.."RepairVehicle", function(id, net)
    TriggerClientEvent(config.prefix.."RepairVehicle", id, net)
end)

RegisterNetEvent(config.prefix.."CleanVehicle")
AddEventHandler(config.prefix.."CleanVehicle", function(id, net)
    TriggerClientEvent(config.prefix.."CleanVehicle", id, net)
end)