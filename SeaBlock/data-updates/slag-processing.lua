local lib = require "lib"

-- Decrease amount of crushed stone for slag-slurry so it's still better than mineralized water crystallization
lib.substingredient('stone-crushed-dissolution', 'stone-crushed', nil, 20)

-- Angels sludge crystalization usually gives normal smeltable ores. This would be far too easy,
-- so change recipes to give the weird ores that need extra processing steps.
for i = 1,6 do
  local recipe = data.raw.recipe["slag-processing-" .. i]
  lib.copy_icon(recipe, {})
  recipe.localised_name = {"recipe-name.slag-processing", {"item-name.angels-ore" .. i}}
  recipe.order = "a-a [angels-ore-" .. i .. "]"

  recipe.ingredients = nil
  recipe.results = nil
  recipe.energy_required = nil

  recipe.normal = {
    energy_required = 4,
    ingredients = {{ type="fluid", name = 'mineral-sludge', amount = 25 }},
    results = {{type = "item", name = "angels-ore" .. i, amount = 1 }},
    enabled = false
  }

  recipe.expensive = {
    energy_required = 8,
    ingredients = {{ type="fluid", name = 'mineral-sludge', amount = 50 }},
    results = {{type = "item", name = "angels-ore" .. i, amount = 1 }},
    enabled = false
  }
end

-- Angels ores 1, 3 (Saphirite, Stiratite) available from the start,
-- Angels ores 5, 6 (Rubyte, Bobmonium) available from Slag processing 1
-- Angels ores 2, 4 (Jivolite, Crotinnium) available from Advanced mechanical refining
lib.moveeffect('catalysator-brown', 'slag-processing-1', 'advanced-ore-refining-1', 3)
local slag1start = lib.findeffectidx(data.raw.technology['slag-processing-1'].effects, 'slag-processing-1')
lib.moveeffect('slag-processing-5', 'slag-processing-2', 'slag-processing-1', slag1start + 3)
lib.moveeffect('slag-processing-6', 'slag-processing-2', 'slag-processing-1', slag1start + 4)
lib.add_recipe_unlock('slag-processing-1', 'angelsore5-crushed', slag1start + 5)
lib.add_recipe_unlock('slag-processing-1', 'angelsore6-crushed', slag1start + 6)
lib.add_recipe_unlock('slag-processing-1', 'angelsore5-crushed-smelting', slag1start + 7)
lib.add_recipe_unlock('slag-processing-1', 'angelsore6-crushed-smelting', slag1start + 8)

local slag2start = 0
lib.moveeffect('slag-processing-2', 'slag-processing-1', 'ore-advanced-crushing', slag2start + 1)
lib.moveeffect('slag-processing-4', 'slag-processing-2', 'ore-advanced-crushing', slag2start + 2)
lib.moveeffect('angelsore2-crushed', 'ore-crushing', 'ore-advanced-crushing', slag2start + 3)
lib.moveeffect('angelsore4-crushed', 'ore-crushing', 'ore-advanced-crushing', slag2start + 4)
lib.moveeffect('angelsore2-crushed-processing', 'ore-crushing', 'ore-advanced-crushing', slag2start + 7)
lib.moveeffect('angelsore4-crushed-processing', 'ore-crushing', 'ore-advanced-crushing', slag2start + 8)

lib.add_recipe_unlock('ore-crushing', 'iron-plate')
lib.add_recipe_unlock('ore-crushing', 'copper-plate')
lib.add_recipe_unlock('ore-crushing', 'lead-plate')
lib.add_recipe_unlock('ore-crushing', 'tin-plate')

-- Hide unwanted recipes
lib.remove_recipe('quartz-glass')
lib.remove_recipe('silver-plate')

-- Add prerequisites
bobmods.lib.tech.add_prerequisite('ore-floatation', 'ore-advanced-crushing')
bobmods.lib.tech.add_prerequisite('advanced-ore-refining-1', 'ore-advanced-crushing')
bobmods.lib.tech.add_prerequisite('angels-metallurgy-1', 'ore-crushing')

-- Move Mechanical Refining under Slag Processing 1
lib.moveeffect('ore-crusher', 'ore-crushing', 'automation')
bobmods.lib.tech.remove_prerequisite('slag-processing-1', 'ore-crushing')
bobmods.lib.tech.replace_prerequisite('ore-crushing', 'automation', 'slag-processing-1')

-- Move crystallization ore recipes up above crushed ores
data.raw['item-subgroup']['slag-processing-1'].order = "ab"

-- Copy Ore Processing Machine tech icon to Mechanical Refining
lib.copy_icon(data.raw.technology['ore-crushing'], data.raw.technology['advanced-ore-refining-1'])

-- Red science level research for slag processing 1
data.raw.technology['slag-processing-1'].unit = {
  count = 20,
  ingredients = {{'automation-science-pack', 1}},
  time = 15
}
