local lib = require "lib"

--Increase cost of resin->rubber smelting to encourage use of angels rubber synthesis
lib.substingredient('bob-rubber', 'resin', nil, 4)

-- Merge tech Rubbers into Rubber
bobmods.lib.tech.remove_recipe_unlock('rubbers', 'solid-rubber')
bobmods.lib.tech.replace_prerequisite('rubber', 'rubbers', 'resin-1')
bobmods.lib.tech.replace_prerequisite('bio-arboretum-desert-1', 'rubbers', 'rubber')
if mods['bobpower'] then
  bobmods.lib.tech.add_prerequisite('electric-pole-3', 'rubber')
  bobmods.lib.tech.add_prerequisite('electric-substation-3', 'rubber')
end
lib.add_recipe_unlock('rubber', 'bob-rubber', 2)
lib.moveeffect('insulated-cable', 'electronics', 'rubber')
data.raw.technology['rubbers'].hidden = true

-- Circuit network wires should not require rubber
data.raw.recipe['green-wire'].ingredients = {{ "electronic-circuit", 1 }, { "copper-cable", 1 }}
data.raw.recipe['red-wire'].ingredients = {{ "electronic-circuit", 1 }, { "copper-cable", 1 }}
