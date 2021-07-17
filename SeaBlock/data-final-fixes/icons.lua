-- Setup recipe bases

local min_water_icons = angelsmods.functions.create_viscous_liquid_fluid_icon(nil, { {039,112,194}, {093,067,049}, {070,133,232}, {109,070,020,0.8} })

-- Build Crystalizer slag processing recipes
local composite_recipes = {}
local slag_processing_list = {
  ['sb-water-mineralized-crystallization'] = min_water_icons  
}

local slag_recipe_shifts = {
  {-10, 10},
  {10, 10}
}

for name,base_icons in pairs(slag_processing_list) do
  -- Check the recipe exists
  local recipe = data.raw.recipe[name]
  if recipe then
    local recipe_results
    if recipe.normal then
      recipe_results = recipe.normal.results
    else
      recipe_results = recipe.results
    end

    -- Build icon overlays based on recipe ingredients
    if recipe_results[1].name ~= "angels-void" then
      local shift_index = 1

      -- Setup base layer
      composite_recipes[name] = {["base"] = {icons = base_icons}}

      -- Build icon overlays based on recipe products
      for _, product in pairs(recipe_results) do
        composite_recipes[name][product.name] = {shift = slag_recipe_shifts[shift_index], scale = 0.5}
        shift_index = shift_index + 1
      end
    end
  end
end

for name,sources in pairs(composite_recipes) do
  seablock.reskins.composite_existing_icons(name, "recipe", sources)
end


-- Revert Artisanal Reskins recipe icons
if mods['reskins-angels'] then
  local slag_processing_list = {
      'slag-processing-1',
      'slag-processing-2',
      'slag-processing-3',
      'slag-processing-4',
      'slag-processing-5',
      'slag-processing-6'
  }
  for _,name in pairs(slag_processing_list) do
    seablock.reskins.clear_icon_specification(name, 'recipe')
  end
end

-- Remove I overlay from explosives recipe
seablock.reskins.clear_icon_specification('explosives', 'recipe')
