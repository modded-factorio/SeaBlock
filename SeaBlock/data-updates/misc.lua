if data.raw.item["wind-turbine-2"] then
  seablock.lib.substingredient("wind-turbine-2", "iron-plate", "steel-plate", 3)
  bobmods.lib.recipe.enabled("wind-turbine-2", false)
  bobmods.lib.tech.add_recipe_unlock("steel-processing", "wind-turbine-2")
end

-- No natural gas, use methane for manganese pellet smelting
seablock.lib.substingredient("pellet-manganese-smelting", "gas-natural-1", "gas-methane")

-- Remove steel's prerequiste on Chemical processing 1
bobmods.lib.tech.remove_prerequisite("steel-processing", "chemical-processing-1")

-- Merge basic chemistry 2 into basic chemistry
local function movealleffects(from, to)
  for _, v in pairs(data.raw.technology[from].effects) do
    table.insert(data.raw.technology[to].effects, v)
  end
  for _, v in pairs(data.raw.technology) do
    for k, prerequisite in pairs(v.prerequisites or {}) do
      if prerequisite == from then
        v.prerequisites[k] = to
      end
    end
  end
  data.raw.technology[from].effects = {}
end
movealleffects("basic-chemistry-2", "basic-chemistry")
movealleffects("basic-chemistry-3", "basic-chemistry-2")
bobmods.lib.tech.add_new_science_pack("basic-chemistry-2", "logistic-science-pack", 1)
seablock.lib.hide_technology("basic-chemistry-3")
-- Move gas shift recipes back
seablock.lib.moveeffect("water-gas-shift-1", "basic-chemistry", "basic-chemistry-2")
seablock.lib.moveeffect("water-gas-shift-2", "basic-chemistry", "basic-chemistry-2")
bobmods.lib.tech.add_prerequisite("angels-nickel-smelting-1", "basic-chemistry-2")

-- Make Basic Chemistry depend on Wood Processing 2. Required for Charcoal > Carbon Dioxide
bobmods.lib.tech.add_prerequisite("basic-chemistry", "bio-wood-processing-2")

-- Move Water Treatment from Electronics to Slag Processing 1. Hydro Plant no longer requires Green Circuits
-- Slag Processing 1 is first source of Sulfuric Waste Water
bobmods.lib.tech.remove_prerequisite("water-treatment", "angels-fluid-control")
bobmods.lib.tech.add_prerequisite("water-treatment", "slag-processing-1")

-- Allow skipping of waste water recycling
bobmods.lib.tech.remove_prerequisite("water-washing-1", "water-treatment")
bobmods.lib.tech.add_prerequisite("water-washing-1", "automation")
seablock.lib.moveeffect("yellow-waste-water-purification", "water-treatment-2", "water-treatment")
seablock.lib.moveeffect("clarifier", "water-treatment", "water-washing-1", 3)

bobmods.lib.tech.remove_prerequisite("electronics", "chemical-processing-1")

seablock.lib.set_recipe_category("liquid-fish-atmosphere", "chemistry")
seablock.lib.hide_technology("pumpjack")

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
for k, v in pairs(data.raw["resource"]) do
  if k == "coal" then
    v.minable.result = nil
    v.minable.results = nil
  else
    data.raw["resource"][k] = nil
  end
end

-- Add prerequisite for Tin and Lead
if settings.startup["bobmods-logistics-beltoverhaul"].value then
  bobmods.lib.tech.add_prerequisite("logistics", "ore-crushing")
end

-- Tidy prerequisite for Bronze & Brass
bobmods.lib.tech.replace_prerequisite("logistics-2", "alloy-processing", "angels-bronze-smelting-1")
bobmods.lib.tech.remove_prerequisite("steel-mixing-furnace", "alloy-processing")
bobmods.lib.tech.remove_prerequisite("chemical-science-pack", "alloy-processing")
bobmods.lib.tech.remove_prerequisite("tungsten-alloy-processing", "alloy-processing")
bobmods.lib.tech.remove_prerequisite("nitinol-processing", "alloy-processing")
bobmods.lib.tech.remove_prerequisite("electric-mixing-furnace", "alloy-processing")

