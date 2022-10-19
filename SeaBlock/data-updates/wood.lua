-- No wood for electric poles, use wood bricks instead
seablock.lib.substingredient("small-electric-pole", "wood", "wood-bricks", nil)

-- Wood removal
seablock.lib.substingredient("phenolic-board", "wood", "wooden-board", 2)

-- Remove wood from basic underground belt and splitter recipes
seablock.lib.removeingredient("basic-underground-belt", "wood")
seablock.lib.removeingredient("basic-splitter", "wood")

-- Can always apply productivity modules to furnace recipes, so make it official
for k, v in pairs(data.raw.module) do
  if v.effect and v.effect.productivity and v.limitation then
    table.insert(v.limitation, "sb-wood-bricks-charcoal")
  end
end

bobmods.lib.tech.remove_recipe_unlock("bio-wood-processing", "bio-resin-wood-reprocessing")

bobmods.lib.tech.remove_recipe_unlock("bio-wood-processing-2", "carbon-from-charcoal")
bobmods.lib.tech.remove_recipe_unlock("bio-wood-processing-2", "wood-charcoal")

bobmods.lib.tech.replace_prerequisite("bio-wood-processing-3", "angels-coal-processing-3", "bio-arboretum-1")
bobmods.lib.tech.replace_prerequisite("bio-wood-processing-3", "angels-coal-processing-3", "bio-arboretum-1")

bobmods.lib.tech.remove_prerequisite("bio-arboretum-1", "bio-wood-processing")

-- Remove wooden chest from composter recipe
bobmods.lib.recipe.remove_ingredient("composter", "wooden-chest")

seablock.lib.moveeffect("cellulose-fiber-algae", "bio-processing-brown", "bio-wood-processing", 1)
seablock.lib.add_recipe_unlock("bio-wood-processing", "cellulose-fiber-raw-wood", 2)
bobmods.lib.recipe.enabled("cellulose-fiber-raw-wood", false)
seablock.lib.add_recipe_unlock("bio-wood-processing", "wood-pellets", 3)
seablock.lib.moveeffect("wood-bricks", "bio-wood-processing-3", "bio-wood-processing", 4)
seablock.lib.add_recipe_unlock("bio-wood-processing", "small-electric-pole", 5)
bobmods.lib.tech.add_recipe_unlock("bio-wood-processing", "wooden-chest")
bobmods.lib.recipe.enabled("wooden-chest", false)
