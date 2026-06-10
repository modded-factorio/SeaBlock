-- See mapgen.md for further information
data.raw.tile["sand-4"] = table.deepcopy(data.raw.tile["sand-1"])
data.raw.tile["sand-5"] = table.deepcopy(data.raw.tile["sand-2"])
data.raw.tile["sand-4"].name = "sand-4"
data.raw.tile["sand-5"].name = "sand-5"

data.raw.tile["dry-dirt"].vehicle_friction_modifier = 1.8
data.raw.tile["dirt-1"].vehicle_friction_modifier = 1.8
data.raw.tile["dirt-2"].vehicle_friction_modifier = 1.8
data.raw.tile["dirt-3"].vehicle_friction_modifier = 1.8

data.raw.tile["dirt-4"].vehicle_friction_modifier = 1.8
data.raw.tile["dirt-5"].vehicle_friction_modifier = 1.8
data.raw.tile["dirt-6"].vehicle_friction_modifier = 1.8
data.raw.tile["dirt-7"].vehicle_friction_modifier = 1.8

data.raw.tile["grass-1"].vehicle_friction_modifier = 1.8
data.raw.tile["grass-3"].vehicle_friction_modifier = 1.8
data.raw.tile["grass-2"].vehicle_friction_modifier = 1.8
data.raw.tile["grass-4"].vehicle_friction_modifier = 1.8

data.raw.tile["red-desert-0"].vehicle_friction_modifier = 1.8
data.raw.tile["red-desert-1"].vehicle_friction_modifier = 1.8
data.raw.tile["red-desert-2"].vehicle_friction_modifier = 1.8
data.raw.tile["red-desert-3"].vehicle_friction_modifier = 1.8

data.raw.tile["sand-1"].vehicle_friction_modifier = 1.8
data.raw.tile["sand-2"].vehicle_friction_modifier = 1.8
data.raw.tile["sand-3"].vehicle_friction_modifier = 1.8
data.raw.tile["sand-4"].vehicle_friction_modifier = 1.8
data.raw.tile["sand-5"].vehicle_friction_modifier = 1.8

data.raw.tile["landfill"].vehicle_friction_modifier = 1.8

for _, v in pairs(data.raw.tile) do
    v.autoplace = nil
end

data.raw.cliff["cliff"].collision_mask = { not_colliding_with_itself = true, layers = { object = true, train = true}}

data:extend({
    {
        type = "noise-expression",
        name = "waterline",
        expression = "10"
    },
    {
        type = "noise-expression",
        name = "distance_sigmoid", -- sigmoid to gradually increase island size while limiting the maximum size
        local_expressions = {
            amount = "2",
            offset = "500",
            scale = "300"
        },
        expression = "amount/(1+e^(-(distance-offset)/scale))"
    },
    {
        type = "noise-function",
        name = "shifted_hyperbolic_rational",
        parameters = { "amplitude", "offset", "squish" },
        expression = "(amplitude*4)/(distance*squish-offset*squish) - (amplitude*4)/((distance*squish-offset*squish)^2)"
    },
    {
        type = "noise-function",
        name = "random_tree_islands",
        parameters = { "seed", "noise_seed", "frequency", "limit" },
        local_expressions = {
            base = "basis_noise{x = x, y = y, seed0 = map_seed, seed1 = noise_seed, input_scale = 1.99995}",
            multoctave = "multioctave_noise{x = x, y = y, persistence = 0.75, seed0 = map_seed, seed1 = seed, octaves = 3, input_scale = 1/32, output_scale = 10} * (1+frequency+shifted_hyperbolic_rational(200, 0, 0.7))"
        },
        expression = "if(multoctave >= limit, base, -inf)"
    },
    {
        type = "noise-function",
        name = "worm_autoplace",
        parameters = { "other_distance", "probability", "falloff", "seed" },
        local_expressions = {
            d = "distance - starting_area_radius",
            _falloff = "if(falloff == 1, clamp(((other_distance+2)*128-d)/128, 0, 1), 1)",
            _waterline = "clamp(waterline-elevation, 0, 1)",
            prob = "clamp((d-other_distance*128)/128, 0, 1) * _falloff * _waterline * probability",
            pen = "random_penalty(x, y, prob, seed, probability*0.5)"
        },
        expression = "pen"
    }
})

-- cant put that in data:extend since elevation exists in base game
local elevation = data.raw["noise-expression"]["elevation"]

