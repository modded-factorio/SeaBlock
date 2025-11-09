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

-- Want player to collide with cliffs
-- Want player to collide with water
-- Don't want cliffs to collide with water
-- Water tile's default collision mask includes player-layer and item-layer
-- So use train-layer as a substitute player-layer
data.raw.cliff["cliff"].collision_mask = { not_colliding_with_itself = true, layers = { object = true, train = true}} --TODO: check if this works/is the best solution

local octaves = -3
local persistence = 0.2
local waterline = 9.4
local elevation_scale = 5
local function scale_elevation(x)
  return (x - waterline) * elevation_scale + waterline
end
--[[
-- low lying sand
data.raw.tile["sand-4"].autoplace = {
  peaks = {
    { -- Around cliff islands
      influence = 5,
      elevation_optimal = 0.3 * elevation_scale + waterline,
      elevation_range = 0.3 * elevation_scale,
      elevation_max_range = 0.3 * elevation_scale,
    },
    {
      influence = 0.77 * 8, -- Worm islands
      min_influence = 0,
      noise_layer = "enemy-base",
      noise_octaves_difference = octaves,
      noise_persistence = persistence,
      tier_from_start_optimal = 8,
      tier_from_start_max_range = 40,
      tier_from_start_top_property_limit = 8,
    },
    { -- Not in starting area
      influence = -5,
      starting_area_weight_optimal = 1,
      starting_area_weight_range = 0,
      starting_area_weight_max_range = 0,
    },
    {
      influence = 100, -- ... except for starting tile
      min_influence = 0,
      distance_optimal = 0,
      distance_range = 0.1,
      distance_max_range = 0.1,
    },
    {
      influence = -5,
    },
  },
}

-- highground sand
data.raw.tile["sand-5"].autoplace = {
  peaks = {
    {
      influence = 5,
      min_influence = 0,
      elevation_optimal = scale_elevation(15),
      elevation_range = 5 * elevation_scale,
      elevation_max_range = 5 * elevation_scale,
      tier_from_start_optimal = 0.1,
      tier_from_start_range = 0,
      tier_from_start_max_range = 0,
      tier_from_start_top_property_limit = 0.1,
    },
    {
      influence = 0.65, -- starting area garden islands
      min_influence = 0,
      max_influence = 1,
      noise_layer = "enemy-base",
      noise_octaves_difference = octaves,
      noise_persistence = persistence,
      tier_from_start_optimal = 0,
      tier_from_start_range = 0.1,
      tier_from_start_max_range = 0.1,
    },
    {
      influence = 1,
      max_influence = 0,
      starting_area_weight_optimal = 1,
      starting_area_weight_range = 0,
      starting_area_weight_max_range = 0,
    },
    {
      influence = -100, -- not on starting tile
      max_influence = 0,
      distance_optimal = 0,
      distance_range = 3,
      distance_max_range = 3,
    },
  },
}

local plant_elevation_range = 9.9 * elevation_scale
data.raw.tree["desert-garden"].autoplace = {
  max_probability = 0.2,
  random_probability_penalty = 0.05,
  sharpness = 1,
  peaks = {
    {
      influence = 1,
      min_influence = 0,
      elevation_optimal = scale_elevation(20),
      elevation_range = plant_elevation_range,
      elevation_max_range = plant_elevation_range,
    },
    {
      influence = 0.31, -- Trial and error value to generate size that approximately matches starting area islands
      min_influence = 0,
      max_influence = 1,
      noise_layer = "enemy-base",
      noise_octaves_difference = octaves,
      noise_persistence = persistence,
      tier_from_start_optimal = 0,
      tier_from_start_range = 0.1,
      tier_from_start_max_range = 0.1,
    },
    {
      influence = 1,
      max_influence = 0,
      noise_layer = "desert-garden-noise",
      noise_persistence = 0.8,
      noise_octaves_difference = -0.5,
    },
  },
  order = "yc",
  tile_restriction = { "sand-5" },
}

data.raw.tree["temperate-garden"].autoplace = {
  max_probability = 0.2,
  random_probability_penalty = 0.05,
  peaks = {
    {
      influence = 1,
      min_influence = 0,
      elevation_optimal = scale_elevation(20),
      elevation_range = plant_elevation_range,
      elevation_max_range = plant_elevation_range,
    },
    {
      influence = 1,
      max_influence = 0,
      noise_layer = "temperate-garden-noise",
      noise_persistence = 0.8,
      noise_octaves_difference = -0.5,
    },
  },
  order = "ya",
  tile_restriction = { "sand-5" },
}

data.raw.tree["swamp-garden"].autoplace = {
  max_probability = 0.05,
  peaks = {
    {
      influence = 1,
      min_influence = 0,
      elevation_optimal = scale_elevation(20),
      elevation_range = plant_elevation_range,
      elevation_max_range = plant_elevation_range,
    },
  },
  order = "yb",
  tile_restriction = { "sand-5" },
}

data.raw.tree["desert-tree"].autoplace = {
  max_probability = 0.1,
  random_probability_penalty = 0.025,
  sharpness = 1,
  peaks = {
    {
      influence = 1,
      min_influence = 0,
      elevation_optimal = scale_elevation(20),
      elevation_range = plant_elevation_range,
      elevation_max_range = plant_elevation_range,
    },
    {
      influence = 0.31, -- Trial and error value to generate size that approximately matches starting area islands
      min_influence = 0,
      max_influence = 1,
      noise_layer = "enemy-base",
      noise_octaves_difference = octaves,
      noise_persistence = persistence,
      tier_from_start_optimal = 0,
      tier_from_start_range = 0.1,
      tier_from_start_max_range = 0.1,
    },
    {
      influence = 1,
      max_influence = 0,
      noise_layer = "desert-tree-noise",
      noise_persistence = 0.8,
      noise_octaves_difference = -0.5,
    },
  },
  order = "za",
  tile_restriction = { "sand-5" },
}
data.raw.tree["temperate-tree"].autoplace = {
  max_probability = 0.1,
  random_probability_penalty = 0.025,
  peaks = {
    {
      influence = 1,
      min_influence = 0,
      elevation_optimal = scale_elevation(20),
      elevation_range = plant_elevation_range,
      elevation_max_range = plant_elevation_range,
    },
    {
      influence = 1,
      max_influence = 0,
      noise_layer = "temperate-tree-noise",
      noise_persistence = 0.8,
      noise_octaves_difference = -0.5,
    },
  },
  order = "zc",
  tile_restriction = { "sand-5" },
}

data.raw.tree["swamp-tree"].autoplace = {
  max_probability = 0.05,
  peaks = {
    {
      influence = 1,
      min_influence = 0,
      elevation_optimal = scale_elevation(20),
      elevation_range = plant_elevation_range,
      elevation_max_range = plant_elevation_range,
    },
    {
      influence = 1,
      max_influence = 0,
      noise_layer = "swamp-tree-noise",
      noise_persistence = 0.8,
      noise_octaves_difference = -0.5,
    },
  },
  order = "zb",
  tile_restriction = { "sand-5" },
}

data.raw.tile["water"].autoplace = {
  peaks = {
    {
      influence = 0.1, -- shallow water around cliff islands
      min_influence = 0,
      elevation_optimal = -2 * elevation_scale + waterline,
      elevation_range = 2.5 * elevation_scale,
      elevation_max_range = 2.5 * elevation_scale,
    },
    {
      influence = 0.77 * 2, -- around worm islands
      min_influence = 0,
      max_influence = 1,
      noise_layer = "enemy-base",
      noise_octaves_difference = octaves,
      noise_persistence = persistence,
    },
    {
      influence = 5, -- around starting tile
      min_influence = 0,
      distance_optimal = 0,
      distance_range = 5,
      distance_max_range = 5,
    },
  },
}

data.raw.tile["deepwater"].autoplace = {
  peaks = {
    {
      influence = 0.01,
    },
  },
}

data.raw.fish["alien-fish-1"].autoplace = {
  peaks = {
    {
      influence = -0.1,
      max_influence = 0,
      noise_layer = "enemy-base",
      noise_octaves_difference = octaves,
      noise_persistence = persistence,
    },
    {
      influence = 0.01,
    },
  },
}

data.raw.fish["alien-fish-2"].autoplace = {
  peaks = {
    {
      influence = 0.02,
      min_influence = 0,
      noise_layer = "enemy-base",
      noise_octaves_difference = octaves,
      noise_persistence = persistence,
    },
  },
}

data.raw.fish["alien-fish-3"].autoplace = {
  peaks = {
    {
      influence = 0.015,
      min_influence = 0,
      elevation_optimal = scale_elevation(10),
      elevation_range = 5 * elevation_scale,
      elevation_max_range = 5 * elevation_scale,
      tier_from_start_optimal = 0.1,
      tier_from_start_range = 0,
      tier_from_start_max_range = 0,
      tier_from_start_top_property_limit = 0.1,
    },
  },
}



data:extend({
  {
    type = "noise-layer",
    name = "desert-tree-noise",
  },
  {
    type = "noise-layer",
    name = "temperate-tree-noise",
  },
  {
    type = "noise-layer",
    name = "swamp-tree-noise",
  },
  {
    type = "noise-layer",
    name = "desert-garden-noise",
  },
  {
    type = "noise-layer",
    name = "temperate-garden-noise",
  },
  {
    type = "noise-layer",
    name = "swamp-garden-noise",
  },
})

data.raw["noise-expression"]["cliffiness"].expression = noise.define_noise_function(function(x, y, tile, map)
  local t = noise.clamp((tile.tier - 0.2) * noise.ceil(noise.var("control-setting:cliffs:richness:multiplier")), 0, 1) -- No cliffs in starting area
  return 100 * t
end)
]]

