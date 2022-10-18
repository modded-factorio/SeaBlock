-- Remove empty bob's techs
bobmods.lib.tech.remove_prerequisite("cobalt-processing", "chemical-processing-1")
bobmods.lib.tech.remove_prerequisite("grinding", "chemical-processing-1")
bobmods.lib.tech.remove_prerequisite("lithium-processing", "chemical-processing-1")

bobmods.lib.tech.remove_prerequisite("cobalt-processing", "chemical-processing-2")
bobmods.lib.tech.remove_prerequisite("silicon-processing", "chemical-processing-2")
bobmods.lib.tech.remove_prerequisite("advanced-electronics", "chemical-processing-2")
bobmods.lib.tech.remove_prerequisite("titanium-processing", "chemical-processing-2")
bobmods.lib.tech.remove_prerequisite("tungsten-processing", "chemical-processing-2")

seablock.lib.hide_technology("electrolysis-1")
seablock.lib.hide_technology("electrolysis-2")
seablock.lib.hide_technology("chemical-processing-1")
seablock.lib.hide_technology("chemical-processing-2")

bobmods.lib.tech.remove_recipe_unlock("angels-advanced-gas-processing", "solid-fuel-methane")
bobmods.lib.tech.remove_prerequisite("circuit-network", "bio-wood-processing")
bobmods.lib.tech.remove_recipe_unlock("circuit-network", "bob-rubber")
bobmods.lib.tech.remove_recipe_unlock("circuit-network", "insulated-cable")

-- Unhide solid fuel from hydrogen
seablock.lib.unhide_recipe("solid-fuel-from-hydrogen")
seablock.lib.add_recipe_unlock("flammables", "solid-fuel-from-hydrogen", 4)
