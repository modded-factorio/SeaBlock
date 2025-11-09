require("starting-items")

-- Populate table of starting items and script enabled techs for YAFC to read
if data.data_crawler then
  data.script_enabled = data.script_enabled or {}

  for k, _ in pairs(seablock.scripted_techs) do
    table.insert(data.script_enabled, { type = "technology", name = k })
  end

  local starting_items = seablock.populate_starting_items(data.raw.item)
  for k, _ in pairs(starting_items) do
    table.insert(data.script_enabled, { type = "item", name = k })
  end

  -- YAFC doesn't recognise that Wind Turbines can generate power
  -- So add Boiler and Steam Engine to script_enabled
  table.insert(data.script_enabled, { type = "item", name = "boiler" })
  table.insert(data.script_enabled, { type = "item", name = "steam-engine" })
end

-- Set Angel's triggers
angelsmods.trigger.smelting_products["copper"].powder = true
angelsmods.trigger.smelting_products["nickel"].plate = false
angelsmods.trigger.smelting_products["zinc"].plate = false
angelsmods.trigger.smelting_products["cobalt"].plate = false
angelsmods.trigger.ores["platinum"] = true
angelsmods.trigger.smelting_products["platinum"].plate = true
angelsmods.trigger.smelting_products["platinum"].wire = true
angelsmods.trigger.smelting_products["gunmetal"].plate = false
angelsmods.trigger.early_sulfuric_acid = true

-- Copy Ore Processing Machine tech icon to Mechanical Refining
seablock.lib.copy_icon(data.raw.technology["angels-ore-crushing"], data.raw.technology["angels-advanced-ore-refining-1"])
