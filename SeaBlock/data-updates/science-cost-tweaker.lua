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
  bobmods.lib.tech.add_prerequisite("utility-science-pack", "battery-2")
  bobmods.lib.tech.add_prerequisite("utility-science-pack", "ceramics")

  if mods["bobmodules"] then
    if bobmods.modules.ModulesLab then
      bobmods.lib.tech.add_prerequisite("sct-lab-modules", "bio-processing-crystal-splinter-1")
    else
      bobmods.lib.tech.remove_recipe_unlock("sct-lab-modules", "lab-module")
      bobmods.lib.tech.hide("sct-lab-modules")
      bobmods.lib.tech.remove_recipe_unlock("sct-lab-modules", "module-processor-board")
      bobmods.lib.tech.remove_recipe_unlock("sct-lab-modules", "speed-processor")
      bobmods.lib.tech.remove_recipe_unlock("sct-lab-modules", "effectivity-processor")
      bobmods.lib.tech.remove_recipe_unlock("sct-lab-modules", "productivity-processor")
    end
  end

  -- Hide empty tech (Lab 2 will have been moved to it's own tech sct-lab-lab2
  seablock.lib.hide_technology("advanced-research")

  bobmods.lib.tech.remove_prerequisite("sct-lab-t3", "plastics")
  bobmods.lib.tech.add_prerequisite("sct-lab-t3", "angels-glass-smelting-1")
  bobmods.lib.tech.add_prerequisite("sct-lab-t3", "angels-aluminium-smelting-1")
  bobmods.lib.tech.add_prerequisite("sct-lab-t3", "angels-brass-smelting-1")
  bobmods.lib.tech.add_prerequisite("sct-lab-t3", "angels-silver-smelting-1")
  bobmods.lib.tech.replace_prerequisite("sct-lab-t3", "bob-solar-energy-2", "solar-energy")
  bobmods.lib.recipe.hide("sct-t3-flash-fuel2")

  -- T4 Lab
  -- Yellow science now requires Purple science
  bobmods.lib.tech.add_new_science_pack("sct-lab-t4", "production-science-pack", 1)
  bobmods.lib.tech.add_new_science_pack("sct-utility-science-pack", "production-science-pack", 1)

  -- Adjust any techs that needed Yellow but not Purple

  bobmods.lib.tech.replace_science_pack("fusion-reactor-equipment", "utility-science-pack", "production-science-pack")
  bobmods.lib.tech.replace_prerequisite("fusion-reactor-equipment", "utility-science-pack", "production-science-pack")
  bobmods.lib.tech.add_prerequisite("fusion-reactor-equipment", "low-density-structure")
  if mods["bobequipment"] then
    bobmods.lib.tech.add_prerequisite("fusion-reactor-equipment-2", "utility-science-pack")
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
