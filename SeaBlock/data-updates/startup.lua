-- First stage:   circuit board  pipe  pipe-to-ground  iron-gear  iron-stick  copper-pipe
-- Electrolyser   5                                               22*4
-- Liquifier      5                    2
-- Flare stack    5*2            10*2
-- Offshore pump  2              1                     10
-- Crystallizer   5                                                           5

local knowningredients = {
  ["angels-electrolyser"] = {
    { "iron-plate", 10 },
    { "bob-basic-circuit-board", 5 },
    { "iron-stick", 22 },
    { "stone-brick", 10 },
  },
  ["angels-liquifier"] = {
    { "iron-plate", 10 },
    { "bob-basic-circuit-board", 5 },
    { "pipe-to-ground", 2 },
    { "stone-brick", 10 },
  },
  ["offshore-pump"] = {
    { "bob-basic-circuit-board", 2 },
    { "pipe", 1 },
    { "iron-gear-wheel", 10 },
  },
  ["angels-crystallizer"] = {
    { "iron-plate", 10 },
    { "bob-basic-circuit-board", 5 },
    { "bob-copper-pipe", 5 },
    { "stone-brick", 10 },
  },
  ["angels-algae-farm"] = {
    { "iron-plate", 10 },
    { "bob-basic-circuit-board", 5 },
    { "iron-stick", 10 },
    { "stone-brick", 25 },
  },
  ["angels-flare-stack"] = {
    { "iron-plate", 5 },
    { "bob-basic-circuit-board", 5 },
    { "pipe", 10 },
    { "stone-brick", 10 },
  },
  ["angels-seafloor-pump"] = {
    { "iron-plate", 5 },
    { "bob-basic-circuit-board", 2 },
    { "pipe", 5 },
  },
  ["angels-washing-plant"] = {
    { "iron-plate", 10 },
    { "bob-basic-circuit-board", 5 },
    { "pipe", 10 },
    { "stone-brick", 10 },
  },
  ["angels-chemical-plant"] = {
    { "iron-plate", 5 },
    { "iron-gear-wheel", 5 },
    { "bob-basic-circuit-board", 5 },
    { "pipe", 5 },
  },
  ["angels-filtration-unit"] = {
    { "iron-plate", 5 },
    { "bob-basic-circuit-board", 5 },
    { "pipe", 10 },
    { "stone-brick", 10 },
  },
  ["angels-filter-frame"] = {
    { "iron-plate", 1 },
    { "iron-stick", 2 },
  },
  ["angels-burner-ore-crusher"] = {
    { "stone", 5 },
    { "stone-furnace", 1 },
  },
}

bobmods.lib.recipe.enabled("angels-flare-stack", true)
seablock.lib.hide_technology("angels-flare-stack")
for k, v in pairs(knowningredients) do
  local recipe = data.raw.recipe[k]
  for ek, ev in pairs(recipe.normal or {}) do
    recipe[ek] = ev
  end
  recipe.normal = nil
  recipe.expensive = nil
  recipe.ingredients = {}
  for _, line in pairs(v) do
    table.insert(recipe.ingredients, { type = "item", name = line[1], amount = line[2] })
  end
end

-- unlock lab and optional components with Basic Circuit Board
if data.raw.technology["sct-lab-t1"] then
  bobmods.lib.tech.add_prerequisite("sct-lab-t1", "sb-startup3")
else
  bobmods.lib.tech.add_recipe_unlock("sb-startup3", "lab")
  bobmods.lib.recipe.enabled("lab", false)
end

if data.raw.technology["sct-automation-science-pack"] then
  bobmods.lib.tech.add_prerequisite("sct-automation-science-pack", "sct-lab-t1")
  -- data.raw.technology["sct-automation-science-pack"].unit = {
  --   count = 1,
  --   ingredients = { { "sb-lab-tool", 1 } },
  --   time = 1,
  -- }
  data.raw.technology["sct-automation-science-pack"].research_trigger = {type = "craft-item", item = "lab"}
  data.raw.technology["sct-automation-science-pack"].unit = nil
  data.raw.technology["sct-lab-t1"].unit = {
    count = 1,
    ingredients = {},
    time = 1,
  }
  seablock.lib.hide_technology("sb-startup4")
