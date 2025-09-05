local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent("fmc:processTrade", function(recipe)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    local hasItems = true
    for itemName, count in pairs(recipe.cost) do
        local playerItem = Player.Functions.GetItemByName(itemName)
        if not playerItem or playerItem.amount < count then
            hasItems = false
            break
        end
    end

    if hasItems then
        for itemName, count in pairs(recipe.cost) do
            Player.Functions.RemoveItem(itemName, count)
        end
        Player.Functions.AddItem(recipe.item, recipe.amount)
        TriggerClientEvent('QBCore:Notify', src, "Trade successful!", "success")
    else
        TriggerClientEvent('QBCore:Notify', src, "You don't have enough materials!", "error")
    end
end)
