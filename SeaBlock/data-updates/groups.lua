local move_item = angelsmods.functions.move_item

if not mods['angelsindustries'] then
  -- Move misc sciencey things over to intermediate products tab
  for k,v in pairs(data.raw['item-subgroup']) do
    if v.group == 'bob-resource-products' or v.group == 'bob-fluid-products' then
      v.group = 'intermediate-products'
    end
  end

  move_item('battery', 'bob-intermediates', 'f-cba[battery]')
  move_item('iron-gear-wheel', 'bob-gears', 'aa[iron-gear-wheel]')
end

if mods['SpaceMod'] then
  if mods['ScienceCostTweakerM'] then
    move_item('rocket-part', 'sct-sciencepack-space', 'z[space]-b[rocket-part]')
  end

  for _,item_name in pairs({
    'assembly-robot',
    'astrometrics',
    'command',
    'drydock-assembly',
    'drydock-structural',
    'ftl-drive',
    'fuel-cell',
    'fusion-reactor',
    'habitation',
    'hull-component',
    'life-support',
    'protection-field',
    'space-thruster'
  }) do
    move_item(item_name, 'sb-SpaceMod')
  end
end

if mods['Explosive Excavation'] then
  move_item('blasting-charge', 'petrochem-solids', 'b[petrochem-solids-2]-c[blasting-charge]')
  move_item('blasting-charge', 'petrochem-solids-2', 'a[explosives]-g', 'recipe')
end

move_item('solid-fuel-from-hydrogen', 'petrochem-fuel', 'e[bob]-d', 'recipe')
