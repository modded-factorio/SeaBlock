local lib = require "lib"
local function makestripes(filename, count)
  local r = {}
  for i = 1,count do
    table.insert(r, { filename = filename, width_in_frames = 1, height_in_frames = 1 })
  end
  return r
end

local function makeextractorlayers(bottom, top)
  layers = {}
  if top then
    table.insert(layers,
      {
        stripes = makestripes("__angelsrefining__/graphics/entity/thermal-extractor/thermal-extractor-base.png", 16),
        priority = "high",
        width = 288,
        height = 288,
        shift = {0, 0},
        frame_count = 16,
        x = 288 * 2,
	animation_speed = 0.5
      })
  end
  table.insert(layers,
    {
      priority = "high",
      width = 288,
      height = 288,
      line_length = 4,
      shift = {0, 0},
      filename = "__angelsrefining__/graphics/entity/thermal-extractor/thermal-extractor-animation.png",
      frame_count = 16,
      animation_speed = 0.5
    })
  if bottom then
    table.insert(layers,
      {
        stripes = makestripes("__angelsrefining__/graphics/entity/thermal-extractor/thermal-extractor-base.png", 16),
        priority = "high",
        width = 288,
        height = 288,
        shift = {0, 0},
        frame_count = 16,
        x = 0,
	animation_speed = 0.5
      })
  end
  return { layers = layers }
end

-- Make these craftable by hand
data.raw.recipe['solid-alginic-acid'].category = "crafting"
data.raw.recipe['wooden-board-paper'].category = "crafting"

-- Fix handcrafting trying to use wrong crafting path
data.raw.recipe['wooden-board'].category = "electronics-machine"
data.raw.recipe['wooden-board'].enabled = false
table.insert(data.raw.technology['bio-wood-processing-3'].effects,
  {type = "unlock-recipe", recipe = "wooden-board"})

data.raw.recipe['cellulose-fiber-algae'].allow_as_intermediate = false
data.raw.recipe['cellulose-fiber-raw-wood'].allow_as_intermediate = false

-- Change resin item icon to match resin recipe icon
local resinrecipe = data.raw.recipe['solid-resin']
if resinrecipe and (resinrecipe.icon or resinrecipe.icons) then
  data.raw.item['resin'].icon = resinrecipe.icon
  data.raw.item['resin'].icons = resinrecipe.icons
  data.raw.item['resin'].icon_size = resinrecipe.icon_size
  data.raw.item['resin'].icon_mipmaps = resinrecipe.icon_mipmaps
end

-- Add resin prerequisite for advanced electronics
table.insert(data.raw.technology['advanced-electronics'].prerequisites, "resin-1")

-- Increase cost of resin->rubber smelting to encourage use of angels rubber synthesis
lib.substingredient('bob-rubber', 'resin', nil, 4)

-- Add unlock for new solder recipe
--table.insert(data.raw.technology['electronics'].effects, { type = "unlock-recipe", recipe = "solder-alginic" })
--lib.moveeffect('mixing-furnace', 'alloy-processing-1', 'electronics')

-- No wood for electric poles, use wood bricks instead
data.raw.recipe['small-electric-pole'].ingredients = {{ "wood-bricks", 1 }, { "copper-cable", 2}}

-- Will need a lot of landfill
data.raw.recipe['landfill'].ingredients = {{ "stone-crushed", 10 }}
for k,v in pairs(data.raw.item) do
  if string.sub(k, 1, 8) == "landfill" then
    v.stack_size = 1000
  end
end

-- Prefer sand for basic landfill crafting
if data.raw.item['landfill-sand-3'] then
  data.raw.recipe['landfill'].result = "landfill-sand-3"
end

-- Speed up algae farm
data.raw['assembling-machine']['algae-farm'].crafting_speed = 0.75

-- Speed up algae->cellulose fiber crafting
data.raw.recipe['cellulose-fiber-algae'].energy_required = 2

