if mods['SpaceMod'] then
  if settings.startup["SpaceX-ignore-tech-multiplier"] then
    if settings.startup["SpaceX-ignore-tech-multiplier"].value then
      for _, tech_name in pairs({
        'ftl-theory-A',
        'ftl-theory-B',
        'ftl-theory-C',
        'ftl-theory-D',
        'ftl-theory-D1',
        'ftl-theory-D2',
        'ftl-propulsion'
      }) do
        local tech = data.raw.technology[tech_name]
        
        if tech then
          tech.ignore_tech_cost_multiplier = true
        end
      end
    else
      for _, tech_name in pairs({
        'space-assembly',
        'space-construction',
        'space-casings',
        'protection-fields',
        'fusion-reactor',
        'space-thrusters',
        'fuel-cells',
        'habitation',
        'life-support-systems',
        'spaceship-command',
        'astrometrics'
      }) do
        local tech = data.raw.technology[tech_name]
        
        if tech then
          tech.unit.count = tech.unit.count / 4
        end
      end
    end
  end
end
