-- Rename internal item names to keep mods like FNEI searching properly
local itemrename = {
  ["solid-coke"] = "wood-charcoal",
  ["filter-coal"] = "filter-charcoal",
  ["pellet-coke"] = "pellet-charcoal",
}

for k, v in pairs(itemrename) do
  local item = data.raw.item[k]
  data.raw.item[k] = nil
  item.name = v
  if not data.raw.item[v] then
    data.raw.item[v] = item
  end
end
local function updateline(line)
  local nameidx = "name"
  if line[nameidx] == nil then
    nameidx = 1
  end
  local item = line[nameidx]
  if itemrename[item] then
    line[nameidx] = itemrename[item]
  end
end
local function updaterecipe(recipe)
  for _, v in pairs(recipe.ingredients) do
    updateline(v)
  end
  if recipe.result and itemrename[recipe.result] then
    recipe.result = itemrename[recipe.result]
  end
  for _, v in pairs(recipe.results or {}) do
    updateline(v)
  end
end
for _, v in pairs(data.raw.recipe) do
  seablock.lib.iteraterecipes(v, updaterecipe)
end

-- Recipes to unconditionally remove
local removerecipes = {}
for _, v in ipairs({
  "alien-artifact-blue-from-basic",
  "alien-artifact-green-from-basic",
  "alien-artifact-orange-from-basic",
  "alien-artifact-purple-from-basic",
  "alien-artifact-red-from-basic",
  "alien-artifact-yellow-from-basic",
  "angels-chemical-void-gas-natural-1",
  "angels-chemical-void-liquid-condensates",
  "angels-water-void-crystal-matrix",
  "angels-water-void-lithia-water",
  "angelsore1-crushed-hand",
  "angelsore3-crushed-hand",
  "big-burner-generator",
  "bio-tile",
  "bob-coal-from-wood",
  "bob-resin-wood",
  "burner-generator",
  "burner-mining-drill",
  "carbon-from-charcoal",
  "coal-cracking-1",
  "coal-cracking-2",
  "coal-cracking-3",
  "coal-crushed",
  "condensates-oil-refining",
  "condensates-refining",
  "diesel-fuel",
  "electric-mining-drill",
  "empty-crystal-matrix-barrel",
  "empty-diesel-fuel-barrel",
  "empty-gas-natural-1-barrel",
  "empty-liquid-condensates-barrel",
  "empty-lithia-water-barrel",
  "fill-crystal-matrix-barrel",
  "fill-diesel-fuel-barrel",
  "fill-gas-natural-1-barrel",
  "fill-liquid-condensates-barrel",
  "fill-lithia-water-barrel",
  "gas-fractioning-condensates",
  "gas-phosgene",
  "gas-separation",
  "oil-steam-boiler",
  "petroleum-generator",
  "protection-field-goopless",
  "pumpjack",
  "slag-processing-7",
  "slag-processing-8",
  "slag-processing-9",
  "solid-coke",
  "solid-coke-sulfur",
  "thermal-water-filtering-1",
  "thermal-water-filtering-2",
  "water-thermal-lithia",
  "wood-charcoal",
}) do
  removerecipes[v] = true
end

-- Items to remove. Recipes are checked to ensure these can't be crafted,
-- then any recipe that uses an unobtainable item is removed
local unobtainable = {}
for _, v in ipairs({
  "big-burner-generator",
  "bio-tile",
  "burner-generator",
  "burner-mining-drill",
  "coal",
  "coal-crushed",
  "diesel-fuel",
  "diesel-fuel-barrel",
  "electric-mining-drill",
  "gas-natural-1",
  "gas-natural-1-barrel",
  "gas-phosgene",
  "gas-phosgene-barrel",
  "liquid-condensates",
  "liquid-condensates-barrel",
  "lithia-water",
  "lithia-water-barrel",
  "oil-steam-boiler",
  "petroleum-generator",
  "pumpjack",
}) do
  unobtainable[v] = {}
end

-- unobtainable[key] -> { { a, and b, and .. }, or { c, ... } or, { d, and e, and f, ...}... }
-- a,b,c... are items which if craftable imply key is also craftable and should not be removed
local recipes = {}
for k, v in pairs(data.raw.recipe) do
  if (v.enabled == true or v.enabled == nil) and not removerecipes[k] then
    recipes[k] = v
  end
end

-- Only scan recipes which are researchable
for k, v in pairs(data.raw.technology) do
  if v.effects and (v.enabled == nil or v.enabled == true) then
    for _, effect in pairs(v.effects) do
      if effect.type == "unlock-recipe" and not removerecipes[effect.recipe] then
        recipes[effect.recipe] = data.raw.recipe[effect.recipe]
      end
    end
  end
end

for k, v in pairs(recipes) do
  local iset = {}
  if v.normal then
    iset = { v.normal, v.expensive }
  else
    iset = { v }
  end
  for _, recipe in ipairs(iset) do
    local items = {}
    if recipe.ingredients then
      for _, ingredient in pairs(recipe.ingredients) do
        local item = ingredient[1] or ingredient.name
        if unobtainable[item] then
          items[item] = true
        end
      end
    end
    local results = {}
    if recipe.result then
      results = { recipe.result }
    elseif recipe.results then
      for _, w in pairs(recipe.results) do
        table.insert(results, w.name)
      end
    end
    if next(items) ~= nil then
      for _, r in pairs(results) do
        if unobtainable[r] ~= nil then
          table.insert(unobtainable[r], table.deepcopy(items))
        end
      end
    else
      for _, r in pairs(results) do
        unobtainable[r] = nil
      end
    end
  end
end

local work = true
while work do
  work = false
  for item, inputs in pairs(unobtainable) do
    for _, inputarray in pairs(inputs) do
      for input, _ in pairs(inputarray) do
        if unobtainable[input] == nil then -- Input is obtainable
          inputarray[input] = nil
          if next(inputarray) == nil then
            unobtainable[item] = nil
            work = true
          end
        end
      end
    end
  end
end

-- Add hidden flag to disabled items so they don't show up in circuit menu/item filter/FNEI etc.
for k, _ in pairs(unobtainable) do
  seablock.lib.hide_item(k)
end

-- Remove any recipe that uses an unobtainable ingredient
local function keeprecipe(r)
  local iset = {}
  local count = 0
  table.insert(iset, r.ingredients)
  table.insert(iset, (r.normal or {}).ingredients)
  table.insert(iset, (r.expensive or {}).ingredients)
  for _, ingredients in ipairs(iset) do
    for _, v in ipairs(ingredients) do
      local ingredient = v[1] or v.name
      if ingredient and unobtainable[ingredient] then
        count = count + 1
        break
      end
    end
  end
  return count < #iset
end

for k, v in pairs(data.raw.recipe) do
  if not keeprecipe(v) then
    removerecipes[k] = true
  end
end

for k, _ in pairs(removerecipes) do
  bobmods.lib.recipe.hide(k)
end

-- Remove disabled recipes from technology unlock
for k, v in pairs(data.raw.technology) do
  if v.effects then
    local neweffects = {}
    for _, e in pairs(v.effects) do
      if e.type ~= "unlock-recipe" or not removerecipes[e.recipe] then
        table.insert(neweffects, e)
      end
    end
    v.effects = neweffects
  end
end

-- Clear the list of science packs that alien lab can take
-- This prevents YAFC warning
if data.raw.lab["lab-alien"] then
  data.raw.lab["lab-alien"].inputs = {}
end