bobmods.lib.tech.remove_prerequisite("zinc-processing", "electrolysis-1")
bobmods.lib.tech.replace_prerequisite("battery-3", "zinc-processing", "angels-zinc-smelting-1")
if mods["bobpower"] then
  bobmods.lib.tech.replace_prerequisite("electric-pole-2", "zinc-processing", "angels-brass-smelting-1")
  bobmods.lib.tech.replace_prerequisite("electric-substation-2", "zinc-processing", "angels-brass-smelting-1")
end

-- Add fluid handling as a prerequisite for Oil and gas extraction
-- Else Electric engine doesn't depend on Engine
bobmods.lib.tech.add_prerequisite("oil-gas-extraction", "fluid-handling")

-- Move recipes that shouldn't be unlocked at startup
if mods["bobenemies"] then
  seablock.lib.add_recipe_unlock("bio-processing-alien-3", "alien-artifact-red-from-small")
  seablock.lib.add_recipe_unlock("bio-processing-alien-3", "alien-artifact-yellow-from-small")
  seablock.lib.add_recipe_unlock("bio-processing-alien-3", "alien-artifact-orange-from-small")
  seablock.lib.add_recipe_unlock("bio-processing-alien-3", "alien-artifact-blue-from-small")
  seablock.lib.add_recipe_unlock("bio-processing-alien-3", "alien-artifact-purple-from-small")
  seablock.lib.add_recipe_unlock("bio-processing-alien-3", "alien-artifact-green-from-small")
  seablock.lib.add_recipe_unlock("bio-processing-alien-3", "alien-artifact-from-small")
end

bobmods.lib.tech.remove_prerequisite("tungsten-processing", "angels-nickel-smelting-1")

bobmods.lib.tech.remove_recipe_unlock("bio-arboretum-swamp-1", "solid-plastic")

seablock.lib.hide("inserter", "steam-inserter")
seablock.lib.hide("mining-drill", "burner-mining-drill")
seablock.lib.hide("mining-drill", "electric-mining-drill")
seablock.lib.hide("mining-drill", "pumpjack")
seablock.lib.hide("storage-tank", "bob-overflow-valve")
seablock.lib.hide("storage-tank", "bob-valve")
seablock.lib.hide("storage-tank", "bob-topup-valve")

-- Buff Lime filtering
seablock.lib.substingredient("filter-lime", "solid-lime", nil, 1)
data.raw.recipe["filter-lime"].energy_required = 1
data.raw.recipe["angels-sulfur-scrubber"].energy_required = 6

-- Make Long Inserters a startup tech
if data.raw.technology["logistics-0"] then
  bobmods.lib.tech.replace_prerequisite("long-inserters-1", "logistics", "logistics-0")
end

-- Adjust for handcrafting boards

-- Divide by 2
seablock.lib.substingredient("solid-alginic-acid", "algae-brown", nil, 5)
seablock.lib.substresult("solid-alginic-acid", "solid-alginic-acid", nil, 1)
data.raw.recipe["solid-alginic-acid"].energy_required = 5

-- Divide by 5
seablock.lib.substingredient("solid-wood-pulp", "cellulose-fiber", nil, 4)
seablock.lib.substingredient("solid-wood-pulp", "solid-alginic-acid", nil, 1)
seablock.lib.substresult("solid-wood-pulp", "solid-wood-pulp", nil, 4)
data.raw.recipe["solid-wood-pulp"].energy_required = 0.8

-- Tidy up ore silo prerequisites
if mods["angelsaddons-storage"] then
  bobmods.lib.tech.remove_prerequisite("ore-silos", "angels-coal-processing")
  bobmods.lib.tech.replace_prerequisite("ore-silos", "ore-crushing", "ore-advanced-crushing")
end

-- Logistic System prerequisite of Pink Science
if not data.raw.tool["advanced-logistic-science-pack"] then
  bobmods.lib.tech.add_prerequisite("logistic-system", "utility-science-pack")
end

-- Saline rebalance
seablock.lib.substingredient("solid-salt-dissolving", "solid-salt", nil, 15)
seablock.lib.substingredient("solid-salt-dissolving", "water-purified", "water", 1000)
seablock.lib.substresult("solid-salt-dissolving", "water-saline", nil, 1000)
data.raw.recipe["solid-salt-dissolving"].energy_required = 5

-- Swap out Nickel and Zinc plates
seablock.lib.substingredient("roboport-antenna-3", "nickel-plate", "titanium-plate", nil)
bobmods.lib.recipe.remove_ingredient("roboport-antenna-4", "nickel-plate")
seablock.lib.substingredient("silver-zinc-battery", "zinc-plate", "solid-zinc-oxide", nil)

