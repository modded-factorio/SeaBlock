if not mods['SpaceMod'] then
  return
end

local recipes = {
  'low-density-structure',
  'rocket-control-unit',
  'assembly-robot',
  'satellite',
  'drydock-assembly',
  'fusion-reactor',
  'hull-component',
  'protection-field',
  'space-thruster',
  'fuel-cell',
  'habitation',
  'life-support',
  'command',
  'astrometrics',
  'ftl-drive'
}

local techs = {
  'space-assembly',
  'space-construction',
  'space-casings',
  'protection-fields',
  'fusion-reactor',
  'space-thrusters',
  'fuel-cells',
  'habitation',
  'life-support-systems',
  'spaceship-command',
  'astrometrics',
  'ftl-theory-A',
  'ftl-theory-B',
  'ftl-theory-C',
  'ftl-theory-D',
  'ftl-theory-D1',
  'ftl-theory-D2',
  'ftl-propulsion'
}

local upgrades = {
  ['bob-construction-robot-4'] = 'bob-construction-robot-5',
  -- CircuitProcessing replaces module-3 with module-4, so SpaceMod data-final-fixes
  -- doesn't find the modules it's expecting.
  ['speed-module-4'] = 'speed-module-8',
  ['effectivity-module-4'] = 'effectivity-module-8',
  ['productivity-module-4'] = 'productivity-module-8',
  ['fusion-reactor-equipment-4'] = 'fusion-reactor-equipment-4', -- for amount adjustment
}

local function iterateingredients(recipe, func)
  if recipe.normal then
    func(recipe.normal.ingredients)
    func(recipe.expensive.ingredients)
  else
    func(recipe.ingredients)
  end
end

local function doupgrade(ingredients)
  for _, item in pairs(ingredients) do
    local nameidx = 1
    local amountidx = 2
    if item.name then nameidx = 'name' end
    if item.amount then amountidx = 'amount' end
    local upgrade = upgrades[item[nameidx]]
    if upgrade and (data.raw.item[upgrade] or data.raw.module[upgrade]) then
      item[nameidx] = upgrade
    end
    if upgrade == 'bob-construction-robot-5' then
      item[amountidx] = 1
    elseif upgrade == 'fusion-reactor-equipment-4' then
      item[amountidx] = item[amountidx] / 2
    end
  end
end

for _, recipe in pairs(recipes) do
  if data.raw.recipe[recipe] then
    iterateingredients(data.raw.recipe[recipe], doupgrade)
  end
end

-- ftl-theory-D means SpaceMod bob's mode has activated
if data.raw.technology['ftl-theory-D'] then
  for _, tech in pairs(techs) do
    if data.raw.technology[tech] then
      data.raw.technology[tech].unit.count = data.raw.technology[tech].unit.count / 10
    end
  end
end
