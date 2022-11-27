bobmods.lib.recipe.hide("bob-rubber")
seablock.lib.moveeffect("insulated-cable", "electronics", "rubbers")

-- Circuit network wires should not require rubber
bobmods.lib.recipe.set_ingredients("green-wire", { { "solid-paper", 2 }, { "tinned-copper-cable", 1 } })
bobmods.lib.recipe.set_ingredients("red-wire", { { "solid-paper", 2 }, { "tinned-copper-cable", 1 } })