seablock.lib.unhide_recipe("zinc-ore-processing-alt")
bobmods.lib.tech.add_recipe_unlock("angels-zinc-smelting-2", "zinc-ore-processing-alt")
bobmods.lib.tech.add_prerequisite("battery-3", "angels-zinc-smelting-2")
if data.raw.recipe["pellet-zinc-smelting"] then
  data.raw.recipe["pellet-zinc-smelting"].icons = angelsmods.functions.add_number_icon_layer(
    angelsmods.functions.get_object_icons("solid-zinc-oxide"),
    2,
    angelsmods.smelting.number_tint
  )
end

if mods["angelsindustries"] then
  seablock.lib.substingredient("angels-thorium-fuel-cell", "angels-plate-zinc", "lead-plate", nil)
  seablock.lib.substingredient("angels-deuterium-fuel-cell", "angels-plate-zinc", "lead-plate", nil)
end

seablock.lib.hide_item("nickel-plate")
seablock.lib.hide_item("zinc-plate")
bobmods.lib.recipe.hide("bob-zinc-plate")
bobmods.lib.tech.remove_recipe_unlock("zinc-processing", "bob-zinc-plate")

-- Add missing science packs

for _, v in pairs({
  "bio-processing-alien-3",
  "gem-processing-1",
  "gem-processing-2",
  "geode-crystallization-1",
  "geode-crystallization-2",
  "polishing",
}) do
  if data.raw.technology[v] then
    bobmods.lib.tech.add_new_science_pack(v, "chemical-science-pack", 1)
  end
end

bobmods.lib.tech.add_prerequisite("polishing", "chemical-science-pack")
bobmods.lib.tech.add_prerequisite("geode-crystallization-1", "chemical-science-pack")

if mods["bobrevamp"] and not mods["bobclasses"] then
  bobmods.lib.tech.add_new_science_pack("rtg", "production-science-pack", 1)
  bobmods.lib.tech.add_new_science_pack("rtg", "utility-science-pack", 1)
  bobmods.lib.tech.add_prerequisite("rtg", "production-science-pack")
  bobmods.lib.tech.add_prerequisite("rtg", "utility-science-pack")
end

if mods["cargo-ships"] then
  seablock.lib.hide_item("oil_rig")
end

-- Swap gold for platinum
seablock.lib.substingredient("processing-electronics", "angels-wire-platinum", nil, 20)
if mods["bobmodules"] then
  seablock.lib.substingredient("module-processor-board-3", "angels-wire-platinum", "angels-plate-platinum", nil)
end
bobmods.lib.tech.add_prerequisite("advanced-electronics-3", "angels-platinum-smelting-1")
seablock.lib.substresult("angelsore-pure-mix2-processing", "platinum-ore", nil, 2)
seablock.lib.substresult("angelsore9-crystal-processing", "platinum-ore", nil, 2)
-- Swap stiratite for crotinnium so all pure ores are used
seablock.lib.substingredient("angelsore-pure-mix2-processing", "angels-ore3-pure", "angels-ore4-pure", nil)

-- Unhide rocket part to make it easier to view recipes
if data.raw.recipe["rocket-part"] then
  angelsmods.functions.remove_flag("rocket-part", "hidden")
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

-- Hide recipes that take Chrome Ingots
bobmods.lib.recipe.hide("molten-iron-smelting-5")
bobmods.lib.tech.hide("angels-iron-casting-4")

bobmods.lib.recipe.hide("molten-steel-smelting-5")
bobmods.lib.tech.hide("angels-steel-smelting-4")

bobmods.lib.recipe.hide("molten-titanium-smelting-5")
bobmods.lib.tech.remove_recipe_unlock("angels-titanium-casting-3", "molten-titanium-smelting-5")
bobmods.lib.tech.remove_prerequisite("angels-titanium-casting-3", "angels-chrome-smelting-2")

-- Buff bob's silicon and tungsten recipes
seablock.lib.substingredient("silicon-carbide", "silicon-powder", nil, 10)
seablock.lib.substingredient("silicon-carbide", "carbon", nil, 10)
data.raw.recipe["silicon-carbide"].result_count = 20

seablock.lib.substingredient("silicon-nitride", "silicon-powder", nil, 10)
seablock.lib.substingredient("silicon-nitride", "gas-nitrogen", nil, 130)
data.raw.recipe["silicon-nitride"].result_count = 10

