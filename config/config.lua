_G.TreasureHuntIndex = {}; -- nao mexa

TreasureHuntIndex.Main = {
    ['minutos'] = { -- minutos para encontrar o tesouro
        60
    },

    ["huntLocations"] = {
        {1000.5, -1000.76, 32.81, 238.12},
        {1500.96, -1200.0, 32.81, 337.33},
        {1200.42, -1400.63, 32.81, 337.33},
        -- Adicione mais localizações conforme necessário
    },

    ['time'] = { -- tempo em milisegundos para encontrar o próximo local
        2000
    },

    ['_reward'] = { -- recompensas do tesouro
        itens = {
            {'dollars', math.random(50, 100)},
            {'capsularifle', math.random(5, 15)},
            {'darkcoins', math.random(1, 5)},
        },
        itens_extra = {
            {"WEAPON_BULLPUPRIFLE_MK2", amount = {1, 1}, chance = 5},
            {"dollars", amount = {100, 200}, chance = 20},
            {"capsularifle", amount = {10, 20}, chance = 20},
            {"darkcoins", amount = {2, 5}, chance = 10},
        }
    },

    ['webhook'] = { -- webhook de ganhadores
        'https://discord.com/api/webhooks/1234567890/abcdefg'
    },

    ['permission'] = { -- permissao para iniciar o evento
        'Admin'
    },

    ['delay'] = { -- delay para iniciar o evento
    10
    },

    ['delayToFind'] = { -- tempo para encontrar o próximo local em milisegundos
        10000
    }
};

return TreasureHuntIndex; -- nao mexa
