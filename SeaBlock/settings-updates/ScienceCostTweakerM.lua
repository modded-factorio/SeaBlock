-- ScienceCostTweaker Mod (mexmer)
if mods["ScienceCostTweakerM"] then
  seablock.overwrite_setting("string-setting", "sct-lab-modules", "none")
  seablock.overwrite_setting("bool-setting", "sct-connect-science", false)
  seablock.overwrite_setting("string-setting", "sct-bio", "tier1")
  seablock.overwrite_setting("string-setting", "sct-tier1-lab", "sct-lab-1")
end
