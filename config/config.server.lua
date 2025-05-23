--  ▄▀▄ █▄ █ █   ▀▄▀   █▀ ▄▀▄ █▀▄   ██▀ ▄▀▀ ▀▄▀
--  ▀▄▀ █ ▀█ █▄▄  █    █▀ ▀▄▀ █▀▄   █▄▄ ▄██ █ █
if Config.Core == "ESX" then
    RegisterNetEvent('lotus_weapontest:sv:loadLicensesWithRestartScript', function()
        local src = source
        local xPlayer = ESX.GetPlayerFromId(src)
        if xPlayer then
            TriggerEvent('esx_license:getLicenses', src, function(licenses)
                TriggerClientEvent('lotus_weapontest:cl:getLicenses', src, licenses)
            end)
        end
    end)

    AddEventHandler(Config.PlayerLoaded, function(source)
        local src = source
        Citizen.Wait(8000)
        TriggerEvent('esx_license:getLicenses', src, function(licenses)
            TriggerClientEvent('lotus_weapontest:cl:getLicenses', src, licenses)
        end)
    end)
end


--  ▄▀▄ █▀▄ █▀▄   █   █ ▄▀▀ ██▀ █▄ █ ▄▀▀ ██▀
--  █▀█ █▄▀ █▄▀   █▄▄ █ ▀▄▄ █▄▄ █ ▀█ ▄██ █▄▄
RegisterNetEvent('lotus_weapontest:sv:addLicense', function(passed, type)
    local src = source
    if passed and type == 'weapon' then
        if Config.Core == "QB-Core" then
            local Player = QBCore.Functions.GetPlayer(src)
            if Player then
                Player.Functions.AddItem('weaponlicense', 1)
                TriggerClientEvent('lotus_weapontest:notification', src, "Silah lisansını başarıyla aldınız! (Envantere eklendi)", 'success')
            end
        elseif Config.Core == "ESX" then
            local xPlayer = ESX.GetPlayerFromId(src)
            if xPlayer then
                xPlayer.addInventoryItem('weaponlicense', 1)
                TriggerClientEvent('lotus_weapontest:notification', src, "Silah lisansını başarıyla aldınız! (Envantere eklendi)", 'success')
            end
        end
    else
        TriggerClientEvent('lotus_weapontest:notification', src, "Sınavdan geçemediniz.", 'error')
    end
end)