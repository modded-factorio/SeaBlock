-- Angel's Industries
if mods["angelsindustries"] then
  seablock.overwrite_setting("bool-setting", "angels-enable-industries", true)
  seablock.overwrite_setting("bool-setting", "angels-enable-components", false)
  seablock.overwrite_setting("bool-setting", "angels-enable-tech", false)
  seablock.overwrite_setting("bool-setting", "angels-return-ingredients", true)
  seablock.overwrite_setting("int-setting", "angels-components-stack-size", 1000)
end
