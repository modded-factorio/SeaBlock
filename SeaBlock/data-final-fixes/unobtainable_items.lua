-- Rename internal item names to keep mods like FNEI searching properly
local itemrename = {
  ["angels-solid-coke"] = "angels-wood-charcoal",
  ["angels-filter-coal"] = "angels-filter-charcoal",
  ["angels-pellet-coke"] = "angels-pellet-charcoal",
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
  -- if recipe.result and itemrename[recipe.result] then
  --   recipe.result = itemrename[recipe.result]
  -- end
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
  "bob-alien-artifact-blue",
  "bob-alien-artifact-green",
  "bob-alien-artifact-orange",
  "bob-alien-artifact-purple",
  "bob-alien-artifact-red",
  "bob-alien-artifact-yellow",
  "angels-chemical-void-angels-gas-natural-1",
  "angels-chemical-void-angels-liquid-condensates",
  "angels-water-void-crystal-matrix", -- TODO: are those two already removed ?
  --"angels-water-void-bob-lithia-water",
  "angels-ore1-crushed-hand",
  "angels-ore3-crushed-hand",
  "big-burner-generator",
  "angels-bio-tile",
  "bob-carbon-from-wood",
  "bob-resin-wood",
  "burner-generator",
  "burner-mining-drill",
  "angels-carbon-from-charcoal",
  "angels-coal-cracking-1",
  "angels-coal-cracking-2",
  "angels-coal-cracking-3",
  "angels-coal-crushed",
  "angels-condensates-oil-refining",
  "angels-condensates-refining",
  "diesel-fuel",
  "electric-mining-drill",
  "empty-crystal-matrix-barrel", -- TODO: where does this item come from ? 
  "empty-diesel-fuel-barrel",
  "empty-angels-gas-natural-1-barrel",
  "empty-angels-liquid-condensates-barrel",
  "empty-bob-lithia-water-barrel",
  "crystal-matrix-barrel",
  "diesel-fuel-barrel",
  "angels-gas-natural-1-barrel",
  "angels-liquid-condensates-barrel",
  "bob-lithia-water-barrel",
  "angels-gas-fractioning-condensates",
  "gas-phosgene",
  "angels-gas-separation",
  "oil-steam-boiler",
  "petroleum-generator",
  "protection-field-goopless", --comes from spacemod
  "pumpjack",
  "angels-slag-processing-7",
  "angels-slag-processing-8",
  "angels-slag-processing-9",
  "angels-solid-coke",
  "angels-solid-coke-sulfur",
  "angels-thermal-water-filtering-1",
  "angels-thermal-water-filtering-2",
  "water-thermal-lithia", -- TODO: where does this come from ? 
  "angels-wood-charcoal",
}) do
  removerecipes[v] = true
end

-- Items to remove. Recipes are checked to ensure these can't be crafted,
-- then any recipe that uses an unobtainable item is removed
local unobtainable = {}
for _, v in ipairs({
  "big-burner-generator",
  "angels-bio-tile",
  "burner-generator",
  "burner-mining-drill",
  "coal",
  "angels-coal-crushed",
  "diesel-fuel",
  "diesel-fuel-barrel",
  "electric-mining-drill",
  "angels-gas-natural-1",
  "angels-gas-natural-1-barrel",
  "gas-phosgene", -- TODO: what happened to those items ? I can't find them in angels/bob/ks power 
  "gas-phosgene-barrel",
  "angels-liquid-condensates",
  "angels-liquid-condensates-barrel",
  "bob-lithia-water",
  "bob-lithia-water-barrel",
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
if data.raw.lab["bob-lab-alien"] then
  data.raw.lab["bob-lab-alien"].inputs = {}
end

-- We now need a dummy lab that can take all the science packs or else some techs can't load (even if hidden), (we could also use "bob-lab-alien" which is hidden in data-updates/military.lua)
local dummyLab = table.deepcopy(data.raw.lab["lab"])
dummyLab.name = "dummy-lab"
dummyLab.hidden = true
--dummyLab.hidden_in_factoriopedia = true
bobmods.lib.safe_insert(dummyLab.inputs, "space-science-pack")
if data.raw.tool["sct-bio-science-pack"] then
  bobmods.lib.safe_insert(dummyLab.inputs, "sct-bio-science-pack")
end
bobmods.lib.safe_insert(dummyLab.inputs, "automation-science-pack")
bobmods.lib.safe_insert(dummyLab.inputs, "logistic-science-pack")
bobmods.lib.safe_insert(dummyLab.inputs, "chemical-science-pack")
bobmods.lib.safe_insert(dummyLab.inputs, "production-science-pack")
bobmods.lib.safe_insert(dummyLab.inputs, "utility-science-pack")

if mods["bobtech"] then
  bobmods.lib.safe_insert(dummyLab.inputs, "bob-science-pack-gold")
  bobmods.lib.safe_insert(dummyLab.inputs, "bob-alien-science-pack-purple")
  bobmods.lib.safe_insert(dummyLab.inputs, "bob-alien-science-pack-blue")
  bobmods.lib.safe_insert(dummyLab.inputs, "bob-alien-science-pack-red")
  bobmods.lib.safe_insert(dummyLab.inputs, "bob-alien-science-pack-green")
  bobmods.lib.safe_insert(dummyLab.inputs, "bob-alien-science-pack-orange")
  bobmods.lib.safe_insert(dummyLab.inputs, "bob-alien-science-pack-yellow")
  bobmods.lib.safe_insert(dummyLab.inputs, "bob-alien-science-pack")
end
data:extend({dummyLab})