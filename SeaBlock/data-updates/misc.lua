if data.raw.item["wind-turbine-2"] then
  seablock.lib.substingredient("wind-turbine-2", "iron-plate", "steel-plate", 3)
  bobmods.lib.recipe.enabled("wind-turbine-2", false)
  bobmods.lib.tech.add_recipe_unlock("steel-processing", "wind-turbine-2")
end

-- No natural gas, use methane for manganese pellet smelting
seablock.lib.substingredient("angels-solid-manganese-oxide-2", "angels-gas-natural-1", "angels-gas-methane")
bobmods.lib.tech.remove_prerequisite("angels-manganese-smelting-3", "angels-oil-gas-extraction")
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

bobmods.lib.recipe.set_category("angels-liquid-fish-atmosphere", "chemistry")
seablock.lib.hide_technology("oil-gathering")

if not seablock.trigger.mining_productivity then
  for i = 1, 4, 1 do
    if data.raw.technology["mining-productivity-" .. i] then
      seablock.lib.hide_technology("mining-productivity-" .. i)
      data.raw.technology["mining-productivity-" .. i].effects = {}
    end
  end
end

-- Remove resources so mining recipes don't show in FNEI
-- Have to leave at least one resource or game will not load

--TODO: handle this : ressource removal creates bugs
--[[for k, v in pairs(data.raw["resource"]) do
  -- Sea-pump-resource is a virtual resource.
  -- When the offshore pump is placed, it is supposed to be replaced by the resource and a mining-drill.
  -- Removing the resource causes placement of heavy pumps to crash new maps.
  if k ~= "sea-pump-resource" then
    data.raw["resource"][k] = nil
  end
end]]

-- Add prerequisite for Tin and Lead
if settings.startup["bobmods-logistics-beltoverhaul"].value then
  bobmods.lib.tech.add_prerequisite("logistics", "angels-ore-crushing")
end

-- Tidy prerequisite for Brass
bobmods.lib.tech.remove_prerequisite("bob-zinc-processing", "bob-electrolysis-1")
bobmods.lib.tech.replace_prerequisite("bob-battery-3", "bob-zinc-processing", "angels-zinc-smelting-1")
if mods["bobpower"] then
  bobmods.lib.tech.replace_prerequisite("bob-electric-pole-2", "bob-zinc-processing", "angels-brass-smelting-1")
  bobmods.lib.tech.replace_prerequisite("bob-electric-substation-2", "bob-zinc-processing", "angels-brass-smelting-1")
end

-- Move recipes that shouldn't be unlocked at startup
if mods["bobenemies"] then
  seablock.lib.add_recipe_unlock("angels-bio-processing-alien-3", "bob-alien-artifact-red-from-small")
  seablock.lib.add_recipe_unlock("angels-bio-processing-alien-3", "bob-alien-artifact-yellow-from-small")
  seablock.lib.add_recipe_unlock("angels-bio-processing-alien-3", "bob-alien-artifact-orange-from-small")
  seablock.lib.add_recipe_unlock("angels-bio-processing-alien-3", "bob-alien-artifact-blue-from-small")
  seablock.lib.add_recipe_unlock("angels-bio-processing-alien-3", "bob-alien-artifact-purple-from-small")
  seablock.lib.add_recipe_unlock("angels-bio-processing-alien-3", "bob-alien-artifact-green-from-small")
  seablock.lib.add_recipe_unlock("angels-bio-processing-alien-3", "bob-alien-artifact")
end

bobmods.lib.tech.remove_prerequisite("bob-tungsten-processing", "angels-nickel-smelting-1")

bobmods.lib.tech.remove_recipe_unlock("angels-bio-arboretum-swamp-1", "angels-solid-plastic")

-- Buff Lime filtering
seablock.lib.substingredient("angels-filter-lime", "angels-solid-lime", nil, 1)
data.raw.recipe["angels-filter-lime"].energy_required = 1
data.raw.recipe["angels-sulfur-air-scrubbing"].energy_required = 6

-- Make Long Inserters a startup tech
if data.raw.technology["logistics-0"] then
  bobmods.lib.tech.replace_prerequisite("bob-long-inserters-1", "logistics", "logistics-0")
end

-- Adjust for handcrafting boards

-- Divide by 2
seablock.lib.substingredient("angels-solid-alginic-acid", "angels-algae-brown", nil, 5)
seablock.lib.substresult("angels-solid-alginic-acid", "angels-solid-alginic-acid", nil, 1)
data.raw.recipe["angels-solid-alginic-acid"].energy_required = 5

