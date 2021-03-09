-- Setup recipe bases

local sludge_icons = {
    {
        icon = "__angelsrefining__/graphics/icons/angels-liquid/liquid-recipe-base.png",
        icon_size = 600,
        icon_mipmaps = 1,
        tint = util.color("404040b2"),
    },
    {
        icon = "__angelsrefining__/graphics/icons/angels-liquid/liquid-recipe-top.png",
        icon_size = 600,
        icon_mipmaps = 1,
        tint = util.color("ca6311"),
    },
    {
        icon = "__angelsrefining__/graphics/icons/angels-liquid/liquid-recipe-mid.png",
        icon_size = 600,
        icon_mipmaps = 1,
        tint = util.color("613414"),
    },
    {
        icon = "__angelsrefining__/graphics/icons/angels-liquid/liquid-recipe-bot.png",
        icon_size = 600,
        icon_mipmaps = 1,
        tint = util.color("613414"),
    }
}
local min_water_icons = angelsmods.functions.create_viscous_liquid_fluid_icon(nil, { {039,112,194}, {093,067,049}, {070,133,232}, {109,070,020,0.8} })

-- Build Crystalizer slag processing recipes
local composite_recipes = {}
local slag_processing_list = {
  ['slag-processing-1'] = sludge_icons,
  ['slag-processing-2'] = sludge_icons,
  ['slag-processing-3'] = sludge_icons,
  ['slag-processing-4'] = sludge_icons,
  ['slag-processing-5'] = sludge_icons,
  ['slag-processing-6'] = sludge_icons,
  ['slag-processing-7'] = sludge_icons,
  ['slag-processing-8'] = sludge_icons,
  ['sb-water-mineralized-crystallization'] = min_water_icons  
}

if mods['Clowns-Extended-Minerals'] then
  slag_processing_list['sb-slag-processing-clowns-1'] = sludge_icons
  slag_processing_list['sb-slag-processing-clowns-2'] = sludge_icons
  slag_processing_list['sb-slag-processing-clowns-3'] = sludge_icons
  slag_processing_list['sb-slag-processing-clowns-4'] = sludge_icons
  slag_processing_list['sb-slag-processing-clowns-5'] = sludge_icons
  slag_processing_list['sb-slag-processing-clowns-6'] = sludge_icons
  slag_processing_list['sb-slag-processing-clowns-7'] = sludge_icons
  slag_processing_list['sb-slag-processing-clowns-8'] = sludge_icons
  slag_processing_list['sb-slag-processing-clowns-9'] = sludge_icons
end

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
