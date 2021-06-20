if data.raw.item['wind-turbine-2'] then
  seablock.lib.substingredient('wind-turbine-2', 'iron-plate', 'steel-plate', 2)
  bobmods.lib.recipe.enabled('wind-turbine-2', false)
  bobmods.lib.tech.add_recipe_unlock('steel-processing', 'wind-turbine-2')
end

-- No natural gas, use methane for manganese pellet smelting
seablock.lib.substingredient("pellet-manganese-smelting", "gas-natural-1", "gas-methane")

-- Remove steel's prerequiste on Chemical processing 1
bobmods.lib.tech.remove_prerequisite('steel-processing', 'electrolysis-1')
bobmods.lib.tech.remove_prerequisite('steel-processing', 'chemical-processing-1')
bobmods.lib.tech.add_prerequisite('steel-processing', 'slag-processing-1')

-- Reduce cost of basic Steel from 8 iron to 6 iron (only for normal difficulty)
bobmods.lib.recipe.remove_difficulty_ingredient('angels-plate-steel-pre-heating', 'normal', 'angels-plate-hot-iron')
bobmods.lib.recipe.add_difficulty_ingredient('angels-plate-steel-pre-heating', 'normal', {type = 'item', name = 'angels-plate-hot-iron', amount = 6})

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

-- Fix Slag Processing 1 prerequisites
bobmods.lib.tech.add_prerequisite('slag-processing-1', 'angels-sulfur-processing-1')
bobmods.lib.tech.remove_prerequisite('slag-processing-1', 'water-treatment-2')

data.raw.technology['water-washing-1'].prerequisites = {'automation'} -- Allow skipping of waste water recycling
seablock.lib.moveeffect('yellow-waste-water-purification', 'water-treatment-2', 'water-treatment')
seablock.lib.moveeffect('clarifier', 'water-treatment', 'water-washing-1', 3)

data.raw.technology['electronics'].prerequisites = {
  'angels-solder-smelting-basic',
  'angels-coal-processing'
}

if bobmods.lib.tech.has_recipe_unlock('angels-tin-smelting-1', 'basic-tinned-copper-wire') then
  seablock.lib.moveeffect('basic-tinned-copper-wire', 'angels-tin-smelting-1', 'electronics', 1)
end

if data.raw.recipe['liquid-fish-atmosphere'] then
  data.raw.recipe['liquid-fish-atmosphere'].category = 'chemistry'
end

seablock.lib.hide_technology('pumpjack')

if not seablock.trigger.mining_productivity then
  for i = 1, 4, 1 do
    if data.raw.technology['mining-productivity-' .. i] then
      seablock.lib.hide_technology('mining-productivity-' .. i)
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
seablock.lib.add_recipe_unlock('geode-crystallization-1', 'bob-ruby-3')
seablock.lib.add_recipe_unlock('geode-crystallization-1', 'bob-sapphire-3')
seablock.lib.add_recipe_unlock('geode-crystallization-1', 'bob-emerald-3')
seablock.lib.add_recipe_unlock('geode-crystallization-1', 'bob-amethyst-3')
seablock.lib.add_recipe_unlock('geode-crystallization-1', 'bob-topaz-3')
seablock.lib.add_recipe_unlock('geode-crystallization-1', 'bob-diamond-3')
if mods['bobenemies'] then
  seablock.lib.add_recipe_unlock('bio-processing-alien-3', 'alien-artifact-red-from-small')
  seablock.lib.add_recipe_unlock('bio-processing-alien-3', 'alien-artifact-yellow-from-small')
  seablock.lib.add_recipe_unlock('bio-processing-alien-3', 'alien-artifact-orange-from-small')
  seablock.lib.add_recipe_unlock('bio-processing-alien-3', 'alien-artifact-blue-from-small')
  seablock.lib.add_recipe_unlock('bio-processing-alien-3', 'alien-artifact-purple-from-small')
  seablock.lib.add_recipe_unlock('bio-processing-alien-3', 'alien-artifact-green-from-small')
  seablock.lib.add_recipe_unlock('bio-processing-alien-3', 'alien-artifact-from-small')
end

bobmods.lib.tech.remove_recipe_unlock('chemical-processing-2', 'carbon-dioxide')
seablock.lib.remove_recipe('carbon-dioxide')

bobmods.lib.tech.remove_prerequisite('tungsten-processing', 'angels-nickel-smelting-1')

