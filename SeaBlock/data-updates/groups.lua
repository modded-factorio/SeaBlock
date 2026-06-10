local move_item = angelsmods.functions.move_item

if not mods["angelsindustries"] then
  -- Move all the gems to separate gems group 
  for _, v in pairs(data.raw["item-subgroup"]) do
    if
      v.name == "bob-gems-crystallization"
      or v.name == "bob-gems-raw"
      or v.name == "bob-gems-cut"
      or v.name == "bob-gems-polished"
    then
      v.group = "bob-gems"
    end
    if (v.name == "bob-nuclear") then
      v.group = "intermediate-products"
    end
  end

  move_item("iron-gear-wheel", "bob-gears", "aa[iron-gear-wheel]")
end

if mods["SpaceMod"] then
  if mods["ScienceCostTweakerM"] then
    move_item("rocket-part", "sct-sciencepack-space", "z[space]-b[rocket-part]")
  end

  for _, item_name in pairs({
    "assembly-robot",
    "astrometrics",
    "command",
    "drydock-assembly",
    "drydock-structural",
    "ftl-drive",
    "fuel-cell",
    "fusion-reactor",
    "habitation",
    "hull-component",
    "life-support",
    "protection-field",
    "space-thruster",
  }) do
    move_item(item_name, "sb-SpaceMod")
  end
end

if mods["Explosive Excavation"] then
  move_item("blasting-charge", "angels-petrochem-solids", "b[petrochem-solids-2]-c[blasting-charge]")
  move_item("blasting-charge", "angels-petrochem-solids-2", "a[explosives]-g", "recipe")
end

move_item("bob-solid-fuel-from-hydrogen", "angels-petrochem-fuel", "e[bob]-d", "recipe")
