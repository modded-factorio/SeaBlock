-- Speed up algae farm
data.raw['assembling-machine']['algae-farm'].crafting_speed = 0.75

-- Brown algae
bobmods.lib.tech.add_prerequisite('bio-processing-brown', 'bio-processing-green')
bobmods.lib.tech.remove_recipe_unlock('bio-processing-brown', 'algae-green-simple')

-- Green algae

-- Move Lithia Salt to Thermal Water Extraction
seablock.lib.moveeffect('algae-brown-burning', 'bio-processing-green', 'thermal-water-extraction', 2)
bobmods.lib.tech.add_prerequisite('lithium-processing', 'thermal-water-extraction')

-- Move Sodium Carbonate from Brown Algae to Sodium processing
seablock.lib.moveeffect('algae-brown-burning-wash', 'bio-processing-green', 'sodium-processing', nil)

-- Move Methanol from Cellulose Fibre to Advanced chemistry 1
seablock.lib.moveeffect('gas-methanol-from-wood', 'bio-processing-green', 'angels-advanced-chemistry-1', 5)

--[[
  Make Green Algae 2 available sooner:
  - Make Red Algae depend on Blue Algae instead of Green Algae
  - Move Algae Farm 2 to Blue Algae (from Green Algae)
  - Make Green Algae depend on Basic Chemistry instead of Water Treatment
--]]
bobmods.lib.tech.replace_prerequisite('bio-processing-red', 'bio-processing-green', 'bio-processing-blue')
seablock.lib.moveeffect('algae-farm-2', 'bio-processing-green', 'bio-processing-blue', 1)
bobmods.lib.tech.remove_prerequisite('bio-processing-green', 'bio-processing-brown')
bobmods.lib.tech.replace_prerequisite('bio-processing-green', 'basic-chemistry', 'bio-wood-processing-2')

-- Blue algae
bobmods.lib.tech.replace_prerequisite('bio-processing-blue', 'bio-processing-red', 'bio-processing-brown')
bobmods.lib.tech.remove_science_pack('bio-processing-blue', 'chemical-science-pack')
bobmods.lib.tech.remove_recipe_unlock('bio-processing-blue', 'algae-farm-4')


-- Make these craftable by hand
data.raw.recipe['solid-alginic-acid'].category = "crafting"
data.raw.recipe['wooden-board-paper'].category = "crafting"

-- Fix handcrafting trying to use wrong crafting path
data.raw.recipe['wooden-board'].category = "electronics-machine"
bobmods.lib.recipe.enabled('wooden-board', false)
bobmods.lib.tech.add_recipe_unlock('bio-wood-processing-3', 'wooden-board')

data.raw.recipe['cellulose-fiber-algae'].allow_as_intermediate = false
data.raw.recipe['cellulose-fiber-raw-wood'].allow_as_intermediate = false

-- Speed up algae->cellulose fiber crafting
data.raw.recipe['cellulose-fiber-algae'].energy_required = 2

-- Speed up cellulose->wood pellet crafting
data.raw.recipe['wood-pellets'].energy_required = 3

-- Reduce cost of Algae farm 3

local buildingmulti = angelsmods.marathon.buildingmulti
local buildingtime = angelsmods.marathon.buildingtime

angelsmods.functions.RB.build(
  {
    {
      type = "recipe",
      name = "algae-farm-4",
      normal = {
        energy_required = 5,
        enabled = false,
        ingredients = {
          {type = "item", name = "algaefarm-4", amount = 1},
          {type = "item", name = "t3-plate", amount = 11},
          {type = "item", name = "t3-circuit", amount = 4},
          {type = "item", name = "t3-brick", amount = 11},
          {type = "item", name = "t3-pipe", amount = 18}
        },
        result = "algae-farm-4"
      },
      expensive = {
        energy_required = 5 * buildingtime,
        enabled = false,
        ingredients = {
          {type = "item", name = "algaefarm-4", amount = 1},
          {type = "item", name = "t3-plate", amount = 11 * buildingmulti},
          {type = "item", name = "t3-circuit", amount = 4 * buildingmulti},
          {type = "item", name = "t3-brick", amount = 11 * buildingmulti},
          {type = "item", name = "t3-pipe", amount = 18 * buildingmulti}
        },
        result = "algae-farm-4"
      }
    }
  }
)
