-- Bob's Assembling Machines
if mods["bobassembly"] then
  seablock.overwrite_setting(
    "bool-setting",
    "bobmods-assembly-chemicalplants",
    false
  )
  seablock.overwrite_setting(
    "bool-setting",
    "bobmods-assembly-electrolysers",
    false
  )
  seablock.overwrite_setting(
    "bool-setting",
    "bobmods-assembly-distilleries",
    false
  )
  seablock.overwrite_setting("bool-setting", "bobmods-assembly-burner", false)

  seablock.set_setting_default_value(
    "bool-setting",
    "bobmods-assembly-oilfurnaces",
    false
  )
end