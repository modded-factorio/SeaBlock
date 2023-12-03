-- Speed up algae farm
data.raw["assembling-machine"]["algae-farm"].crafting_speed = 0.75

-- Brown algae
bobmods.lib.tech.remove_prerequisite("bio-processing-brown", "automation")
bobmods.lib.tech.add_prerequisite("bio-processing-brown", "water-treatment")
bobmods.lib.tech.add_prerequisite("bio-processing-brown", "bio-processing-green")
bobmods.lib.tech.remove_recipe_unlock("bio-processing-brown", "algae-green-simple")
seablock.lib.moveeffect("algae-brown", "bio-processing-green", "bio-processing-brown", nil)
seablock.lib.moveeffect("algae-farm-2", "bio-processing-green", "bio-processing-brown", 1)
bobmods.lib.tech.ignore_tech_cost_multiplier("bio-processing-brown", false)

-- Green algae
bobmods.lib.recipe.set_category("algae-green", "bio-processing")
bobmods.lib.tech.remove_prerequisite("bio-processing-green", "bio-processing-brown")
bobmods.lib.tech.remove_prerequisite("bio-processing-green", "water-treatment")
bobmods.lib.tech.add_prerequisite("bio-processing-green", "bio-wood-processing-2")

-- Move Lithia Salt to Thermal Water Extraction
seablock.lib.moveeffect("algae-brown-burning", "bio-processing-green", "thermal-water-extraction", 2)
bobmods.lib.tech.add_prerequisite("lithium-processing", "thermal-water-extraction")

-- Change lithium crafting category
bobmods.lib.recipe.set_category("lithium", "petrochem-electrolyser")
bobmods.lib.recipe.set_category("lithium-water-electrolysis", "petrochem-electrolyser")

bobmods.lib.tech.remove_recipe_unlock("water-treatment-3", "solid-lithium")
bobmods.lib.recipe.hide("solid-lithium")

-- Move Sodium Carbonate from Brown Algae to Sodium processing 2
seablock.lib.moveeffect("algae-brown-burning-wash", "bio-processing-green", "sodium-processing-2", nil)

-- Move Methanol from Cellulose Fibre to Advanced chemistry 1
seablock.lib.moveeffect("gas-methanol-from-wood", "bio-processing-green", "angels-advanced-chemistry-1", 5)

-- Make Red Algae depend on Blue Algae instead of Green Algae
bobmods.lib.tech.replace_prerequisite("bio-processing-red", "bio-processing-green", "bio-processing-blue")

-- Blue algae
bobmods.lib.tech.replace_prerequisite("bio-processing-blue", "bio-processing-red", "bio-processing-brown")
bobmods.lib.tech.remove_prerequisite("bio-processing-blue", "chemical-science-pack")
bobmods.lib.tech.remove_science_pack("bio-processing-blue", "chemical-science-pack")
bobmods.lib.tech.remove_recipe_unlock("bio-processing-blue", "algae-farm-4")
bobmods.lib.recipe.set_category("algae-blue", "bio-processing-2")

-- Red algae. Make Calcium carbonate in an assembling machine, not a liquefier
bobmods.lib.recipe.set_category("solid-calcium-carbonate", "advanced-crafting")

-- Alien bacteria
bobmods.lib.recipe.set_category("alien-bacteria", "bio-processing-3")

-- Make these craftable by hand
bobmods.lib.recipe.set_category("solid-alginic-acid", "crafting")
bobmods.lib.recipe.set_category("wooden-board-paper", "crafting")

-- Fix handcrafting trying to use wrong crafting path
bobmods.lib.recipe.set_category("wooden-board", "electronics-machine")
bobmods.lib.recipe.enabled("wooden-board", false)
bobmods.lib.tech.add_recipe_unlock("bio-wood-processing-3", "wooden-board")

data.raw.recipe["cellulose-fiber-algae"].allow_as_intermediate = false
data.raw.recipe["cellulose-fiber-raw-wood"].allow_as_intermediate = false

-- Speed up algae->cellulose fiber crafting
data.raw.recipe["cellulose-fiber-algae"].energy_required = 2

-- Speed up cellulose->wood pellet crafting
data.raw.recipe["wood-pellets"].energy_required = 3

-- Reduce cost of Algae farm 2

local buildingmulti = angelsmods.marathon.buildingmulti
local buildingtime = angelsmods.marathon.buildingtime

angelsmods.functions.RB.build({
  {
    type = "recipe",
    name = "algae-farm-2",
    normal = {
      energy_required = 5,
      enabled = false,
      ingredients = {
        { type = "item", name = "algaefarm-2", amount = 1 },
        { type = "item", name = "t0-plate", amount = 11 },
        { type = "item", name = "t0-circuit", amount = 4 },
        { type = "item", name = "t0-brick", amount = 11 },
        { type = "item", name = "t0-pipe", amount = 18 },
      },
      result = "algae-farm-2",
    },
    expensive = {
      energy_required = 5 * buildingtime,
      enabled = false,
      ingredients = {
        { type = "item", name = "algaefarm-2", amount = 1 },
        { type = "item", name = "t0-plate", amount = 11 * buildingmulti },
        { type = "item", name = "t0-circuit", amount = 4 * buildingmulti },
        { type = "item", name = "t0-brick", amount = 11 * buildingmulti },
        { type = "item", name = "t0-pipe", amount = 18 * buildingmulti },
      },
      result = "algae-farm-2",
    },
  },
})