-- Speed up cellulose->wood pellet crafting
data.raw.recipe['wood-pellets'].energy_required = 3

-- Washing plant sulfur byproduct
local washing_fluid_box = {
  production_type = 'output',
  pipe_covers = pipecoverspictures(),
  base_level = 1,
  pipe_connections = {{ position = {-3, 0} }}
}
for _,v in pairs({"", "-2", "-3", "-4"}) do
  local washingplant = data.raw['assembling-machine']['washing-plant'..v]
  if washingplant then
    table.insert(washingplant.fluid_boxes, washing_fluid_box)
  end
end
lib.addresult('washing-1', {type = "fluid", name = "gas-hydrogen-sulfide", amount = 5})

-- Coal removal
lib.substingredient('poison-capsule', 'coal', 'wood-charcoal')
lib.substingredient('slowdown-capsule', 'coal', 'wood-charcoal')
lib.substingredient('grenade', 'coal', 'wood-charcoal')
lib.substingredient('explosives', 'coal', 'wood-charcoal')
lib.substingredient('solid-fuel-from-hydrogen', 'coal', 'wood-charcoal')
lib.substingredient('alien-poison', 'coal', 'wood-charcoal')
lib.substingredient('alien-explosive', 'coal', 'wood-charcoal')
lib.substingredient('filter-coal', 'coal', 'wood-charcoal')
lib.substingredient('solid-nitroglycerin', 'coal', 'wood-charcoal')
lib.substingredient('carbon', 'coal', 'wood-charcoal')
lib.substingredient('sct-mil-circuit1', 'coal', 'wood-charcoal')
lib.substingredient('steam-science-pack', 'coal', 'wood-charcoal')

--data.raw.recipe['carbon-separation-2'].energy_required = 1
lib.substingredient('carbon-separation-2', 'coal', 'wood-charcoal', 1)
--lib.substresult('carbon-separation-2', 'gas-carbon-dioxide', nil, 25)

-- Wood removal
lib.substingredient('sct-bio-sample-scaffold', 'wood', 'wood-bricks')
lib.substingredient('polishing-wheel', 'wood', 'wood-pellets')
lib.substingredient('phenolic-board', 'wood', 'wooden-board', 2)
lib.substingredient('gun-cotton', 'wood', 'cellulose-fiber', 2)
lib.takeeffect('plastics', 'synthetic-wood')

-- Sulfuric acid prerequisites
table.insert(data.raw.technology['slag-processing-1'].prerequisites, 'angels-sulfur-processing-1')
table.insert(data.raw.technology['angels-sulfur-processing-1'].prerequisites, 'water-washing-1')

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

-- Remove blue science requirement for slag-processing-2 technology
-- Needed for gold ore
-- Update: Not needed for gold now we unlock Rubyte ore with the above technology shuffle.
-- Leave change in because slag-processing-2 unlocks ceramic filters, which are quite helpful.
-- Also, having a source of silver (from crotinnum) early allows making resin/rubber
for k,v in pairs(data.raw.technology['slag-processing-2'].unit.ingredients) do
  if v[1] == 'chemical-science-pack' then
    table.remove(data.raw.technology['slag-processing-2'].unit.ingredients, k)
    break
  end
end

-- Red science level research for slag processing 1
data.raw.technology['slag-processing-1'].unit = {
  count = 20,
  ingredients = {{'automation-science-pack', 1}},
  time = 15
}

-- Disable coal cracking technology
data.raw.technology['angels-coal-cracking'].enabled = false

-- Add alien bioprocessing prerequisite for technologies that need alien artifacts
--local artifacttech = 'bio-processing-alien'
--if data.raw.technology['big-alien-artifacts'] and
--  (data.raw.technology['big-alien-artifacts'].enabled == nil or
--   data.raw.technology['big-alien-artifacts'].enabled) then
--   artifacttech = 'big-alien-artifacts'
--end
--if data.raw.technology['alien-research'] then
--  table.insert(data.raw.technology['alien-research'].prerequisites, artifacttech)
--end