seablock.lib.substingredient("tungsten-carbide", "tungsten-oxide", nil, 10)
seablock.lib.substingredient("tungsten-carbide", "carbon", nil, 10)
seablock.lib.substresult("tungsten-carbide", "tungsten-carbide", nil, 20)
bobmods.lib.recipe.set_energy_required("tungsten-carbide", 6)

seablock.lib.substingredient("tungsten-carbide-2", "powdered-tungsten", nil, 10)
seablock.lib.substingredient("tungsten-carbide-2", "carbon", nil, 10)
seablock.lib.substresult("tungsten-carbide-2", "tungsten-carbide", nil, 20)
bobmods.lib.recipe.set_energy_required("tungsten-carbide-2", 6)

seablock.lib.substingredient("copper-tungsten-alloy", "powdered-tungsten", nil, 15)
seablock.lib.substingredient("copper-tungsten-alloy", "copper-plate", "powder-copper", 10)
seablock.lib.substresult("copper-tungsten-alloy", "copper-tungsten-alloy", nil, 25)
bobmods.lib.recipe.set_energy_required("copper-tungsten-alloy", 8)
bobmods.lib.tech.add_prerequisite("tungsten-alloy-processing", "angels-copper-smelting-2")

-- Hide steam inserter
bobmods.lib.recipe.hide("steam-inserter")
seablock.lib.hide_item("steam-inserter")
if data.raw.inserter["steam-inserter"] then
  data.raw.inserter["steam-inserter"].next_upgrade = nil
end

-- Swap out concrete for bricks

seablock.lib.substingredient("artillery-turret", "concrete", "reinforced-concrete-brick", nil)
if data.raw.recipe["burner-reactor-2"] then
  seablock.lib.substingredient("burner-reactor-2", "concrete", "concrete-brick", nil)
  bobmods.lib.tech.remove_prerequisite("burner-reactor-2", "concrete")
  bobmods.lib.tech.add_prerequisite("burner-reactor-2", "angels-stone-smelting-2")
end
seablock.lib.substingredient("centrifuge", "concrete", "concrete-brick", nil)
if data.raw.recipe["fluid-reactor-2"] then
  seablock.lib.substingredient("fluid-reactor-2", "concrete", "concrete-brick", nil)
end
seablock.lib.substingredient("nuclear-reactor", "concrete", "concrete-brick", nil)
seablock.lib.substingredient("rocket-silo", "concrete", "reinforced-concrete-brick", nil)

bobmods.lib.tech.replace_prerequisite("uranium-processing", "concrete", "angels-stone-smelting-2")
bobmods.lib.tech.replace_prerequisite("rocket-silo", "concrete", "angels-stone-smelting-3")

-- Swap concrete tiles
local item = data.raw.item["concrete-brick"]
if item and item.place_as_tile then
  item.place_as_tile["result"] = "concrete"
end
item = data.raw.item["reinforced-concrete-brick"]
if item and item.place_as_tile then
  item.place_as_tile["result"] = "refined-concrete"
end
item = data.raw.item["concrete"]
if item and item.place_as_tile then
  item.place_as_tile["result"] = "tile-concrete-brick"
end
item = data.raw.item["refined-concrete"]
if item and item.place_as_tile then
  item.place_as_tile["result"] = "tile-reinforced-concrete-brick"
end

item = data.raw.tile["concrete"]
if item then
  item.minable["result"] = "concrete-brick"
  item.placeable_by = { item = "concrete-brick", count = 1 }
  item.walking_speed_modifier = 1.4
end
item = data.raw.tile["refined-concrete"]
if item then
  item.minable["result"] = "reinforced-concrete-brick"
  item.placeable_by = { item = "reinforced-concrete-brick", count = 1 }
  item.walking_speed_modifier = 1.55
end
item = data.raw.tile["tile-concrete-brick"]
if item then
  item.minable["result"] = "concrete"
  item.placeable_by = { item = "concrete", count = 1 }
  item.walking_speed_modifier = 1.4
end
item = data.raw.tile["tile-reinforced-concrete-brick"]
if item then
  item.minable["result"] = "refined-concrete"
  item.placeable_by = { item = "refined-concrete", count = 1 }
  item.walking_speed_modifier = 1.55
end
item = data.raw.tile["hazard-concrete-left"]
if item then
  item.walking_speed_modifier = 1.4
