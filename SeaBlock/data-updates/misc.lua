local lib = require "lib"

if data.raw.item['wind-turbine-2'] then
  lib.substingredient('wind-turbine-2', 'iron-plate', 'steel-plate', 2)
  data.raw.recipe['wind-turbine-2'].enabled = false
  table.insert(data.raw.technology['steel-processing'].effects, {type = 'unlock-recipe', recipe = 'wind-turbine-2'})
end

-- No natural gas, use methane for manganese pellet smelting
lib.substingredient("pellet-manganese-smelting", "gas-natural-1", "gas-methane")

-- Remove steel's prerequiste on Chemical processing 1
data.raw.technology['steel-processing'].prerequisites = nil

-- Merge basic chemistry 2 into basic chemistry
local function movealleffects(from, to)
  for _,v in pairs(data.raw.technology[from].effects) do
    table.insert(data.raw.technology[to].effects, v)
  end
  for _,v in pairs(data.raw.technology) do
    for k,prerequisite in pairs(v.prerequisites or {}) do
      if prerequisite == from then
        v.prerequisites[k] = to
      end
    end
  end
  data.raw.technology[from].effects = {}
end
movealleffects('basic-chemistry-2', 'basic-chemistry')
movealleffects('basic-chemistry-3', 'basic-chemistry-2')
data.raw.technology['basic-chemistry-2'].unit = data.raw.technology['basic-chemistry-3'].unit
data.raw.technology['basic-chemistry-3'].enabled = false

-- Make Basic Chemistry depend on Wood Processing 2. Required for Charcoal > Carbon Dioxide
bobmods.lib.tech.add_prerequisite('basic-chemistry', 'bio-wood-processing-2')

-- Move Water Treatment from Electronics to Slag Processing 1. Hydro Plant no longer requires Green Circuits
-- Slag Processing 1 is first source of Sulfuric Waste Water
bobmods.lib.tech.replace_prerequisite('water-treatment', 'electronics', 'slag-processing-1')


data.raw.technology['water-washing-1'].prerequisites = {'ore-crushing'} -- Allow skipping of waste water recycling
lib.moveeffect('yellow-waste-water-purification', 'water-treatment-2', 'water-treatment')
data.raw.technology['electronics'].prerequisites = {
  'angels-solder-smelting-basic',
  'automation',
  'angels-tin-smelting-1',
  'angels-coal-processing'
}


if data.raw.recipe['liquid-fish-atmosphere'] then
  data.raw.recipe['liquid-fish-atmosphere'].category = 'chemistry'
end

if data.raw.technology['pumpjack'] then
  data.raw.technology['pumpjack'].hidden = true
end

if not seablock.trigger.mining_productivity then
  for i = 1, 4, 1 do
    if data.raw.technology['mining-productivity-' .. i] then
      data.raw.technology['mining-productivity-' .. i].hidden = true
    end
  end
end

-- Add prerequisite for Tin and Lead
if settings.startup['bobmods-logistics-beltoverhaul'].value then
  bobmods.lib.tech.add_prerequisite('logistics', 'slag-processing-1')
end

-- Tidy prerequisite for Bronze & Brass
bobmods.lib.tech.add_prerequisite('alloy-processing', 'angels-bronze-smelting-1')
if data.raw.technology['fluid-generator-1'] then
  bobmods.lib.tech.replace_prerequisite('fluid-generator-1', 'alloy-processing', 'angels-bronze-smelting-1')
end
bobmods.lib.tech.replace_prerequisite('logistics-2', 'alloy-processing', 'angels-bronze-smelting-1')
bobmods.lib.tech.remove_prerequisite('steel-mixing-furnace', 'alloy-processing')
bobmods.lib.tech.remove_prerequisite('chemical-science-pack', 'alloy-processing')
bobmods.lib.tech.remove_prerequisite('tungsten-alloy-processing', 'alloy-processing')
bobmods.lib.tech.remove_prerequisite('nitinol-processing', 'alloy-processing')
bobmods.lib.tech.remove_prerequisite('electric-mixing-furnace', 'alloy-processing')
bobmods.lib.tech.add_prerequisite('bob-fluid-handling-2', 'alloy-processing')

bobmods.lib.tech.remove_prerequisite('zinc-processing', 'electrolysis-1')
bobmods.lib.tech.replace_prerequisite('battery-3', 'zinc-processing', 'angels-zinc-smelting-1')
bobmods.lib.tech.replace_prerequisite('electric-pole-2', 'zinc-processing', 'angels-brass-smelting-1')
bobmods.lib.tech.replace_prerequisite('electric-substation-2', 'zinc-processing', 'angels-brass-smelting-1')
bobmods.lib.tech.replace_prerequisite('bob-bullets', 'zinc-processing', 'angels-gunmetal-smelting-1')
bobmods.lib.tech.replace_prerequisite('bob-shotgun-shells', 'zinc-processing', 'angels-gunmetal-smelting-1')

-- Add fluid handling as a prerequisite for Oil and gas extraction
-- Else Electric engine doesn't depend on Engine
bobmods.lib.tech.add_prerequisite('oil-gas-extraction', 'fluid-handling')

-- Move recipes that shouldn't be unlocked at startup
bobmods.lib.tech.add_recipe_unlock('geode-crystallization-1', 'bob-ruby-3')
bobmods.lib.tech.add_recipe_unlock('geode-crystallization-1', 'bob-sapphire-3')
bobmods.lib.tech.add_recipe_unlock('geode-crystallization-1', 'bob-emerald-3')
bobmods.lib.tech.add_recipe_unlock('geode-crystallization-1', 'bob-amethyst-3')
bobmods.lib.tech.add_recipe_unlock('geode-crystallization-1', 'bob-topaz-3')
bobmods.lib.tech.add_recipe_unlock('geode-crystallization-1', 'bob-diamond-3')
bobmods.lib.recipe.enabled('bob-ruby-3', false)
bobmods.lib.recipe.enabled('bob-sapphire-3', false)
bobmods.lib.recipe.enabled('bob-emerald-3', false)
bobmods.lib.recipe.enabled('bob-amethyst-3', false)
bobmods.lib.recipe.enabled('bob-topaz-3', false)
bobmods.lib.recipe.enabled('bob-diamond-3', false)
