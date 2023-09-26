-- Buff Lead 3
seablock.lib.substresult("anode-lead-smelting", "slag", "quartz", 1)
seablock.lib.substingredient("anode-lead-smelting", "liquid-hexafluorosilicic-acid", nil, 20)

-- Compost void recipe
angelsmods.functions.make_void("solid-compost", "bio", 5)

-- Remove recipe Wood pellets > Carbon dioxide
-- Move recipe Charcoal > Carbon dioxide from Basic chemistry to Wood processing 2
bobmods.lib.tech.remove_recipe_unlock("bio-wood-processing-3", "gas-carbon-dioxide-from-wood")
bobmods.lib.recipe.hide("gas-carbon-dioxide-from-wood")
bobmods.lib.tech.remove_recipe_unlock("basic-chemistry", "carbon-separation-2")
