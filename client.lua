local QBCore = exports['qb-core']:GetCoreObject()
local NPCModel = `s_m_m_dockwork_01`
local NPCCoords = vector4(-1110.5, -2003.5, 13.16, 158.0)

local AllowedGrades = {
    [1] = false,
    [2] = true,
    [3] = true,
    [4] = true
}

local TradeRecipes = {
    { label = "Copper x10", item = "copper", cost = {["copperore"] = 10}, amount = 10, image = "images/copper.png" },
    { label = "Gold Ingot x10", item = "goldingot", cost = {["goldore"] = 10}, amount = 10, image = "images/goldingot.png" },
    { label = "Silver Ingot x10", item = "silveringot", cost = {["silverore"] = 10}, amount = 10, image = "images/silveringot.png" },
    { label = "Iron x10", item = "iron", cost = {["ironore"] = 10}, amount = 10, image = "images/iron.png" },
    { label = "Steel x20", item = "steel", cost = {["ironore"] = 10, ["carbon"] = 5}, amount = 20, image = "images/steel.png" },
    { label = "Aluminum x10", item = "aluminum", cost = {["emptycan"] = 20}, amount = 10, image = "images/aluminum.png" },
    { label = "Glass x10", item = "glass", cost = {["emptybottle"] = 20}, amount = 10, image = "images/glass.png" },
}

CreateThread(function()
    RequestModel(NPCModel)
    while not HasModelLoaded(NPCModel) do Wait(100) end

    local npc = CreatePed(0, NPCModel, NPCCoords.x, NPCCoords.y, NPCCoords.z - 1, NPCCoords.w, false, false)
    SetEntityInvincible(npc, true)
    SetBlockingOfNonTemporaryEvents(npc, true)
    FreezeEntityPosition(npc, true)

    exports['qb-target']:AddEntityZone("smelt_npc", npc, {
        name = "smelt_npc",
        debugPoly = false,
    }, {
        options = {
            {
                label = "Trade Materials",
                icon = "fas fa-tablet",
                canInteract = function(entity, distance, data)
                    local Player = QBCore.Functions.GetPlayerData()
                    return Player.job.name == "fmc" and AllowedGrades[Player.job.grade.level]
                end,
                action = function()
                    OpenTradeTablet()
                end,
            }
        },
        distance = 2.0
    })
end)

function OpenTradeTablet()
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = "openTablet",
        trades = TradeRecipes
    })
end

RegisterNUICallback("closeTablet", function(data, cb)
    SetNuiFocus(false, false)
    cb("ok")
end)

RegisterNUICallback("tradeItem", function(data, cb)
    if data.recipe then
        -- FIXED: Call server event instead of client-only event
        TriggerServerEvent("fmc:processTrade", data.recipe)
    end
    cb("ok")
end)
