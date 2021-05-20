-- Undo boblogistic changes to underground belt lengths, and reduce length of purple and green belts
if data.raw['underground-belt']['basic-underground-belt'] then
  data.raw['underground-belt']['basic-underground-belt'].max_distance = 3
  data.raw['transport-belt']['basic-transport-belt'].speed = 7.5/(60*8)
  data.raw['underground-belt']['basic-underground-belt'].speed = 7.5/(60*8)
  data.raw['splitter']['basic-splitter'].speed = 7.5/(60*8)
end
data.raw['underground-belt']['underground-belt'].max_distance = 5
data.raw['transport-belt']['transport-belt'].speed = 15/(60*8)
data.raw['underground-belt']['underground-belt'].speed = 15/(60*8)
data.raw['splitter']['splitter'].speed = 15/(60*8)

data.raw['underground-belt']['fast-underground-belt'].max_distance = 7
data.raw['transport-belt']['fast-transport-belt'].speed = 30/(60*8)
data.raw['underground-belt']['fast-underground-belt'].speed = 30/(60*8)
data.raw['splitter']['fast-splitter'].speed = 30/(60*8)

data.raw['underground-belt']['express-underground-belt'].max_distance = 9
data.raw['transport-belt']['express-transport-belt'].speed = 45/(60*8)
data.raw['underground-belt']['express-underground-belt'].speed = 45/(60*8)
data.raw['splitter']['express-splitter'].speed = 45/(60*8)

if data.raw['underground-belt']['turbo-underground-belt'] then
  data.raw['underground-belt']['turbo-underground-belt'].max_distance = 11
  data.raw['transport-belt']['turbo-transport-belt'].speed = 60/(60*8)
  data.raw['underground-belt']['turbo-underground-belt'].speed = 60/(60*8)
  data.raw['splitter']['turbo-splitter'].speed = 60/(60*8)
end
if data.raw['underground-belt']['ultimate-underground-belt'] then
  data.raw['underground-belt']['ultimate-underground-belt'].max_distance = 13
  data.raw['transport-belt']['ultimate-transport-belt'].speed = 75/(60*8)
  data.raw['underground-belt']['ultimate-underground-belt'].speed = 75/(60*8)
  data.raw['splitter']['ultimate-splitter'].speed = 75/(60*8)
end

-- Increase energy consumption of bob's extra beacons
-- Also reduce module slots and effectivity
if data.raw.beacon['beacon-2'] then
  data.raw.beacon['beacon-2'].energy_usage = "960kW"
  data.raw.beacon['beacon-2'].module_specification.module_slots = 2
  data.raw.beacon['beacon-2'].distribution_effectivity = 0.5
end
if data.raw.beacon['beacon-3'] then
  data.raw.beacon['beacon-3'].energy_usage = "1920kW"
  data.raw.beacon['beacon-3'].module_specification.module_slots = 2
  data.raw.beacon['beacon-3'].distribution_effectivity = 0.5
end

-- Undo boblogistcs changes to logistic system research
bobmods.lib.tech.add_new_science_pack('logistic-system', 'production-science-pack', 1)
if data.raw.tool['advanced-logistic-science-pack'] then
  bobmods.lib.tech.add_new_science_pack('logistic-system', 'advanced-logistic-science-pack', 1)
else
  bobmods.lib.tech.add_new_science_pack('logistic-system', 'utility-science-pack', 1)
end

bobmods.lib.tech.add_prerequisite('logistic-system', 'bob-robots-2')

local logisticstechs = {
  'logistic-system-2',
  'logistic-system-3',
  'angels-logistic-warehouses',
  'logistic-silos'
}

for _, v in pairs(logisticstechs) do
  if data.raw.technology[v] then
    bobmods.lib.tech.add_new_science_pack(v, 'production-science-pack', 1)
    bobmods.lib.tech.add_new_science_pack(v, 'utility-science-pack', 1)

    if data.raw.tool['advanced-logistic-science-pack'] then
      bobmods.lib.tech.add_new_science_pack(v, 'advanced-logistic-science-pack', 1)
    end
  end
end

-- No logistics chest at green science level.
local function revertchests(tech)
  local neweffects = {
    { type = "unlock-recipe", recipe = "logistic-chest-passive-provider" },
    { type = "unlock-recipe", recipe = "logistic-chest-storage" }
  }
  for k,v in pairs(tech.effects) do
    if v.type ~= "unlock-recipe" or (
      v.recipe ~= "logistic-chest-passive-provider" and
      v.recipe ~= "logistic-chest-storage" and
      v.recipe ~= "logistic-chest-requester") then
      table.insert(neweffects, v)
    end
  end
  tech.effects = neweffects
end
revertchests(data.raw.technology['logistic-robotics'])
revertchests(data.raw.technology['construction-robotics'])
local found = false
for k,v in pairs(data.raw.technology['logistic-system'].effects) do
  if v.type == "unlock-recipe" and v.recipe == "logistic-chest-requester" then
    found = true
  end
end
if not found then
  table.insert(data.raw.technology['logistic-system'].effects,
    {type = "unlock-recipe", recipe = "logistic-chest-requester"})
end

if mods['angelsindustries'] then
  bobmods.lib.tech.remove_recipe_unlock('angels-construction-robots-2', 'angels-logistic-chest-buffer')
  bobmods.lib.tech.remove_recipe_unlock('cargo-robots', 'angels-logistic-chest-requester')
  bobmods.lib.tech.remove_recipe_unlock('cargo-robots-2', 'angels-logistic-chest-active-provider')
  bobmods.lib.tech.add_recipe_unlock('logistic-system', 'angels-logistic-chest-active-provider')
  bobmods.lib.tech.add_recipe_unlock('logistic-system', 'angels-logistic-chest-buffer')
  bobmods.lib.tech.add_recipe_unlock('logistic-system', 'angels-logistic-chest-requester')
end

-- Reduce payload size of Bob's bots
for i = 2,5 do
  local robot = data.raw['logistic-robot']['bob-logistic-robot-' .. i]
  if robot then
    robot.max_payload_size = 1
  end
  robot = data.raw['construction-robot']['bob-construction-robot-' .. i]
  if robot then
    robot.max_payload_size = 1
  end
end
