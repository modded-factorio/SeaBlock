require 'starting-items'

data.script_enabled = data.script_enabled or {}

seablock.scripted_techs = {
  ['sb-startup1'] = true,
  ['landfill'] = true,
  ['sb-startup2'] = true,
  ['bio-paper-1'] = true,
  ['bio-wood-processing'] = true,
  ['sb-startup3'] = true,
  ['sb-startup4'] = true
}

if data.raw.technology['sct-lab-t1'] then
  seablock.scripted_techs['sct-lab-t1'] = true
end
if data.raw.technology['sct-automation-science-pack'] then
  seablock.scripted_techs['sct-automation-science-pack'] = true
end

seablock.startup_techs = {
  ['automation'] = {true},
  ['optics'] = {true},
  ['basic-chemistry'] = {true},
  ['military'] = {true},
  ['angels-sulfur-processing-1'] = {true},
  ['water-washing-1'] = {true},
  ['slag-processing-1'] = {true},
  ['angels-fluid-control'] = {true},
  ['bio-wood-processing-2'] = {true},
  -- Don't reduce the science pack cost of green algae
  ['bio-processing-green'] = {false},
  ['long-inserters-1'] = {true}
}

if data.raw.technology['logistics-0'] then
  seablock.startup_techs['logistics-0'] = {true}
else
  seablock.startup_techs['logistics'] = {true}
end
if data.raw.technology['basic-automation'] then
  seablock.startup_techs['basic-automation'] = {true}
end

for k,_ in pairs(seablock.scripted_techs) do
  table.insert(data.script_enabled, {type = 'technology', name = k})
end

seablock.populate_starting_items(seablock, data.raw.item)
for k,_ in pairs(seablock.starting_items) do
  table.insert(data.script_enabled, {type = 'item', name = k})
end

angelsmods.trigger.smelting_products["nickel"].plate = false
angelsmods.trigger.smelting_products["zinc"].plate = false
angelsmods.trigger.smelting_products["cobalt"].plate = false
angelsmods.trigger.ores["platinum"] = true
angelsmods.trigger.smelting_products["platinum"].plate = true
angelsmods.trigger.smelting_products["platinum"].wire = true

sctm.enabledebug = false
