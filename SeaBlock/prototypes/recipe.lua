data:extend({
  {
    type = "recipe",
    name = "sb-wood-bricks-charcoal",
    category = "smelting",
    enabled = false,
    energy_required = 3.5,
    ingredients = { { type = "item", name = "angels-wood-bricks", amount = 1 } },
    results = { { type = "item", name = "angels-wood-charcoal", amount = 5 } },
    subgroup = "angels-bio-processing-wood",
  },
  {
    type = "recipe",
    name = "sb-thermal-bore-water",
    category = "sb-thermal-bore",
    subgroup = "angels-water-treatment",
    order = "h[thermal-bore-water]",
    energy_required = 10,
    enabled = false,
    ingredients = {
      { type = "item", name = "bob-lithium-chloride", amount = 1 },
    },
    results = {
      { type = "fluid", name = "angels-thermal-water", amount = 20 },
    },
  },
  {
    type = "recipe",
    name = "sb-thermal-extractor-water",
    category = "sb-thermal-extractor",
    subgroup = "angels-water-treatment",
    order = "h[thermal-extractor-water]",
    energy_required = 5,
    enabled = false,
    ingredients = {
      { type = "fluid", name = "steam", amount = 100 },
      { type = "item", name = "bob-lithium-chloride", amount = 2 },
    },
    results = {
      { type = "fluid", name = "angels-thermal-water", amount = 100 },
    },
  },
  {
    type = "recipe",
    name = "sb-water-mineralized-crystallization",
    category = "angels-crystallizing",
    subgroup = "angels-slag-processing-1",
    order = "z[slag-processing]",
    enabled = true,
    energy_required = 2,
    ingredients = {
      { type = "fluid", name = "angels-water-mineralized", amount = 200 },
    },
    results = {
      { type = "item", name = "angels-ore1", amount = 2, probability = 0.55 },
      { type = "item", name = "angels-ore3", amount = 1, probability = 0.7 },
    },
  },
  {
    type = "recipe",
    name = "sb-wood-foraging",
    localised_name = { "recipe-name.sb-wood-foraging" },
    category = "sb-crafting-handonly",
    subgroup = "angels-bio-processing-green",
    enabled = true,
    energy_required = 4,
    ingredients = {},
    results = {
      { type = "item", name = "wood", amount = 1 },
    },
    order = "ab[sb-wood-foraging]",
    allow_as_intermediate = true,
    allow_decomposition = false,
  },
  {
    type = "recipe",
    name = "sb-catalyst-metal-purple",
    category = "crafting",
    energy_required = 2,
    enabled = false,
    ingredients = {
      { type = "item", name = "angels-catalyst-metal-carrier", amount = 10 },
      { type = "item", name = "bob-gold-ore", amount = 1 },
      { type = "item", name = "bob-rutile-ore", amount = 1 },
    },
    results = {
      { type = "item", name = "sb-catalyst-metal-purple", amount = 10 },
    },
  },
  {
    -- Balance assuming blue algae is about equal to green algae in MJ value.
    -- 1 blue cellulose = 2MJ (1 green cellulose = 1MJ but converting to wood pellets doubles it.
    --   Wrong, but I'll stick with it to avoid increasing the cost of all petrochem recipes)
    -- basic oil refining is 100 crude oil -> 30 fuel oil + 50 naphtha (and other stuff i'll ignore)
    -- 45 crude oil = 27MJ (fuel oil) + 22.5MJ (naphtha) = 49.5MJ
    -- Let's round that up to 50MJ for 20 blue cellulose fiber.
    -- This is being generous, haven't counted base mineral oil.

    -- 100 sulfuric waste water -> 40 blue algae
    -- 40 blue algae -> 20 blue cellulose
    -- 20 blue cellulose -> 90 crude oil + 70 sulfuric waste water
    -- 70% of sulfuric waste water is recycled
    type = "recipe",
    name = "sb-blue-algae-liquefaction",
    icons = angelsmods.functions.create_liquid_recipe_icon({
      "angels-blue-cellulose-fiber",
    }, { { 100, 100, 100 }, { 171, 161, 055 }, { 127, 163, 109 } }),
    category = "oil-processing",
    enabled = false,
    energy_required = 5,
    ingredients = {
      { type = "item", name = "angels-blue-cellulose-fiber", amount = 20 },
      { type = "fluid", name = "steam", amount = 100 },
    },
    results = {
      { type = "fluid", name = "crude-oil", amount = 90 },
      { type = "fluid", name = "angels-water-yellow-waste", amount = 70 },
      { type = "fluid", name = "angels-gas-carbon-dioxide", amount = 20 },
    },
    subgroup = "angels-bio-processing-blue",
    order = "d[blue-algae-liquefaction]",
  },
})

bobmods.lib.tech.add_prerequisite("angels-oil-processing", "angels-bio-processing-blue")
bobmods.lib.tech.add_recipe_unlock("angels-oil-processing", "sb-blue-algae-liquefaction")

-- Setup recipe bases

local min_water_icons = angelsmods.functions.create_viscous_liquid_fluid_icon(
  nil,
  { { 039, 112, 194 }, { 093, 067, 049 }, { 070, 133, 232 }, { 109, 070, 020, 0.8 } }
)

-- Build Crystalizer slag processing recipes
local composite_recipes = {}
local slag_processing_list = {
  ["sb-water-mineralized-crystallization"] = min_water_icons,
}

local slag_recipe_shifts = {
  { -10, 10 },
  { 10, 10 },
}

for name, base_icons in pairs(slag_processing_list) do
  -- Check the recipe exists
  local recipe = data.raw.recipe[name]
  if recipe then
    local recipe_results
    if recipe.normal then
      log("Warning - Recipe still using 'normal' subsection : " .. name)
      recipe_results = recipe.normal.results
    else
      recipe_results = recipe.results
    end

    -- Build icon overlays based on recipe ingredients
    if recipe_results[1].name ~= "angels-void" then
      local shift_index = 1

      -- Setup base layer
      composite_recipes[name] = { ["base"] = { icons = base_icons } }

      -- Build icon overlays based on recipe products
      for _, product in pairs(recipe_results) do
        composite_recipes[name][product.name] = { shift = slag_recipe_shifts[shift_index], scale = 0.5 }
        shift_index = shift_index + 1
      end
    end
  end
end

for name, sources in pairs(composite_recipes) do
  seablock.reskins.composite_existing_icons(name, "recipe", sources)
end
