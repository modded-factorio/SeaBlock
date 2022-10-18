-- Bob's Power mod
if mods["bobpower"] then
  seablock.set_setting_default_value("bool-setting", "bobmods-power-accumulators", false)
  seablock.overwrite_setting("bool-setting", "bobmods-power-fluidgenerator", false)
  seablock.overwrite_setting("bool-setting", "bobmods-power-burnergenerator", false)
end
