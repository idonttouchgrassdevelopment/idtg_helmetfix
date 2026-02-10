local lastPed = 0

local function dprint(msg)
    if Config.Debug then
        print(('[idtg_helmetfix] %s'):format(msg))
    end
end

local function removeHelmetHard(ped)
    -- Prevent ped from auto-equipping helmets (bike/mask behavior)
    SetPedHelmet(ped, false)

    -- Only remove prop if it's actually a helmet, so hats/caps aren't constantly stripped
    if IsPedWearingHelmet(ped) then
        RemovePedHelmet(ped, true)
        ClearPedProp(ped, 0)
    end
end

local function applyHelmetFix(ped)
    ped = ped or PlayerPedId()
    if not ped or ped == 0 or not DoesEntityExist(ped) then return end

    if Config.ForceCriticalHits then
        -- Ensure headshots are critical/lethal
        SetPedSuffersCriticalHits(ped, true)
    end

    if Config.DisableHelmetDamageReduction then
        -- Community-used flag to remove helmet bullet resistance behavior
        SetPedConfigFlag(ped, Config.HelmetConfigFlag or 438, true)
    end

    if Config.ForceNoHelmet then
        removeHelmetHard(ped)
    end
end

CreateThread(function()
    while true do
        local ped = PlayerPedId()

        -- Re-apply on ped change (spawn/skin changes)
        if ped ~= lastPed then
            lastPed = ped
            Wait(250)
            applyHelmetFix(ped)
            dprint('Applied on ped change')
        end

        -- Re-apply periodically in case other resources overwrite values
        applyHelmetFix(ped)

        Wait(Config.CheckInterval or 500)
    end
end)

-- Fast helmet blocker loop
CreateThread(function()
    while true do
        if Config.DisableAutoHelmet then
            local ped = PlayerPedId()
            if ped and ped ~= 0 and DoesEntityExist(ped) then
                removeHelmetHard(ped)
            end
            Wait(Config.AutoHelmetBlockInterval or 150)
        else
            Wait(1000)
        end
    end
end)

-- Apply when resource starts/restarts
AddEventHandler('onClientResourceStart', function(resourceName)
    if resourceName ~= GetCurrentResourceName() then return end
    Wait(1000)
    local ped = PlayerPedId()
    applyHelmetFix(ped)
    if Config.DisableAutoHelmet then
        removeHelmetHard(ped)
    end
    dprint('Applied on resource start')
end)

-- Apply on playerSpawned for compatibility with many frameworks/resources
AddEventHandler('playerSpawned', function()
    Wait(500)
    local ped = PlayerPedId()
    applyHelmetFix(ped)
    if Config.DisableAutoHelmet then
        removeHelmetHard(ped)
    end
    dprint('Applied on playerSpawned')
end)

-- Common framework spawn hooks
RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    Wait(500)
    local ped = PlayerPedId()
    applyHelmetFix(ped)
    if Config.DisableAutoHelmet then
        removeHelmetHard(ped)
    end
    dprint('Applied on QBCore:Client:OnPlayerLoaded')
end)

RegisterNetEvent('esx:playerLoaded', function()
    Wait(500)
    local ped = PlayerPedId()
    applyHelmetFix(ped)
    if Config.DisableAutoHelmet then
        removeHelmetHard(ped)
    end
    dprint('Applied on esx:playerLoaded')
end)
