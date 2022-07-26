QBCore ={}
local sharedItems = exports['qbr-core']:GetItems()

for k, v in pairs(Config.Collecting) do
    RegisterServerEvent("crafting:process:"..v.ItemIn, function()
        local src = source
        local Player = exports['qbr-core']:GetPlayer(src)

        if Player.Functions.GetItemByName(v.ItemIn).amount >= v.Input then
            Player.Functions.RemoveItem(v.ItemIn, v.Input)
            Player.Functions.AddItem(v.ItemOut, v.Output)
            TriggerClientEvent("inventory:client:ItemBox", src, sharedItems[v.ItemIn], "remove")
            TriggerClientEvent("inventory:client:ItemBox", src, sharedItems[v.ItemOut], "add")
            TriggerClientEvent('QBCore:Notify', src, 'You have crafted '..v.Output..'x '..sharedItems[v.ItemOut].label..'!', "success")
        else
            TriggerClientEvent('QBCore:Notify', src, 'You need at least '..v.Input..'x '..sharedItems[v.ItemIn].label ..'!', "error")
        end

    end)
end

for k, v in pairs(Config.Collecting) do
    RegisterServerEvent(v.ItemIn..':getItem')
    AddEventHandler(v.ItemIn..':getItem', function()
        local src = source
        local xPlayer = exports['qbr-core']:GetPlayer(src)
        local randomItem = v.Items[math.random(1, #v.Items)]
        local Item = xPlayer.Functions.GetItemByName(v.ItemIn)

        if Item == nil then
            xPlayer.Functions.AddItem(randomItem, 1)
            TriggerClientEvent("inventory:client:ItemBox", source, sharedItems[randomItem], "add")
        else
            if Item.amount < v.MaxItems then
                xPlayer.Functions.AddItem(randomItem, 1)
                TriggerClientEvent("inventory:client:ItemBox", source, sharedItems[randomItem], "add")
            else
                TriggerClientEvent('QBCore:Notify', source, 'You have enough for now, go and process the '..sharedItems[v.ItemIn].label..'!', "error")
            end
        end

    end)
end
