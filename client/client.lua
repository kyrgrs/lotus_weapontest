local playerLicenses, ownLicenses = {}, {}
local openedMenu = false
local isLicensesNotLoaded = false

if Config.Core == "ESX" then
    ESX = Config.CoreExport()
    RegisterNetEvent('lotus_weapontest:cl:getLicenses')
    AddEventHandler('lotus_weapontest:cl:getLicenses', function(licenses)
        playerLicenses = licenses
    end)
elseif Config.Core == "QB-Core" then
    QBCore = Config.CoreExport()
    PlayerData = QBCore.Functions.GetPlayerData()
    RegisterNetEvent('lotus_weapontest:cl:getLicenses')
    AddEventHandler('lotus_weapontest:cl:getLicenses', function()
        PlayerData = QBCore.Functions.GetPlayerData()
    end)
    RegisterNetEvent(Config.PlayerLoaded)
    AddEventHandler(Config.PlayerLoaded, function()
        PlayerData = QBCore.Functions.GetPlayerData()
    end)
end

openMenu = function()
    if not isLicensesNotLoaded and Config.Core == "ESX" and ESX.GetPlayerData() then
        TriggerServerEvent('lotus_weapontest:sv:loadLicensesWithRestartScript')
        isLicensesNotLoaded = true
        Citizen.Wait(200)
    end

    local elements = {}
    local hasLicense = false

    if Config.Core == "ESX" then
        ownLicenses = {}
        for k, v in pairs(playerLicenses) do
            ownLicenses[v.type] = true
        end
        hasLicense = ownLicenses[Config.Licenses.Theory['WEAPON'].name]
    elseif Config.Core == "QB-Core" then
        hasLicense = PlayerData.metadata and PlayerData.metadata['licences'] and PlayerData.metadata['licences'][Config.Licenses.Theory['WEAPON'].name]
    end

    if Config.Licenses.Theory['WEAPON'].enabled and not hasLicense then
        elements[#elements + 1] = {
            icon = "fas fa-gun",
            label = "Ruhsat Sınavı (" .. Config.Licenses.Theory['WEAPON'].price .. "$)",
            value = "theory_weapon"
        }
    end

    if Config.Zones["menu"].menuType == "esx_menu_default" then
        openedMenu = true
        ESX.UI.Menu.CloseAll()
        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'menu', {
            title    = "Ruhsat Sınavı",
            elements = elements,
            align    = Config.Zones['menu'].menuPosition,
        }, function(data, menu)
            menu.close()
            if data.current.value == "theory_weapon" then
                TriggerServerEvent('lotus_weapontest:sv:buyExam', {type = 'Theory', category = 'WEAPON'})
            end
        end, function(data, menu)
            menu.close()
            openedMenu = false
        end)
    elseif Config.Zones["menu"].menuType == "esx_context" then
        ESX.CloseContext()
        local contextElements = {
            {unselectable = true, icon = "fas fa-gun", title = "Ruhsat Sınavı"}
        }
        for _, v in ipairs(elements) do
            contextElements[#contextElements + 1] = {icon = v.icon, title = v.label, value = v.value}
        end
        ESX.OpenContext(Config.Zones['menu'].menuPosition, contextElements, function(menu, element)
            ESX.CloseContext()
            if element.value == "theory_weapon" then
                TriggerServerEvent('lotus_weapontest:sv:buyExam', {type = 'Theory', category = 'WEAPON'})
            end
        end)
    elseif Config.Zones["menu"].menuType == "qb-menu" then
        local qbElements = {
            {icon = "fas fa-gun", header = "Ruhsat Sınavı", isMenuHeader = true},
        }
        for _, v in ipairs(elements) do
            qbElements[#qbElements + 1] = {
                icon = v.icon,
                header = v.label,
                params = {
                    isAction = true,
                    event = function()
                        TriggerServerEvent('lotus_weapontest:sv:buyExam', {type = "Theory", category = "WEAPON"})
                    end
                }
            }
        end
        exports['qb-menu']:openMenu(qbElements)
    elseif Config.Zones["menu"].menuType == "ox_lib" then
        openedMenu = true
        local oxElements = {}
        for _, v in ipairs(elements) do
            oxElements[#oxElements + 1] = {
                icon = v.icon,
                title = v.label,
                onSelect = function()
                    TriggerServerEvent('lotus_weapontest:sv:buyExam', {type = 'Theory', category = 'WEAPON'})
                end,
                onExit = function()
                    openedMenu = false
                end
            }
        end
        exports['ox_lib']:registerContext({
            id = "weaponlicense-menu",
            title = "Ruhsat Sınavı",
            options = oxElements,
            onExit = function()
                openedMenu = false
            end
        })
        exports['ox_lib']:showContext('weaponlicense-menu')
    end
end

RegisterNetEvent('lotus_weapontest:openMenu', function()
    openMenu()
end)

Citizen.CreateThread(function()
    local blipData = Config.Zones["menu"].blip
    local blip = AddBlipForCoord(Config.Zones["menu"].coords)
    SetBlipSprite(blip, blipData.sprite)
    SetBlipDisplay(blip, blipData.display)
    SetBlipScale(blip, blipData.scale)
    SetBlipColour(blip, blipData.color)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(blipData.name)
    EndTextCommandSetBlipName(blip)
end)

Citizen.CreateThread(function()
    local inRange = false
    local shown = false
    local sleep = true
    while Config.AccessOnMarker do
        inRange = false
        sleep = true
        local myPed = PlayerPedId()
        local myCoords = GetEntityCoords(myPed)
        local distance = #(Config.Zones["menu"].coords - myCoords)
        if distance < 25.0 then
            sleep = false
            if distance < 15.0 then
                if not isLicensesNotLoaded and Config.Core == "ESX" and ESX.GetPlayerData() then
                    TriggerServerEvent('lotus_weapontest:sv:loadLicensesWithRestartScript')
                    isLicensesNotLoaded = true
                end
                DrawMarker(Config.Zones["menu"].marker.id, Config.Zones["menu"].coords, 0, 0, 0, 0, 0, 0, Config.Zones["menu"].marker.scale, Config.Zones["menu"].marker.color[1], Config.Zones["menu"].marker.color[2], Config.Zones["menu"].marker.color[3], Config.Zones["menu"].marker.color[4], Config.Zones["menu"].marker.bobUpAndDown, false, false, Config.Zones["menu"].marker.rotate, false, false, false)
                if distance < Config.Zones["menu"].marker.scale.x+.15 then
                    if not openedMenu then
                        inRange = true
                        if Config.Core == "ESX" and not Config.Interact.Enabled then
                            ESX.ShowHelpNotification(Config.Translate['open_menu'])
                        end
                        if IsControlJustPressed(0, 38) then
                            openMenu()
                            inRange = false
                        end
                    end
                end
            end
        end
        if Config.Interact.Enabled then
            if inRange and not shown then
                shown = true
                Config.Interact.Open(Config.Translate['open_menu'])
            elseif not inRange and shown then
                shown = false
                Config.Interact.Close()
            end
        end
        Citizen.Wait(sleep and 2000 or 1)
    end
end)

startTheoretical = function(category)
    SendNUIMessage({action = 'openTheory', category = category, questions = Config.Questions[category]})
    SetNuiFocus(true, true)
    SetTimecycleModifier(Config.EnableBlur and 'hud_def_blur')
end

RegisterNetEvent('lotus_weapontest:cl:startExam', function(type, category)
    if type == "Theory" and category == "WEAPON" then
        startTheoretical(category)
    end
end)

RegisterNUICallback('action', function(data, cb)
    if data.action == "close" then
        SetNuiFocus(false, false)
        SendNUIMessage({action = 'closeTheory'})
        openedMenu = false
        TriggerServerEvent('lotus_weapontest:sv:addLicense', data.passed, 'weapon')
        SetTimecycleModifier(Config.EnableBlur and 'default')
    end
end)

RegisterNetEvent('lotus_weapontest:notification', function(message, type, enableAccessMenu)
    Config.Notification(message, type)
    if enableAccessMenu then
        openedMenu = false
    end
end)