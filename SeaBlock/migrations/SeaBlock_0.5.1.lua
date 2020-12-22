for _, force in pairs(game.forces) do
  if (force.technologies['sct-automation-science-pack'] and force.technologies['sct-automation-science-pack'].researched) or
     (force.technologies['sb-startup4'] and force.technologies['sb-startup4'].researched)  then
    force.technologies['sb-startup3'].researched = true
  end
end