-- No way to make light fuel/fuel oil, so use methanol instead
-- Update: can make light-oil now with bioprocessing or algae liqufaction.
--lib.substingredient("sct-t3-flash-fuel", "light-oil", "gas-methanol")

-- Move misc sciencey things over to science tab
if data.raw['item-group']['sct-science'] then
  if data.raw.item['lab-2'] then
    -- Update lab MK2 ingredients and energy usage
    lib.substingredient('lab-2', 'advanced-circuit', 'advanced-processing-unit')
    data.raw.lab['lab-2'].energy_usage = "3MW"
    -- Only two module slots for lab-2 if s.c.t. is installed (other labs have no module slots)
    data.raw.lab['lab-2'].module_specification.module_slots = 2
  end
  -- Put centrifuge next to nuclear components
  data.raw.item['centrifuge'].subgroup = "energy"
  data.raw.item['centrifuge'].order = "f[nuclear-energy]-a[centrifuge]"

  -- Remove bob's gems item group. This reduces the total number of groups
  -- to 18, 3 rows of 6.
  data.raw['item-group']['bob-gems'] = nil
  data.raw['item-group']['bob-fluid-products'] = nil
  for k,v in pairs(data.raw['item-subgroup']) do
    if v.group == 'bob-gems' or v.group == 'bob-fluid-products' then
      v.group = 'bob-resource-products'
    end
  end
end

-- No fuel value on these because they are also smelting inputs
-- https://forums.factorio.com/viewtopic.php?f=23&t=46634
data.raw.item['wood-bricks'].fuel_value = nil
data.raw.item['wood-bricks'].fuel_category = nil

-- First stage:                    pipe  pipe-to-ground iron-gear iron-stick
-- Electrolyser  5 circuit board                                  20
-- Liquifier     5 circuit board         2
-- Flare stack   5 circuit board*2 10*2
-- Offshore pump 2 circuit board*2 1*2                  10*2
-- Crystallizer  5 circuit board                                             5 copper-pipe

-- Second stage:
-- Hydro plant   5 electronic      5
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
  {'electronic-circuit', 5},
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

if data.raw.item['wind-turbine-2'] then
  lib.substingredient('wind-turbine-2', 'iron-plate', 'steel-plate', 2)
  data.raw.recipe['wind-turbine-2'].enabled = false
  table.insert(data.raw.technology['steel-processing'].effects,
    { type = 'unlock-recipe', recipe = 'wind-turbine-2' })
end
data.raw.technology['steel-processing'].prerequisites = {'chemical-processing-1'}
data.raw.technology['steel-processing'].unit.count = 20

-- No natural gas, use methane for manganese pellet smelting
lib.substingredient("pellet-manganese-smelting", "gas-natural-1", "gas-methane")

-- Repurpose thermal extractor
local extractor = data.raw['mining-drill']['thermal-extractor']
data.raw['mining-drill']['thermal-extractor'] = nil
data.raw['assembling-machine']['thermal-extractor'] = extractor
extractor.type = 'assembling-machine'
extractor.crafting_speed = 1
extractor.ingredient_count = 2
extractor.fluid_boxes = {
  {
    production_type = 'input',
    base_area = 10,
    base_level = -1,
    pipe_covers = pipecoverspictures(),
    pipe_connections = {{ type = 'input', position = { 5, 3 } }}
  },
  {
    production_type = 'output',
    base_area = 10,
    base_level = 1,
    pipe_covers = pipecoverspictures(),
    pipe_connections = {{ type = 'output', position = { -5, -3 } }}
  }
}
extractor.animation = {
  north = makeextractorlayers(false, false),
  east = makeextractorlayers(true, true),
  south = makeextractorlayers(false, false),
  west = makeextractorlayers(true, true),
}
extractor.crafting_categories = { "thermal-extractor" }
extractor.fixed_recipe = "thermal-extractor-water"
table.insert(data.raw.technology['thermal-water-extraction-2'].effects,
  { type = "unlock-recipe", recipe = "thermal-extractor-water" })

