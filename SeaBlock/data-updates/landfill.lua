-- Will need a lot of landfill
seablock.lib.substingredient("landfill", "stone", "stone-crushed", 10)
for k, v in pairs(data.raw.item) do
  if string.sub(k, 1, 8) == "landfill" then
    v.stack_size = 1000
  end
end

-- Set prefered type for basic landfill crafting
if settings.startup["sb-default-landfill"] and data.raw.item[settings.startup["sb-default-landfill"].value] then
  data.raw.recipe["landfill"].result = settings.startup["sb-default-landfill"].value
end

local function BuffLandfill(recipe)
  seablock.lib.substingredient(recipe, "solid-mud", nil, 5)
  bobmods.lib.recipe.set_energy_required(recipe, 2)
end

BuffLandfill("solid-mud-landfill")

if mods["LandfillPainting"] then
  BuffLandfill("landfill-dry-dirt")
  BuffLandfill("landfill-dirt-4")
  BuffLandfill("landfill-grass-1")
  BuffLandfill("landfill-red-desert-1")
  BuffLandfill("landfill-sand-3")
else
  bobmods.lib.tech.remove_recipe_unlock("water-washing-2", "solid-mud-landfill")
  bobmods.lib.tech.add_recipe_unlock("water-washing-1", "solid-mud-landfill")
end
