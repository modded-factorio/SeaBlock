-- Buff Lead 3
seablock.lib.substresult("angels-ingot-lead-3", "angels-slag", "bob-quartz", 1)
seablock.lib.substingredient("angels-ingot-lead-3", "angels-liquid-hexafluorosilicic-acid", nil, 20)

-- Compost void recipe
angelsmods.functions.make_void("angels-solid-compost", "bio", 5)

-- Remove recipe Wood pellets > Carbon dioxide
-- Move recipe Charcoal > Carbon dioxide from Basic chemistry to Wood processing 2
bobmods.lib.tech.remove_recipe_unlock("angels-bio-wood-processing-3", "angels-gas-carbon-dioxide-from-wood")
bobmods.lib.recipe.hide("angels-gas-carbon-dioxide-from-wood")
bobmods.lib.tech.remove_recipe_unlock("angels-basic-chemistry", "angels-carbon-separation-2")
