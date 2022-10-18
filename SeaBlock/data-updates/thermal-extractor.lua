-- Repurpose thermal extractor

local function makestripes(filename, count)
  local r = {}
  for i = 1, count do
    table.insert(r, { filename = filename, width_in_frames = 1, height_in_frames = 1 })
  end
  return r
end

local function makeextractorlayers(bottom, top)
  local layers = {}
  if top then
    table.insert(layers, {
      stripes = makestripes("__angelsrefining__/graphics/entity/thermal-extractor/thermal-extractor-base.png", 16),
      priority = "high",
      width = 288,
      height = 288,
      shift = { 0, 0 },
      frame_count = 16,
      x = 288 * 2,
      animation_speed = 0.5,
    })
  end
  table.insert(layers, {
    priority = "high",
    width = 288,
    height = 288,
    line_length = 4,
    shift = { 0, 0 },
    filename = "__angelsrefining__/graphics/entity/thermal-extractor/thermal-extractor-animation.png",
    frame_count = 16,
    animation_speed = 0.5,
  })
  if bottom then
    table.insert(layers, {
      stripes = makestripes("__angelsrefining__/graphics/entity/thermal-extractor/thermal-extractor-base.png", 16),
      priority = "high",
      width = 288,
      height = 288,
      shift = { 0, 0 },
      frame_count = 16,
      x = 0,
      animation_speed = 0.5,
    })
  end
  return { layers = layers }
end

local extractor = data.raw["mining-drill"]["thermal-extractor"]
data.raw["mining-drill"]["thermal-extractor"] = nil
data.raw["assembling-machine"]["thermal-extractor"] = extractor
extractor.type = "assembling-machine"
extractor.crafting_speed = 1
extractor.ingredient_count = 2
extractor.fluid_boxes = {
  {
    production_type = "input",
    base_area = 10,
    base_level = -1,
    pipe_covers = pipecoverspictures(),
    pipe_connections = { { type = "input", position = { 5, 3 } } },
  },
  {
    production_type = "output",
    base_area = 10,
    base_level = 1,
    pipe_covers = pipecoverspictures(),
    pipe_connections = { { type = "output", position = { -5, -3 } } },
  },
}
extractor.animation = {
  north = makeextractorlayers(false, false),
  east = makeextractorlayers(true, true),
  south = makeextractorlayers(false, false),
  west = makeextractorlayers(true, true),
}
extractor.crafting_categories = { "thermal-extractor" }
extractor.fixed_recipe = "thermal-extractor-water"
bobmods.lib.tech.add_recipe_unlock("thermal-water-extraction-2", "thermal-extractor-water")

local bore = data.raw["mining-drill"]["thermal-bore"]
data.raw["mining-drill"]["thermal-bore"] = nil
data.raw["assembling-machine"]["thermal-bore"] = bore
bore.type = "assembling-machine"
bore.crafting_speed = 1
bore.ingredient_count = 1
bore.fluid_boxes = {
  {
    production_type = "output",
    base_area = 1,
    base_level = 1,
    pipe_covers = pipecoverspictures(),
    pipe_connections = { {
      type = "output",
      positions = { { 1, -2 }, { 2, -1 }, { -1, 2 }, { -2, 1 } },
    } },
  },
}

local function makesheet(sheet, count, d)
  local r = table.deepcopy(sheet)
  r.stripes = makestripes(r.filename, count)
  r.frame_count = count
  r.filename = nil
  r.x = r.width * d
  if r.hr_version then
    r.hr_version = makesheet(r.hr_version, count, d)
  end
  return r
end
local function makeborelayers(d)
  return {
    layers = {
      makesheet(bore.base_picture.sheets[1], bore.animations.north.layers[1].frame_count, d),
      makesheet(bore.base_picture.sheets[2], bore.animations.north.layers[1].frame_count, d),
      bore.animations.north.layers[1],
      bore.animations.north.layers[2],
    },
  }
end
bore.animation = {
  north = makeborelayers(0),
  east = makeborelayers(1),
  south = makeborelayers(2),
  west = makeborelayers(3),
}
bore.crafting_categories = { "thermal-bore" }
bore.fixed_recipe = "thermal-bore-water"
bobmods.lib.tech.add_recipe_unlock("thermal-water-extraction", "thermal-bore-water")

-- Fish Pressing requires thermal water so add a prerequisite
if data.raw.technology["bio-pressing-fish"] then
  bobmods.lib.tech.add_prerequisite("bio-pressing-fish", "thermal-water-extraction")
else
  bobmods.lib.tech.add_prerequisite("bio-pressing-fish-1", "thermal-water-extraction")
end
bobmods.lib.tech.add_prerequisite("thermal-water-extraction", "bio-processing-brown")
