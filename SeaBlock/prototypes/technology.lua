data:extend({
  {
    type = "tool",
    name = "sb-angelsore3-tool",
    localised_name = { "item-name.angels-ore3-crushed" },
    icon = "__angelsrefining__/graphics/icons/angels-ore3-crushed.png",
    icon_size = 32,
    flags = { "hidden" },
    stack_size = 100,
    durability = 1,
  },
  {
    type = "tool",
    name = "sb-basic-circuit-board-tool",
    localised_name = { "item-name.basic-circuit-board" },
    icon = "__bobelectronics__/graphics/icons/basic-circuit-board.png",
    icon_size = 128,
    flags = { "hidden" },
    stack_size = 100,
    durability = 1,
  },
  {
    type = "tool",
    name = "sb-lab-tool",
    localised_name = { "item-name.lab" },
    icon = "__base__/graphics/icons/lab.png",
    icon_size = 64,
    icon_mipmaps = 4,
    flags = { "hidden" },
    stack_size = 100,
    durability = 1,
  },
  {
    type = "technology",
    name = "sb-startup1",
    icon = "__SeaBlock__/graphics/technology/ore.png",
    icon_size = 128,
    effects = {
      { type = "unlock-recipe", recipe = "angelsore1-crushed-smelting" },
      { type = "unlock-recipe", recipe = "angelsore3-crushed-smelting" },
      { type = "unlock-recipe", recipe = "copper-cable" },
    },
    unit = {
      count = 1,
      ingredients = { { "sb-angelsore3-tool", 1 } },
      time = 1,
    },
  },
  {
    type = "technology",
    name = "sb-startup3",
    icon = "__SeaBlock__/graphics/technology/basic-circuit-board.png",
    icon_size = 128,
    effects = {
      { type = "unlock-recipe", recipe = "inserter" },
      { type = "unlock-recipe", recipe = "pipe" },
      { type = "unlock-recipe", recipe = "pipe-to-ground" },
      { type = "unlock-recipe", recipe = "copper-pipe" },
      { type = "unlock-recipe", recipe = "copper-pipe-to-ground" },
      { type = "unlock-recipe", recipe = "iron-stick" },
      { type = "unlock-recipe", recipe = "iron-gear-wheel" },
      { type = "unlock-recipe", recipe = "burner-inserter" },
      { type = "unlock-recipe", recipe = "iron-chest" },
    },
    prerequisites = { "bio-wood-processing" },
    unit = {
      count = 1,
      ingredients = { { "sb-basic-circuit-board-tool", 1 } },
      time = 1,
    },
  },
  {
    type = "technology",
    name = "sb-startup4",
    icon = "__SeaBlock__/graphics/technology/lab.png",
    icon_size = 128,
    effects = {
      { type = "unlock-recipe", recipe = "automation-science-pack" },
    },
    prerequisites = { "sb-startup3" },
    unit = {
      count = 1,
      ingredients = { { "sb-lab-tool", 1 } },
      time = 1,
    },
  },
  {
    type = "technology",
    name = "sb-bio-processing-advanced",
    localised_name = { "technology-name.bio-processing-green" },
    localised_description = { "technology-description.bio-processing-green" },
    icon = "__angelsbioprocessing__/graphics/technology/algae-farm-tech.png",
    icon_size = 128,
    order = "c-a",
    prerequisites = {
      "bio-processing-red",
      "advanced-electronics",
      "angels-stone-smelting-2",
      "zinc-processing",
      "chemical-science-pack",
    },
    effects = {
      {
        type = "unlock-recipe",
        recipe = "algae-farm-4",
      },
    },
    unit = {
      count = 50,
      ingredients = {
        { type = "item", name = "automation-science-pack", amount = 1 },
        { type = "item", name = "logistic-science-pack", amount = 1 },
        { type = "item", name = "token-bio", amount = 1 },
        { type = "item", name = "chemical-science-pack", amount = 1 },
      },
      time = 30,
    },
  },
  {
    type = "technology",
    name = "steam-power",
    icon = "__base__/graphics/icons/fluid/steam.png",
    icon_size = 64,
    icon_mipmaps = 4,
    prerequisites = {},
    effects = {
      {
        type = "unlock-recipe",
        recipe = "boiler",
      },
      {
        type = "unlock-recipe",
        recipe = "steam-engine",
      },
    },
    unit = {
      count = 10,
      ingredients = {
        { "automation-science-pack", 1 },
      },
      time = 10,
    },
    order = "a-a",
  },
})

bobmods.lib.recipe.enabled("boiler", false)
bobmods.lib.recipe.enabled("steam-engine", false)
bobmods.lib.recipe.enabled("copper-pipe-to-ground", false)
bobmods.lib.recipe.enabled("basic-circuit-board", false)
bobmods.lib.recipe.enabled("automation-science-pack", false)
if data.raw.recipe["basic-transport-belt"] then
  bobmods.lib.tech.add_recipe_unlock("sb-startup3", "basic-transport-belt")
else
  bobmods.lib.tech.add_recipe_unlock("sb-startup3", "transport-belt")
end

if mods["bobwarfare"] then
  data:extend({
    {
      type = "technology",
      name = "sb-sniper-rifle",
      localised_name = { "item-name.sniper-rifle" },
      icon_size = 256,
      icon_mipmaps = 4,
      icon = "__base__/graphics/technology/military.png",
      effects = {
        {
          type = "unlock-recipe",
          recipe = "sniper-rifle",
        },
      },
      prerequisites = { "military-science-pack" },
      unit = {
        count = 200,
        ingredients = {
          { "automation-science-pack", 1 },
          { "logistic-science-pack", 1 },
          { "military-science-pack", 1 },
        },
        time = 15,
      },
    },
  })
end
