local lib = require "lib"

-- Coal removal
lib.substingredient('poison-capsule', 'coal', 'wood-charcoal')
lib.substingredient('slowdown-capsule', 'coal', 'wood-charcoal')
lib.substingredient('grenade', 'coal', 'wood-charcoal')
lib.substingredient('explosives', 'coal', 'wood-charcoal')
lib.substingredient('solid-fuel-from-hydrogen', 'coal', 'wood-charcoal')
lib.substingredient('alien-poison', 'coal', 'wood-charcoal')
lib.substingredient('alien-explosive', 'coal', 'wood-charcoal')
lib.substingredient('filter-coal', 'coal', 'wood-charcoal')
lib.substingredient('solid-nitroglycerin', 'coal', 'wood-charcoal')
lib.substingredient('carbon', 'coal', 'wood-charcoal')
lib.substingredient('sct-mil-circuit1', 'coal', 'wood-charcoal')
lib.substingredient('steam-science-pack', 'coal', 'wood-charcoal')
lib.substingredient('road', 'coal', 'wood-charcoal')
lib.substingredient('carbon-separation-2', 'coal', 'wood-charcoal', 1)

-- Disable coal cracking technology
data.raw.technology['angels-coal-cracking'].enabled = false
lib.moveeffect('pellet-coke', 'angels-coal-cracking', 'angels-coal-processing-2')

-- Clear fuel value so these don't appear in Helmod's fuel picker
data.raw.item['carbon'].fuel_emissions_multiplier = nil
data.raw.item['carbon'].fuel_value = nil
data.raw.item['carbon'].fuel_category = nil
data.raw.item['coal'].fuel_emissions_multiplier = nil
data.raw.item['coal'].fuel_value = nil
data.raw.item['coal'].fuel_category = nil
data.raw.item['coal-crushed'].fuel_value = nil
data.raw.item['coal-crushed'].fuel_category = nil
