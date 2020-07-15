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


local entityEnumerator = {
	__gc = function(enum)
		if enum.destructor and enum.handle then
			enum.destructor(enum.handle)
		end

		enum.destructor = nil
		enum.handle = nil
	end
}

local function EnumerateEntities(initFunc, moveFunc, disposeFunc)
	return coroutine.wrap(function()
		local iter, id = initFunc()
		if not id or id == 0 then
			disposeFunc(iter)
			return
		end

		local enum = {handle = iter, destructor = disposeFunc}
		setmetatable(enum, entityEnumerator)

		local next = true
		repeat
		coroutine.yield(id)
		next, id = moveFunc(iter)
		until not next

		enum.destructor, enum.handle = nil, nil
		disposeFunc(iter)
	end)
end

function EnumerateObjects()
	return EnumerateEntities(FindFirstObject, FindNextObject, EndFindObject)
end

function EnumeratePeds()
	return EnumerateEntities(FindFirstPed, FindNextPed, EndFindPed)
end

function EnumerateVehicles()
	return EnumerateEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle)
end

function EnumeratePickups()
	return EnumerateEntities(FindFirstPickup, FindNextPickup, EndFindPickup)
end

exports.rFw:RegisterItemAction("repairkit", function()
	print("Ouai l'item repairkit est utilisé")
end)

RegisterCommand("repaircmd", function(source, args, rawCommand)
	exports.rFw:UseItem("repairkit")
end, false)

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