end
item = data.raw.tile["hazard-concrete-right"]
if item then
  item.walking_speed_modifier = 1.4
end
item = data.raw.tile["refined-hazard-concrete-left"]
if item then
  item.walking_speed_modifier = 1.55
end
item = data.raw.tile["refined-hazard-concrete-right"]
if item then
  item.walking_speed_modifier = 1.55
end

-- Other prerequisites
if data.raw.technology["electronics-machine-1"] then
  bobmods.lib.tech.add_prerequisite("electronics-machine-1", "electronics")
end
bobmods.lib.tech.add_prerequisite("bio-pressing-1", "bio-nutrient-paste")
bobmods.lib.tech.add_prerequisite("angels-advanced-chemistry-3", "ore-leaching")

bobmods.lib.tech.add_prerequisite("resins", "automation-2")
bobmods.lib.tech.add_prerequisite("plastics", "automation-2")

-- Nerf early game glass. Just need a little bit for arboretums
seablock.lib.substingredient("quartz-glass", "quartz", nil, 10)
seablock.lib.substresult("quartz-glass", "glass", nil, 1)

-- Biologically active tile has been hidden so no need for the prerequisites
bobmods.lib.tech.remove_prerequisite("bio-farm-2", "angels-glass-smelting-1")
bobmods.lib.tech.remove_prerequisite("bio-farm-2", "angels-stone-smelting-2")

-- Rebalance glass mixture recipes
bobmods.lib.recipe.remove_ingredient("glass-mixture-1", "quartz")
bobmods.lib.recipe.set_ingredient("glass-mixture-1", { "silicon-powder", 1 })

bobmods.lib.recipe.remove_ingredient("glass-mixture-2", "quartz")
bobmods.lib.recipe.set_ingredient("glass-mixture-2", { "silicon-powder", 2 })
bobmods.lib.recipe.set_result("glass-mixture-2", { "solid-glass-mixture", 3 })
bobmods.lib.recipe.set_energy_required("glass-mixture-2", 6)

bobmods.lib.recipe.remove_ingredient("glass-mixture-3", "quartz")
bobmods.lib.recipe.set_ingredient("glass-mixture-3", { "silicon-powder", 1 })
bobmods.lib.recipe.set_ingredient("glass-mixture-3", { "solid-lime", 2 })
bobmods.lib.recipe.set_result("glass-mixture-3", { "solid-glass-mixture", 4 })
bobmods.lib.recipe.set_energy_required("glass-mixture-3", 8)

bobmods.lib.recipe.set_energy_required("glass-mixture-4", 8)

-- Rebalance cement recipes
bobmods.lib.recipe.replace_ingredient("cement-mixture-1", "quartz", "silicon-powder")

bobmods.lib.recipe.remove_ingredient("cement-mixture-2", "iron-ore")
bobmods.lib.recipe.replace_ingredient("cement-mixture-2", "quartz", "silicon-powder")
bobmods.lib.recipe.set_ingredient("cement-mixture-2", { "solid-lime", 4 })
bobmods.lib.recipe.set_result("cement-mixture-2", { "solid-cement", 4 })
bobmods.lib.recipe.set_energy_required("cement-mixture-2", 16)

bobmods.lib.tech.add_prerequisite("angels-advanced-gas-processing", "gas-steam-cracking-2")

-- Bronze prerequisites
bobmods.lib.tech.add_prerequisite("angels-cooling", "alloy-processing")
bobmods.lib.tech.add_prerequisite("bio-nutrient-paste", "alloy-processing")
bobmods.lib.tech.add_prerequisite("gas-steam-cracking-1", "alloy-processing")
bobmods.lib.tech.add_prerequisite("ore-floatation", "alloy-processing")
bobmods.lib.tech.add_prerequisite("ore-processing-1", "alloy-processing")
bobmods.lib.tech.add_prerequisite("powder-metallurgy-2", "alloy-processing")
bobmods.lib.tech.add_prerequisite("strand-casting-1", "alloy-processing")
bobmods.lib.tech.add_prerequisite("thermal-water-extraction", "alloy-processing")
bobmods.lib.tech.add_prerequisite("water-washing-2", "alloy-processing")

