local bombs = {}
local exploded = {}

local function GenerateBombs()
    bombs = {}
    exploded = {}

    for i = 1, Config.BombCount do
        local angle = math.random() * math.pi * 2
        local radius = math.random() * Config.Radius

        local x = Config.Center.x + math.cos(angle) * radius
        local y = Config.Center.y + math.sin(angle) * radius
        local z = Config.Center.z

        bombs[i] = vector3(x, y, z)
    end
end

CreateThread(function()
    GenerateBombs()

    while true do
        Wait(Config.RefreshTime)
        GenerateBombs()
    end
end)

CreateThread(function()
    while true do

        local sleep = 500
        local ped = PlayerPedId()
        local entity = ped

        if IsPedInAnyVehicle(ped, false) then
            entity = GetVehiclePedIsIn(ped, false)
        end

        local coords = GetEntityCoords(entity)

        for i, bomb in pairs(bombs) do
            if not exploded[i] then

                local dist = #(coords - bomb)

                if dist < Config.TriggerRadius then

                    exploded[i] = true

                    AddExplosion(
                        bomb.x,
                        bomb.y,
                        bomb.z,
                        Config.ExplosionType,
                        Config.ExplosionDamage,
                        true,
                        false,
                        0.8
                    )

                end
            end
        end

        Wait(sleep)

    end
end)
