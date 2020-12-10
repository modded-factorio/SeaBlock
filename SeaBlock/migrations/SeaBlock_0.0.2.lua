local unlocktech = function(force, tech)
  if tech.researched then
    for _,v in ipairs(tech.effects) do
      if v.type == 'unlock-recipe' then
        force.recipes[v.recipe].enabled = true
      end
    end
  end
end

for _, force in pairs(game.forces) do
  force.reset_technologies()
  unlocktech(force, force.technologies['slag-processing-1'])
  unlocktech(force, force.technologies['slag-processing-2'])
end