-- Clay Brick prerequisites
bobmods.lib.tech.add_prerequisite("advanced-ore-refining-1", "angels-stone-smelting-1")
bobmods.lib.tech.add_prerequisite("angels-cooling", "angels-stone-smelting-1")
bobmods.lib.tech.add_prerequisite("angels-metallurgy-2", "angels-stone-smelting-1")
bobmods.lib.tech.add_prerequisite("gardens", "angels-stone-smelting-1")
bobmods.lib.tech.add_prerequisite("oil-gas-extraction", "angels-stone-smelting-1")
bobmods.lib.tech.add_prerequisite("water-washing-2", "angels-stone-smelting-1")

-- Brass prerequisites
bobmods.lib.tech.add_prerequisite("advanced-ore-refining-2", "zinc-processing")
bobmods.lib.tech.add_prerequisite("angels-advanced-chemistry-2", "zinc-processing")
bobmods.lib.tech.add_prerequisite("angels-metallurgy-3", "zinc-processing")
bobmods.lib.tech.add_prerequisite("bio-desert-farm", "zinc-processing")
bobmods.lib.tech.add_prerequisite("bio-refugium-puffer-1", "zinc-processing")
bobmods.lib.tech.add_prerequisite("bio-swamp-farm", "zinc-processing")
bobmods.lib.tech.add_prerequisite("bio-temperate-farm", "zinc-processing")
bobmods.lib.tech.add_prerequisite("water-treatment-3", "zinc-processing")

-- Concrete Brick prerequisites
bobmods.lib.tech.add_prerequisite("advanced-ore-refining-2", "angels-stone-smelting-2")
bobmods.lib.tech.add_prerequisite("angels-advanced-chemistry-2", "angels-stone-smelting-2")
bobmods.lib.tech.add_prerequisite("angels-metallurgy-3", "angels-stone-smelting-2")
bobmods.lib.tech.add_prerequisite("bio-desert-farm", "angels-stone-smelting-2")
bobmods.lib.tech.add_prerequisite("bio-swamp-farm", "angels-stone-smelting-2")
bobmods.lib.tech.add_prerequisite("bio-temperate-farm", "angels-stone-smelting-2")
bobmods.lib.tech.add_prerequisite("bio-refugium-hatchery", "angels-stone-smelting-2")
bobmods.lib.tech.add_prerequisite("bio-refugium-puffer-1", "angels-stone-smelting-2")
bobmods.lib.tech.add_prerequisite("water-treatment-3", "angels-stone-smelting-2")

-- Titanium prerequisites
bobmods.lib.tech.add_prerequisite("angels-advanced-chemistry-4", "titanium-processing")
bobmods.lib.tech.add_prerequisite("angels-metallurgy-4", "titanium-processing")
bobmods.lib.tech.add_prerequisite("bio-refugium-biter-1", "titanium-processing")
bobmods.lib.tech.add_prerequisite("slag-processing-3", "titanium-processing")
bobmods.lib.tech.add_prerequisite("water-treatment-4", "titanium-processing")

-- Reinforced concrete brick
bobmods.lib.tech.add_prerequisite("angels-advanced-chemistry-3", "angels-stone-smelting-3")
bobmods.lib.tech.add_prerequisite("angels-metallurgy-4", "angels-stone-smelting-3")
bobmods.lib.tech.add_prerequisite("slag-processing-3", "angels-stone-smelting-3")
bobmods.lib.tech.add_prerequisite("thermal-water-extraction-2", "angels-stone-smelting-3")
bobmods.lib.tech.add_prerequisite("water-treatment-4", "angels-stone-smelting-3")

-- Copper tungsten / tungsten carbide prerequisites
bobmods.lib.tech.add_prerequisite("angels-nitrogen-processing-4", "tungsten-alloy-processing")
bobmods.lib.tech.add_prerequisite("ore-processing-5", "tungsten-alloy-processing")

-- Nitinol prerequisites
bobmods.lib.tech.add_prerequisite("ore-processing-5", "nitinol-processing")

-- Advanced circuit
bobmods.lib.tech.add_prerequisite("tank", "advanced-electronics")

-- Processing unit
bobmods.lib.tech.add_prerequisite("bio-refugium-biter-1", "advanced-electronics-2")
bobmods.lib.tech.add_prerequisite("water-treatment-4", "advanced-electronics-2")

-- Advanced processing unit
bobmods.lib.tech.add_prerequisite("angels-advanced-chemistry-4", "advanced-electronics-3")
bobmods.lib.tech.add_prerequisite("angels-metallurgy-5", "advanced-electronics-3")