-- Divide by 5
seablock.lib.substingredient("angels-solid-wood-pulp", "angels-cellulose-fiber", nil, 4)
seablock.lib.substingredient("angels-solid-wood-pulp", "angels-solid-alginic-acid", nil, 1)
seablock.lib.substresult("angels-solid-wood-pulp", "angels-solid-wood-pulp", nil, 4)
data.raw.recipe["angels-solid-wood-pulp"].energy_required = 0.8

-- Tidy up ore silo prerequisites
if mods["angelsaddons-storage"] then
  bobmods.lib.tech.remove_prerequisite("ore-silos", "angels-coal-processing")
  bobmods.lib.tech.replace_prerequisite("ore-silos", "angels-ore-crushing", "angels-ore-advanced-crushing")
end

-- Logistic System prerequisite of Pink Science
if not data.raw.tool["bob-advanced-logistic-science-pack"] then
  bobmods.lib.tech.add_prerequisite("logistic-system", "utility-science-pack")
end

-- Saline rebalance
seablock.lib.substingredient("angels-solid-salt-dissolving", "angels-solid-salt", nil, 15)
seablock.lib.substingredient("angels-solid-salt-dissolving", "angels-water-purified", "water", 1000)
seablock.lib.substresult("angels-solid-salt-dissolving", "angels-water-saline", nil, 1000)
data.raw.recipe["angels-solid-salt-dissolving"].energy_required = 5

-- Add missing science packs

