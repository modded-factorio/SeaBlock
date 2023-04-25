bobmods.lib.recipe.hide("bob-rubber")
seablock.lib.moveeffect("insulated-cable", "electronics", "rubbers")

-- Circuit network wires should not require rubber
bobmods.lib.recipe.set_ingredients("green-wire", { { "solid-paper", 2 }, { "tinned-copper-cable", 1 } })
bobmods.lib.recipe.set_ingredients("red-wire", { { "solid-paper", 2 }, { "tinned-copper-cable", 1 } })

if mods["CircuitProcessing"] then
  bobmods.lib.tech.add_prerequisite("effectivity-module", "rubbers")
  bobmods.lib.tech.add_prerequisite("productivity-module", "rubbers")
  bobmods.lib.tech.add_prerequisite("speed-module", "rubbers")
end
