if mods["Companion_Drones"] then
  bobmods.lib.tech.add_recipe_unlock("bob-electronics", "companion")
  bobmods.lib.tech.add_recipe_unlock("bob-electronics", "companion-roboport-equipment")
  bobmods.lib.tech.add_recipe_unlock("bob-electronics", "companion-reactor-equipment")
  bobmods.lib.tech.add_recipe_unlock("energy-shield-mk2-equipment", "companion-shield-equipment")

  bobmods.lib.recipe.set_ingredient("companion-shield-equipment", { "energy-shield-mk2-equipment", 1 })

  bobmods.lib.recipe.enabled("companion", false)
  bobmods.lib.recipe.enabled("companion-roboport-equipment", false)
  bobmods.lib.recipe.enabled("companion-reactor-equipment", false)
  bobmods.lib.recipe.enabled("companion-shield-equipment", false)
  bobmods.lib.recipe.enabled("companion-defense-equipment", false)

  if mods["bobwarfare"] and mods["bobequipment"] then
    -- If both Bob's Warfare and Bob's Personal equipment mods are enabled,
    -- then make make sure companion shield and laser defence stay at military + blue science
    bobmods.lib.tech.remove_science_pack("personal-laser-defense-equipment", "chemical-science-pack")
    bobmods.lib.tech.replace_prerequisite("personal-laser-defense-equipment", "power-armor", "modular-armor")
    bobmods.lib.tech.remove_prerequisite("personal-laser-defense-equipment", "low-density-structure")
    bobmods.lib.tech.remove_prerequisite("personal-laser-defense-equipment", "military-3")
    bobmods.lib.tech.add_prerequisite("personal-laser-defense-equipment-2", "military-3")

    bobmods.lib.tech.add_recipe_unlock("personal-laser-defense-equipment-2", "companion-defense-equipment")
    bobmods.lib.recipe.set_ingredient("companion-defense-equipment", { "personal-laser-defense-equipment-2", 1 })
  end
end
