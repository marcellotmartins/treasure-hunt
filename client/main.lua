local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")
vCLIENT = Tunnel.getInterface(GetCurrentResourceName(), "vCLIENT")

connection = {}
Tunnel.bindInterface(GetCurrentResourceName(), connection)
vSERVER = Tunnel.getInterface(GetCurrentResourceName())

local blips = {}
local treasures = {}
local searching = false

function createTreasureBlip(index, x, y, z)
    if not blips[index] then
        blips[index] = AddBlipForCoord(x, y, z)
        SetBlipSprite(blips[index], 94)
        SetBlipColour(blips[index], 5)
        SetBlipScale(blips[index], 0.9)
        SetBlipAsShortRange(blips[index], true)

        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Caça ao Tesouro")
        EndTextCommandSetBlipName(blips[index])
    end
end

function removeTreasureBlip(index)
    if blips[index] then
        RemoveBlip(blips[index])
        blips[index] = nil
    end
end

function drawText(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    SetTextFont(6)
    SetTextScale(0.35, 0.35)
    SetTextColour(255, 255, 255, 150)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x, _y)
    local factor = (string.len(text)) / 400
    DrawRect(_x, _y + 0.0125, 0.01 + factor, 0.03, 0, 0, 0, 80)
end

function drawScreen(text, font, x, y, scale)
    SetTextFont(font)
    SetTextScale(scale, scale)
    SetTextColour(255, 255, 255, 150)
    SetTextOutline()
    SetTextCentre(1)
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x, y)
end

function connection.startEvent(index, x, y, z)
    treasures[index] = {coords = vector3(x, y, z), found = false}
    createTreasureBlip(index, x, y, z)
    TriggerEvent('Notify', "amarelo", "Um tesouro foi escondido em algum lugar do mapa. Encontre-o para ganhar recompensas!", 15000)
end

function connection.finishEvent(index)
    if treasures[index] then
        treasures[index] = nil
        removeTreasureBlip(index)
        TriggerEvent('Notify', "verde", "O tesouro foi encontrado! Parabéns ao jogador que encontrou!", 15000)
    end
end

CreateThread(function()
    while true do
        local ped = PlayerPedId()
        local pedCoords = GetEntityCoords(ped)
        local idle = 2000

        for k, v in pairs(treasures) do
            if v.coords and not v.found then
                local dist = #(pedCoords - v.coords)
                if dist <= 5.0 then
                    idle = 4
                    drawText(v.coords.x, v.coords.y, v.coords.z, "~w~PRESSIONE ~b~[E]~w~ PARA PROCURAR O TESOURO")
                    if IsControlJustPressed(0, 38) and not searching then
                        searching = true
                        TaskStartScenarioInPlace(ped, "WORLD_HUMAN_GARDENER_PLANT", 0, true)
                        Citizen.Wait(10000)
                        ClearPedTasks(ped)
                        if #(GetEntityCoords(ped) - v.coords) < 2.0 then
                            vSERVER.collectTreasure(k)
                            treasures[k].found = true
                            removeTreasureBlip(k)
                        end
                        searching = false
                    end
                end
            end
        end

        Wait(idle)
    end
end)
