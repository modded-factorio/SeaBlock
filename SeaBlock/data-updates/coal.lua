-- Coal removal
seablock.lib.substingredient("grenade", "coal", "angels-wood-charcoal")
seablock.lib.substingredient("explosives", "coal", "angels-wood-charcoal")
seablock.lib.substingredient("bob-solid-fuel-from-hydrogen", "coal", "angels-wood-charcoal")
if mods["bobenemies"] then
  seablock.lib.substingredient("bob-alien-poison", "coal", "angels-wood-charcoal")
  seablock.lib.substingredient("bob-alien-explosive", "coal", "angels-wood-charcoal")
end
seablock.lib.substingredient("angels-filter-coal", "coal", "angels-wood-charcoal")
seablock.lib.substingredient("carbon", "coal", "angels-wood-charcoal")
if mods["Transport_Drones"] then
  seablock.lib.substingredient("road", "coal", "angels-wood-charcoal")
end
seablock.lib.substingredient("angels-gas-carbon-dioxide", "coal", "angels-wood-charcoal", 1)
if mods["angelsaddons-storage"] and data.raw.recipe["angels-silo-coal"] then
  seablock.lib.substingredient("angels-silo-coal", "angels-coal-crushed", "angels-wood-charcoal", 10)
end

-- Disable coal cracking technology
seablock.lib.hide_technology("angels-coal-cracking")
seablock.lib.moveeffect("angels-pellet-coke", "angels-coal-processing-3", "angels-coal-processing-2")
angelsmods.functions.move_item("angels-pellet-coke", "angels-bio-processing-wood", "f[pellet-coke]")
angelsmods.functions.move_item("angels-pellet-coke", "angels-bio-processing-wood", "f[pellet-coke]", "recipe")
data.raw.recipe["angels-pellet-coke"].localised_name = { "item-name.angels-pellet-charcoal" }

-- Clear fuel value so these don't appear in Helmod's fuel picker
data.raw.item["carbon"].fuel_emissions_multiplier = nil
data.raw.item["carbon"].fuel_value = nil
data.raw.item["carbon"].fuel_category = nil
data.raw.item["coal"].fuel_emissions_multiplier = nil
data.raw.item["coal"].fuel_value = nil
data.raw.item["coal"].fuel_category = nil
data.raw.item["angels-coal-crushed"].fuel_value = nil
data.raw.item["angels-coal-crushed"].fuel_category = nil

-- Move charcoal processing 3 to purple science
-- Sodium carbonate is unusable before then
bobmods.lib.tech.add_science_pack("angels-coal-processing-3", "chemical-science-pack", 1)
bobmods.lib.tech.add_science_pack("angels-coal-processing-3", "production-science-pack", 1)
bobmods.lib.tech.remove_prerequisite("angels-sodium-processing-2", "angels-coal-processing-3")
bobmods.lib.tech.add_prerequisite("angels-coal-processing-3", "angels-sodium-processing-2")

-- Buff the Carbon 2 recipe to make it a bit more worthwhile
bobmods.lib.recipe.set_result("angels-coke-purification-2", { type = "item", name = "angels-solid-carbon", amount = 8 })

data.raw.recipe["angels-filter-coal"].localised_name = { "item-name.angels-filter-charcoal" }
