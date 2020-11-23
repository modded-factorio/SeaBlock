local lib = require("lib")

-- Adjust resin production amount to how it was in petrochem 0.7.9.
-- TODO: Revisit this after Angel adds more liquid rubber recipes
lib.substresult('liquid-rubber-1', 'liquid-rubber', nil, 20)

-- Reset solid-resin recipe icon to remove the II stamp
data.raw.recipe['solid-resin'].icon = nil
data.raw.recipe['solid-resin'].icons = nil

-- Rename internal item names to keep mods like FNEI searching properly
local itemrename =
{
  ['solid-coke'] = 'wood-charcoal',
  ['filter-coal'] = 'filter-charcoal',
  ['pellet-coke'] = 'pellet-charcoal'
}

for k,v in pairs(itemrename) do
  local item = data.raw.item[k]
  data.raw.item[k] = nil
  item.name = v
  if not data.raw.item[v] then
    data.raw.item[v] = item
  end
end
local function updateline(line)
  local nameidx = 'name'
  if line[nameidx] == nil then
    nameidx = 1
  end
  local item = line[nameidx]
  if itemrename[item] then
    line[nameidx] = itemrename[item]
  end
end
local function updaterecipe(recipe)
  for _,v in pairs(recipe.ingredients) do
    updateline(v)
  end
  if recipe.result and itemrename[recipe.result] then
    recipe.result = itemrename[recipe.result]
  end
  for _,v in pairs(recipe.results or {}) do
    updateline(v)
  end
end
for _,v in pairs(data.raw.recipe) do
  lib.iteraterecipes(v, updaterecipe)
end

-- Recipes to unconditionally remove
local removerecipes = {}
for _,v in ipairs({
  'bob-resin-wood',
  'burner-mining-drill',
  --'electric-mining-drill',
  'slag-processing-nuc',
  'alien-artifact-red-from-basic',
  'alien-artifact-orange-from-basic',
  'alien-artifact-yellow-from-basic',
  'alien-artifact-green-from-basic',
  'alien-artifact-blue-from-basic',
  'alien-artifact-purple-from-basic',
  'bob-distillery',
  'water-thermal-lithia',
  'thermal-water-filtering-1',
  'thermal-water-filtering-2',
  'circuit-paper-board', -- currently useless
  'protection-field-goopless',
  'slag-processing-7',
  'slag-processing-8',
  'slag-processing-9'
}) do
  removerecipes[v] = true
end

-- Items to remove. Recipes are checked to ensure these can't be crafted,
-- then any recipe that uses an unobtainable item is removed
local unobtainable = {}
for _,v in ipairs({
  --'raw-wood',
  --'solid-oil-residual',
  'coal',
  'coal-crushed',
  'circuit-wood-fiber-board',

  --'gas-acid',
  --'angels-barrel-gas-acid',
  --'gas-acid-barrel',

  --'gas-raw-1',
  --'angels-barrel-gas-raw-1',
  --'gas-raw-1-barrel',

  'liquid-condensates',
  'angels-barrel-liquid-condensates',
  'liquid-condensates-barrel',

  'gas-natural-1',
  'angels-barrel-gas-natural-1',
  'gas-natural-1-barrel',

  'lithia-water',
  'angels-barrel-lithia-water',
  'lithia-water-barrel'
}) do
  unobtainable[v] = {}
end

-- unobtainable[key] -> { { a, and b, and .. }, or { c, ... } or, { d, and e, and f, ...}... }
-- a,b,c... are items which if craftable imply key is also craftable and should not be removed
local recipes = {}
for k,v in pairs(data.raw.recipe) do
  if (v.enabled == true or v.enabled == nil) and not removerecipes[k] then
    recipes[k] = v
  end
end

-- Only scan recipes which are researchable
for k,v in pairs(data.raw.technology) do
  if v.effects and (v.enabled == nil or v.enabled == true) then
    for _,effect in pairs(v.effects) do
      if effect.type == "unlock-recipe" and not removerecipes[effect.recipe] then
        recipes[effect.recipe] = data.raw.recipe[effect.recipe]
      end
    end
  end
end

