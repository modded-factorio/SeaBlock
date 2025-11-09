-- Remove empty bob's techs
bobmods.lib.tech.remove_prerequisite("bob-cobalt-processing", "bob-chemical-processing-1")
bobmods.lib.tech.remove_prerequisite("bob-grinding", "bob-chemical-processing-1")
bobmods.lib.tech.remove_prerequisite("bob-lithium-processing", "bob-chemical-processing-1")

bobmods.lib.tech.remove_prerequisite("bob-cobalt-processing", "bob-chemical-processing-2")
bobmods.lib.tech.remove_prerequisite("bob-silicon-processing", "bob-chemical-processing-2")
bobmods.lib.tech.remove_prerequisite("advanced-circuit", "bob-chemical-processing-2")
bobmods.lib.tech.remove_prerequisite("bob-titanium-processing", "bob-chemical-processing-2")
bobmods.lib.tech.remove_prerequisite("bob-tungsten-processing", "bob-chemical-processing-2")

seablock.lib.hide_technology("bob-electrolysis-1")
seablock.lib.hide_technology("bob-electrolysis-2")
seablock.lib.hide_technology("bob-chemical-processing-1")
seablock.lib.hide_technology("bob-chemical-processing-2")

bobmods.lib.tech.remove_prerequisite("circuit-network", "angels-bio-wood-processing-2")
bobmods.lib.tech.add_prerequisite("circuit-network", "angels-bio-paper-1")
bobmods.lib.tech.remove_prerequisite("angels-rubbers", "circuit-network")

-- Unhide solid fuel from hydrogen
seablock.lib.unhide_recipe("bob-solid-fuel-from-hydrogen")
seablock.lib.add_recipe_unlock("flammables", "bob-solid-fuel-from-hydrogen", 4)

bobmods.lib.tech.replace_prerequisite("bob-lithium-processing", "angels-chlorine-processing-4", "angels-chlorine-processing-2")
