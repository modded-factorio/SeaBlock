local lib = require "lib"

-- First stage:                    pipe  pipe-to-ground iron-gear iron-stick
-- Electrolyser  5 circuit board                                  20
-- Liquifier     5 circuit board         2
-- Flare stack   5 circuit board*2 10*2
-- Offshore pump 2 circuit board*2 1*2                  10*2
-- Crystallizer  5 circuit board                                             5 copper-pipe

-- Second stage:
-- Hydro plant   5 circuit board   5
-- Clarifier     5 circuit board                        5
-- Algae farm    5 circuit board                                  16

local knowningredients = {
['angels-electrolyser'] = {
  {'iron-plate', 10},
  {'basic-circuit-board', 5},
  {'iron-stick', 20},
  {'stone-brick', 10}
},
['liquifier'] = {
  {'iron-plate', 10},
  {'basic-circuit-board', 5},
  {'pipe-to-ground', 2},
  {'stone-brick', 10}
},
['offshore-pump'] = {
  {'basic-circuit-board', 2},
  {'pipe', 1},
  {'iron-gear-wheel', 10}
},
['crystallizer'] = {
  {'iron-plate', 10},
  {'basic-circuit-board', 5},
  {'copper-pipe', 5},
  {'stone-brick', 10}
},
['hydro-plant'] = {
  {'iron-plate', 10},
  {'basic-circuit-board', 5},
  {'pipe', 5},
  {'stone-brick', 10}
},
['algae-farm'] = {
  {'iron-plate', 10},
  {'basic-circuit-board', 5},
  {'iron-stick', 16},
  {'stone-brick', 25}
},
['angels-flare-stack'] = {
  {'iron-plate', 5},
  {'basic-circuit-board', 5},
  {'pipe', 10},
  {'stone-brick', 10}
},
['clarifier'] = {
  {'iron-plate', 10},
  {'basic-circuit-board', 5},
  {'iron-gear-wheel', 5},
  {'stone-brick', 10}
},
['seafloor-pump'] = {
  {'iron-plate', 5},
  {'basic-circuit-board', 2},
  {'pipe', 5}
},
['washing-plant'] = {
  {'iron-plate', 10},
  {'basic-circuit-board', 5},
  {'pipe', 10},
  {'stone-brick', 10}
},
['angels-chemical-plant'] = {
  {'iron-plate', 5},
  {'iron-gear-wheel', 5},
  {'basic-circuit-board', 5},
  {'pipe', 5}
},
['filtration-unit'] = {
  {'iron-plate', 5},
  {'basic-circuit-board', 5},
  {'pipe', 10},
  {'stone-brick', 10}
},
['filter-frame'] = {
  {'iron-plate', 1},
  {'iron-stick', 2}
},
['burner-ore-crusher'] = {
  {'stone', 5},
  {'stone-furnace', 1}
}
}

data.raw.recipe['angels-flare-stack'].enabled = true
data.raw.technology['angels-flare-stack'].enabled = false
for k,v in pairs(knowningredients) do
  local recipe = data.raw.recipe[k]
  for ek, ev in pairs(recipe.normal or {}) do
    recipe[ek] = ev
  end
  recipe.normal = nil
  recipe.expensive = nil
  recipe.ingredients = {}
  for _, line in pairs(v) do
    table.insert(recipe.ingredients, {type = 'item', name = line[1], amount = line[2]})
  end
end

-- unlock lab and optional components with bio-wood-processing
if data.raw.technology['sct-lab-t1'] then
  for k,v in pairs(data.raw.technology['sct-lab-t1'].effects) do
    table.insert(data.raw.technology['bio-wood-processing'].effects, v)
  end
  -- Remove empty SCT Lab tech
  data.raw.technology['sct-lab-t1'].effects = {}
  data.raw.technology['sct-lab-t1'].enabled = false
  data.raw.technology['sct-lab-t1'].hidden = true
else
  table.insert(data.raw.technology['bio-wood-processing'].effects, {type = "unlock-recipe", recipe = "lab"})
  if data.raw.recipe['lab'].normal then
    data.raw.recipe['lab'].normal.enabled = false
    data.raw.recipe['lab'].expensive.enabled = false
  else
    data.raw.recipe['lab'].enabled = false
  end
end

local startuprecipes = {
  ['angels-electrolyser'] = true,
  ['liquifier'] = true,
  ['offshore-pump'] = true,
  ['angels-flare-stack'] = true,
  ['burner-ore-crusher'] = true,
  ['stone-crushed'] = true,
  ['stone-brick'] = true,
  ['crystallizer'] = true,
  ['dirt-water-separation'] = true,
  ['sb-cellulose-foraging'] = true,
  ['sb-water-mineralized-crystallization'] = true,
  ['iron-plate'] = true,
  ['copper-plate'] = true,
  ['angelsore1-crushed-hand'] = true,
  ['angelsore3-crushed-hand'] = true,
  ['angelsore1-crushed-smelting'] = true,
  ['angelsore3-crushed-smelting'] = true,
  ['wood-pellets'] = true,
  ['slag-processing-stone'] = true,
  ['water-mineralized'] = true,
  ['stone-pipe'] = true,
  ['stone-pipe-to-ground'] = true
}

local sbtechs = {
  ['sb-startup1'] = true,
  ['sb-startup2'] = true,
  ['bio-wood-processing'] = true,
  ['sb-startup4'] = true
}
if data.raw.technology['sct-lab-t1'] then
  sbtechs['sct-lab-t1'] = true
end
if data.raw.technology['sct-automation-science-pack'] then
  sbtechs['sct-automation-science-pack'] = true
