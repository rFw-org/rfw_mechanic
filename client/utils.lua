GetVehicles = function()
	local vehicles = {}

	for vehicle in EnumerateVehicles() do
		table.insert(vehicles, vehicle)
	end

	return vehicles
end

GetClosestVehicle = function(coords)
	local vehicles        = GetVehicles()
	local closestDistance = -1
	local closestVehicle  = -1
	local coords          = coords

	if coords == nil then
		local playerPed = PlayerPedId()
		coords          = GetEntityCoords(playerPed)
	end

	for i=1, #vehicles, 1 do
		local vehicleCoords = GetEntityCoords(vehicles[i])
		local distance      = GetDistanceBetweenCoords(vehicleCoords, coords.x, coords.y, coords.z, true)

		if closestDistance == -1 or closestDistance > distance then
			closestVehicle  = vehicles[i]
			closestDistance = distance
		end
	end

	return closestVehicle, closestDistance
end

function GetEntityOwner(entity)
	local owner = NetworkGetEntityOwner(entity)
	return GetPlayerServerId(owner)
end

exports.rFw:RegisterNewItem("repairkit", "Repair kit", 1)

exports.rFw:RegisterItemAction("repairkit", function() -- Need to do animation later
	local veh = GetClosestVehicle()
	local owner = GetEntityOwner(veh)
	TriggerServerEvent(config.prefix.."RepairVehicle", owner, VehToNet(veh))
end)

--RegisterCommand("repaircmd", function(source, args, rawCommand)
--	exports.rFw:UseItem("repairkit")
--end, false)

RegisterNetEvent(config.prefix.."RepairVehicle")
AddEventHandler(config.prefix.."RepairVehicle", function(net)
	local veh = NetToVeh(net)
	SetVehicleFixed(veh)
	SetVehicleDeformationFixed(veh)
end)

RegisterNetEvent(config.prefix.."CleanVehicle")
AddEventHandler(config.prefix.."CleanVehicle", function(net)
	local veh = NetToVeh(net)
	SetVehicleDirtLevel(veh, 0.0)
end)