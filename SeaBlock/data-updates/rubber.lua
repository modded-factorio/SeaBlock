local lib = require "lib"

--[[
======
Rubber
======
Increase cost of resin->rubber smelting to encourage use of angels rubber synthesis

Tech: Rubbers
- Resin > Rubber  (previously unlocked from start)
- Rubber > Insulated Wire (previously unlocked by Electronics)

Tech: Rubber
- Liquid Rubber
- Liquid Rubber > Rubber
--]]
lib.substingredient('bob-rubber', 'resin', nil, 4)
bobmods.lib.tech.remove_recipe_unlock('electronics', 'insulated-cable')
bobmods.lib.tech.remove_recipe_unlock('rubbers', 'solid-rubber')
bobmods.lib.tech.add_recipe_unlock('rubbers', 'bob-rubber')
bobmods.lib.tech.add_recipe_unlock('rubbers', 'insulated-cable')
bobmods.lib.tech.remove_prerequisite('rubbers', 'angels-oil-processing')
bobmods.lib.recipe.enabled('bob-rubber', false)

-- Circuit network wires should not require rubber
data.raw.recipe['green-wire'].ingredients = {{ "electronic-circuit", 1 }, { "copper-cable", 1 }}
data.raw.recipe['red-wire'].ingredients = {{ "electronic-circuit", 1 }, { "copper-cable", 1 }}
