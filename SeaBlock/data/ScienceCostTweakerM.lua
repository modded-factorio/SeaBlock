-- Disable SCT debug to prevent the log from being spammed
if mods['ScienceCostTweakerM'] then
  sctm.enabledebug = false

  seablock.lib.set_recipe_category('sct-t2-instruments', 'electronics')
  seablock.lib.set_recipe_category('sct-t2-wafer-stamp', 'electronics')

  bobmods.lib.recipe.remove_ingredient('chemical-science-pack', 'sct-t3-sulfur-lightsource')
end
