-- Decrease amount of crushed stone for slag-slurry so it's still better than mineralized water crystallization
seablock.lib.substingredient("angels-stone-crushed-dissolution", "angels-stone-crushed", nil, 20)

-- Angels sludge crystalization usually gives normal smeltable ores. This would be far too easy,
-- so change recipes to give the weird ores that need extra processing steps.
for i = 1, 6 do
  local recipe = data.raw.recipe["angels-slag-processing-" .. i]
  seablock.lib.copy_icon(recipe, {})
  recipe.localised_name = { "recipe-name.slag-processing", { "item-name.angels-ore" .. i } }
  recipe.order = "a-a [angels-ore-" .. i .. "]"

  recipe.category = "angels-crystallizing"
  recipe.energy_required = 4
  recipe.ingredients = { { type = "fluid", name = "angels-mineral-sludge", amount = 25 } }
  recipe.results = { { type = "item", name = "angels-ore" .. i, amount = 1 } }
  recipe.enabled = false
  
end

-- Angels ores 1, 3 (Saphirite, Stiratite) available from tutorial tech 1,
-- Angels ores 5, 6 (Rubyte, Bobmonium) available from Slag processing 1
-- Angels ores 2, 4 (Jivolite, Crotinnium) available from Advanced mechanical refining
bobmods.lib.recipe.enabled("angels-ore1-crushed-smelting", false)
bobmods.lib.recipe.enabled("angels-ore3-crushed-smelting", false)
seablock.lib.moveeffect("angels-catalysator-brown", "angels-slag-processing-1", "angels-advanced-ore-refining-1", 3)
local slag1start = seablock.lib.findeffectidx(data.raw.technology["angels-slag-processing-1"].effects, "angels-slag-processing-1")
seablock.lib.moveeffect("angels-slag-processing-5", "angels-slag-processing-2", "angels-slag-processing-1", slag1start + 3)
seablock.lib.moveeffect("angels-slag-processing-6", "angels-slag-processing-2", "angels-slag-processing-1", slag1start + 4)

local slag2start = 0
seablock.lib.moveeffect("angels-slag-processing-2", "angels-slag-processing-1", "angels-ore-advanced-crushing", slag2start + 1)
seablock.lib.moveeffect("angels-slag-processing-4", "angels-slag-processing-2", "angels-ore-advanced-crushing", slag2start + 2)
seablock.lib.moveeffect("angels-ore2-crushed", "angels-ore-crushing", "angels-ore-advanced-crushing", slag2start + 3)
seablock.lib.moveeffect("angels-ore4-crushed", "angels-ore-crushing", "angels-ore-advanced-crushing", slag2start + 4)


seablock.lib.add_recipe_unlock("angels-ore-crushing", "angels-ore5-crushed", 3)
seablock.lib.add_recipe_unlock("angels-ore-crushing", "angels-ore6-crushed", 4)
seablock.lib.add_recipe_unlock("angels-ore-crushing", "iron-plate")
seablock.lib.add_recipe_unlock("angels-ore-crushing", "copper-plate")
seablock.lib.add_recipe_unlock("angels-ore-crushing", "bob-lead-plate")
seablock.lib.add_recipe_unlock("angels-ore-crushing", "bob-tin-plate")
seablock.lib.add_recipe_unlock("angels-ore-crushing", "bob-glass")

seablock.lib.unhide_recipe("iron-plate")
seablock.lib.unhide_recipe("copper-plate")
seablock.lib.unhide_recipe("bob-lead-plate")
seablock.lib.unhide_recipe("bob-tin-plate")

-- Hide unwanted recipes
bobmods.lib.recipe.hide("bob-silver-plate")
bobmods.lib.tech.remove_recipe_unlock("angels-ore-crushing", "angels-ore2-crushed-processing")
bobmods.lib.tech.remove_recipe_unlock("angels-ore-crushing", "angels-ore4-crushed-processing")
bobmods.lib.recipe.hide("angels-ore2-crushed-processing")
bobmods.lib.recipe.hide("angels-ore4-crushed-processing")
bobmods.lib.recipe.hide("angels-ore5-crushed-smelting")
bobmods.lib.recipe.hide("angels-ore6-crushed-smelting")