local bore = data.raw['mining-drill']['thermal-bore']
data.raw['mining-drill']['thermal-bore'] = nil
data.raw['assembling-machine']['thermal-bore'] = bore
bore.type = 'assembling-machine'
bore.crafting_speed = 1
bore.ingredient_count = 1
bore.fluid_boxes = {
  {
    production_type = 'output',
    base_area = 1,
    base_level = 1,
    pipe_covers = pipecoverspictures(),
    pipe_connections = {{
      type = 'output',
      positions = { {1, -2}, {2, -1}, {-1, 2}, {-2, 1} }
    }}
  }
}

local function makesheet(sheet, count, d)
  local r = table.deepcopy(sheet)
  r.stripes = makestripes(r.filename, count)
  r.frame_count = count
  r.filename = nil
  r.x = r.width * d
  if (r.hr_version) then
    r.hr_version = makesheet(r.hr_version, count, d)
  end
  return r
end
local function makeborelayers(d)
  return {
    layers = {
      makesheet(bore.base_picture.sheets[1], bore.animations.north.layers[1].frame_count, d),
      makesheet(bore.base_picture.sheets[2], bore.animations.north.layers[1].frame_count, d),
      bore.animations.north.layers[1],
      bore.animations.north.layers[2]
    }
  }
end
bore.animation = {
  north = makeborelayers(0),
  east = makeborelayers(1),
  south = makeborelayers(2),
  west = makeborelayers(3)
}
bore.crafting_categories = { "thermal-bore" }
bore.fixed_recipe = "thermal-bore-water"
table.insert(data.raw.technology['thermal-water-extraction'].effects,
  { type = "unlock-recipe", recipe = "thermal-bore-water" })

-- Circuit network wires should not require rubber
data.raw.recipe['green-wire'].ingredients = {{ "electronic-circuit", 1 }, { "copper-cable", 1 }}
data.raw.recipe['red-wire'].ingredients = {{ "electronic-circuit", 1 }, { "copper-cable", 1 }}

-- Merge basic chemistry 2 into basic chemistry
local function movealleffects(from, to)
  for _,v in pairs(data.raw.technology[from].effects) do
    table.insert(data.raw.technology[to].effects, v)
  end
  for _,v in pairs(data.raw.technology) do
    for k,prerequisite in pairs(v.prerequisites or {}) do
      if prerequisite == from then
        v.prerequisites[k] = to
      end
    end
  end
  data.raw.technology[from].effects = {}
end
movealleffects('basic-chemistry-2', 'basic-chemistry')
movealleffects('basic-chemistry-3', 'basic-chemistry-2')
data.raw.technology['basic-chemistry-2'].unit = data.raw.technology['basic-chemistry-3'].unit
data.raw.technology['basic-chemistry-3'].enabled = false

-- unlock lab and optional components with bio-wood-processing
if data.raw.technology['sct-lab-t1'] then
  for k,v in pairs(data.raw.technology['sct-lab-t1'].effects) do
    table.insert(data.raw.technology['bio-wood-processing'].effects, v)
  end
  data.raw.technology['sct-lab-t1'].effects = {}
else
  table.insert(data.raw.technology['bio-wood-processing'].effects,
    {type = "unlock-recipe", recipe = "lab"})
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
  --['sb-startup3'] = true,
  --['sb-startup-sulfur'] = true,
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
  ['turrets'] = true,
  ['stone-walls'] = true,
  ['basic-chemistry'] = true,
  ['ore-crushing'] = true,
  ['chemical-processing-1'] = true,
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
  ['bio-processing-green'] = true,

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
    local haveiron = true
    for k,v in pairs(recipe.ingredients) do
      local nameidx = 1
      if v.name then nameidx = 'name' end
      if not ironnames[v[nameidx]] then
        haveiron = false
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

