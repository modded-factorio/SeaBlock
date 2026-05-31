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

-- SeaBlock supplies its own island/water generation. Clear vanilla tile
-- autoplace first so the only remaining tile placement comes from the
-- compatibility expression data below.
for _, v in pairs(data.raw.tile) do
  v.autoplace = nil
end

-- Want player to collide with cliffs
-- Want player to collide with water
-- Don't want cliffs to collide with water
-- Water tile's default collision mask includes player-layer and item-layer
-- So use train-layer as a substitute player-layer
data.raw.cliff["cliff"].collision_mask = { "object-layer", "train-layer", "not-colliding-with-itself" }

local octaves = -3
local persistence = 0.2
local waterline = 9.4
local elevation_scale = 5
local function scale_elevation(x)
  return (x - waterline) * elevation_scale + waterline
end
-- Factorio 2.0 no longer accepts the old peak-based tile autoplace shape for
-- these custom sand tiles. Use small constant probability expressions as a
-- load-safe placeholder; broader SeaBlock water/island shaping is handled by
-- water expressions and startup map settings.
-- low lying sand
data.raw.tile["sand-4"].autoplace = {
  probability_expression = "0.01",
}

-- highground sand
data.raw.tile["sand-5"].autoplace = {
  probability_expression = "0.01",
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

-- Base water tiles now need probability expressions instead of legacy peak
-- tables. `water_base` is provided by Factorio's map generator; these offsets
-- preserve a water-dominant SeaBlock surface while satisfying 2.0 validation.
data.raw.tile["water"].autoplace = {
  probability_expression = "water_base(0, 100)",
}

data.raw.tile["deepwater"].autoplace = {
  probability_expression = "water_base(-2, 200)",
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

local enemy_random_seed = 1
local function new_random_seed()
  enemy_random_seed = enemy_random_seed + 1
  return enemy_random_seed
end
local function expr(value)
  return tostring(value)
end

-- The worm placement code below used to build Factorio 1.1 peak tables. These
-- helpers build 2.0 noise-expression snippets while keeping the old
-- distance/probability tuning readable.
local function var(name)
  return name:match("^[%a_][%w_]*$") and name or "var('" .. name .. "')"
end
local function clamp(value, min, max)
  return "clamp((" .. value .. "), " .. expr(min) .. ", " .. expr(max) .. ")"
end
local function worm_autoplace(distance, probability, order, falloff, control_name)
  local d = "(" .. var("distance") .. " - " .. var("starting_area_radius") .. ")"
  local p = clamp("(" .. d .. " - " .. expr(distance * 128) .. ") / 128", 0, 1)
  if falloff then
    p = "(" .. p .. ") * " .. clamp("(" .. expr((distance + 2) * 128) .. " - " .. d .. ") / 128", 0, 1)
  end
  p = "(" .. p .. ") * " .. clamp(expr(waterline) .. " - " .. var("elevation"), 0, 1)
  p = "(" .. p .. ") * " .. expr(probability)
  p = "random_penalty{x = x + "
    .. expr(new_random_seed())
    .. ", y = y, source = "
    .. p
    .. ", amplitude = "
    .. expr(probability * 0.5)
    .. "}"

  return {
    control = control_name,
    order = order,
    force = "enemy",
    probability_expression = p,
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
end

local function make_basis_noise_function(seed0, seed1, outscale0, inscale0)
  outscale0 = outscale0 or 1
  inscale0 = inscale0 or 1 / outscale0
  return function(x, y, inscale, outscale)
    return "basis_noise{x = "
      .. x
      .. ", y = "
      .. y
      .. ", seed0 = "
      .. seed0
      .. ", seed1 = "
      .. seed1
      .. ", input_scale = "
      .. expr((inscale or 1) * inscale0)
      .. ", output_scale = "
      .. expr((outscale or 1) * outscale0)
      .. "}"
  end
end

data.raw["noise-expression"]["cliffiness"].expression = 0
local elevation = make_basis_noise_function(var("map_seed"), 5, 6, 1 / 64)("x + 40000", "y")
data.raw["noise-expression"]["elevation"].expression = "max(("
  .. elevation
  .. "), 0) * "
  .. expr(elevation_scale)
  .. " - "
  .. expr(waterline * (elevation_scale - 1))
