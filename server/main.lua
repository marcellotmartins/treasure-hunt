local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")

connection = {}
Tunnel.bindInterface(GetCurrentResourceName(), connection)
vCLIENT = Tunnel.getInterface(GetCurrentResourceName())

local global_max_percent_number = 10000

function CalcPercent(percent)
    return (percent * 10000) / 100
end

function GetPercentByTotal(value, pervalue)
    return (value / pervalue) * 100
end

function GiveItemPercent()
    local actual_percent = GetPercentByTotal(math.random(global_max_percent_number), global_max_percent_number)
    return actual_percent
end

function RollItemChance()
    local totalChance = 0
    
    for _, v in pairs(TreasureHuntIndex.Main["_reward"].itens_extra) do
        totalChance = totalChance + v.chance
    end

    local randomChance = math.random(totalChance)
    local currentChance = 0

    for _, v in pairs(TreasureHuntIndex.Main["_reward"].itens_extra) do
        currentChance = currentChance + v.chance
        if randomChance <= currentChance then
            local item = v[1]
            local amount = math.random(v.amount[1], v.amount[2])
            return item, amount
        end
    end
end

local event_collected = {}
local started_events = {}

function connection.startTreasureHunt(index)
    local source = source
    local Passport = vRP.Passport(source)
    if Passport then
        local ammount_receivd = 0
        local itens_receivd = {}
        local itemtable = TreasureHuntIndex.Main["_reward"].itens_extra

        local alwaysGivenItem = "map"
        local alwaysGivenAmount = 1
        vRP.giveInventoryItem(Passport, alwaysGivenItem, alwaysGivenAmount, true)
        itens_receivd[alwaysGivenItem] = alwaysGivenAmount

        ammount_receivd = ammount_receivd + 1

        repeat
            local item, amount = RollItemChance()
            if not itens_receivd[item] then
                vRP.giveInventoryItem(Passport, item, amount, true)
                print("Dando item ao jogador:", item, "Quantidade:", amount)
                itens_receivd[item] = amount
                ammount_receivd = ammount_receivd + 1
            end
        until ammount_receivd == 5

        SendWebhookMessage(TreasureHuntIndex.Main.webhook[1], "```prolog\n[ID]: " .. Passport .. " " .. vRP.Identity(Passport)["name"] .. " \n[===========ENCONTROU O TESOURO==========]\n[ITENS]: " .. json.encode(itens_receivd) .. os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S") .. " \r```")
    end
end

RegisterCommand("iniciartesouro", function(source, args)
    local source = source
    local Passport = vRP.Passport(source)
    if Passport then
        if vRP.HasPermission(Passport, TreasureHuntIndex.Main.permission[1]) then
            local index = math.random(#TreasureHuntIndex.Main["huntLocations"])
            local coords = TreasureHuntIndex.Main["huntLocations"][index]
            event_collected[index] = false
            vCLIENT.startEvent(-1, index, coords[1], coords[2], coords[3])
            started_events[index] = true
        end
    end
end)