-- Merge tech Plastics into Plastic 1
seablock.lib.moveeffect('plastic-pipe', 'plastics', 'plastic-1')
seablock.lib.moveeffect('plastic-pipe-to-ground', 'plastics', 'plastic-1')
bobmods.lib.tech.remove_recipe_unlock('bio-plastic-1', 'solid-plastic')
bobmods.lib.tech.remove_recipe_unlock('bio-arboretum-swamp-1', 'solid-plastic')
bobmods.lib.tech.remove_prerequisite('plastic-1', 'plastics')
bobmods.lib.tech.remove_prerequisite('plastic-1', 'angels-advanced-chemistry-2')
bobmods.lib.tech.add_prerequisite('plastic-1', 'gas-steam-cracking-1')
bobmods.lib.tech.add_prerequisite('plastic-1', 'oil-steam-cracking-1')
bobmods.lib.tech.replace_prerequisite('advanced-electronics', 'plastics', 'plastic-1')
bobmods.lib.tech.replace_prerequisite('battery', 'plastics', 'plastic-1')
bobmods.lib.tech.replace_prerequisite('bio-arboretum-swamp-1', 'plastics', 'plastic-1')
bobmods.lib.tech.replace_prerequisite('bio-plastic-1', 'plastics', 'plastic-1')
if data.raw.technology['sct-lab-t3'] then
  bobmods.lib.tech.remove_prerequisite('sct-lab-t3', 'plastics')
  bobmods.lib.tech.add_prerequisite('sct-lab-t3', 'angels-cobalt-steel-smelting-1')
  bobmods.lib.tech.add_prerequisite('sct-lab-t3', 'angels-glass-smelting-1')
  bobmods.lib.tech.add_prerequisite('sct-lab-t3', 'angels-aluminium-smelting-1')
end

seablock.lib.hide_technology('plastics')


-- Buff Lime filtering
seablock.lib.substingredient('filter-lime', 'solid-lime', nil, 1)
data.raw.recipe['filter-lime'].energy_required = 1
data.raw.recipe['angels-sulfur-scrubber'].energy_required = 6

-- Make Long Inserters a startup tech
if data.raw.technology['logistics-0'] then
  bobmods.lib.tech.replace_prerequisite('long-inserters-1', 'logistics', 'logistics-0')
end

-- Adjust for handcrafting boards

-- Divide by 2
seablock.lib.substingredient('solid-alginic-acid', 'algae-brown', nil, 5)
seablock.lib.substresult('solid-alginic-acid', 'solid-alginic-acid', nil, 1)
data.raw.recipe['solid-alginic-acid'].energy_required = 5

-- Divide by 5
seablock.lib.substingredient('solid-wood-pulp', 'cellulose-fiber', nil, 4)
seablock.lib.substingredient('solid-wood-pulp', 'solid-alginic-acid', nil, 1)
seablock.lib.substresult('solid-wood-pulp', 'solid-wood-pulp', nil, 4)
data.raw.recipe['solid-wood-pulp'].energy_required = 0.8

-- Tidy up ore silo prerequisites
if mods['angelsaddons-storage'] then
  bobmods.lib.tech.remove_prerequisite('ore-silos', 'angels-coal-processing')
  bobmods.lib.tech.replace_prerequisite('ore-silos', 'ore-crushing', 'ore-advanced-crushing')
end

-- Logistic System prerequisite of Pink Science
if not data.raw.tool['advanced-logistic-science-pack'] then
  bobmods.lib.tech.add_prerequisite('logistic-system', 'utility-science-pack')
end

-- Cobalt Oxide prerequisite for Battery 2
bobmods.lib.tech.replace_prerequisite('battery-2', 'cobalt-processing', 'angels-cobalt-smelting-2')

-- Saline rebalance
seablock.lib.substingredient('solid-salt-dissolving', 'solid-salt', nil, 15)
seablock.lib.substingredient('solid-salt-dissolving', 'water-purified', 'water', 1000)
seablock.lib.substresult('solid-salt-dissolving', 'water-saline', nil, 1000)
data.raw.recipe['solid-salt-dissolving'].energy_required = 5

-- Swap out Nickel and Zinc plates
seablock.lib.substingredient('roboport-antenna-3', 'nickel-plate', 'titanium-plate', nil)
bobmods.lib.recipe.remove_ingredient('roboport-antenna-4', 'nickel-plate')
seablock.lib.substingredient('silver-zinc-battery', 'zinc-plate', 'solid-zinc-oxide', nil)

bobmods.lib.tech.add_prerequisite('battery-3', 'angels-zinc-smelting-3')

seablock.lib.hide_item('nickel-plate')
seablock.lib.hide_item('zinc-plate')
seablock.lib.hide_item('cobalt-plate')

if mods['cargo-ships'] then
  seablock.lib.hide_item('oil_rig')
end

-- Swap gold for platinum
seablock.lib.substingredient('processing-electronics', 'gilded-copper-cable', 'angels-wire-platinum', 10)
seablock.lib.substingredient('module-processor-board-3', 'gold-plate', 'angels-plate-platinum', nil)
bobmods.lib.tech.add_prerequisite('advanced-electronics-3', 'angels-platinum-smelting-1')
