-- Speed up algae farm
data.raw['assembling-machine']['algae-farm'].crafting_speed = 0.75

-- Brown algae
bobmods.lib.tech.add_prerequisite('bio-processing-brown', 'bio-processing-green')
bobmods.lib.tech.remove_recipe_unlock('bio-processing-brown', 'algae-farm')
bobmods.lib.tech.remove_recipe_unlock('bio-processing-brown', 'algae-green-simple')
bobmods.lib.tech.remove_recipe_unlock('bio-processing-green', 'algae-brown-burning')
bobmods.lib.tech.add_recipe_unlock('bio-processing-brown', 'algae-brown-burning')
bobmods.lib.tech.remove_recipe_unlock('bio-processing-green', 'algae-brown-burning-wash')
bobmods.lib.tech.add_recipe_unlock('bio-processing-brown', 'algae-brown-burning-wash')

--[[
  Make Green Algae 2 available sooner:
  - Make Red Algae depend on Blue Algae instead of Green Algae
  - Move Algae Farm 2 to Blue Algae (from Green Algae)
  - Make Green Algae depend on Basic Chemistry instead of Water Treatment
--]]
bobmods.lib.tech.replace_prerequisite('bio-processing-red', 'bio-processing-green', 'bio-processing-blue')
bobmods.lib.tech.remove_recipe_unlock('bio-processing-green', 'algae-farm-2')
bobmods.lib.tech.add_recipe_unlock('bio-processing-blue', 'algae-farm-2')
bobmods.lib.tech.replace_prerequisite('bio-processing-green', 'bio-processing-brown', 'basic-chemistry')

-- Blue algae
bobmods.lib.tech.replace_prerequisite('bio-processing-blue', 'bio-processing-red', 'bio-processing-brown')
bobmods.lib.tech.remove_science_pack('bio-processing-blue', 'chemical-science-pack')

-- Make these craftable by hand
data.raw.recipe['solid-alginic-acid'].category = "crafting"
data.raw.recipe['wooden-board-paper'].category = "crafting"

-- Fix handcrafting trying to use wrong crafting path
data.raw.recipe['wooden-board'].category = "electronics-machine"
bobmods.lib.recipe.enabled('wooden-board', false)
table.insert(data.raw.technology['bio-wood-processing-3'].effects, {type = "unlock-recipe", recipe = "wooden-board"})

data.raw.recipe['cellulose-fiber-algae'].allow_as_intermediate = false
data.raw.recipe['cellulose-fiber-raw-wood'].allow_as_intermediate = false

-- Speed up algae->cellulose fiber crafting
data.raw.recipe['cellulose-fiber-algae'].energy_required = 2

-- Speed up cellulose->wood pellet crafting
data.raw.recipe['wood-pellets'].energy_required = 3