data.raw.technology['water-washing-1'].prerequisites = {'ore-crushing'} -- Allow skipping of waste water recycling
lib.moveeffect('yellow-waste-water-purification', 'water-treatment-2', 'water-treatment')
data.raw.technology['electronics'].prerequisites = {
  'angels-solder-smelting-basic', 'automation', 'angels-tin-smelting-1', 'angels-coal-processing'
}

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
--lib.takeeffect('bio-wood-processing', 'gas-carbon-dioxide-from-wood')
lib.moveeffect('cellulose-fiber-algae', 'bio-processing-brown', 'bio-wood-processing', 2)
lib.moveeffect('wood-bricks', 'bio-wood-processing-3', 'bio-wood-processing', 3)
--lib.moveeffect('wood-from-cellulose', 'bio-wood-processing', 'bio-wood-processing-3')
table.insert(data.raw.technology['bio-wood-processing-2'].effects,
  {type = 'unlock-recipe', recipe = 'sb-wood-bricks-charcoal'})
table.insert(data.raw.technology['bio-wood-processing'].effects, 3,
  {type = 'unlock-recipe', recipe = 'small-electric-pole'})
data.raw.technology['bio-wood-processing-2'].prerequisites = { lasttech }
data.raw.technology['bio-arboretum-1'].prerequisites = { lasttech }
lib.moveeffect('pellet-coke', 'angels-coal-cracking', 'angels-coal-processing-2')

-- Reduce angels charcoal fuel value
data.raw.item['wood-charcoal'].fuel_value = '4MJ'
data.raw.item['pellet-coke'].fuel_value = '24MJ'

lib.takeeffect('bio-wood-processing-2', 'carbon-from-charcoal')
lib.takeeffect('bio-wood-processing-2', 'wood-charcoal')

-- Remove brown algae tech
data.raw.technology['bio-processing-green'].prerequisites = {'water-treatment'}
--local brownidx = lib.tablefind(data.raw.technology['bio-processing-blue'].prerequisites, 'bio-processing-brown')
--if brownidx ~= nil then
--  table.remove(data.raw.technology['bio-processing-blue'].prerequisites, brownidx)
--end
--data.raw.technology['bio-processing-brown'].enabled = false

data.raw.technology['bio-paper-1'].prerequisites = {}
data.raw.technology['landfill'].prerequisites = {}
data.raw.technology['bio-processing-brown'].prerequisites = {}
data.raw.technology['bio-paper-1'].unit.ingredients = {}
data.raw.technology['landfill'].unit.ingredients = {}
data.raw.technology['bio-processing-brown'].unit.ingredients = {}

-- Make hydrazine solid fuel match fuel_value
if data.raw.fluid['hydrazine'] then
  local hydrazinevalue = data.raw.fluid['hydrazine'].fuel_value
  data.raw.fluid['gas-hydrazine'].fuel_value = hydrazinevalue
  if hydrazinevalue:sub(-2) == 'kJ' then
    local hydrazinevaluekj = tonumber(hydrazinevalue:sub(1, -3))
    lib.substingredient('solid-fuel-hydrazine', 'gas-hydrazine', nil, math.floor(24000 / hydrazinevaluekj))
  end
end

-- Make bobpower hydrazine generator use angels hydrazine
if data.raw.generator['hydrazine-generator'] then
  data.raw.generator['hydrazine-generator'].fluid_box.filter = 'gas-hydrazine'
end

-- petroleum gas/methane has same solid fuel value as naphtha.
data.raw.fluid['liquid-fuel-oil'].fuel_value = '1MJ'
data.raw.fluid['light-oil'].fuel_value = '1MJ'
data.raw.fluid['liquid-fuel'].fuel_value = '1MJ'
data.raw.fluid['liquid-naphtha'].fuel_value = '0.5MJ'
data.raw.fluid['heavy-oil'].fuel_value = '0.5MJ'
data.raw.fluid['gas-methane'].fuel_value = '0.5MJ'
data.raw.fluid['petroleum-gas'].fuel_value = '0.5MJ'
data.raw.fluid['crude-oil'].fuel_value = '0.5MJ'
-- 20 petroleum gas + 20 light fuel = 30 diesel
-- 20/100*21.5 + 20/50*21.5 = 12.9MJ = 30 diesel
if data.raw.fluid['diesel-fuel'] then
  data.raw.fluid['diesel-fuel'].fuel_value = '1MJ'
