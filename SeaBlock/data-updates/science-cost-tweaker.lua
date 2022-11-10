if mods["ScienceCostTweakerM"] then
  if data.raw.item["lab-2"] then
    -- Update lab MK2 ingredients and energy usage
    seablock.lib.substingredient("lab-2", "advanced-circuit", "advanced-processing-unit")
    data.raw.lab["lab-2"].energy_usage = "10MW"
    -- Only two module slots for lab-2 if s.c.t. is installed (other labs have no module slots)
    data.raw.lab["lab-2"].module_specification.module_slots = 2
  end

  -- Change tech to use lab icon from SCT
  data.raw.tool["sb-lab-tool"].icon = "__ScienceCostTweakerM__/graphics/sct-lab-t1/icon-64.png"
  data.raw.tool["sb-lab-tool"].icon_mipmaps = 0

  -- Reduce processing unit cost of S.C.T. high-tech science
  seablock.lib.substingredient("sct-htech-injector", "processing-unit", nil, 3)

  -- Add prerequisites
  bobmods.lib.tech.add_prerequisite("military-science-pack", "angels-brass-smelting-1")
  bobmods.lib.tech.add_prerequisite("military-science-pack", "angels-invar-smelting-1")

  -- Hide empty tech (Lab 2 will have been moved to it's own tech sct-lab-lab2
  seablock.lib.hide_technology("advanced-research")

  if data.raw.technology["sct-lab-t3"] then
    bobmods.lib.tech.remove_prerequisite("sct-lab-t3", "plastics")
    bobmods.lib.tech.add_prerequisite("sct-lab-t3", "angels-glass-smelting-1")
    bobmods.lib.tech.add_prerequisite("sct-lab-t3", "angels-aluminium-smelting-1")
    bobmods.lib.tech.add_prerequisite("sct-lab-t3", "angels-brass-smelting-1")
    bobmods.lib.tech.add_prerequisite("sct-lab-t3", "angels-silver-smelting-1")
    bobmods.lib.tech.replace_prerequisite("sct-lab-t3", "bob-solar-energy-2", "solar-energy")
    bobmods.lib.recipe.hide("sct-t3-flash-fuel2")
  end

  -- Make yellow science require purple science
  for _, tech_name in pairs({
    "fusion-reactor-equipment",
    "power-armor-mk2",
    "rocket-fuel",
    "sct-lab-t4",
    "sct-utility-science-pack",
  }) do
    bobmods.lib.tech.add_new_science_pack(tech_name, "production-science-pack", 1)
  end
end
