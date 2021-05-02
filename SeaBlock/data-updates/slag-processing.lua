-- Decrease amount of crushed stone for slag-slurry so it's still better than mineralized water crystallization
seablock.lib.substingredient('stone-crushed-dissolution', 'stone-crushed', nil, 20)

-- Angels sludge crystalization usually gives normal smeltable ores. This would be far too easy,
-- so change recipes to give the weird ores that need extra processing steps.
for i = 1,6 do
  local recipe = data.raw.recipe["slag-processing-" .. i]
  seablock.lib.copy_icon(recipe, {})
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

-- Angels ores 1, 3 (Saphirite, Stiratite) available from tutorial tech 1,
-- Angels ores 5, 6 (Rubyte, Bobmonium) available from Slag processing 1
-- Angels ores 2, 4 (Jivolite, Crotinnium) available from Advanced mechanical refining
bobmods.lib.recipe.enabled('angelsore1-crushed-smelting', false)
bobmods.lib.recipe.enabled('angelsore3-crushed-smelting', false)
seablock.lib.moveeffect('catalysator-brown', 'slag-processing-1', 'advanced-ore-refining-1', 3)
local slag1start = seablock.lib.findeffectidx(data.raw.technology['slag-processing-1'].effects, 'slag-processing-1')
seablock.lib.moveeffect('slag-processing-5', 'slag-processing-2', 'slag-processing-1', slag1start + 3)
seablock.lib.moveeffect('slag-processing-6', 'slag-processing-2', 'slag-processing-1', slag1start + 4)
seablock.lib.add_recipe_unlock('slag-processing-1', 'angelsore5-crushed', slag1start + 5)
seablock.lib.add_recipe_unlock('slag-processing-1', 'angelsore6-crushed', slag1start + 6)
seablock.lib.add_recipe_unlock('slag-processing-1', 'angelsore5-crushed-smelting', slag1start + 7)
seablock.lib.add_recipe_unlock('slag-processing-1', 'angelsore6-crushed-smelting', slag1start + 8)

local slag2start = 0
seablock.lib.moveeffect('slag-processing-2', 'slag-processing-1', 'ore-advanced-crushing', slag2start + 1)
seablock.lib.moveeffect('slag-processing-4', 'slag-processing-2', 'ore-advanced-crushing', slag2start + 2)
seablock.lib.moveeffect('angelsore2-crushed', 'ore-crushing', 'ore-advanced-crushing', slag2start + 3)
seablock.lib.moveeffect('angelsore4-crushed', 'ore-crushing', 'ore-advanced-crushing', slag2start + 4)

seablock.lib.add_recipe_unlock('ore-crushing', 'iron-plate')
seablock.lib.add_recipe_unlock('ore-crushing', 'copper-plate')
seablock.lib.add_recipe_unlock('ore-crushing', 'lead-plate')
seablock.lib.add_recipe_unlock('ore-crushing', 'tin-plate')

-- Hide unwanted recipes
seablock.lib.remove_recipe('quartz-glass')
seablock.lib.remove_recipe('silver-plate')
bobmods.lib.tech.remove_recipe_unlock('ore-crushing', 'angelsore2-crushed-processing')
bobmods.lib.tech.remove_recipe_unlock('ore-crushing', 'angelsore4-crushed-processing')
seablock.lib.remove_recipe('angelsore2-crushed-processing')
seablock.lib.remove_recipe('angelsore4-crushed-processing')

-- Add prerequisites
bobmods.lib.tech.add_prerequisite('ore-floatation', 'ore-advanced-crushing')
bobmods.lib.tech.add_prerequisite('advanced-ore-refining-1', 'ore-advanced-crushing')
bobmods.lib.tech.add_prerequisite('angels-metallurgy-1', 'ore-crushing')

-- Move Mechanical Refining under Slag Processing 1
seablock.lib.moveeffect('ore-crusher', 'ore-crushing', 'automation')
bobmods.lib.tech.remove_prerequisite('slag-processing-1', 'ore-crushing')
bobmods.lib.tech.replace_prerequisite('ore-crushing', 'automation', 'slag-processing-1')

-- Move crystallization ore recipes up above crushed ores
data.raw['item-subgroup']['slag-processing-1'].order = "ab"

-- Copy Ore Processing Machine tech icon to Mechanical Refining
seablock.lib.copy_icon(data.raw.technology['ore-crushing'], data.raw.technology['advanced-ore-refining-1'])

-- Red science level research for slag processing 1
data.raw.technology['slag-processing-1'].unit = {
  count = 20,
  ingredients = {{'automation-science-pack', 1}},
  time = 15
}
