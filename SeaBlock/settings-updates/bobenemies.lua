-- Bob's Enemies
if mods["bobenemies"] then
  seablock.overwrite_setting("bool-setting", "bobmods-enemies-enableartifacts", true)
  seablock.overwrite_setting("bool-setting", "bobmods-enemies-enablesmallartifacts", true)
  seablock.overwrite_setting("bool-setting", "bobmods-enemies-enablenewartifacts", true)
  seablock.overwrite_setting("bool-setting", "bobmods-enemies-aliensdropartifacts", false)
  seablock.overwrite_setting("double-setting", "bobmods-enemies-leviathanfrequency", 0)
  seablock.overwrite_setting("bool-setting", "bobmods-enemies-biggersooner", false)
  seablock.overwrite_setting("bool-setting", "bobmods-enemies-superspawner", false)
  seablock.overwrite_setting("bool-setting", "bobmods-enemies-healthincrease", false)
end
