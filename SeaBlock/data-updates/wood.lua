-- Replace wood with paper for T2 boards
seablock.lib.substingredient('phenolic-board', 'wood', 'solid-paper', 4)

-- Remove wood from basic underground belt and splitter recipes
seablock.lib.removeingredient('basic-underground-belt', 'wood')
seablock.lib.removeingredient('basic-splitter', 'wood')

-- Remove 'wooden board from paper' recipe
bobmods.lib.tech.remove_recipe_unlock('bio-paper-1', 'wooden-board-paper')
seablock.lib.remove_recipe('wooden-board-paper')

-- Allow hand-crafting for wooden boards
seablock.lib.set_recipe_category('wooden-board', 'electronics')

-- Move compost building recipe from bio-farm-1 to sb-startup-1
seablock.lib.moveeffect('composter', 'bio-farm-1', 'sb-startup1', 4)

-- Can always apply productivity modules to furnace recipes, so make it official
for k,v in pairs(data.raw.module) do
  if v.effect and v.effect.productivity and v.limitation then
    table.insert(v.limitation, "sb-wood-bricks-charcoal")
  end
end

bobmods.lib.tech.remove_recipe_unlock('bio-wood-processing', 'bio-resin-wood-reprocessing')

bobmods.lib.tech.remove_recipe_unlock('bio-wood-processing-2', 'carbon-from-charcoal')
bobmods.lib.tech.remove_recipe_unlock('bio-wood-processing-2', 'wood-charcoal')

bobmods.lib.tech.remove_prerequisite('bio-wood-processing-3', 'logistic-science-pack')
bobmods.lib.tech.remove_prerequisite('bio-wood-processing-3', 'bio-arboretum-1')
bobmods.lib.tech.remove_prerequisite('bio-wood-processing-3', 'bio-wood-processing-2')
bobmods.lib.tech.remove_recipe_unlock('bio-wood-processing-3', 'wooden-board')
seablock.lib.hide_technology('bio-wood-processing-3')

bobmods.lib.tech.remove_prerequisite('bio-arboretum-1', 'bio-wood-processing')

-- Remove wooden chest from composter recipe
bobmods.lib.recipe.remove_ingredient('composter', 'wooden-chest')

bobmods.lib.tech.add_prerequisite('advanced-electronics', 'bio-paper-1')

seablock.lib.moveeffect('cellulose-fiber-algae', 'bio-processing-brown', 'sb-startup1')
seablock.lib.add_recipe_unlock('bio-wood-processing', 'cellulose-fiber-raw-wood', 2)
bobmods.lib.recipe.enabled('cellulose-fiber-raw-wood', false)
seablock.lib.add_recipe_unlock('bio-wood-processing', 'wood-pellets', 3)
seablock.lib.moveeffect('wood-bricks', 'bio-wood-processing-3', 'bio-wood-processing', 4)
seablock.lib.add_recipe_unlock('bio-wood-processing', 'small-electric-pole', 5)
bobmods.lib.tech.add_recipe_unlock('bio-wood-processing', 'wooden-chest')
bobmods.lib.recipe.enabled('wooden-chest', false)