end
data.raw.item['enriched-fuel'].fuel_value = '24MJ'
data.raw.item['enriched-fuel'].stack_size = 50

lib.substingredient('solid-fuel-methane', 'gas-methane', nil, 40)
lib.substingredient('solid-fuel-naphtha', 'liquid-naphtha', nil, 40)
lib.substingredient('solid-fuel-fuel-oil', 'liquid-fuel-oil', nil, 20)

data.raw.fluid['hydrogen'].fuel_value = nil
data.raw.fluid['gas-hydrogen'].fuel_value = nil
data.raw.fluid['gas-ethane'].fuel_value = nil
data.raw.fluid['gas-butane'].fuel_value = nil
data.raw.fluid['gas-propene'].fuel_value = nil
data.raw.fluid['gas-methanol'].fuel_value = nil
data.raw.fluid['gas-ethylene'].fuel_value = nil
data.raw.fluid['gas-benzene'].fuel_value = nil
data.raw.fluid['gas-ethanol'].fuel_value = nil

if data.raw.fluid['glycerol'] then
  data.raw.fluid['glycerol'].fuel_value = nil
end

-- Increase consumption of generators, sea block fuel values are lower than other mods expect.
if data.raw.generator['petroleum-generator'] then
  data.raw.generator['petroleum-generator'].fluid_usage_per_tick = 10/60
  -- KS_Power diesel generator is 100% efficient, put it after bob's fluid generators in tech tree
  if data.raw.technology['fluid-generator-3'] then
    table.insert(data.raw.technology['petroleum-generator'].prerequisites, "fluid-generator-3")
    table.insert(data.raw.technology['petroleum-generator'].unit.ingredients,
      {"production-science-pack", 1})
  end
end

-- Remove wood from basic underground belt and splitter recipes
lib.removeingredient('basic-underground-belt', 'wood')
lib.removeingredient('basic-splitter', 'wood')

-- Reduce processing unit cost of S.C.T. high-tech science
lib.substingredient('sct-htech-injector', 'processing-unit', nil, 3)

-- Can always apply productivity modules to furnace recipes, so make it official
for k,v in pairs(data.raw.module) do
  if v.effect and v.effect.productivity and v.limitation then
    table.insert(v.limitation, "sb-wood-bricks-charcoal")
  end
end

-- Update circuit board tool icon to match mod settings
data.raw.tool['sb-basic-circuit-board-tool'].icon = data.raw.item['basic-circuit-board'].icon
data.raw.tool['sb-basic-circuit-board-tool'].icon_mipmaps = data.raw.item['basic-circuit-board'].icon_mipmaps
data.raw.tool['sb-basic-circuit-board-tool'].icon_size = data.raw.item['basic-circuit-board'].icon_size

-- Blue algae
data.raw.technology['bio-processing-blue'].prerequisites = { 'bio-processing-green' }
for k,v in pairs(data.raw.technology['bio-processing-blue'].unit.ingredients) do
  if v[1] == 'chemical-science-pack' or v.name == 'chemical-science-pack' then
    table.remove(data.raw.technology['bio-processing-blue'].unit.ingredients, k)
    break
  end
end

local function disabletech(name)
  if data.raw.technology[name] then
    data.raw.technology[name].enabled = false
  end
end
for _,v in pairs({
  'water-bore-1',
  'water-bore-2',
  'water-bore-3',
  'water-bore-4',
  'coal-liquefaction',
  'bob-distillery-2',
  'bob-distillery-3',
  'bob-distillery-4',
  'bob-distillery-5'}) do
  disabletech(v)
end
