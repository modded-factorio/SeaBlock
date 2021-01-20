local lib = require "lib"

if data.raw.item['wind-turbine-2'] then
  lib.substingredient('wind-turbine-2', 'iron-plate', 'steel-plate', 2)
  bobmods.lib.recipe.enabled('wind-turbine-2', false)
  bobmods.lib.tech.add_recipe_unlock('steel-processing', 'wind-turbine-2')
end

-- No natural gas, use methane for manganese pellet smelting
lib.substingredient("pellet-manganese-smelting", "gas-natural-1", "gas-methane")

-- Remove steel's prerequiste on Chemical processing 1
bobmods.lib.tech.replace_prerequisite('steel-processing', 'electrolysis-1', 'slag-processing-1')
bobmods.lib.tech.remove_prerequisite('steel-processing', 'chemical-processing-1')
      
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

data.raw.technology['water-washing-1'].prerequisites = {'automation'} -- Allow skipping of waste water recycling
lib.moveeffect('yellow-waste-water-purification', 'water-treatment-2', 'water-treatment')
lib.moveeffect('clarifier', 'water-treatment', 'water-washing-1', 3)

-- Increase tech cost to 50
data.raw.technology['water-treatment'].unit.count = 50
data.raw.technology['electronics'].prerequisites = {
  'angels-solder-smelting-basic',
  'angels-coal-processing'
}

lib.moveeffect('basic-tinned-copper-wire', 'angels-tin-smelting-1', 'electronics', 1)

if data.raw.recipe['liquid-fish-atmosphere'] then
  data.raw.recipe['liquid-fish-atmosphere'].category = 'chemistry'
end

lib.hide_technology('pumpjack')

if not seablock.trigger.mining_productivity then
  for i = 1, 4, 1 do
    if data.raw.technology['mining-productivity-' .. i] then
      lib.hide_technology('mining-productivity-' .. i)
      data.raw.technology['mining-productivity-' .. i].effects = {}
    end
  end
end

-- Remove resources so mining recipes don't show in FNEI
for k,v in pairs(data.raw['resource']) do
  if k ~='iron-ore' and k ~= 'coal' then
    data.raw['resource'][k] = nil
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
if mods['bobpower'] then
  bobmods.lib.tech.replace_prerequisite('electric-pole-2', 'zinc-processing', 'angels-brass-smelting-1')
  bobmods.lib.tech.replace_prerequisite('electric-substation-2', 'zinc-processing', 'angels-brass-smelting-1')
end
if mods['bobwarfare'] then
  bobmods.lib.tech.replace_prerequisite('bob-bullets', 'zinc-processing', 'angels-gunmetal-smelting-1')
  bobmods.lib.tech.replace_prerequisite('bob-shotgun-shells', 'zinc-processing', 'angels-gunmetal-smelting-1')
end

-- Add fluid handling as a prerequisite for Oil and gas extraction
-- Else Electric engine doesn't depend on Engine
bobmods.lib.tech.add_prerequisite('oil-gas-extraction', 'fluid-handling')

-- Move recipes that shouldn't be unlocked at startup
lib.add_recipe_unlock('geode-crystallization-1', 'bob-ruby-3')
lib.add_recipe_unlock('geode-crystallization-1', 'bob-sapphire-3')
lib.add_recipe_unlock('geode-crystallization-1', 'bob-emerald-3')
lib.add_recipe_unlock('geode-crystallization-1', 'bob-amethyst-3')
lib.add_recipe_unlock('geode-crystallization-1', 'bob-topaz-3')
lib.add_recipe_unlock('geode-crystallization-1', 'bob-diamond-3')
if mods['bobenemies'] then
  lib.add_recipe_unlock('bio-processing-alien-3', 'alien-artifact-red-from-small')
  lib.add_recipe_unlock('bio-processing-alien-3', 'alien-artifact-yellow-from-small')
  lib.add_recipe_unlock('bio-processing-alien-3', 'alien-artifact-orange-from-small')
  lib.add_recipe_unlock('bio-processing-alien-3', 'alien-artifact-blue-from-small')
  lib.add_recipe_unlock('bio-processing-alien-3', 'alien-artifact-purple-from-small')
  lib.add_recipe_unlock('bio-processing-alien-3', 'alien-artifact-green-from-small')
  lib.add_recipe_unlock('bio-processing-alien-3', 'alien-artifact-from-small')
end

bobmods.lib.tech.remove_recipe_unlock('chemical-processing-2', 'carbon-dioxide')
lib.remove_recipe('carbon-dioxide')

bobmods.lib.tech.remove_prerequisite('tungsten-processing', 'angels-nickel-smelting-1')

-- Merge tech Plastics into Plastic 1
lib.moveeffect('plastic-pipe', 'plastics', 'plastic-1')
lib.moveeffect('plastic-pipe-to-ground', 'plastics', 'plastic-1')
bobmods.lib.tech.remove_recipe_unlock('plastics', 'solid-plastic')
bobmods.lib.tech.remove_prerequisite('plastic-1', 'plastics')
bobmods.lib.tech.remove_prerequisite('plastic-1', 'angels-advanced-chemistry-1')
bobmods.lib.tech.add_prerequisite('plastic-1', 'gas-steam-cracking-1')
bobmods.lib.tech.add_prerequisite('plastic-1', 'oil-steam-cracking-1')
bobmods.lib.tech.replace_prerequisite('advanced-electronics', 'plastics', 'plastic-1')
bobmods.lib.tech.replace_prerequisite('battery', 'plastics', 'plastic-1')
bobmods.lib.tech.replace_prerequisite('bio-arboretum-swamp-1', 'plastics', 'plastic-1')
bobmods.lib.tech.replace_prerequisite('bio-plastic-1', 'plastics', 'plastic-1')
if data.raw.technology['sct-lab-t3'] then
  bobmods.lib.tech.remove_prerequisite('sct-lab-t3', 'plastics')
end
lib.hide_technology('plastics')


-- Buff Lime filtering
lib.substingredient('filter-lime', 'solid-lime', nil, 1)
data.raw.recipe['filter-lime'].energy_required = 1
data.raw.recipe['angels-sulfur-scrubber'].energy_required = 6
