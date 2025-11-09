if mods["early_construction"] then
  bobmods.lib.recipe.replace_ingredient("early-construction-robot", "coal", "angels-wood-charcoal")
  bobmods.lib.tech.add_prerequisite("early-construction-light-armor", "military")
  bobmods.lib.tech.add_prerequisite("early-construction-light-armor", "angels-bio-wood-processing-2")
end

if mods["grappling-gun"] then
  bobmods.lib.recipe.replace_ingredient("grappling-gun-ammo", "coal", "angels-wood-charcoal")
end

if mods["jetpack"] then
  bobmods.lib.tech.remove_science_pack("jetpack-1", "chemical-science-pack")
  bobmods.lib.tech.add_science_pack("jetpack-1", "military-science-pack", 1)
  bobmods.lib.tech.remove_prerequisite("jetpack-1", "rocket-fuel")
  bobmods.lib.tech.remove_prerequisite("jetpack-1", "solar-panel-equipment")
  bobmods.lib.tech.add_prerequisite("jetpack-1", "modular-armor")
  bobmods.lib.tech.add_prerequisite("jetpack-1", "rocket-booster-1")
  bobmods.lib.tech.add_prerequisite("jetpack-1", "military-science-pack")
  bobmods.lib.tech.add_prerequisite("jetpack-1", "zinc-processing")
  bobmods.lib.recipe.replace_ingredient("jetpack-1", "electronic-circuit", "advanced-circuit")
  bobmods.lib.recipe.replace_ingredient("jetpack-1", "pipe", "brass-pipe")
  bobmods.lib.recipe.replace_ingredient("jetpack-1", "steel-plate", "bob-invar-alloy")

  bobmods.lib.tech.add_science_pack("jetpack-2", "military-science-pack", 1)
  bobmods.lib.tech.add_prerequisite("jetpack-2", "advanced-electronics-2")
  bobmods.lib.recipe.replace_ingredient("jetpack-2", "advanced-circuit", "processing-unit")

  bobmods.lib.tech.add_science_pack("jetpack-3", "military-science-pack", 1)
  bobmods.lib.tech.add_science_pack("jetpack-3", "production-science-pack", 1)
  bobmods.lib.recipe.replace_ingredient("jetpack-3", "processing-unit", "bob-advanced-processing-unit")

  bobmods.lib.tech.add_science_pack("jetpack-4", "military-science-pack", 1)
  bobmods.lib.tech.add_science_pack("jetpack-4", "production-science-pack", 1)
  if mods["bobmodules"] then
    if mods["CircuitProcessing"] then
      bobmods.lib.recipe.remove_ingredient("jetpack-4", "speed-module-4")
      bobmods.lib.recipe.remove_ingredient("jetpack-4", "efficiency-module-4")
      bobmods.lib.recipe.add_new_ingredient("jetpack-4", { type = "item", name = "speed-module-5", amount = 2 })
      bobmods.lib.recipe.add_new_ingredient("jetpack-4", { type = "item", name = "efficiency-module-5", amount = 2 })
    else
      bobmods.lib.recipe.replace_ingredient("jetpack-4", "speed-module-3", "speed-module-5")
      bobmods.lib.recipe.replace_ingredient("jetpack-4", "efficiency-module-3", "efficiency-module-5")
    end
  end
end
