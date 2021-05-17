-- Coal removal
seablock.lib.substingredient('poison-capsule', 'coal', 'wood-charcoal')
seablock.lib.substingredient('slowdown-capsule', 'coal', 'wood-charcoal')
seablock.lib.substingredient('grenade', 'coal', 'wood-charcoal')
seablock.lib.substingredient('explosives', 'coal', 'wood-charcoal')
seablock.lib.substingredient('solid-fuel-from-hydrogen', 'coal', 'wood-charcoal')
seablock.lib.substingredient('alien-poison', 'coal', 'wood-charcoal')
seablock.lib.substingredient('alien-explosive', 'coal', 'wood-charcoal')
seablock.lib.substingredient('filter-coal', 'coal', 'wood-charcoal')
seablock.lib.substingredient('solid-nitroglycerin', 'coal', 'wood-charcoal')
seablock.lib.substingredient('carbon', 'coal', 'wood-charcoal')
seablock.lib.substingredient('sct-mil-circuit1', 'coal', 'wood-charcoal')
seablock.lib.substingredient('steam-science-pack', 'coal', 'wood-charcoal')
seablock.lib.substingredient('road', 'coal', 'wood-charcoal')
seablock.lib.substingredient('carbon-separation-2', 'coal', 'wood-charcoal', 1)
seablock.lib.substingredient('silo-coal', 'coal-crushed', 'wood-charcoal', 10)

-- Disable coal cracking technology
data.raw.technology['angels-coal-cracking'].enabled = false
seablock.lib.moveeffect('pellet-coke', 'angels-coal-cracking', 'angels-coal-processing-2')

-- Clear fuel value so these don't appear in Helmod's fuel picker
data.raw.item['carbon'].fuel_emissions_multiplier = nil
data.raw.item['carbon'].fuel_value = nil
data.raw.item['carbon'].fuel_category = nil
data.raw.item['coal'].fuel_emissions_multiplier = nil
data.raw.item['coal'].fuel_value = nil
data.raw.item['coal'].fuel_category = nil
data.raw.item['coal-crushed'].fuel_value = nil
data.raw.item['coal-crushed'].fuel_category = nil
