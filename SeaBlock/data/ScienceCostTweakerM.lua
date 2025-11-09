if mods["ScienceCostTweakerM"] then
  bobmods.lib.recipe.set_subgroup("sct-t3-sulfur-lightsource", "sct-labparts")
  bobmods.lib.recipe.remove_ingredient("chemical-science-pack", "sct-t3-sulfur-lightsource")

  if mods["bobtech"] then
    -- Rename Lab 2 to Exoplanetary Studies Lab
    if data.raw.item["bob-lab-2"] then
      data.raw.item["bob-lab-2"].localised_name = { "item-name.sct-lab-lab2" }
    end
    if data.raw.lab["bob-lab-2"] then
      data.raw.lab["bob-lab-2"].localised_name = { "entity-name.sct-lab-lab2" }
    end

    bobmods.lib.recipe.set_ingredients("bob-lab-2", {
      { type = "item", name = "sct-lab-t4", amount = 1 },
      { type = "item", name = "rocket-silo", amount = 1 },
      { type = "item", name = "bob-nitinol-alloy", amount = 100 },
      { type = "item", name = "bob-express-bulk-inserter", amount = 2 },
      { type = "item", name = "bob-advanced-processing-unit", amount = 20 },
    })
    bobmods.lib.tech.add_prerequisite("sct-lab-lab2", "rocket-silo")
    bobmods.lib.tech.remove_prerequisite("sct-space-science-pack", "rocket-silo")
    bobmods.lib.tech.add_prerequisite("sct-space-science-pack", "sct-lab-lab2")
    if data.raw.technology["bob-bulk-inserter-4"] then
      bobmods.lib.tech.add_prerequisite("sct-lab-lab2", "bob-bulk-inserter-4")
    else
      bobmods.lib.tech.add_prerequisite("sct-lab-lab2", "bob-bulk-inserter-2")
    end
  end
end
