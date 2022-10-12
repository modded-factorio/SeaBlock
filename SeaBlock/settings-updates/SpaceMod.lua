-- Space Extension Mod
if mods["SpaceMod"] then
  seablock.overwrite_setting("bool-setting", "SpaceX-no-bob", false)
  seablock.set_setting_default_value(
    "bool-setting",
    "SpaceX-ignore-tech-multiplier",
    true
  )
end