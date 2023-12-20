bobmods.lib.recipe.hide("bob-rubber")
bobmods.lib.tech.remove_recipe_unlock("circuit-network", "insulated-cable")
bobmods.lib.tech.add_recipe_unlock("rubbers", "insulated-cable")

-- Circuit network wires should not require rubber
bobmods.lib.recipe.set_ingredients("green-wire", { { "solid-paper", 2 }, { "tinned-copper-cable", 1 } })
bobmods.lib.recipe.set_ingredients("red-wire", { { "solid-paper", 2 }, { "tinned-copper-cable", 1 } })

if mods["CircuitProcessing"] then
  bobmods.lib.tech.add_prerequisite("effectivity-module", "rubbers")
  bobmods.lib.tech.add_prerequisite("productivity-module", "rubbers")
  bobmods.lib.tech.add_prerequisite("speed-module", "rubbers")
end
