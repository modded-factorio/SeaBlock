for _,force in pairs(game.forces) do
  if force.technologies['logistics'].researched and force.technologies['bob-logistics-0'] then
    force.technologies['bob-logistics-0'].researched = true
  end
end

local plants = {
  'desert-tree', 'temperate-tree', 'swamp-tree',
  'desert-garden', 'temperate-garden', 'swamp-garden'
}
-- Remove old gardens so trees have room to spawn
for _,plant in pairs(plants) do
  for _,entity in pairs(game.surfaces[1].find_entities_filtered{name = plant}) do
    entity.destroy()
  end
end
game.surfaces[1].regenerate_entity(plants)
