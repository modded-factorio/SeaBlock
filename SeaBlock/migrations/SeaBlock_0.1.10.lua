for _, force in pairs(game.forces) do
  if force.technologies['angels-advanced-chemistry-1'].researched then
    force.technologies['angels-coal-cracking'].researched = true
  end
end