for k,v in pairs(recipes) do
  local iset = {}
  if v.normal then
    iset = {v.normal, v.expensive}
  else
    iset = {v}
  end
  for _, recipe in ipairs(iset) do
    local items = {}
    --local allitemsdbg = {}
    for _, ingredient in pairs(recipe.ingredients) do
      local item = ingredient[1] or ingredient.name
      if unobtainable[item] then
        items[item] = true
      end
      --allitemsdbg[item] = true
    end
    local results = {}
    if recipe.result then
      results = { recipe.result }
    elseif recipe.results then
      for _,w in pairs(recipe.results) do
        table.insert(results, w.name)
      end
    end
  --[[
  if k == 'empty-lithia-water-barrel' then
    print ("recipe " .. k)
    for a,_ in pairs(allitemsdbg) do
      print("  ingredient " .. a)
    end
    for _,a in pairs(results) do
      print(" result " .. a)
    end
  end
  ]]--
    if next(items) ~= nil then
      for _,r in pairs(results) do
        if unobtainable[r] ~= nil then
          table.insert(unobtainable[r], table.deepcopy(items))
        end
      end
    else
      for _,r in pairs(results) do
        if unobtainable[r] then
          --print(" item " .. r .. " obtainable from recipe " .. k)
        end
        unobtainable[r] = nil
      end
    end
  end
end

local work = true
while work do
  work = false
  for item,inputs in pairs(unobtainable) do
    for _, inputarray in pairs(inputs) do
      for input, _  in pairs(inputarray) do
        if unobtainable[input] == nil then -- Input is obtainable
	  inputarray[input] = nil
	  if next(inputarray) == nil then
            --print (" item " .. item .. " obtainable via item " .. input)
	    unobtainable[item] = nil
	    work = true
	  end
	end
      end
    end
  end
end

-- Add hidden flag to disabled items so they don't show up in circuit menu/item filter/FNEI etc.
for k,v in pairs(unobtainable) do
  local item = data.raw.item[k]
  if not item then
    item = data.raw.fluid[k]
  end
  if item then
    if not item.flags then
      item.flags = {}
    end
    if not lib.tablefind(item.flags, "hidden") then
      table.insert(item.flags, "hidden")
    end
  else
    --print("no item " .. k)
  end
end

-- Remove any recipe that uses an unobtainable ingredient
local function keeprecipe(r)
  local iset = {}
  local count = 0
  table.insert(iset, r.ingredients)
  table.insert(iset, (r.normal or {}).ingredients)
  table.insert(iset, (r.expensive or {}).ingredients)
  for _, ingredients in ipairs(iset) do
    for _,v in ipairs(ingredients) do
      local ingredient = v[1] or v.name
      if ingredient and unobtainable[ingredient] then
        count = count + 1
	break
      end
    end
  end
  return count < #iset
end

for k,v in pairs(data.raw.recipe) do
  if not keeprecipe(v) then
    --print("remove recipe " .. k)
    removerecipes[k] = true
  end
end

for k,v in pairs(removerecipes) do
  local recipe = data.raw.recipe[k]
  if recipe then
    if recipe.normal then
      recipe.normal.enabled = false
      recipe.expensive.enabled = false
    else
      recipe.enabled = false
    end
  end
end

-- Remove disabled recipes from technology unlock
for k,v in pairs(data.raw.technology) do
  if v.effects then
    local neweffects = {}
    for _,e in pairs(v.effects) do
      if e.type ~= "unlock-recipe" or not removerecipes[e.recipe] then
        table.insert(neweffects, e)
      end
    end
    v.effects = neweffects
  end
end

-- No resource placement
for k,v in pairs(data.raw.resource) do
  v.autoplace = nil
end
-- No spawners
for k,v in pairs(data.raw["unit-spawner"]) do
  v.autoplace = nil
  v.control = nil
end
-- No trees
for k,v in pairs(data.raw.tree) do
  if k ~= 'temperate-garden' and k ~= 'desert-garden' and k ~= 'swamp-garden' and
    k ~= 'temperate-tree' and k ~= 'desert-tree' and k ~= 'swamp-tree' and
    k ~= 'puffer-nest' then
    v.autoplace = nil
  end
end
-- No rocks
for k,v in pairs(data.raw["simple-entity"]) do
  v.autoplace = nil
end

local keepcontrols = {}
for _,v in pairs(data.raw) do
  for _,v2 in pairs(v) do
    if v2.autoplace and v2.autoplace.control then
      keepcontrols[v2.autoplace.control] = true
    end
  end
end
local controls = data.raw['autoplace-control']
for k,v in pairs(controls) do
  if k ~= "enemy-base" and not keepcontrols[k] then
    controls[k] = nil
  end
end

data.raw['map-gen-presets']['default']['death-world'] = nil
data.raw['map-gen-presets']['default']['death-world-marathon'] = nil
data.raw['map-gen-presets']['default']['rail-world'] = nil
data.raw['map-gen-presets']['default']['rich-resources'] = nil
data.raw['map-gen-presets']['default']['ribbon-world'] = nil
data.raw['map-gen-presets']['default']['island'] = nil

-- Spacemod updates
require "SpaceMod-updates"
