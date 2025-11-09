-- Speed up algae farm
data.raw["assembling-machine"]["angels-algae-farm"].crafting_speed = 0.75

-- Green algae
bobmods.lib.recipe.set_category("angels-algae-green", "angels-bio-processing")

-- Improved algae processing
bobmods.lib.tech.remove_prerequisite("angels-bio-processing-green", "angels-water-treatment")
bobmods.lib.tech.add_prerequisite("angels-bio-processing-green", "angels-bio-wood-processing-2")
bobmods.lib.tech.add_prerequisite("angels-bio-processing-green", "angels-water-washing-1")
data.raw.technology["angels-bio-processing-green"].localised_name = { "technology-name.sb-bio-processing-green" }

-- Move Lithia Salt to Thermal Water Extraction
seablock.lib.moveeffect("angels-algae-brown-burning", "angels-bio-processing-green", "angels-thermal-water-extraction", 2)
bobmods.lib.tech.add_prerequisite("bob-lithium-processing", "angels-thermal-water-extraction")

-- Change lithium crafting category
bobmods.lib.recipe.set_category("bob-lithium", "angels-petrochem-electrolyser")
bobmods.lib.recipe.set_category("bob-lithium-water-electrolysis", "angels-petrochem-electrolyser")

bobmods.lib.tech.remove_recipe_unlock("angels-water-treatment-3", "angels-solid-lithium")
bobmods.lib.recipe.hide("angels-solid-lithium") -- TODO: move angels-solid-lithium to the same group as the recipe or the other way around

-- Move Sodium Carbonate from Brown Algae to Sodium processing 2
seablock.lib.moveeffect("angels-algae-brown-burning-wash", "angels-bio-processing-green", "angels-sodium-processing-2", nil)

-- Move Methanol from Cellulose Fibre to Advanced chemistry 1
seablock.lib.moveeffect("angels-gas-methanol-from-wood", "angels-bio-processing-green", "angels-advanced-chemistry-1", 5)

-- Make Red Algae depend on Blue Algae instead of Green Algae
bobmods.lib.tech.remove_prerequisite("angels-bio-processing-red", "angels-bio-processing-green")
bobmods.lib.tech.add_prerequisite("angels-bio-processing-red", "angels-bio-processing-blue")

-- Blue algae
bobmods.lib.tech.replace_prerequisite("angels-bio-processing-blue", "angels-bio-processing-red", "angels-bio-processing-green")
bobmods.lib.tech.remove_prerequisite("angels-bio-processing-blue", "chemical-science-pack")
bobmods.lib.tech.remove_science_pack("angels-bio-processing-blue", "chemical-science-pack")
bobmods.lib.tech.remove_recipe_unlock("angels-bio-processing-blue", "angels-algae-farm-4")
bobmods.lib.recipe.set_category("angels-algae-blue", "angels-bio-processing-2")

-- Red algae. Make Calcium carbonate in an assembling machine, not a liquefier
bobmods.lib.recipe.set_category("angels-solid-calcium-carbonate", "advanced-crafting")

-- Alien bacteria
bobmods.lib.recipe.set_category("angels-alien-bacteria", "angels-bio-processing-3")

-- Make these craftable by hand
bobmods.lib.recipe.set_category("angels-solid-alginic-acid", "crafting")

-- Fix handcrafting trying to use wrong crafting path
data.raw.recipe["angels-cellulose-fiber-raw-wood"].allow_as_intermediate = false

-- Speed up algae->cellulose fiber crafting
data.raw.recipe["angels-cellulose-fiber"].energy_required = 2

-- Speed up cellulose->wood pellet crafting
data.raw.recipe["angels-wood-pellets"].energy_required = 3

-- Reduce cost of Algae farm 2

angelsmods.functions.RB.build({
  {
    type = "recipe",
    name = "angels-algae-farm-2",
    energy_required = 5,
    enabled = false,
    ingredients = {
      { type = "item", name = "algaefarm-2", amount = 1 },
      { type = "item", name = "t0-plate", amount = 11 },
      { type = "item", name = "t0-circuit", amount = 4 },
      { type = "item", name = "t0-brick", amount = 11 },
      { type = "item", name = "t0-pipe", amount = 18 },
    },
    results = {{type = "item", name = "angels-algae-farm-2", amount = 1}}
  },
})
