local lib = require "lib"

local function SetRecipeCategory(recipes, category)
  for _,v in pairs(recipes) do
    if v and data.raw.recipe[v] then
      data.raw.recipe[v].category = category
    end
  end
end

-- Change recipe category from mixing-furnace to sintering
SetRecipeCategory({
  'tungsten-carbide',
  'tungsten-carbide-2',
  'copper-tungsten-alloy'},
  'sintering'
)

-- Change recipe category from mixing-furnace to blast-smelting
-- alien-blue-alloy, alien-orange-alloy
for k,v in pairs(data.raw.recipe) do
  if v.category == 'mixing-furnace' then
    SetRecipeCategory({v.name}, 'blast-smelting')
  end
end

-- Change recipe category from chemical-furnace to chemical-smelting
-- silicon-nitride, silicon-carbide, lithium-cobalt-oxide
for k,v in pairs(data.raw.recipe) do
  if v.category == 'chemical-furnace' then
    SetRecipeCategory({v.name}, 'chemical-smelting')
  end
end

-- Remove prereq alloy-processing
bobmods.lib.tech.remove_recipe_unlock('alloy-processing', 'stone-mixing-furnace')
bobmods.lib.tech.remove_recipe_unlock('alloy-processing', 'stone-mixing-furnace-from-stone-furnace')
bobmods.lib.tech.remove_recipe_unlock('alloy-processing', 'stone-furnace-from-stone-mixing-furnace')

-- Remove Chemical Furnaces
lib.substingredient('electric-chemical-mixing-furnace', 'electric-chemical-furnace', 'electric-furnace')

bobmods.lib.tech.remove_recipe_unlock('chemical-processing-1', 'stone-chemical-furnace')
bobmods.lib.tech.remove_recipe_unlock('chemical-processing-1', 'stone-chemical-furnace-from-stone-furnace')
bobmods.lib.tech.remove_recipe_unlock('chemical-processing-1', 'stone-furnace-from-stone-chemical-furnace')

data.raw['assembling-machine']['stone-chemical-furnace'].next_upgrade = nil
data.raw['assembling-machine']['electric-chemical-furnace'].next_upgrade = nil

if data.raw.technology['fluid-chemical-furnace'] then
  data.raw.technology['fluid-chemical-furnace'].enabled = false
end
data.raw.technology['steel-chemical-furnace'].enabled = false
data.raw.technology['electric-chemical-furnace'].enabled = false

if data.raw.technology['multi-purpose-furnace-1'] then
  bobmods.lib.tech.remove_prerequisite('multi-purpose-furnace-1', 'electric-chemical-furnace')
end

-- Remove smelting from crafting_categories so machine doesn't appear in Helmod
data.raw['assembling-machine']['electric-chemical-furnace'].crafting_categories = {'chemical-furnace'}

-- Fix up furnace tech icons
if not mods['reskins-bobs'] then
  for _,v in pairs({
    'fluid-mixing-furnace',
    'steel-mixing-furnace'
  }) do
    lib.copy_icon(data.raw.technology[v], data.raw.technology['advanced-material-processing'])
  end

  for _,v in pairs({
    'electric-mixing-furnace',
    'multi-purpose-furnace-1',
    'multi-purpose-furnace-2',
    'advanced-material-processing-3',
    'advanced-material-processing-4'
  }) do
    lib.copy_icon(data.raw.technology[v], data.raw.technology['advanced-material-processing-2'])
  end
end