end

local movedrecipes = table.deepcopy(seablock.startup_recipes)
for k, v in pairs(seablock.scripted_techs) do
  if data.raw.technology[k] then
    for _, effect in pairs(data.raw.technology[k].effects or {}) do
      movedrecipes[effect.recipe] = true
    end
    bobmods.lib.tech.ignore_tech_cost_multiplier(k, true)
  end
end
local disabledrecipes = {}

-- Don't want any recipes available that consume our carefully
-- selected starting items until the self-sufficient startup is complete
local function ironrecipe(recipe)
  local foundiron = false
  local ironnames = {
    ["iron-plate"] = true,
    ["iron-gear-wheel"] = true,
    ["iron-stick"] = true,
    ["pipe"] = true,
    ["pipe-to-ground"] = true,
    ["bob-basic-circuit-board"] = true,
    ["electronic-circuit"] = true,
    ["stone-brick"] = true,
    ["copper-plate"] = true,
    ["copper-cable"] = true,
    ["stone-furnace"] = true,
  }
  local function scaningredients(recipe)
    local haveiron = false
    for k, v in pairs(recipe.ingredients) do
      local nameidx = 1
      if v.name then
        nameidx = "name"
      end
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
for k, v in pairs(data.raw.recipe) do
  local r = v.normal or v
  if (r.enabled == nil or r.enabled == true or r.enabled == "true") and ironrecipe(v) and not v.hidden then
    if not movedrecipes[k] then
      table.insert(disabledrecipes, k)
    end
    bobmods.lib.recipe.enabled(k, false)
  end
end

-- Add prerequisites to technologies which are not part of the selected startup techs.
for tech_name, tech in pairs(data.raw.technology) do
  if
    (tech.enabled == nil or tech.enabled == true or tech.enabled == "true") and not seablock.scripted_techs[tech_name]
  then
    if not tech.prerequisites or #tech.prerequisites == 0 then
      local prerequisite = seablock.final_startup_tech
      if seablock.startup_techs[tech_name] then
        prerequisite = seablock.final_scripted_tech
      end
      tech.prerequisites = { prerequisite }
    end
  end
  if tech.effects and not seablock.scripted_techs[tech_name] then
    local neweffects = {}
    for _, effect in pairs(tech.effects) do
      if effect.type ~= "unlock-recipe" or not movedrecipes[effect.recipe] then
        table.insert(neweffects, effect)
      end
    end
    tech.effects = neweffects
  end
end

-- Disabled recipes are enabled at last stage of startup. (Laboratory research)
for _, v in pairs(disabledrecipes) do
  bobmods.lib.tech.add_recipe_unlock(seablock.final_scripted_tech, v)
end
for k, _ in pairs(seablock.startup_recipes) do
  if data.raw.recipe[k] then
    bobmods.lib.recipe.enabled(k, true)
  end
end

-- Limit research required for startup techs.
for k, v in pairs(seablock.startup_techs) do
  if data.raw.technology[k] then
    if data.raw.technology[k].unit then
      if v[1] and data.raw.technology[k].unit.count > 20 then
        data.raw.technology[k].unit.count = 20
        data.raw.technology[k].unit.ingredients = { { "automation-science-pack", 1 } }
      end
      bobmods.lib.tech.ignore_tech_cost_multiplier(k, true)
      data.raw.technology[k].unit.time = 15
    end
  end
end

-- Make bio-wood-processing a startup tutorial tech
data.raw.technology["angels-bio-wood-processing"].prerequisites = { "sb-startup1" }
data.raw.technology["angels-bio-wood-processing"].unit = {
  count = 1,
  ingredients = {},
  time = 1,
}

-- Remove cycle introduced in the tech tree
-- Sectoid upgraded angelsbioprocessing by renaming the old prerequisite "basic-automation" into "electronics"
bobmods.lib.tech.remove_prerequisite("angels-basic-chemistry", "electronics")
bobmods.lib.tech.remove_prerequisite("angels-bio-processing-brown", "electronics")
bobmods.lib.tech.add_prerequisite("angels-bio-processing-brown", "automation")