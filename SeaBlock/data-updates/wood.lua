-- No wood for electric poles, use wood bricks instead
data.raw.recipe['small-electric-pole'].ingredients = {{ "wood-bricks", 1 }, { "copper-cable", 2}}

-- Wood removal
seablock.lib.substingredient('phenolic-board', 'wood', 'wooden-board', 2)

-- Remove wood from basic underground belt and splitter recipes
seablock.lib.removeingredient('basic-underground-belt', 'wood')
seablock.lib.removeingredient('basic-splitter', 'wood')

-- Can always apply productivity modules to furnace recipes, so make it official
for k,v in pairs(data.raw.module) do
  if v.effect and v.effect.productivity and v.limitation then
    table.insert(v.limitation, "sb-wood-bricks-charcoal")
  end
end

bobmods.lib.tech.remove_recipe_unlock('bio-wood-processing', 'bio-resin-wood-reprocessing')

bobmods.lib.tech.add_recipe_unlock('bio-wood-processing-2', 'sb-wood-bricks-charcoal')
bobmods.lib.tech.remove_recipe_unlock('bio-wood-processing-2', 'carbon-from-charcoal')
bobmods.lib.tech.remove_recipe_unlock('bio-wood-processing-2', 'wood-charcoal')

bobmods.lib.tech.replace_prerequisite('bio-wood-processing-3', 'angels-coal-processing-3', 'bio-arboretum-1')
bobmods.lib.tech.replace_prerequisite('bio-wood-processing-3', 'angels-coal-processing-3', 'bio-arboretum-1')

bobmods.lib.tech.remove_prerequisite('bio-arboretum-1', 'bio-wood-processing')

-- Remove wooden chest from composter recipe
bobmods.lib.recipe.remove_ingredient('composter', 'wooden-chest')


seablock.lib.moveeffect('cellulose-fiber-algae', 'bio-processing-brown', 'bio-wood-processing', 1)
seablock.lib.add_recipe_unlock('bio-wood-processing', 'wood-pellets', 2)
seablock.lib.moveeffect('wood-bricks', 'bio-wood-processing-3', 'bio-wood-processing', 3)
seablock.lib.add_recipe_unlock('bio-wood-processing', 'small-electric-pole', 4)
