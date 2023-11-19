if mods["early_construction"] then
  bobmods.lib.recipe.replace_ingredient("early-construction-robot", "coal", "wood-charcoal")
  bobmods.lib.tech.add_prerequisite("early-construction-light-armor", "military")
  bobmods.lib.tech.add_prerequisite("early-construction-light-armor", "bio-wood-processing-2")
end
