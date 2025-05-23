Config.OnVehicleSpawn = function(vehicle)
    TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
    SetVehicleEngineOn(vehicle, false, false, true)
    FreezeEntityPosition(vehicle, true)
    SetVehicleCustomPrimaryColour(vehicle, 255, 255, 255)
    SetVehicleCustomSecondaryColour(vehicle, 15, 15, 15)
    if Config.Core == "QB-Core" then
        TriggerEvent("vehiclekeys:client:SetOwner", QBCore.Functions.GetPlate(vehicle))
    end
end