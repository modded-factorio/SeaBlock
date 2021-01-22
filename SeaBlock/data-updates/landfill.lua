local lib = require "lib"

-- Will need a lot of landfill
data.raw.recipe['landfill'].ingredients = {{ "stone-crushed", 10 }}
for k,v in pairs(data.raw.item) do
  if string.sub(k, 1, 8) == "landfill" then
    v.stack_size = 1000
  end
end

-- Set prefered type for basic landfill crafting
if settings.startup['sb-default-landfill'] and data.raw.item[settings.startup['sb-default-landfill'].value] then
  data.raw.recipe['landfill'].result = settings.startup['sb-default-landfill'].value
end

lib.substingredient('solid-mud-landfill', 'solid-mud', nil, 5)
if mods['LandfillPainting'] then
  lib.substingredient('landfill-dry-dirt', 'solid-mud', nil, 5)
  lib.substingredient('landfill-dirt-4', 'solid-mud', nil, 5)
  lib.substingredient('landfill-grass-1', 'solid-mud', nil, 5)
  lib.substingredient('landfill-red-desert-1', 'solid-mud', nil, 5)
  lib.substingredient('landfill-sand-3', 'solid-mud', nil, 5)
else
  bobmods.lib.tech.remove_recipe_unlock('water-washing-2', 'solid-mud-landfill')
  bobmods.lib.tech.add_recipe_unlock('water-washing-1', 'solid-mud-landfill')
end
