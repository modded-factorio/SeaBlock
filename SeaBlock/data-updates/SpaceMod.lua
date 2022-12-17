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
end
