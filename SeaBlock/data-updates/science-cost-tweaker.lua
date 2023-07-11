if mods["ScienceCostTweakerM"] then
  if data.raw.item["lab-2"] then
    -- Update lab energy usage
    data.raw.lab["lab-2"].energy_usage = "10MW"
    -- Only two module slots for lab-2 if s.c.t. is installed (other labs have no module slots)
    data.raw.lab["lab-2"].module_specification.module_slots = 2
  end

  -- Change tech to use lab icon from SCT
  data.raw.tool["sb-lab-tool"].icon = "__ScienceCostTweakerM__/graphics/sct-lab-t1/icon-64.png"
  data.raw.tool["sb-lab-tool"].icon_mipmaps = 0

  -- Reduce processing unit cost of S.C.T. high-tech science
  seablock.lib.substingredient("sct-htech-injector", "processing-unit", nil, 3)

  -- Hide empty tech (Lab 2 will have been moved to it's own tech sct-lab-lab2
  seablock.lib.hide_technology("advanced-research")

  -- Yellow science now requires Purple science
  -- Adjust any techs that needed Yellow but not Purple

  bobmods.lib.tech.replace_science_pack("fusion-reactor-equipment", "utility-science-pack", "production-science-pack")
  bobmods.lib.tech.replace_prerequisite("fusion-reactor-equipment", "utility-science-pack", "production-science-pack")
  bobmods.lib.tech.add_prerequisite("fusion-reactor-equipment", "low-density-structure")
  if mods["bobequipment"] then
    bobmods.lib.tech.add_prerequisite("fusion-reactor-equipment-3", "utility-science-pack")
  end

  if mods["bobvehicleequipment"] then
    bobmods.lib.tech.replace_science_pack(
      "vehicle-fusion-reactor-equipment-2",
      "utility-science-pack",
      "production-science-pack"
    )
    bobmods.lib.tech.replace_prerequisite(
      "vehicle-fusion-reactor-equipment-2",
      "utility-science-pack",
      "production-science-pack"
    )
    bobmods.lib.tech.add_prerequisite("vehicle-fusion-reactor-equipment-3", "utility-science-pack")
  end
end
