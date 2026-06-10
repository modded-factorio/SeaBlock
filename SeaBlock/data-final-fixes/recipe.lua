-- Revert massive buff of insulated wire recipe
bobmods.lib.recipe.set_energy_required("bob-insulated-cable", 2)
seablock.lib.substingredient("bob-insulated-cable", "bob-tinned-copper-cable", nil, 8)
seablock.lib.substingredient("bob-insulated-cable", "bob-rubber", nil, 8)
bobmods.lib.recipe.set_result("bob-insulated-cable", { type = "item", name = "bob-insulated-cable", amount = 8 })

-- Combine Stone and Crushed Stone
for _, recipe in pairs(data.raw.recipe) do
  if recipe.ingredients then
    for _, ingredient in pairs(recipe.ingredients) do
      if ingredient.name == "stone" then
        ingredient.amount = ingredient.amount * 2
      elseif ingredient.name == "angels-stone-crushed" then
        ingredient.name = "stone"
      end
    end
  end
  if recipe.results then --needed for recipes parameter- which have no results
    for _, result in pairs(recipe.results) do
      if result.name == "stone" then
        result.amount = result.amount * 2
      elseif result.name == "angels-stone-crushed" then
        result.name = "stone"
      end
    end
  end
  if recipe.main_product == "angels-stone-crushed" then
    recipe.main_product = "stone"
  end
end
bobmods.lib.recipe.hide("angels-stone-from-crushed-stone")
seablock.lib.hide("item", "angels-stone-crushed")

if data.raw.recipe["angels-stone-crushed-dissolution"] then
  data.raw.recipe["angels-stone-crushed-dissolution"].icons = angelsmods.functions.create_liquid_recipe_icon(
    nil,
    { { 142, 079, 028 }, { 107, 062, 021 }, { 075, 040, 015 } },
    { "stone" }
  )
end

-- Recipe gets changed by bobwarfare to include coal which is unobtainable
bobmods.lib.recipe.set_ingredients("firearm-magazine", {{ type = "item", name = "iron-plate", amount = 4}}) --this function automatically clears previous ingredients

-- angelspetrochem changes petroleum-gas to angels-gas-methane
bobmods.lib.recipe.remove_ingredient("sct-t3-flash-fuel", "angels-gas-methane")

-- bobmods switched plastic-bar for steel-plate in 2.0
if settings.startup["bobmods-plates-batteryupdate"].value == true then
  bobmods.lib.recipe.replace_ingredient("battery", "steel-plate", "plastic-bar")
else
  bobmods.lib.recipe.replace_ingredient("battery", "iron-plate", "plastic-bar")
end
bobmods.lib.tech.add_prerequisite("battery", "plastics")

if (mods["blueprint-shotgun"]) then
  seablock.lib.unhide_recipe("shotgun")
  seablock.lib.unhide_recipe("shotgun-shell")

  seablock.lib.unhide("gun", "shotgun")
  seablock.lib.unhide("ammo", "shotgun-shell")

  bobmods.lib.tech.add_recipe_unlock("military", "shotgun")
  bobmods.lib.tech.add_recipe_unlock("military", "shotgun-shell")
end

-- bob-alien-x-alloy is hidden by Sea Block
bobmods.lib.recipe.replace_ingredient("bob-fission-reactor-equipment-4", "bob-alien-blue-alloy", "bob-cobalt-steel-alloy")
bobmods.lib.recipe.replace_ingredient("bob-fission-reactor-equipment-4", "bob-alien-fire", "angels-liquid-naphtha")

bobmods.lib.recipe.replace_ingredient("bob-exoskeleton-equipment-3", "bob-alien-blue-alloy", "bob-cobalt-steel-alloy")

bobmods.lib.recipe.replace_ingredient("bob-personal-laser-defense-equipment-6", "bob-alien-blue-alloy", "bob-cobalt-steel-alloy")
bobmods.lib.recipe.replace_ingredient("bob-personal-laser-defense-equipment-6", "bob-alien-orange-alloy", "bob-gold-plate")
bobmods.lib.recipe.replace_ingredient("bob-personal-laser-defense-equipment-6", "bob-alien-poison", "angels-liquid-nitric-acid")

-- No longer needed for rockets
bobmods.lib.recipe.hide("bob-rocket-engine")
bobmods.lib.item.hide("bob-rocket-engine")