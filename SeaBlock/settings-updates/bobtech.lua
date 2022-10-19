-- Bob's Tech
if mods["bobtech"] then
  seablock.overwrite_setting("bool-setting", "bobmods-burnerphase", false)

  if mods["ScienceCostTweakerM"] then
    seablock.overwrite_setting("bool-setting", "bobmods-tech-colorupdate", false)
  else
    seablock.set_setting_default_value("bool-setting", "bobmods-tech-colorupdate", false)
  end
end
