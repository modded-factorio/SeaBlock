for _, force in pairs(game.forces) do
  if force.technologies["fluid-chemical-furnace"] and force.technologies["fluid-chemical-furnace"].researched then
    force.technologies["fluid-chemical-furnace"].researched = false
    force.technologies["fluid-chemical-furnace"].enabled = false
  end
  if force.technologies["steel-chemical-furnace"].researched then
    force.technologies["steel-chemical-furnace"].researched = false
    force.technologies["steel-chemical-furnace"].enabled = false
  end
  if force.technologies["electric-chemical-furnace"].researched then
    force.technologies["electric-chemical-furnace"].researched = false
    force.technologies["electric-chemical-furnace"].enabled = false
  end
end