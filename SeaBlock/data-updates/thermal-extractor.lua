local move_item = angelsmods.functions.move_item

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
      stripes = makestripes(
        "__angelsrefininggraphics__/graphics/entity/thermal-extractor/thermal-extractor-base.png",
        16
      ),
      priority = "high",
      width = 288,
      height = 288,
      shift = { 0, 0 },
      frame_count = 16,
      x = 288 * 2,
      animation_speed = 1,
    })
  end
  table.insert(layers, {
    priority = "high",
    width = 288,
    height = 288,
    line_length = 4,
    shift = { 0, 0 },
    filename = "__angelsrefininggraphics__/graphics/entity/thermal-extractor/thermal-extractor-animation.png",
    frame_count = 16,
    animation_speed = 1,
  })
  if bottom then
    table.insert(layers, {
      stripes = makestripes(
        "__angelsrefininggraphics__/graphics/entity/thermal-extractor/thermal-extractor-base.png",
        16
      ),
      priority = "high",
      width = 288,
      height = 288,
      shift = { 0, 0 },
      frame_count = 16,
      x = 0,
      animation_speed = 1,
    })
  end
  return { layers = layers }
end

local extractor = data.raw["mining-drill"]["angels-thermal-extractor"]
data.raw["mining-drill"]["angels-thermal-extractor"] = nil
data.raw["assembling-machine"]["angels-thermal-extractor"] = extractor
extractor.type = "assembling-machine"
extractor.crafting_speed = 1
extractor.ingredient_count = 2
extractor.fluid_boxes = {
  {
    production_type = "input",
    base_area = 10,
    --base_level = -1,
    volume = 1000,
    pipe_covers = pipecoverspictures(),
    pipe_connections = { { flow_direction = "input", position = { 3, - 4 }, direction = defines.direction.north } },
  },
  {
    production_type = "output",
    base_area = 10,
    --base_level = 1,
    volume = 1000,
    pipe_covers = pipecoverspictures(),
    pipe_connections = { { flow_direction = "output", position = { -3, 4 }, direction = defines.direction.south } },
  },
}
extractor.graphics_set.animation = {
  north = makeextractorlayers(true, true),
  east = makeextractorlayers(false, false),
  south = makeextractorlayers(true, true),
  west = makeextractorlayers(false, false),
}
extractor.crafting_categories = { "sb-thermal-extractor" }
extractor.fixed_recipe = "sb-thermal-extractor-water"
bobmods.lib.tech.add_recipe_unlock("angels-thermal-water-extraction-2", "sb-thermal-extractor-water")
move_item("angels-thermal-extractor", "angels-water-treatment-building", "f[thermal-extractor]-b[extractor]", "item")
bobmods.lib.recipe.add_ingredient("angels-thermal-extractor", { type = "item", name = "angels-thermal-bore", amount = 1 })
extractor.vector_to_place_result = nil -- remove the yellow arrow of the mining drill

local bore = data.raw["mining-drill"]["angels-thermal-bore"]
data.raw["mining-drill"]["angels-thermal-bore"] = nil
data.raw["assembling-machine"]["angels-thermal-bore"] = bore
bore.type = "assembling-machine"
bore.crafting_speed = 1
bore.ingredient_count = 1
bore.fluid_boxes = {
  {
    production_type = "output",
    base_area = 1,
    volume = 500,
    pipe_covers = bore.output_fluid_box.pipe_covers,
    pipe_connections = bore.output_fluid_box.pipe_connections
  },
}
bore.vector_to_place_result = nil

-- This is needed for the animation below
bore.base_picture.sheet.line_length = 1
bore.base_picture.sheet.repeat_count = 16

-- Edit animation to include output pipe facing north and south
local working_animation = table.deepcopy(bore.graphics_set.animation.north)

--- This animation is a translation of the mining_drill but for an assembling_machine
--- This is done because an assembling_machine has no base_picture so the northern and southern pipe extentions have to be added via animation
bore.graphics_set.animation = {
  north = {
    layers = {
      table.deepcopy(bore.base_picture.sheet),
      working_animation
    }
  },
  east = working_animation,
  south = {
    layers = {
      table.deepcopy(bore.base_picture.sheet),
      working_animation
    }
  },
  west = working_animation,
}

-- Shift animation to make other pipe visible 
bore.graphics_set.animation.south.layers[1].x = 576

-- Reset animation speed for directions without additional layers
bore.graphics_set.animation.east.animation_speed = 1
bore.graphics_set.animation.west.animation_speed = 1

bore.crafting_categories = { "sb-thermal-bore" }
bore.fixed_recipe = "sb-thermal-bore-water"
bobmods.lib.tech.add_recipe_unlock("angels-thermal-water-extraction", "sb-thermal-bore-water")
move_item("angels-thermal-bore", "angels-water-treatment-building", "f[thermal-extractor]-a[bore]", "item")

-- Fish Pressing requires thermal water so add a prerequisite
if data.raw.technology["angels-bio-pressing-fish"] then
  bobmods.lib.tech.add_prerequisite("angels-bio-pressing-fish", "angels-thermal-water-extraction")
else
  bobmods.lib.tech.add_prerequisite("angels-bio-pressing-fish-1", "angels-thermal-water-extraction")
end
bobmods.lib.tech.add_prerequisite("angels-thermal-water-extraction", "angels-bio-processing-brown")