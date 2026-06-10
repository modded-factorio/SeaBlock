if data.raw.item["wind-turbine-2"] then
  seablock.lib.substingredient("wind-turbine-2", "iron-plate", "steel-plate", 3)
  bobmods.lib.recipe.enabled("wind-turbine-2", false)
  bobmods.lib.tech.add_recipe_unlock("steel-processing", "wind-turbine-2")
end

-- No natural gas, use methane for manganese pellet smelting
seablock.lib.substingredient("angels-solid-manganese-oxide-2", "angels-gas-natural-1", "angels-gas-methane")
bobmods.lib.tech.remove_prerequisite("angels-manganese-smelting-3", "oil-gathering")
bobmods.lib.tech.add_prerequisite("angels-manganese-smelting-3", "angels-advanced-gas-processing")

-- Remove steel's prerequiste on Chemical processing 1
bobmods.lib.tech.remove_prerequisite("steel-processing", "bob-chemical-processing-1")

-- Move Water Treatment from Electronics to Slag Processing 1. Hydro Plant no longer requires Green Circuits
-- Slag Processing 1 is first source of Sulfuric Waste Water
bobmods.lib.tech.remove_prerequisite("angels-water-treatment", "angels-fluid-control")
bobmods.lib.tech.add_prerequisite("angels-water-treatment", "angels-slag-processing-1")

-- Allow skipping of waste water recycling
bobmods.lib.tech.remove_prerequisite("angels-water-washing-1", "angels-water-treatment")
bobmods.lib.tech.add_prerequisite("angels-water-washing-1", "automation")
seablock.lib.moveeffect("angels-yellow-waste-water-purification", "angels-water-treatment-2", "angels-water-treatment")

bobmods.lib.tech.remove_prerequisite("bob-electronics", "bob-chemical-processing-1")

seablock.lib.hide_technology("oil-gathering")

for i = 1, 4, 1 do
  if data.raw.technology["mining-productivity-" .. i] then
    seablock.lib.hide_technology("mining-productivity-" .. i)
    data.raw.technology["mining-productivity-" .. i].effects = {}
  end
end

-- Angels-sea-pump-resource is a virtual resource.
-- When the heavy offshore pump is placed, it is supposed to be replaced by the resource and a mining-drill.
-- Removing the resource causes placement of heavy pumps to crash new maps.
-- Crude-oil causes an error because of the trigger techs
local exclusion_map = {
  ["angels-sea-pump-resource"] = true,
  ["crude-oil"] = true
}

-- Remove resources so mining recipes don't show in FNEI
-- Have to leave at least one resource or game will not load
for k, _ in pairs(data.raw["resource"]) do
  if (not exclusion_map[k]) then
    data.raw["resource"][k] = nil
  end
end

-- Tidy prerequisite for Brass
bobmods.lib.tech.remove_prerequisite("bob-zinc-processing", "bob-electrolysis-1")
bobmods.lib.tech.replace_prerequisite("bob-battery-3", "bob-zinc-processing", "angels-zinc-smelting-1")
if mods["bobpower"] then
  bobmods.lib.tech.replace_prerequisite("bob-electric-pole-2", "bob-zinc-processing", "angels-brass-smelting-1")
  bobmods.lib.tech.replace_prerequisite("bob-electric-substation-2", "bob-zinc-processing", "angels-brass-smelting-1")
end

-- Make Long Inserters a startup tech
if data.raw.technology["logistics-0"] then
  bobmods.lib.tech.replace_prerequisite("bob-long-inserters-1", "logistics", "logistics-0")
end

-- Tidy up ore silo prerequisites
if mods["angelsaddons-storage"] then
  bobmods.lib.tech.remove_prerequisite("ore-silos", "angels-coal-processing")
  bobmods.lib.tech.replace_prerequisite("ore-silos", "angels-ore-crushing", "angels-ore-advanced-crushing")
end

-- Logistic System prerequisite of Pink Science
if not data.raw.tool["bob-advanced-logistic-science-pack"] then
  bobmods.lib.tech.add_prerequisite("logistic-system", "utility-science-pack")
end

-- Add missing science packs

for _, v in pairs({
  "bob-gem-processing-1",
  "bob-gem-processing-2",
  "bob-gem-processing-3",
  "angels-geode-crystallization-1",
  "bob-polishing",
}) do
  if data.raw.technology[v] then
    bobmods.lib.tech.add_new_science_pack(v, "chemical-science-pack", 1)
  end
end

bobmods.lib.tech.add_prerequisite("bob-polishing", "chemical-science-pack")
bobmods.lib.tech.add_prerequisite("angels-geode-crystallization-1", "chemical-science-pack")

-- Buff platinum from mixed output sorting
seablock.lib.substresult("angels-ore-pure-mix2-processing", "angels-platinum-ore", nil, 2)
seablock.lib.substresult("angels-ore9-crystal-processing", "angels-platinum-ore", nil, 2)

-- Unhide rocket part to make it easier to view recipes
if data.raw.recipe["rocket-part"] then
  local r = data.raw.recipe["rocket-part"]

  r.hidden = false
  r.hide_from_player_crafting = true
end