data.extend{
  {
    type = "noise-expression",
    name = "octaves",
    expression = "-3"
  },
  
  {
    type = "noise-expression",
    name = "persistence",
    expression = "0.2"
  },
  {
    type = "noise-expression",
    name = "waterline",
    expression = "9.4"
  },
  {
    type = "noise-expression",
    name = "elevation_scale",
    expression = "5"
  },
  {
    type = "noise-function",
    name = "scale_elevation",
    parameters = {"x"},
    expression = "(x - waterline) * elevation_scale + waterline"
  },
}

--[[local enemy_random_seed = 1
local function new_random_seed()
  enemy_random_seed = enemy_random_seed + 1
  return enemy_random_seed
end
local function worm_autoplace(distance, probability, order, falloff, control_name)
  data.extend{{
    type = "noise-function",
    name = "worm_placer",
    parameters = {"distance", "probability", "falloff", "random_seed"},
    expression = "random_penalty{source = p1, amplitude = probability * 0.5, x = x + random_seed, y = 1}", --TODO: replace y with other constant or x or y
    local_expressions = {
      d = "distance - starting_area_radius",
      p0 = "clamp((d - distance * 128) / 128, 0, 1)",
      falloffFactor = "if(falloff, clamp(((distance + 2) * 128 - d) / 128, 0, 1), 1)",
      p1 = "p0 * falloffFactor * probability * clamp((waterline - elevation), 0, 1)"
    }
  }}
  
  return {
    control = control_name,
    order = order,
    force = "enemy",
    probability_expression = "worm_placer(" .. distance ..", " .. probability .. ", " .. tostring(falloff) .. ", " .. new_random_seed() .. ")",
    richness_expression = 1,
  }
end

data.raw.turret["small-worm-turret"].autoplace = worm_autoplace(0, 1, "z", true, "enemy-base")
data.raw.turret["medium-worm-turret"].autoplace = worm_autoplace(1, 1, "y", true, "enemy-base")
if data.raw.turret["bob-big-explosive-worm-turret"] then
  data.raw.turret["bob-big-explosive-worm-turret"].autoplace = worm_autoplace(1.5, 0.5, "v", false, "enemy-base")
end
if data.raw.turret["bob-big-fire-worm-turret"] then
  data.raw.turret["bob-big-fire-worm-turret"].autoplace = worm_autoplace(1.5, 0.5, "v", false, "enemy-base")
end
if data.raw.turret["bob-big-poison-worm-turret"] then
  data.raw.turret["bob-big-poison-worm-turret"].autoplace = worm_autoplace(1.5, 0.5, "v", false, "enemy-base")
end
if data.raw.turret["bob-big-piercing-worm-turret"] then
  data.raw.turret["bob-big-piercing-worm-turret"].autoplace = worm_autoplace(1.5, 0.5, "v", false, "enemy-base")
end
if data.raw.turret["bob-big-electric-worm-turret"] then
  data.raw.turret["bob-big-electric-worm-turret"].autoplace = worm_autoplace(1.5, 0.5, "v", false, "enemy-base")
end
if data.raw.turret["bob-giant-worm-turret"] then
  data.raw.turret["bob-giant-worm-turret"].autoplace = worm_autoplace(2, 0.6, "u", false, "enemy-base")
end
if data.raw.turret["behemoth-worm-turret"] then
  data.raw.turret["big-worm-turret"].autoplace = worm_autoplace(1.5, 0.5, "v", false, "enemy-base")
  data.raw.turret["behemoth-worm-turret"].autoplace = worm_autoplace(2, 0.2, "t", false, "enemy-base")
else
  data.raw.turret["big-worm-turret"].autoplace = worm_autoplace(2, 1, "v", false, "enemy-base")
end
data.raw.tree["puffer-nest"].autoplace = worm_autoplace(0, 0.01, "s", false)

for _, v in pairs(data.raw.turret) do
  v.map_generator_bounding_box = nil
end]]

