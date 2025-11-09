if mods["ScienceCostTweakerM"] then
  if data.raw.item["bob-lab-2"] then
    -- Update lab energy usage
    data.raw.lab["bob-lab-2"].energy_usage = "10MW"
    -- Only two module slots for lab-2 if s.c.t. is installed (other labs have no module slots)
    data.raw.lab["bob-lab-2"].module_slots = 2
  end

  -- Change tech to use lab icon from SCT
  data.raw["technology"]["sb-startup4"].icon = "__ScienceCostTweakerM__/graphics/sct-lab-t1/icon-64.png"
  data.raw["technology"]["sb-startup4"].icon_mipmaps = 0

  -- Reduce processing unit cost of S.C.T. high-tech science
  seablock.lib.substingredient("sct-htech-injector", "processing-unit", nil, 3)

  -- Hide empty tech (Lab 2 will have been moved to it's own tech sct-lab-lab2
  seablock.lib.hide_technology("bob-advanced-research")

  -- Yellow science now requires Purple science
  -- Adjust any techs that needed Yellow but not Purple

  bobmods.lib.tech.replace_science_pack("fission-reactor-equipment", "utility-science-pack", "production-science-pack")
  bobmods.lib.tech.replace_prerequisite("fission-reactor-equipment", "utility-science-pack", "production-science-pack")
  bobmods.lib.tech.add_prerequisite("fission-reactor-equipment", "low-density-structure")
  if mods["bobequipment"] then
    bobmods.lib.tech.add_prerequisite("bob-fission-reactor-equipment-3", "utility-science-pack")
  end

  if mods["bobvehicleequipment"] then
    bobmods.lib.tech.replace_science_pack(
      "bob-vehicle-fission-reactor-equipment-2",
      "utility-science-pack",
      "production-science-pack"
    )
    bobmods.lib.tech.replace_prerequisite(
      "bob-vehicle-fission-reactor-equipment-2",
      "utility-science-pack",
      "production-science-pack"
    )
    bobmods.lib.tech.add_prerequisite("bob-vehicle-fission-reactor-equipment-3", "utility-science-pack")
  end

  -- Move intermediates from Advanced Material Processing to Purple Science
  bobmods.lib.tech.remove_recipe_unlock("advanced-material-processing-2", "sct-prod-baked-biopaste")
  bobmods.lib.tech.remove_recipe_unlock("advanced-material-processing-2", "sct-prod-biosilicate")
  bobmods.lib.tech.add_recipe_unlock("production-science-pack", "sct-prod-baked-biopaste")
  bobmods.lib.tech.add_recipe_unlock("production-science-pack", "sct-prod-biosilicate")
  bobmods.lib.tech.add_prerequisite("sct-production-science-pack", "angels-advanced-gas-processing")
end
