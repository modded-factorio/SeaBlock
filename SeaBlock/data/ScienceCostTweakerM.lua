-- Disable SCT debug to prevent the log from being spammed
if mods['ScienceCostTweakerM'] then
  sctm.enabledebug = false

  seablock.lib.set_recipe_category('sct-t2-instruments', 'electronics')
  seablock.lib.set_recipe_category('sct-t2-wafer-stamp', 'electronics')
  seablock.lib.set_recipe_category('sct-mil-circuit1', 'electronics')
  seablock.lib.set_recipe_category('sct-mil-circuit2', 'electronics')
  seablock.lib.set_recipe_category('sct-mil-circuit3', 'electronics')
  seablock.lib.set_recipe_category('sct-prod-bioprocessor', 'electronics')
  seablock.lib.set_recipe_category('sct-prod-overclocker', 'electronics-with-fluid')
  seablock.lib.set_recipe_category('sct-prod-chipcase', 'electronics-with-fluid')

  bobmods.lib.recipe.remove_ingredient('chemical-science-pack', 'sct-t3-sulfur-lightsource')
end
