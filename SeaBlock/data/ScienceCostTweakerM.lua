if mods["ScienceCostTweakerM"] then
  bobmods.lib.recipe.set_subgroup("sct-t3-sulfur-lightsource", "sct-labparts")
  bobmods.lib.recipe.remove_ingredient("chemical-science-pack", "sct-t3-sulfur-lightsource")

  if mods["bobtech"] then
    -- Rename Lab 2 to Exoplanetary Studies Lab
    if data.raw.item["lab-2"] then
      data.raw.item["lab-2"].localised_name = { "item-name.sct-lab-lab2" }
    end
    if data.raw.lab["lab-2"] then
      data.raw.lab["lab-2"].localised_name = { "entity-name.sct-lab-lab2" }
    end

    bobmods.lib.recipe.set_ingredients("lab-2", {
      { "sct-lab-t4", 1 },
      { "rocket-silo", 1 },
      { "nitinol-alloy", 100 },
      { "express-stack-filter-inserter", 2 },
      { "advanced-processing-unit", 20 },
    })
    bobmods.lib.tech.add_prerequisite("sct-lab-lab2", "rocket-silo")
    bobmods.lib.tech.remove_prerequisite("sct-space-science-pack", "rocket-silo")
    bobmods.lib.tech.add_prerequisite("sct-space-science-pack", "sct-lab-lab2")
    if data.raw.technology["stack-inserter-4"] then
      bobmods.lib.tech.add_prerequisite("sct-lab-lab2", "stack-inserter-4")
    else
      bobmods.lib.tech.add_prerequisite("sct-lab-lab2", "stack-inserter-2")
    end
  end
end
