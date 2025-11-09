-- Remove wood from basic underground belt and splitter recipes
seablock.lib.removeingredient("bob-basic-underground-belt", "wood")
seablock.lib.removeingredient("bob-basic-splitter", "wood")

-- Can always apply productivity modules to furnace recipes, so make it official
-- for k, v in pairs(data.raw.module) do
--   if v.effect and v.effect.productivity and v.limitation then
--     table.insert(v.limitation, "sb-wood-bricks-charcoal")
--   end
-- end
angelsmods.functions.allow_productivity("sb-wood-bricks-charcoal")

bobmods.lib.recipe.enabled("wooden-chest", false)
bobmods.lib.recipe.enabled("bob-wooden-board", false)
bobmods.lib.recipe.enabled("angels-cellulose-fiber-raw-wood", false)

bobmods.lib.tech.remove_recipe_unlock("angels-bio-wood-processing", "angels-wood-pellets")
bobmods.lib.tech.add_recipe_unlock("angels-bio-wood-processing", "small-electric-pole")
bobmods.lib.tech.add_recipe_unlock("angels-bio-wood-processing", "wooden-chest")
bobmods.lib.tech.add_recipe_unlock("angels-bio-wood-processing", "bob-wooden-board")
bobmods.lib.tech.add_recipe_unlock("angels-bio-wood-processing", "bob-basic-circuit-board")

bobmods.lib.tech.remove_prerequisite("angels-bio-wood-processing-2", "angels-bio-farm-1")
bobmods.lib.tech.remove_prerequisite("angels-bio-wood-processing-2", "angels-bio-wood-processing")
bobmods.lib.tech.add_prerequisite("angels-bio-wood-processing-2", "angels-bio-processing-brown")
bobmods.lib.tech.remove_recipe_unlock("angels-bio-wood-processing-2", "angels-wood-charcoal")
bobmods.lib.tech.remove_recipe_unlock("angels-bio-wood-processing-2", "angels-bio-resin-wood-reprocessing")
bobmods.lib.tech.remove_recipe_unlock("angels-bio-wood-processing-2", "bob-rubber")
bobmods.lib.tech.remove_recipe_unlock("angels-bio-wood-processing-2", "angels-bio-processor")
bobmods.lib.tech.add_recipe_unlock("angels-bio-wood-processing-2", "angels-wood-pellets")
bobmods.lib.tech.add_recipe_unlock("angels-bio-wood-processing-2", "angels-wood-bricks")
bobmods.lib.tech.add_recipe_unlock("angels-bio-wood-processing-2", "sb-wood-bricks-charcoal")
bobmods.lib.tech.add_recipe_unlock("angels-bio-wood-processing-2", "angels-gas-carbon-dioxide")

bobmods.lib.tech.remove_prerequisite("angels-bio-wood-processing-3", "angels-coal-processing")
bobmods.lib.tech.add_prerequisite("angels-bio-wood-processing-3", "angels-bio-arboretum-1")
bobmods.lib.tech.remove_recipe_unlock("angels-bio-wood-processing-3", "angels-wood-bricks")
bobmods.lib.tech.add_recipe_unlock("angels-bio-wood-processing-3", "angels-cellulose-fiber-raw-wood")

-- Remove solid resin
bobmods.lib.recipe.hide("angels-bio-resin-wood-reprocessing")
bobmods.lib.tech.remove_prerequisite("angels-bio-wood-processing-2", "angels-bio-farm-1")
bobmods.lib.tech.remove_recipe_unlock("angels-resins", "angels-solid-resin")
bobmods.lib.recipe.hide("angels-solid-resin")
seablock.lib.hide_item("angels-solid-resin")
seablock.lib.hide_item("bob-resin")
bobmods.lib.tech.remove_recipe_unlock("angels-bio-arboretum-temperate-1", "angels-bio-resin-resin-liquification")
bobmods.lib.recipe.hide("angels-bio-resin-resin-liquification")
