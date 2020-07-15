local PlayerJob = ""
local PlayerJobGrade = 0

RegisterNetEvent("rFw:JobChange")
AddEventHandler("rFw:JobChange", function(job, grade)
    PlayerJob = job
    PlayerJobGrade = grade

    if PlayerJob == "Mechanic" then
        loadMechanicJob()
    end
end)

Citizen.CreateThread(function()
    while not exports.rFw:IsPlayerLoaded() do Wait(100) end
    PlayerJob, PlayerJobGrade = exports.rFw:GetPlayerJob()

    if PlayerJob == "Mechanic" then
        loadMechanicJob()
    end
end)


function loadMechanicJob() -- All things in this will only be loaded if you have the Mechanic job
    local MenuOpen = false

    RegisterKeyMapping("openmechmenu", "Open mechanic menu", 'keyboard', "F6")
    RegisterCommand("openmechmenu", function()
        OpenMechanicMenu()
    end, false)

    RMenu.Add('mechanic', 'main', RageUI.CreateMenu("Mechanic", ""))
    RMenu:Get('mechanic', 'main'):SetSubtitle("~b~Mechanic action menu")
    RMenu:Get('mechanic', 'main').EnableMouse = false
    RMenu:Get('mechanic', 'main').Closed = function()
        MenuOpen = false
    end;

    
    function OpenMechanicMenu()
        if PlayerJob ~= "Mechanic" then return end -- if the player was a mechanic but change job, this will prevent the menu to be usable
        if MenuOpen then
            MenuOpen = false
            return
        else
            RageUI.Visible(RMenu:Get('mechanic', 'main'), true)
            MenuOpen = true
            Citizen.CreateThread(function()
                while MenuOpen do
                    RageUI.IsVisible(RMenu:Get('mechanic', 'main'), true, true, true, function()
                        RageUI.Button("Repair", "Repair the closet car", true, function(Hovered, Active, Selected)
                            if (Selected) then
                                local veh = GetClosestVehicle()
                                SetVehicleFixed(veh)
                                SetVehicleDeformationFixed(veh)
                            end
                        end)
                        RageUI.Button("Clean", "Clean the closet car", true, function(Hovered, Active, Selected)
                            if (Selected) then
                                local veh = GetClosestVehicle()
                                SetVehicleDirtLevel(veh, 0.0)
                            end
                        end)
                
                    end, function()
                    end)
                    Wait(1)
                end
            end)
        end
    end
end