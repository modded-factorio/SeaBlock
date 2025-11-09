bobmods.lib.recipe.hide("bob-rubber")
bobmods.lib.tech.remove_recipe_unlock("circuit-network", "bob-insulated-cable")
bobmods.lib.tech.add_recipe_unlock("angels-rubbers", "bob-insulated-cable")

-- Circuit network wires should not require rubber
--bobmods.lib.recipe.set_ingredients("green-wire", { { "angels-solid-paper", 2 }, { "bob-tinned-copper-cable", 1 } })
--bobmods.lib.recipe.set_ingredients("red-wire", { { "angels-solid-paper", 2 }, { "bob-tinned-copper-cable", 1 } })

if mods["CircuitProcessing"] then
  bobmods.lib.tech.add_prerequisite("efficiency-module", "angels-rubbers")
  bobmods.lib.tech.add_prerequisite("productivity-module", "angels-rubbers")
  bobmods.lib.tech.add_prerequisite("speed-module", "angels-rubbers")
end
