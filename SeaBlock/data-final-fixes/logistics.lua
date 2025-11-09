-- Overwrite belt lengths

local function set_speed(type, name, speed)
  local item = data.raw[type][name]
  if item then
    item.speed = speed / (60 * 8)
  end
end

set_speed("transport-belt", "bob-basic-transport-belt", 7.5)
set_speed("underground-belt", "bob-basic-underground-belt", 7.5)
set_speed("splitter", "bob-basic-splitter", 7.5)

set_speed("transport-belt", "transport-belt", 15)
set_speed("underground-belt", "underground-belt", 15)
set_speed("splitter", "splitter", 15)

set_speed("transport-belt", "fast-transport-belt", 30)
set_speed("underground-belt", "fast-underground-belt", 30)
set_speed("splitter", "fast-splitter", 30)

set_speed("transport-belt", "express-transport-belt", 45)
set_speed("underground-belt", "express-underground-belt", 45)
set_speed("splitter", "express-splitter", 45)

set_speed("transport-belt", "bob-turbo-transport-belt", 60)
set_speed("underground-belt", "bob-turbo-underground-belt", 60)
set_speed("splitter", "bob-turbo-splitter", 60)

set_speed("transport-belt", "bob-ultimate-transport-belt", 75)
set_speed("underground-belt", "bob-ultimate-underground-belt", 75)
set_speed("splitter", "bob-ultimate-splitter", 75)

-- Increase energy consumption of bob's extra beacons
-- Also reduce module slots and effectivity
if data.raw.beacon["bob-beacon-2"] then
  data.raw.beacon["bob-beacon-2"].energy_usage = "960kW"
  data.raw.beacon["bob-beacon-2"].module_slots = 2
  data.raw.beacon["bob-beacon-2"].distribution_effectivity = 0.5
end
if data.raw.beacon["bob-beacon-3"] then
  data.raw.beacon["bob-beacon-3"].energy_usage = "1920kW"
  data.raw.beacon["bob-beacon-3"].module_slots = 2
  data.raw.beacon["bob-beacon-3"].distribution_effectivity = 0.5
end

-- Undo boblogistcs changes to logistic system research
bobmods.lib.tech.add_new_science_pack("logistic-system", "production-science-pack", 1)
if data.raw.tool["bob-advanced-logistic-science-pack"] then
  bobmods.lib.tech.add_new_science_pack("logistic-system", "bob-advanced-logistic-science-pack", 1)
else
  bobmods.lib.tech.add_new_science_pack("logistic-system", "utility-science-pack", 1)
end

bobmods.lib.tech.add_prerequisite("logistic-system", "bob-robots-2")

local logisticstechs = {
  "logistic-system-2",
  "logistic-system-3",
  "angels-logistic-warehouses",
  "logistic-silos",
}

for _, v in pairs(logisticstechs) do
  if data.raw.technology[v] then
    bobmods.lib.tech.add_new_science_pack(v, "production-science-pack", 1)
    bobmods.lib.tech.add_new_science_pack(v, "utility-science-pack", 1)

    if data.raw.tool["bob-advanced-logistic-science-pack"] then
      bobmods.lib.tech.add_new_science_pack(v, "bob-advanced-logistic-science-pack", 1)
    end
  end
end

if mods["angelsaddons-storage"] then
  bobmods.lib.tech.replace_prerequisite("logistic-silos", "logistic-system", "logistic-system-3")
  bobmods.lib.tech.replace_prerequisite("angels-logistic-warehouses", "logistic-system", "logistic-silos")
end
bobmods.lib.tech.add_prerequisite("logistic-system-2", "utility-science-pack")

-- No logistics chest at green science level.
local function revertchests(tech)
  local neweffects = {
    { type = "unlock-recipe", recipe = "passive-provider-chest" },
    { type = "unlock-recipe", recipe = "storage-chest" },
  }
  for k, v in pairs(tech.effects) do
    if
      v.type ~= "unlock-recipe"
      or (
        v.recipe ~= "passive-provider-chest"
        and v.recipe ~= "storage-chest"
        and v.recipe ~= "requester-chest"
      )
    then
      table.insert(neweffects, v)
    end
  end
  tech.effects = neweffects
end
revertchests(data.raw.technology["logistic-robotics"])
revertchests(data.raw.technology["construction-robotics"])
local found = false
for k, v in pairs(data.raw.technology["logistic-system"].effects) do
  if v.type == "unlock-recipe" and v.recipe == "requester-chest" then
    found = true
  end
end
if not found then
  table.insert(
    data.raw.technology["logistic-system"].effects,
    { type = "unlock-recipe", recipe = "requester-chest" }
  )
end

if mods["angelsindustries"] then
  bobmods.lib.tech.remove_recipe_unlock("angels-construction-robots-2", "angels-logistic-chest-buffer")
  bobmods.lib.tech.remove_recipe_unlock("cargo-robots", "angels-logistic-chest-requester")
  bobmods.lib.tech.remove_recipe_unlock("cargo-robots-2", "angels-logistic-chest-active-provider")
  bobmods.lib.tech.add_recipe_unlock("logistic-system", "angels-logistic-chest-active-provider")
  bobmods.lib.tech.add_recipe_unlock("logistic-system", "angels-logistic-chest-buffer")
  bobmods.lib.tech.add_recipe_unlock("logistic-system", "angels-logistic-chest-requester")
end

-- Reduce payload size of Bob's bots
for i = 2, 5 do
  local robot = data.raw["logistic-robot"]["bob-logistic-robot-" .. i]
  if robot then
    robot.max_payload_size = 1
  end
  robot = data.raw["construction-robot"]["bob-construction-robot-" .. i]
  if robot then
    robot.max_payload_size = 1
  end
end
