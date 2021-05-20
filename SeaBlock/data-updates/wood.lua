-- No wood for electric poles, use wood bricks instead
data.raw.recipe['small-electric-pole'].ingredients = {{ "wood-bricks", 1 }, { "copper-cable", 2}}

-- Wood removal
seablock.lib.substingredient('phenolic-board', 'wood', 'wooden-board', 2)
seablock.lib.substingredient('gun-cotton', 'wood', 'cellulose-fiber', 2)

-- Remove wood from basic underground belt and splitter recipes
seablock.lib.removeingredient('basic-underground-belt', 'wood')
seablock.lib.removeingredient('basic-splitter', 'wood')

-- Can always apply productivity modules to furnace recipes, so make it official
for k,v in pairs(data.raw.module) do
  if v.effect and v.effect.productivity and v.limitation then
    table.insert(v.limitation, "sb-wood-bricks-charcoal")
  end
end

table.insert(data.raw.technology['bio-wood-processing-2'].effects, {type = 'unlock-recipe', recipe = 'sb-wood-bricks-charcoal'})

seablock.lib.takeeffect('bio-wood-processing-2', 'carbon-from-charcoal')
seablock.lib.takeeffect('bio-wood-processing-2', 'wood-charcoal')