end

local startuptechs = {
  ['automation'] = true,
  ['logistics'] = true,
  ['optics'] = true,
  ['gun-turret'] = true,
  ['stone-wall'] = true,
  ['basic-chemistry'] = true,
  ['ore-crushing'] = true,
  ['military'] = true,
  ['angels-sulfur-processing-1'] = true,
  ['water-treatment'] = true,
  ['water-washing-1'] = true,
  ['slag-processing-1'] = true,
  ['angels-fluid-control'] = true,
  ['angels-metallurgy-1'] = true,
  ['angels-iron-smelting-1'] = true,
  ['angels-copper-smelting-1'] = true,
  ['angels-tin-smelting-1'] = true,
  ['angels-lead-smelting-1'] = true,
  ['angels-solder-smelting-1'] = true,
  ['angels-coal-processing'] = true,
  ['bio-wood-processing-2'] = true,
  ['landfill'] = true
}
if data.raw.technology['logistics-0'] then
  startuptechs['logistics-0'] = true
end
if data.raw.technology['basic-automation'] then
  startuptechs['basic-automation'] = true
end
local lasttech = 'sb-startup4'
if data.raw.technology['sct-automation-science-pack'] then
  lasttech = 'sct-automation-science-pack'
  data.raw.technology['sct-automation-science-pack'].prerequisites = { 'bio-wood-processing' }
  data.raw.technology['sct-automation-science-pack'].unit = {
    count = 1,
    ingredients = {{"sb-lab-tool", 1}},
    time = 5
  }
  data.raw.technology['sb-startup4'].enabled = false
end

local movedrecipes = table.deepcopy(startuprecipes)
for k,v in pairs(sbtechs) do
  for _,effect in pairs(data.raw.technology[k].effects or {}) do
    movedrecipes[effect.recipe] = true
  end
end
local disabledrecipes = {}

-- Don't want any recipes available that consume our carefully
-- selected starting items until the self-sufficient startup is complete
local function ironrecipe(recipe)
  local foundiron = false
  local ironnames = {
    ['iron-plate'] = true,
    ['iron-gear-wheel'] = true,
    ['iron-stick'] = true,
    ['pipe'] = true,
    ['pipe-to-ground'] = true,
    ['basic-circuit-board'] = true,
    ['electronic-circuit'] = true,
    ['stone-brick'] = true,
    ['copper-plate'] = true,
    ['copper-cable'] = true,
    ['stone-furnace'] = true
  }
  local function scaningredients(recipe)
    local haveiron = false
    for k,v in pairs(recipe.ingredients) do
      local nameidx = 1
      if v.name then nameidx = 'name' end
      if ironnames[v[nameidx]] then
        haveiron = true
      end
    end
    foundiron = foundiron or haveiron
  end
  lib.iteraterecipes(recipe, scaningredients)
  return foundiron
end
-- Disable recipes that shouldn't consume startup items
for k,v in pairs(data.raw.recipe) do
  local r = v.normal or v
  if (r.enabled == nil or r.enabled == true or r.enabled == 'true') and
    ironrecipe(v) and
    not v.hidden then
    if not movedrecipes[k] then
      table.insert(disabledrecipes, k)
    end
    r.enabled = false
    if v.normal then
      v.expensive.enabled = false
    end
  end
end

-- Add prerequisites to technologies which are not part of the selected startup techs.
for k,v in pairs(data.raw.technology) do
  if (v.enabled == nil or v.enabled == true or v.enabled == 'true') and not sbtechs[k] then
    if not v.prerequisites or #v.prerequisites == 0 then
      local prerequisite = 'slag-processing-1'
      if startuptechs[k] then
        prerequisite = lasttech
      end
      v.prerequisites = {prerequisite}
    end
  end
  if v.effects and not sbtechs[k] then
    local neweffects = {}
    for _,effect in pairs(v.effects) do
      if effect.type ~= "unlock-recipe" or not movedrecipes[effect.recipe] then
        table.insert(neweffects, effect)
      end
    end
    v.effects = neweffects
  end
end

-- Disabled recipes are enabled at last stage of startup. (Laboratory research)
for _,v in pairs(disabledrecipes) do
  table.insert(data.raw.technology[lasttech].effects, {type="unlock-recipe", recipe=v})
end
for k,_ in pairs(startuprecipes) do
  local recipe = data.raw.recipe[k]
  if recipe.normal then
    recipe.normal.enabled = true
    recipe.expensive.enabled = true
  else
    recipe.enabled = true
  end
end

-- Limit research required for startup techs.
for k,_ in pairs(startuptechs) do
  if data.raw.technology[k].unit.count > 20 then
    data.raw.technology[k].unit.count = 20
    data.raw.technology[k].unit.ingredients = {{"automation-science-pack", 1}}
  end
end

-- Make bio-wood-processing a startup tutorial tech
data.raw.technology['bio-wood-processing'].prerequisites = {'sb-startup2'}
data.raw.technology['bio-wood-processing'].unit = {
  count = 1,
  ingredients = {{"sb-algae-green-tool", 1}},
  time = 5
}
lib.takeeffect('bio-wood-processing', 'wood-pellets')
lib.moveeffect('cellulose-fiber-algae', 'bio-processing-brown', 'bio-wood-processing', 2)
lib.moveeffect('wood-bricks', 'bio-wood-processing-3', 'bio-wood-processing', 3)
table.insert(data.raw.technology['bio-wood-processing'].effects, 3, {type = 'unlock-recipe', recipe = 'small-electric-pole'})
data.raw.technology['bio-wood-processing-2'].prerequisites = {lasttech}


