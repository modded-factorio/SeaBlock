-- Bob's Logistics
if mods["boblogistics"] then
  seablock.overwrite_setting(
    "bool-setting",
    "bobmods-logistics-beltoverhaul",
    true
  )
  seablock.overwrite_setting(
    "bool-setting",
    "bobmods-logistics-beltoverhaulspeed",
    false
  )
  seablock.overwrite_setting(
    "double-setting",
    "bobmods-logistics-beltspeedperlevel",
    15
  )
  seablock.overwrite_setting(
    "bool-setting",
    "bobmods-logistics-ugdistanceoverhaul",
    true
  )
  seablock.overwrite_setting("int-setting", "bobmods-logistics-beltstarting", 3)
  seablock.overwrite_setting("int-setting", "bobmods-logistics-beltperlevel", 2)
  seablock.overwrite_setting(
    "int-setting",
    "bobmods-logistics-pipestarting",
    11
  )
  seablock.overwrite_setting("int-setting", "bobmods-logistics-pipeperlevel", 4)
end