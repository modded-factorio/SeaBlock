-- First stage:   circuit board  pipe  pipe-to-ground  iron-gear  iron-stick  copper-pipe
-- Electrolyser   5                                               20*4
-- Liquifier      5                    2
-- Flare stack    5*2            10*2
-- Offshore pump  2*2            1*2                   10*2
-- Crystallizer   5                                                           5

-- Second stage:
-- Algae farm     5                                               16

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

bobmods.lib.recipe.enabled('angels-flare-stack', true)
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

-- unlock lab and optional components with Basic Circuit Board
if data.raw.technology['sct-lab-t1'] then
  bobmods.lib.tech.add_prerequisite('sct-lab-t1', 'sb-startup3')
else
  bobmods.lib.tech.add_recipe_unlock('sb-startup3', 'lab')
  bobmods.lib.recipe.enabled('lab', false)
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
  ['wood-pellets'] = true,
  ['slag-processing-stone'] = true,
  ['water-mineralized'] = true,
  ['stone-pipe'] = true,
  ['stone-pipe-to-ground'] = true
}

if settings.startup['bobmods-assembly-multipurposefurnaces'].value then
  startuprecipes['stone-mixing-furnace'] = true
  startuprecipes['stone-mixing-furnace-from-stone-furnace'] = true
  startuprecipes['stone-furnace-from-stone-mixing-furnace'] = true
end

local sbtechs = {
  ['sb-startup1'] = true,
  ['landfill'] = true,
  ['sb-startup2'] = true,
  ['bio-paper-1'] = true,
  ['bio-wood-processing'] = true,
  ['sb-startup3'] = true,
  ['sb-startup4'] = true
}
if data.raw.technology['sct-lab-t1'] then
  sbtechs['sct-lab-t1'] = true
end
if data.raw.technology['sct-automation-science-pack'] then
  sbtechs['sct-automation-science-pack'] = true
end

local startuptechs = {
  ['automation'] = {true},
  ['optics'] = {true},
  ['gun-turret'] = {true},
  ['stone-wall'] = {true},
  ['basic-chemistry'] = {true},
  ['military'] = {true},
  ['angels-sulfur-processing-1'] = {true},
  ['water-washing-1'] = {true},
  ['slag-processing-1'] = {true},
  ['angels-fluid-control'] = {true},
  ['bio-wood-processing-2'] = {true},
  -- Don't reduce the science pack cost of green algae
  ['bio-processing-green'] = {false}
}

if data.raw.technology['logistics-0'] then
  startuptechs['logistics-0'] = {true}
else
  startuptechs['logistics'] = {true}
end
if data.raw.technology['basic-automation'] then
  startuptechs['basic-automation'] = {true}
end

local lasttech = 'sb-startup4'
if data.raw.technology['sct-automation-science-pack'] then
  lasttech = 'sct-automation-science-pack'
  bobmods.lib.tech.add_prerequisite('sct-automation-science-pack', 'sct-lab-t1')
  data.raw.technology['sct-automation-science-pack'].unit = {
    count = 1,
    ingredients = {{"sb-lab-tool", 1}},
    time = 5
  }
  data.raw.technology['sct-lab-t1'].unit = {
    count = 1,
    ingredients = {},
    time = 5
  }
  data.raw.technology['sb-startup4'].enabled = false
end

local movedrecipes = table.deepcopy(startuprecipes)
for k,v in pairs(sbtechs) do
  for _,effect in pairs(data.raw.technology[k].effects or {}) do
    movedrecipes[effect.recipe] = true
  end
  data.raw.technology[k].ignore_tech_cost_multiplier = true
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
  seablock.lib.iteraterecipes(recipe, scaningredients)
  return foundiron
end
-- Disable recipes that shouldn't consume startup items
for k,v in pairs(data.raw.recipe) do
  local r = v.normal or v
  if (r.enabled == nil or r.enabled == true or r.enabled == 'true') and
    ironrecipe(v) and not v.hidden then
    if not movedrecipes[k] then
      table.insert(disabledrecipes, k)
    end
    bobmods.lib.recipe.enabled(k, false)
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
  bobmods.lib.tech.add_recipe_unlock(lasttech, v)
end
for k,_ in pairs(startuprecipes) do
  if data.raw.recipe[k] then
    bobmods.lib.recipe.enabled(k, true)
  end
end

-- Limit research required for startup techs.
for k,v in pairs(startuptechs) do
  if data.raw.technology[k] then
    if v[1] and data.raw.technology[k].unit.count > 20 then
      data.raw.technology[k].unit.count = 20
      data.raw.technology[k].unit.ingredients = {{"automation-science-pack", 1}}
    end
    data.raw.technology[k].ignore_tech_cost_multiplier = true
    data.raw.technology[k].time = 15
  end
end

-- Make landfill a startup tutorial tech
data.raw.technology['landfill'].prerequisites = {'sb-startup1'}
data.raw.technology['landfill'].unit = {
  count = 1,
  ingredients = {},
  time = 5
}
bobmods.lib.tech.remove_prerequisite('water-washing-2', 'landfill')
if mods['Explosive Excavation'] then
  bobmods.lib.tech.remove_prerequisite('blasting-charges', 'landfill')
end

-- Make bio-wood-processing a startup tutorial tech
data.raw.technology['bio-wood-processing'].prerequisites = {'sb-startup2'}
data.raw.technology['bio-wood-processing'].unit = {
  count = 1,
  ingredients = {},
  time = 5
}
seablock.lib.takeeffect('bio-wood-processing', 'wood-pellets')
seablock.lib.moveeffect('cellulose-fiber-algae', 'bio-processing-brown', 'bio-wood-processing', 2)
seablock.lib.moveeffect('wood-bricks', 'bio-wood-processing-3', 'bio-wood-processing', 3)
seablock.lib.add_recipe_unlock('bio-wood-processing', 'small-electric-pole', 4)
data.raw.technology['bio-wood-processing-2'].prerequisites = {lasttech}

-- Make bio-paper-1 a startup tutorial tech
data.raw.technology['bio-paper-1'].prerequisites = {'sb-startup2'}
data.raw.technology['bio-paper-1'].unit = {
  count = 1,
  ingredients = {},
  time = 5
}
bobmods.lib.tech.remove_recipe_unlock('bio-processing-brown', 'solid-alginic-acid')
bobmods.lib.tech.add_recipe_unlock('bio-paper-1', 'solid-alginic-acid')
bobmods.lib.tech.remove_prerequisite('bio-paper-2', 'bio-paper-1')