elevation.local_expressions = {
    base = "basis_noise{x = x, y = y, seed0 = map_seed, seed1 = 5, input_scale = 1/32, output_scale = 6}",
    starting_tile = "if(distance <= 1, 100, 0)",
}

elevation.expression = "if(distance <= starting_area_radius/2, min(base - waterline, 0), base - waterline) + starting_tile + distance_sigmoid+1"

------- Tiles -------
-- Water
seablock.lib.set_probability_expression("tile", "deepwater", "if(elevation <= -8, elevation*-1, -inf)")
seablock.lib.set_probability_expression("tile", "water", "if(elevation < 0, elevation*-1, -inf)")

-- Beaches
seablock.lib.set_probability_expression("tile", "sand-4", "if(elevation >= 0, elevation, -inf)")

-- Landmass
seablock.lib.set_probability_expression("tile", "sand-5", "if(elevation >= 1.2, inf, -inf)")

------- Trees -------
-- Trees should only spawn on sand-5 which is the middle of each island
for _, name in pairs({ "angels-desert-garden", "angels-temperate-garden", "angels-swamp-garden", "angels-desert-tree", "angels-temperate-tree", "angels-swamp-tree", }) do
    seablock.lib.set_tile_restriction("tree", name, "sand-5")
end

seablock.lib.set_probability_expression("tree", "angels-desert-garden", "random_tree_islands(1, 1, 0.6, 16)")
seablock.lib.set_probability_expression("tree", "angels-desert-tree", "random_tree_islands(1, 2, 0.4, 16)")

seablock.lib.set_probability_expression("tree", "angels-temperate-garden", "random_tree_islands(2, 1, 0.6, 16)")
seablock.lib.set_probability_expression("tree", "angels-temperate-tree", "random_tree_islands(2, 2, 0.6, 16)")

seablock.lib.set_probability_expression("tree", "angels-swamp-garden", "random_tree_islands(3, 1, 0.6, 16)")
seablock.lib.set_probability_expression("tree", "angels-swamp-tree", "random_tree_islands(3, 2, 0.5, 16)")

------- Enemies -------
local enemy_random_seed = 1
local function new_random_seed()
    enemy_random_seed = enemy_random_seed + 1
    return enemy_random_seed
end

local function worm_autoplace(distance, probability, order, falloff, control_name)
    return {
        control = control_name,
        order = order,
        force = "enemy",
        probability_expression = "worm_autoplace("..distance..","..probability..","..falloff..","..new_random_seed()..")",
        richness_expression = 1,
    }
end

data.raw.turret["small-worm-turret"].autoplace = worm_autoplace(0, 1, "z", 1, "enemy-base")
data.raw.turret["medium-worm-turret"].autoplace = worm_autoplace(1, 1, "y", 1, "enemy-base")
data.raw.turret["big-worm-turret"].autoplace = worm_autoplace(1.5, 0.5, "v", 0, "enemy-base")
data.raw.turret["behemoth-worm-turret"].autoplace = worm_autoplace(2, 0.2, "t", 0, "enemy-base")

seablock.lib.set_tile_restriction("tree", "angels-puffer-nest", {}) --clear tile restrictions
data.raw.tree["angels-puffer-nest"].autoplace = worm_autoplace(0, 0.01, "s", 0)

if data.raw.turret["bob-big-explosive-worm-turret"] then
    data.raw.turret["bob-big-explosive-worm-turret"].autoplace = worm_autoplace(1.5, 0.5, "v", 0, "enemy-base")
end
if data.raw.turret["bob-big-fire-worm-turret"] then
    data.raw.turret["bob-big-fire-worm-turret"].autoplace = worm_autoplace(1.5, 0.5, "v", 0, "enemy-base")
end
if data.raw.turret["bob-big-poison-worm-turret"] then
    data.raw.turret["bob-big-poison-worm-turret"].autoplace = worm_autoplace(1.5, 0.5, "v", 0, "enemy-base")
end
if data.raw.turret["bob-big-piercing-worm-turret"] then
    data.raw.turret["bob-big-piercing-worm-turret"].autoplace = worm_autoplace(1.5, 0.5, "v", 0, "enemy-base")
end
if data.raw.turret["bob-big-electric-worm-turret"] then
    data.raw.turret["bob-big-electric-worm-turret"].autoplace = worm_autoplace(1.5, 0.5, "v", 0, "enemy-base")
end
if data.raw.turret["bob-giant-worm-turret"] then
    data.raw.turret["bob-giant-worm-turret"].autoplace = worm_autoplace(2, 0.6, "u", 0, "enemy-base")
end
