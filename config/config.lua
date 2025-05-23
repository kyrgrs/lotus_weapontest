Config = {}

-- █▀ █▀▄ ▄▀▄ █▄ ▄█ ██▀ █   █ ▄▀▄ █▀▄ █▄▀
-- █▀ █▀▄ █▀█ █ ▀ █ █▄▄ ▀▄▀▄▀ ▀▄▀ █▀▄ █ █
Config.Core = "QB-Core" -- "ESX" / "QB-Core"
Config.CoreExport = function()
    -- return exports['es_extended']:getSharedObject()
    return exports['qb-core']:GetCoreObject()
end

Config.PlayerLoaded = 'QBCore:Client:OnPlayerLoaded'
-- @Config.PlayerLoaded for ESX: 'esx:playerLoaded'
-- @Config.PlayerLoaded for QB-Core: 'QBCore:Client:OnPlayerLoaded'

Config.Notification = function(message, type)
    if type == "success" then
        -- TriggerEvent('esx:showNotification', message)
        TriggerEvent('QBCore:Notify', message, 'success', 5000)
    elseif type == "error" then
        -- TriggerEvent('esx:showNotification', message)
        TriggerEvent('QBCore:Notify', message, 'error', 5000)
    end
end

Config.Interact = {
    Enabled = false,
    Open = function(message)
        exports["interact"]:Open("E", message) -- Here you can use your TextUI or use my free one - https://github.com/vames-dev/interact
        exports['qb-core']:DrawText(message, 'right')
    end,
    Close = function()
        exports["interact"]:Close() -- Here you can use your TextUI or use my free one - https://github.com/vames-dev/interact
        exports['qb-core']:HideText()
    end,
}


-- ▀█▀ █▀▄ ▄▀▄ █▄ █ ▄▀▀ █   ▄▀▄ ▀█▀ ██▀
--  █  █▀▄ █▀█ █ ▀█ ▄██ █▄▄ █▀█  █  █▄▄
Config.Translate = {
    ['open_menu'] = "Menüyü açmak için ~INPUT_CONTEXT~ tuşuna basın",
    ['not_enough_cash'] = "Bu sınav için yeterli nakit paranız yok.",
    ['not_enough_cash_and_bank'] = "Nakit ve banka bakiyeniz bu sınav için yetersiz.",
}


-- █▄ ▄█ ▄▀▄ █ █▄ █   ▄▀▀ ██▀ ▀█▀ ▀█▀ █ █▄ █ ▄▀  ▄▀▀
-- █ ▀ █ █▀█ █ █ ▀█   ▄██ █▄▄  █   █  █ █ ▀█ ▀▄█ ▄██
Config.AccessOnMarker = true -- Do you want to use access to the exam selection menu as E in marker?
Config.UseTarget = false
Config.TargetResource = 'qb-target'
Config.Target = function()
    exports[Config.TargetResource]:addBoxZone({
        coords = vec(Config.Zones["menu"].coords.x, Config.Zones["menu"].coords.y, Config.Zones["menu"].coords.z+0.35),
        size = vec(4.0, 4.0, 4.0),
        debug = false,
        useZ = true,
        rotation = 60,
        distance = 9.0,
        options = {
            {
                name = 'weapontest',
                event = 'lotus_weapontest:openMenu',
                icon = 'fa-regular fa-file-lines',
                label = "Ruhsat Sınavı"
            }
        }
    })
end


Config.UseSoundsUI = true -- Do you want to use interaction sounds in the UI?
Config.EnableBlur = true -- Do you want to blur the background in the game when you have the UI running?

Config.PossibleChargeByBank = true -- if you set it true, when the player does not have enough cash, it will try to take it from his bank account

Config.EnableMaxSpeedLoop = true
Config.MaxSpeedLoopTimeout = 1000 -- if Config.EnableMaxSpeedLoop = true and exceeds the maximum speed, will have 1 second (1000 milliseconds) to reduce the speed, otherwise another error will be charged
Config.MaxSpeed = 50 -- if you don't want a speed limit set nil
Config.SpeedMultiplier = 3.6 -- kmh = 3.6 / mph = 2.236936

Config.MaxDriveErrors = 5 -- How much maximum a player can get bugs for vehicle damage, on 5 will require going back to driving school and failing the test

Config.CheckIsManeuveringAreaIsOccupied = true -- If the maneuvering area is occupied, the practical exam will not start and the player will receive notification about it

Config.Examiner = {
    Enabled = true, -- Do you want to use a ped as an examiner who sits with the player in the vehicle?
    SpokenCommands = true,
    SpokenLanguage = "FR", -- "EN", "DE", "BG", "ES", "FR", "PT"
    PedModel = 'ig_fbisuit_01' -- https://wiki.rage.mp/index.php?title=Peds
}

Config.Licenses = {
    Theory = {
        ['WEAPON'] = {name = 'weaponlicense', price = 500, enabled = true},
    },
}

Config.Questions = {
    ['WEAPON'] = {
        QuestionsCount = 8, -- Number of all questions for the draw pool
        QuestionToAnswer = 8, -- Questions the player will have to answer
        NeedAnswersToPass = 8, -- Number of questions a player must answer correctly to pass the theory exam
    },
}

Config.Zones = {
    ["menu"] = {
        menuType = "ox_lib", -- "esx_menu_default" / "esx_context" / "qb-menu" / "ox_lib"
        menuPosition = 'left', -- only for esx_menu_default and esx_context
        coords = vector3(441.31, -982.01, 30.69),
        marker = {
            id = 30, -- https://docs.fivem.net/docs/game-references/markers/
            color = {115, 255, 115, 120}, -- R(ed), G(reen), B(lue), A(lpha)
            scale = vec(0.65, 0.65, 0.65),
            bobUpAndDown = false, -- jumping marker
            rotate = true -- rotating marker
        },
        blip = { -- https://docs.fivem.net/docs/game-references/blips/
            sprite = 313,
            display = 4,
            scale = 0.4,
            color = 1,
            name = "Ruhsat Sınavı",
        }
    },
}
