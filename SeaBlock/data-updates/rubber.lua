bobmods.lib.recipe.hide("bob-rubber")
seablock.lib.moveeffect("insulated-cable", "electronics", "rubbers")

-- Circuit network wires should not require rubber
bobmods.lib.recipe.set_ingredients("green-wire", { { "electronic-circuit", 1 }, { "copper-cable", 1 } })
bobmods.lib.recipe.set_ingredients("red-wire", { { "electronic-circuit", 1 }, { "copper-cable", 1 } })
