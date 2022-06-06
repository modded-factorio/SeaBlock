-- Merge tech Rubbers into Rubber
bobmods.lib.tech.remove_recipe_unlock('rubbers', 'solid-rubber')
bobmods.lib.tech.replace_prerequisite('rubber', 'rubbers', 'resin-1')
bobmods.lib.tech.replace_prerequisite('bio-arboretum-desert-1', 'rubbers', 'rubber')
if mods['bobpower'] then
  bobmods.lib.tech.add_prerequisite('electric-pole-3', 'rubber')
  bobmods.lib.tech.add_prerequisite('electric-substation-3', 'rubber')
end
bobmods.lib.recipe.hide_recipe('bob-rubber')
seablock.lib.moveeffect('insulated-cable', 'electronics', 'rubber')
seablock.lib.hide_technology('rubbers')
bobmods.lib.tech.remove_recipe_unlock('bio-arboretum-desert-1', 'solid-rubber')

-- Circuit network wires should not require rubber
bobmods.lib.recipe.set_ingredients('green-wire', {{'electronic-circuit', 1}, {'copper-cable', 1}})
bobmods.lib.recipe.set_ingredients('red-wire',   {{'electronic-circuit', 1}, {'copper-cable', 1}})
