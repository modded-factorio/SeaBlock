-- Will need a lot of landfill
seablock.lib.substingredient("landfill", "stone", "angels-stone-crushed", 10)
for k, v in pairs(data.raw.item) do
  if string.sub(k, 1, 8) == "landfill" then
    v.stack_size = 1000
  end
end

-- Set prefered type for basic landfill crafting
if settings.startup["sb-default-landfill"] and data.raw.item[settings.startup["sb-default-landfill"].value] then
  data.raw.recipe["landfill"].results[1].name = settings.startup["sb-default-landfill"].value
end

local function BuffLandfill(recipe)
  seablock.lib.substingredient(recipe, "angels-solid-mud", nil, 5)
  bobmods.lib.recipe.set_energy_required(recipe, 2)
  bobmods.lib.tech.remove_recipe_unlock("angels-water-washing-1", recipe)
  bobmods.lib.tech.add_recipe_unlock("landfill", recipe)
end

BuffLandfill("angels-solid-mud-landfill")

if mods["LandfillPainting"] then
  BuffLandfill("landfill-dry-dirt")
  BuffLandfill("landfill-dirt-4")
  BuffLandfill("landfill-grass-1")
  BuffLandfill("landfill-red-desert-1")
  BuffLandfill("landfill-sand-3")
else
  bobmods.lib.tech.remove_recipe_unlock("angels-water-washing-2", "angels-solid-mud-landfill")
end

-- Make landfill a red science tech
data.raw.technology["landfill"].prerequisites = { "angels-water-washing-1" }
data.raw.technology["landfill"].unit = {
  count = 10,
  ingredients = { { "automation-science-pack", 1 } },
  time = 15,
}

bobmods.lib.tech.remove_prerequisite("angels-water-washing-2", "landfill")
bobmods.lib.tech.ignore_tech_cost_multiplier("landfill", true)