for _, v in pairs({
  "angels-bio-processing-alien-3",
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

if mods["bobrevamp"] and not mods["bobclasses"] then
  bobmods.lib.tech.add_new_science_pack("bob-rtg", "production-science-pack", 1)
  bobmods.lib.tech.add_new_science_pack("bob-rtg", "utility-science-pack", 1)
  bobmods.lib.tech.add_prerequisite("bob-rtg", "utility-science-pack")
  bobmods.lib.tech.remove_prerequisite("bob-rtg", "angels-coal-processing-3")
  bobmods.lib.tech.add_prerequisite("bob-rtg", "angels-sodium-processing-2")
end

-- Swap gold for platinum
seablock.lib.substingredient("bob-processing-electronics", "angels-wire-platinum", nil, 20)
if mods["bobmodules"] then
  seablock.lib.substingredient("bob-module-processor-board-3", "angels-wire-platinum", "angels-plate-platinum", nil)
end
bobmods.lib.tech.add_prerequisite("bob-advanced-processing-unit", "angels-platinum-smelting-1")
seablock.lib.substresult("angels-ore-pure-mix2-processing", "angels-platinum-ore", nil, 2)
seablock.lib.substresult("angels-ore9-crystal-processing", "angels-platinum-ore", nil, 2)
-- Swap stiratite for crotinnium so all pure ores are used
seablock.lib.substingredient("angels-ore-pure-mix2-processing", "angels-ore3-pure", "angels-ore4-pure", nil)

-- Unhide rocket part to make it easier to view recipes
if data.raw.recipe["rocket-part"] then
  -- angelsmods.functions.remove_flag("rocket-part", "hidden")
  -- angelsmods.functions.unhide("rocket-part")
  local r = data.raw.recipe["rocket-part"]

  if r.normal then
    r.normal.hidden = false
    r.normal.hide_from_player_crafting = true
  end
  if r.expensive then
    r.expensive.hidden = false
    r.expensive.hide_from_player_crafting = true
  end
  if not r.normal and not r.expensive then
    r.hidden = false
    r.hide_from_player_crafting = true
  end
end

-- Buff bob's silicon and tungsten recipes
seablock.lib.substingredient("bob-silicon-carbide", "bob-silicon-powder", nil, 10)
seablock.lib.substingredient("bob-silicon-carbide", "bob-carbon", nil, 10)
data.raw.recipe["bob-silicon-carbide"].results[1].amount = 20

seablock.lib.substingredient("bob-silicon-nitride", "bob-silicon-powder", nil, 10)
seablock.lib.substingredient("bob-silicon-nitride", "angels-gas-nitrogen", nil, 130)
data.raw.recipe["bob-silicon-nitride"].results[1].amount = 10

seablock.lib.substingredient("bob-tungsten-carbide", "bob-tungsten-oxide", nil, 10)
seablock.lib.substingredient("bob-tungsten-carbide", "bob-carbon", nil, 10)
seablock.lib.substresult("bob-tungsten-carbide", "bob-tungsten-carbide", nil, 20)
bobmods.lib.recipe.set_energy_required("bob-tungsten-carbide", 6)

seablock.lib.substingredient("bob-tungsten-carbide-2", "bob-powdered-tungsten", nil, 10)
seablock.lib.substingredient("bob-tungsten-carbide-2", "bob-carbon", nil, 10)
seablock.lib.substresult("bob-tungsten-carbide-2", "bob-tungsten-carbide", nil, 20)
bobmods.lib.recipe.set_energy_required("bob-tungsten-carbide-2", 6)

seablock.lib.substingredient("bob-copper-tungsten-alloy", "bob-powdered-tungsten", nil, 15)
seablock.lib.substingredient("bob-copper-tungsten-alloy", "copper-plate", "angels-powder-copper", 10)
seablock.lib.substresult("bob-copper-tungsten-alloy", "bob-copper-tungsten-alloy", nil, 25)
bobmods.lib.recipe.set_energy_required("bob-copper-tungsten-alloy", 8)
bobmods.lib.tech.add_prerequisite("bob-tungsten-alloy-processing", "angels-copper-smelting-2")

-- Other prerequisites
if data.raw.technology["bob-electronics-machine-1"] then
  bobmods.lib.tech.add_prerequisite("bob-electronics-machine-1", "bob-electronics")
end
bobmods.lib.tech.add_prerequisite("angels-bio-pressing-1", "angels-bio-nutrient-paste")

bobmods.lib.tech.add_prerequisite("angels-resins", "automation-2")
bobmods.lib.tech.add_prerequisite("plastics", "automation-2")
if mods["boblogistics"] then
  bobmods.lib.tech.add_prerequisite("bob-repair-pack-2", "military")
end
bobmods.lib.tech.add_prerequisite("angels-advanced-chemistry-1", "fluid-handling")
bobmods.lib.tech.add_prerequisite("angels-water-treatment-2", "fluid-handling")
bobmods.lib.tech.add_prerequisite("angels-water-washing-2", "fluid-handling")

-- Nerf early game glass. Just need a little bit for arboretums
seablock.lib.substingredient("bob-glass", "bob-quartz", nil, 10)
seablock.lib.substresult("bob-glass", "bob-glass", nil, 1)

-- Biologically active tile has been hidden so no need for the prerequisites
bobmods.lib.tech.remove_prerequisite("angels-bio-farm-2", "angels-glass-smelting-1")
bobmods.lib.tech.remove_prerequisite("angels-bio-farm-2", "angels-stone-smelting-2")

-- Rebalance glass mixture recipes
bobmods.lib.recipe.remove_ingredient("angels-solid-glass-mixture", "bob-quartz")
bobmods.lib.recipe.set_ingredient("angels-solid-glass-mixture", { type = "item", name = "bob-silicon-powder", amount = 1 })

bobmods.lib.recipe.remove_ingredient("angels-solid-glass-mixture-2", "bob-quartz")
bobmods.lib.recipe.set_ingredient("angels-solid-glass-mixture-2", { type = "item", name = "bob-silicon-powder", amount = 2 })
bobmods.lib.recipe.set_result("angels-solid-glass-mixture-2", { type = "item", name = "angels-solid-glass-mixture", amount = 3 })
bobmods.lib.recipe.set_energy_required("angels-solid-glass-mixture-2", 6)

bobmods.lib.recipe.remove_ingredient("angels-solid-glass-mixture-3", "bob-quartz")
bobmods.lib.recipe.set_ingredient("angels-solid-glass-mixture-3", { type = "item", name = "bob-silicon-powder", amount = 1 })
bobmods.lib.recipe.set_ingredient("angels-solid-glass-mixture-3", { type = "item", name = "angels-solid-lime", amount = 2 })
bobmods.lib.recipe.set_result("angels-solid-glass-mixture-3", { type = "item", name = "angels-solid-glass-mixture", amount = 4 })
bobmods.lib.recipe.set_energy_required("angels-solid-glass-mixture-3", 8)

bobmods.lib.recipe.set_energy_required("angels-solid-glass-mixture-4", 8)

-- Rebalance cement recipes
bobmods.lib.recipe.replace_ingredient("angels-solid-cement", "bob-quartz", "bob-silicon-powder")

bobmods.lib.recipe.remove_ingredient("angels-solid-cement-2", "iron-ore")
bobmods.lib.recipe.replace_ingredient("angels-solid-cement-2", "bob-quartz", "bob-silicon-powder")
bobmods.lib.recipe.set_ingredient("angels-solid-cement-2", { type = "item", name = "angels-solid-lime", amount = 4 })
bobmods.lib.recipe.set_result("angels-solid-cement-2", { type = "item", name = "angels-solid-cement", amount = 4 })
bobmods.lib.recipe.set_energy_required("angels-solid-cement-2", 16)