-- Add prerequisites
bobmods.lib.tech.add_prerequisite("angels-ore-floatation", "angels-ore-advanced-crushing")
bobmods.lib.tech.add_prerequisite("angels-advanced-ore-refining-1", "angels-ore-advanced-crushing")

-- Move Mechanical Refining under Slag Processing 1
seablock.lib.moveeffect("angels-ore-crusher", "angels-ore-crushing", "automation")
bobmods.lib.tech.remove_prerequisite("angels-slag-processing-1", "angels-ore-crushing")
bobmods.lib.tech.remove_prerequisite("angels-slag-processing-1", "logistic-science-pack")
bobmods.lib.tech.remove_prerequisite("angels-ore-crushing", "angels-basic-chemistry")
bobmods.lib.tech.add_prerequisite("angels-ore-crushing", "angels-slag-processing-1")

-- Move crystallization ore recipes up above crushed ores
data.raw["item-subgroup"]["angels-slag-processing-1"].order = "ab"

-- Red science level research for slag processing 1
data.raw.technology["angels-slag-processing-1"].unit = {
  count = 20,
  ingredients = { { "automation-science-pack", 1 } },
  time = 15,
}

bobmods.lib.tech.add_prerequisite("angels-advanced-ore-refining-2", "angels-ore-powderizer")
bobmods.lib.tech.add_prerequisite("angels-advanced-ore-refining-2", "advanced-circuit")
bobmods.lib.tech.add_prerequisite("angels-advanced-ore-refining-4", "bob-advanced-processing-unit")
bobmods.lib.tech.add_prerequisite("angels-advanced-ore-refining-4", "angels-tungsten-smelting-1")

-- Add an additional slag to the mixed sorting recipes
for _, v in pairs({
  -- Saphirite
  "angels-ore1-crushed-processing",
  "angels-ore1-chunk-processing",
  "angels-ore1-crystal-processing",
  -- Jivolite
  "angels-ore2-chunk-processing",
  "angels-ore2-crystal-processing",
  -- Stiratite
  "angels-ore3-crushed-processing",
  "angels-ore3-chunk-processing",
  "angels-ore3-crystal-processing",
  -- Crotinnium
  "angels-ore4-chunk-processing",
  "angels-ore4-crystal-processing",
  -- Rubyte
  "angels-ore5-crushed-processing",
  "angels-ore5-chunk-processing",
  "angels-ore5-crystal-processing",
  -- Bobmonium
  "angels-ore6-crushed-processing",
  "angels-ore6-chunk-processing",
  "angels-ore6-crystal-processing",
}) do
  seablock.lib.substresult(v, "angels-slag", nil, 2)
end

-- Change the recipe icon for Dirt water electrolysis to show slag icon
data.raw.recipe["angels-dirt-water-separation"].icons = angelsmods.functions.add_number_icon_layer(
  angelsmods.functions.get_object_icons("angels-slag"),
  1,
  angelsmods.petrochem.number_tint
)
data.raw.recipe["angels-dirt-water-separation-2"].icons = angelsmods.functions.add_number_icon_layer(
  angelsmods.functions.get_object_icons("angels-slag"),
  2,
  angelsmods.petrochem.number_tint
)

-- Move Ferrous & Cupric concentrate anodizing recipes from Electrowinning cell to Electrolyser 4
table.insert(data.raw["assembling-machine"]["angels-electrolyser-4"].crafting_categories, "sb-petrochem-electrolyser-4")
bobmods.lib.recipe.set_category("angels-ore8-anode-sludge", "sb-petrochem-electrolyser-4")
bobmods.lib.recipe.set_category("angels-ore9-anode-sludge", "sb-petrochem-electrolyser-4")
bobmods.lib.tech.add_prerequisite("angels-ore-electro-whinning-cell", "angels-advanced-chemistry-3")
