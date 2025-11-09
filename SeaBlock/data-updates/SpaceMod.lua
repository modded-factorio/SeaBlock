if mods["SpaceMod"] then
  if
    settings.startup["bobmods-logistics-disableroboports"]
    and settings.startup["bobmods-logistics-disableroboports"].value
  then
    bobmods.lib.recipe.remove_ingredient("drydock-assembly", "roboport")
    bobmods.lib.recipe.add_ingredients("drydock-assembly", {
      { type = "item", name = "bob-robochest", amount = 10 },
      { type = "item", name = "bob-logistic-zone-expander", amount = 10 },
      { type = "item", name = "bob-robo-charge-port-large", amount = 10 },
    })
  end

  bobmods.lib.tech.add_science_pack("ftl-theory-D2", "production-science-pack", 1)
  bobmods.lib.tech.remove_prerequisite("ftl-propulsion", "ftl-theory-D1")
  bobmods.lib.tech.add_prerequisite("ftl-theory-D2", "ftl-theory-D1")
  bobmods.lib.tech.remove_prerequisite("ftl-theory-D2", "ftl-theory-C")

  if mods["boblogistics"] then
    bobmods.lib.tech.add_prerequisite("space-assembly", "bob-robots-4")
  end

  if not mods["bobmodules"] then
    -- Do nothing
  elseif mods["CircuitProcessing"] then
    bobmods.lib.tech.add_prerequisite("space-assembly", "bob-efficiency-module-4")
    bobmods.lib.tech.add_prerequisite("space-assembly", "bob-productivity-module-4")
    bobmods.lib.tech.add_prerequisite("space-assembly", "bob-speed-module-4")
  else
    bobmods.lib.tech.add_prerequisite("space-assembly", "bob-productivity-module-5")
  end

  if mods["bobpower"] and settings.startup["bobmods-power-solar"].value == true then
    bobmods.lib.tech.add_prerequisite("space-construction", "bob-solar-energy-3")
  end
end
