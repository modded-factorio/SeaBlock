-- Speed up algae farm
data.raw['assembling-machine']['algae-farm'].crafting_speed = 0.75

-- Remove brown algae tech
data.raw.technology['bio-processing-green'].prerequisites = {'water-treatment'}

data.raw.technology['bio-paper-1'].prerequisites = {}
data.raw.technology['bio-processing-brown'].prerequisites = {}
data.raw.technology['bio-paper-1'].unit.ingredients = {}
data.raw.technology['bio-processing-brown'].unit.ingredients = {}
bobmods.lib.tech.remove_prerequisite('bio-processing-paste', 'bio-processing-brown')
data.raw.technology['bio-processing-brown'].enabled = false
data.raw.technology['bio-processing-brown'].hidden = true

--[[
  Make Green Algae 2 available sooner:
  - Make Red Algae depend on Blue Algae instead of Green Algae
  - Move Algae Farm 2 to Blue Algae (from Green Algae)
  - Make Green Algae depend on Basic Chemistry instead of Water Treatment
--]]
bobmods.lib.tech.remove_prerequisite('bio-processing-red', 'bio-processing-green')
bobmods.lib.tech.add_prerequisite('bio-processing-red', 'bio-processing-blue')
bobmods.lib.tech.remove_recipe_unlock('bio-processing-green', 'algae-farm-2')
bobmods.lib.tech.add_recipe_unlock('bio-processing-blue', 'algae-farm-2')
bobmods.lib.tech.remove_prerequisite('bio-processing-green', 'water-treatment')
bobmods.lib.tech.add_prerequisite('bio-processing-green', 'basic-chemistry')

-- Blue algae
data.raw.technology['bio-processing-blue'].prerequisites = { 'bio-processing-green' }
for k,v in pairs(data.raw.technology['bio-processing-blue'].unit.ingredients) do
  if v[1] == 'chemical-science-pack' or v.name == 'chemical-science-pack' then
    table.remove(data.raw.technology['bio-processing-blue'].unit.ingredients, k)
    break
  end
end

-- Make these craftable by hand
data.raw.recipe['solid-alginic-acid'].category = "crafting"
data.raw.recipe['wooden-board-paper'].category = "crafting"

-- Fix handcrafting trying to use wrong crafting path
data.raw.recipe['wooden-board'].category = "electronics-machine"
data.raw.recipe['wooden-board'].enabled = false
table.insert(data.raw.technology['bio-wood-processing-3'].effects,
  {type = "unlock-recipe", recipe = "wooden-board"})

data.raw.recipe['cellulose-fiber-algae'].allow_as_intermediate = false
data.raw.recipe['cellulose-fiber-raw-wood'].allow_as_intermediate = false

-- Speed up algae->cellulose fiber crafting
data.raw.recipe['cellulose-fiber-algae'].energy_required = 2

-- Speed up cellulose->wood pellet crafting
data.raw.recipe['wood-pellets'].energy_required = 3