-- old tries - meh/not working
-- data.raw["noise-expression"]["elevation"].local_expressions = {base = "max(basis_noise{x = x + 4000, y = y, seed0 = map_seed, seed1 = 5, input_scale = 1/64, output_scale = 6},0)"}
-- data.raw["noise-expression"]["elevation"].expression = "(base * elevation_scale) - (waterline * (elevation_scale - 1))" -- Increase gradient for cliffs while leaving waterline unchanged

-- data.raw.tile["deepwater"].autoplace.probability_expression = "if(elevation <= (waterline*elevation_scale/2), 10, 0)"
-- data.raw.tile["sand-4"].autoplace.probability_expression = "if(distance <= 1, 10000, 0)"

data.raw["noise-expression"]["elevation"].local_expressions = {
  base = "basis_noise{x = x, y = y, seed0 = map_seed, seed1 = 5, input_scale = 1/32, output_scale = 6}",
  starting_tile = "if(distance <= 1, 100, 0)",
  --small_islands = "if(distance >= starting_area_radius/2, basis_noise{x = x, y = y, seed0 = map_seed, seed1 = 3, input_scale = 1/32, output_scale = 10} - waterline, 0)"
}

data.raw["noise-expression"]["elevation"].expression = "if(distance <= starting_area_radius/2, min(base - waterline, 0), base - waterline) + starting_tile"-- "min((base - waterline - 2) + starting_tile, 10) + small_islands"

