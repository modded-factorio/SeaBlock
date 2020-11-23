data:extend({
{
  type = "tool",
  name = "sb-angelsore3-tool",
  localised_name = {"item-name.angels-ore3-crushed"},
  icon = "__angelsrefining__/graphics/icons/angels-ore3-crushed.png",
  icon_size = 32,
  flags = {"hidden"},
  stack_size = 100,
  durability = 1
},
{
  type = "tool",
  name = "sb-basic-circuit-board-tool",
  localised_name = {"item-name.basic-circuit-board"},
  icon = "__bobelectronics__/graphics/icons/basic-circuit-board.png",
  icon_size = 128,
  flags = {"hidden"},
  stack_size = 100,
  durability = 1
},
{
  type = "tool",
  name = "sb-algae-green-tool",
  localised_name = {"item-name.algae-green"},
  icon = "__angelsbioprocessing__/graphics/icons/algae-green.png",
  icon_size = 32,
  flags = {"hidden"},
  stack_size = 100,
  durability = 1
},
{
  type = "tool",
  name = "sb-sulfur-tool",
  localised_name = {"item-name.sulfur"},
  icon = "__angelspetrochem__/graphics/icons/solid-sulfur.png",
  icon_size = 32,
  flags = {"hidden"},
  stack_size = 100,
  durability = 1
},
{
  type = "tool",
  name = "sb-lab-tool",
  localised_name = {"item-name.lab"},
  icon = "__base__/graphics/icons/lab.png",
  icon_size = 64,
  icon_mipmaps = 4,
  flags = {"hidden"},
  stack_size = 100,
  durability = 1
},
{
  type = "technology",
  name = "sb-startup1",
  icon = "__SeaBlock__/graphics/technology/ore.png",
  icon_size = 128,
  effects = {
    {type = "unlock-recipe", recipe = "basic-circuit-board"},
    {type = "unlock-recipe", recipe = "copper-cable"},
    {type = "unlock-recipe", recipe = "algae-farm"},
    {type = "unlock-recipe", recipe = "algae-brown"},
    {type = "unlock-recipe", recipe = "hydro-plant"},
    {type = "unlock-recipe", recipe = "clarifier"},
    {type = "unlock-recipe", recipe = "water-purification"},
    {type = "unlock-recipe", recipe = "iron-chest"},
    {type = "unlock-recipe", recipe = "solid-alginic-acid"}
  },
  unit = {
    count = 1,
    ingredients = {{"sb-angelsore3-tool", 1}},
    time = 5
  }
},
{
  type = "technology",
  name = "sb-startup2",
  icon = "__SeaBlock__/graphics/technology/basic-circuit-board.png",
  icon_size = 128,
  effects = {
    {type = "unlock-recipe", recipe = "inserter"},
    {type = "unlock-recipe", recipe = "algae-green-simple"},
    --{type = "unlock-recipe", recipe = "gas-carbon-dioxide-from-wood"},
    {type = "unlock-recipe", recipe = "pipe"},
    {type = "unlock-recipe", recipe = "pipe-to-ground"},
    {type = "unlock-recipe", recipe = "copper-pipe"},
    {type = "unlock-recipe", recipe = "copper-pipe-to-ground"},
    {type = "unlock-recipe", recipe = "iron-stick"},
    {type = "unlock-recipe", recipe = "iron-gear-wheel"},
    {type = "unlock-recipe", recipe = "burner-inserter"}
  },
  prerequisites = {"sb-startup1"},
  unit = {
    count = 1,
    ingredients = {{"sb-basic-circuit-board-tool", 1}},
    time = 5
  }
},
--[[
{
  type = "technology",
  name = "sb-startup3",
  icon = "__SeaBlock__/graphics/technology/coal.png",
  icon_size = 128,
  effects = {
    {type = "unlock-recipe", recipe = "wood-bricks"},
    {type = "unlock-recipe", recipe = "sb-wood-bricks-charcoal"},
    {type = "unlock-recipe", recipe = "carbon-separation-2"},
    {type = "unlock-recipe", recipe = "lab"}
  },
  prerequisites = {"sb-startup2"},
  unit = {
    count = 1,
    ingredients = {{"sb-algae-green-tool", 1}},
    time = 5
  }
},
{
  type = "technology",
  name = "sb-startup-sulfur",
  icon = "__base__/graphics/technology/sulfur-processing.png",
  icon_size = 128,
  effects = {
    --{type = "unlock-recipe", recipe = "gas-sulfur-dioxide"},
    --{type = "unlock-recipe", recipe = "liquid-sulfuric-acid"},
    --{type = "unlock-recipe", recipe = "yellow-waste-water-purification"}
  },
  prerequisites = {"sb-startup3"},
  unit = {
    count = 1,
    ingredients = {{"sb-sulfur-tool", 1}},
    time = 5
  }
},
]]--
{
  type = "technology",
  name = "sb-startup4",
  icon = "__SeaBlock__/graphics/technology/lab.png",
  icon_size = 128,
  effects = {
    {type = "unlock-recipe", recipe = "automation-science-pack"}
  },
  prerequisites = {"bio-wood-processing"},
  unit = {
    count = 1,
    ingredients = {{"sb-lab-tool", 1}},
    time = 5
  }
}
})

data.raw.recipe['copper-pipe-to-ground'].enabled = false
data.raw.recipe['basic-circuit-board'].enabled = false
if data.raw.recipe['automation-science-pack'].normal then
  data.raw.recipe['automation-science-pack'].normal.enabled = false
  data.raw.recipe['automation-science-pack'].expensive.enabled = false
else
  data.raw.recipe['automation-science-pack'].enabled = false
end
if data.raw.recipe['basic-transport-belt'] then
  table.insert(data.raw.technology['sb-startup2'].effects,
    {type = "unlock-recipe", recipe = "basic-transport-belt"})
else
  table.insert(data.raw.technology['sb-startup2'].effects,
    {type = "unlock-recipe", recipe = "transport-belt"})
end
