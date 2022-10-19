-- Coal removal
seablock.lib.substingredient("poison-capsule", "coal", "wood-charcoal")
seablock.lib.substingredient("slowdown-capsule", "coal", "wood-charcoal")
seablock.lib.substingredient("grenade", "coal", "wood-charcoal")
seablock.lib.substingredient("explosives", "coal", "wood-charcoal")
seablock.lib.substingredient("solid-fuel-from-hydrogen", "coal", "wood-charcoal")
if mods["bobenemies"] then
  seablock.lib.substingredient("alien-poison", "coal", "wood-charcoal")
  seablock.lib.substingredient("alien-explosive", "coal", "wood-charcoal")
end
seablock.lib.substingredient("filter-coal", "coal", "wood-charcoal")
seablock.lib.substingredient("solid-nitroglycerin", "coal", "wood-charcoal")
seablock.lib.substingredient("carbon", "coal", "wood-charcoal")
if mods["Transport_Drones"] then
  seablock.lib.substingredient("road", "coal", "wood-charcoal")
end
seablock.lib.substingredient("carbon-separation-2", "coal", "wood-charcoal", 1)
if mods["angelsaddons-storage"] and data.raw.recipe["silo-coal"] then
  seablock.lib.substingredient("silo-coal", "coal-crushed", "wood-charcoal", 10)
end

-- Disable coal cracking technology
seablock.lib.hide_technology("angels-coal-cracking")
seablock.lib.moveeffect("pellet-coke", "angels-coal-cracking", "angels-coal-processing-2")

-- Clear fuel value so these don't appear in Helmod's fuel picker
data.raw.item["carbon"].fuel_emissions_multiplier = nil
data.raw.item["carbon"].fuel_value = nil
data.raw.item["carbon"].fuel_category = nil
data.raw.item["coal"].fuel_emissions_multiplier = nil
data.raw.item["coal"].fuel_value = nil
data.raw.item["coal"].fuel_category = nil
data.raw.item["coal-crushed"].fuel_value = nil
data.raw.item["coal-crushed"].fuel_category = nil

data.raw.recipe["coolant-used-filtration-1"].localised_name = { "recipe-name.coolant-used-filtration-1" }
data.raw.recipe["coolant-used-filtration-2"].localised_name = { "recipe-name.coolant-used-filtration-2" }
