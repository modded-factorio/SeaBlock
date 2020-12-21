local lib = require "lib"

-- Decrease amount of crushed stone for slag-slurry so it's still better than mineralized water crystallization
lib.substingredient('stone-crushed-dissolution', 'stone-crushed', nil, 20)

-- Angels sludge crystalization usually gives normal smeltable ores. This would be far too easy,
-- so change recipes to give the weird ores that need extra processing steps.
for i = 1,6 do
  local recipe = data.raw.recipe["slag-processing-" .. i]
  recipe.icon = nil
  recipe.icons = nil
  recipe.icon_size = nil
  recipe.icon_mipmaps = nil
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

-- Want angels ores 1,3,5,6 (Saphirite, Stiratite, Rubyte, Bobmonium) available from the start,
-- so shuffle crystallization recipe unlocks around
local slag1start = lib.findeffectidx(data.raw.technology['slag-processing-1'].effects, 'slag-processing-1')
local slag2start = 0

-- move ore2 to slag-processing-2
lib.moveeffect('slag-processing-2', 'slag-processing-1', 'ore-advanced-crushing', slag2start + 1)
-- move ore5 to slag-processing-1
lib.moveeffect('slag-processing-5', 'slag-processing-2', 'slag-processing-1', slag1start + 2)
-- move ore6 to slag-processing-1
lib.moveeffect('slag-processing-6', 'slag-processing-2', 'slag-processing-1', slag1start + 3)
lib.moveeffect('slag-processing-4', 'slag-processing-2', 'ore-advanced-crushing', slag2start + 2)

-- Move crystallization ore recipes up above crushed ores
data.raw['item-subgroup']['slag-processing-1'].order = "ab"

-- Red science level research for slag processing 1
data.raw.technology['slag-processing-1'].unit = {
  count = 20,
  ingredients = {{'automation-science-pack', 1}},
  time = 15
}