data.raw.tile["deepwater"].autoplace = {probability_expression = "if(-8 >= elevation, 200 * min(-6 - elevation, 1), -inf)"}
data.raw.tile["water"].autoplace = {probability_expression = "if(0 >= elevation, 100 * min(0 - elevation, 1), -inf)"}
data.raw.tile["sand-4"].autoplace = {probability_expression = "if(elevation >= 0, elevation, -inf)"}

-- data.raw.tile["sand-5"].autoplace = {probability_expression = "if(elevation >= 0, elevation, -inf)"} -- decided against using this

data.raw.tree["angels-desert-garden"].autoplace = {probability_expression = "if(elevation >= 0, random_penalty{x = x, y = y, seed = 1, source = 0.03, amplitude = 0.01}, -inf)"} --, tile_restriction = {"sand-5"}}
data.raw.tree["angels-temperate-garden"].autoplace = {probability_expression = "if(elevation >= 0, random_penalty{x = x, y = y, seed = 2, source = 0.03, amplitude = 0.01}, -inf)"}
data.raw.tree["angels-swamp-garden"].autoplace = {probability_expression = "if(elevation >= 0, random_penalty{x = x, y = y, seed = 3, source = 0.03, amplitude = 0.015}, -inf)"}

data.raw.tree["angels-desert-tree"].autoplace = {probability_expression = "if(elevation >= 0, random_penalty{x = x, y = y, seed = 4, source = 0.03, amplitude = 0.01}, -inf)"} --, placement_density = 3}
data.raw.tree["angels-temperate-tree"].autoplace = {probability_expression = "if(elevation >= 0, random_penalty{x = x, y = y, seed = 5, source = 0.03, amplitude = 0.01}, -inf)"}
data.raw.tree["angels-swamp-tree"].autoplace = {probability_expression = "if(elevation >= 0, random_penalty{x = x, y = y, seed = 6, source = 0.03, amplitude = 0.015}, -inf)"} 