seablock = seablock or {}

function seablock.populate_starting_items(items)
  local starting_items = {
    ["stone"] = 130,
    ["small-electric-pole"] = 50,
    ["small-lamp"] = 12,
    ["iron-plate"] = 1200,
    ["bob-basic-circuit-board"] = 200,
    ["bob-stone-pipe"] = 100,
    ["bob-stone-pipe-to-ground"] = 50,
    ["stone-brick"] = 500,
    ["pipe"] = 21,
    ["bob-copper-pipe"] = 5,
    ["iron-gear-wheel"] = 10,
    ["iron-stick"] = 88,
    ["pipe-to-ground"] = 2,
  }

  -- Starting power production
  if items["wind-turbine-2"] then
    starting_items["wind-turbine-2"] = 120
  else
    starting_items["solar-panel"] = 38
    starting_items["accumulator"] = 32
  end

  -- Starting landfill
  local landfill
  local setting = settings.startup["sb-default-landfill"]
  if setting and items[setting.value] then
    landfill = setting.value
  else
    landfill = "landfill"
  end
  starting_items[landfill] = 2000
  return starting_items
end
