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
  seablock.lib.set_recipe_subgroup('sct-t3-sulfur-lightsource', 'sct-labparts')

  bobmods.lib.recipe.remove_ingredient('chemical-science-pack', 'sct-t3-sulfur-lightsource')

  -- Allow productivity modules in bio science
  bobmods.lib.module.add_productivity_limitation('sct-bio-science-pack')

  -- Rename Lab 2 to Exoplanetary Studies Lab
  if data.raw.item['lab-2'] then
    data.raw.item['lab-2'].localised_name = {'item-name.sct-lab-lab2'}
  end
  if data.raw.lab['lab-2'] then
    data.raw.lab['lab-2'].localised_name = {'entity-name.sct-lab-lab2'}
  end
end
