for _,force in pairs(game.forces) do
  if force.technologies['sb-startup4'].researched and force.technologies['sct-research-t1'] then
    force.technologies['sct-research-t1'].researched = true
  end
end

