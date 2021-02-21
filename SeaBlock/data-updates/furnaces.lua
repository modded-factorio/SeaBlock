local fluid_furnaces = settings.startup['bobmods-assembly-oilfurnaces'].value

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
seablock.lib.hide_item('stone-chemical-furnace')
seablock.lib.hide_item('steel-chemical-furnace')
seablock.lib.hide_item('electric-chemical-furnace')

seablock.lib.substingredient('electric-chemical-mixing-furnace', 'electric-chemical-furnace', 'electric-furnace')

bobmods.lib.tech.remove_recipe_unlock('chemical-processing-1', 'stone-chemical-furnace')
bobmods.lib.tech.remove_recipe_unlock('chemical-processing-1', 'stone-chemical-furnace-from-stone-furnace')
bobmods.lib.tech.remove_recipe_unlock('chemical-processing-1', 'stone-furnace-from-stone-chemical-furnace')

seablock.lib.remove_recipe('stone-chemical-furnace')
seablock.lib.remove_recipe('stone-furnace-from-stone-chemical-furnace')
seablock.lib.remove_recipe('stone-chemical-furnace-from-stone-furnace')
seablock.lib.remove_recipe('steel-chemical-furnace')
seablock.lib.remove_recipe('steel-chemical-furnace-from-steel-furnace')
seablock.lib.remove_recipe('steel-furnace-from-steel-chemical-furnace')
seablock.lib.remove_recipe('electric-furnace-from-electric-chemical-furnace')
seablock.lib.remove_recipe('electric-chemical-furnace')
seablock.lib.remove_recipe('electric-chemical-furnace-from-electric-furnace')

data.raw['assembling-machine']['stone-chemical-furnace'].next_upgrade = nil
data.raw['assembling-machine']['electric-chemical-furnace'].next_upgrade = nil

data.raw.technology['steel-chemical-furnace'].enabled = false
data.raw.technology['electric-chemical-furnace'].enabled = false

if data.raw.technology['multi-purpose-furnace-1'] then
  bobmods.lib.tech.remove_prerequisite('multi-purpose-furnace-1', 'electric-chemical-furnace')
end

if fluid_furnaces then
  seablock.lib.hide_item('fluid-chemical-furnace')
  seablock.lib.remove_recipe('steel-chemical-furnace-from-fluid-chemical-furnace')
  seablock.lib.remove_recipe('fluid-chemical-furnace')
  seablock.lib.remove_recipe('fluid-chemical-furnace-from-fluid-furnace')
  seablock.lib.remove_recipe('fluid-furnace-from-fluid-chemical-furnace')
  data.raw.technology['fluid-chemical-furnace'].enabled = false
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

-- Disable metal mixing furnaces if multi purpose furnaces are disabled
if settings.startup['bobmods-assembly-multipurposefurnaces'].value then
  data.raw.technology['multi-purpose-furnace-1'].localised_name = {'technology-name.multi-purpose-furnace-1'}
  data.raw.technology['multi-purpose-furnace-2'].localised_name = {'technology-name.multi-purpose-furnace-2'}
else
  lib.remove_recipe('stone-mixing-furnace')
  lib.remove_recipe('steel-mixing-furnace')
  lib.remove_recipe('electric-mixing-furnace')
  
  lib.remove_recipe('stone-mixing-furnace-from-stone-furnace')
  lib.remove_recipe('stone-furnace-from-stone-mixing-furnace')  
  lib.remove_recipe('steel-mixing-furnace-from-steel-furnace')
  lib.remove_recipe('steel-furnace-from-steel-mixing-furnace')
  lib.remove_recipe('electric-mixing-furnace-from-electric-furnace')
  lib.remove_recipe('electric-furnace-from-electric-mixing-furnace')
  
  lib.hide_technology('steel-mixing-furnace')
  lib.hide_technology('electric-mixing-furnace')
  
  lib.hide_item('stone-mixing-furnace')
  lib.hide_item('steel-mixing-furnace')
  lib.hide_item('electric-mixing-furnace')
  
  data.raw['assembling-machine']['stone-mixing-furnace'].next_upgrade = nil
  
  -- Change crafting_categories so machines don't appear in Helmod
  data.raw['assembling-machine']['stone-mixing-furnace'].crafting_categories = {'chemical-furnace'}
  data.raw['assembling-machine']['steel-mixing-furnace'].crafting_categories = {'chemical-furnace'}
  data.raw['assembling-machine']['electric-mixing-furnace'].crafting_categories = {'chemical-furnace'}
  
  if fluid_furnaces then
    lib.remove_recipe('fluid-mixing-furnace')
    lib.remove_recipe('steel-mixing-furnace-from-fluid-mixing-furnace')
    lib.remove_recipe('fluid-mixing-furnace-from-fluid-furnace')
    lib.remove_recipe('fluid-furnace-from-fluid-mixing-furnace')  
    lib.hide_technology('fluid-mixing-furnace')
    lib.hide_item('fluid-mixing-furnace')
    data.raw['assembling-machine']['fluid-mixing-furnace'].crafting_categories = {'chemical-furnace'}
  end
end
