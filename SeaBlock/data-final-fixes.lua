-- Adjust rubber production amount to how it was in petrochem 0.7.9.
-- TODO: Revisit this after Angel adds more liquid rubber recipes
seablock.lib.substresult("angels-liquid-rubber", "angels-liquid-rubber", nil, 20)

-- Reduce burner heat source neighbour bonus
local reactors = {
  "burner-reactor",
  "burner-reactor-2",
  "fluid-reactor",
  "fluid-reactor-2",
}

for _, v in pairs(reactors) do
  local r = data.raw.reactor[v]
  if r then
    r.neighbour_bonus = 0.125
  end
end

require("data-final-fixes/logistics")
require("data-final-fixes/icons")
require("data-final-fixes/recipe")
require("data-final-fixes/tech-tree")
require("data-final-fixes/unobtainable_items")
require("data-final-fixes/mapgen")
require("data-final-fixes/SpaceMod")
require("data-final-fixes/entities")


data.raw.recipe["copper-cable"].allow_decomposition = true
data.raw.recipe["angels-solid-paper"].allow_decomposition = true

for _, v in pairs(data.raw.character) do
  if v.crafting_categories then
    table.insert(v.crafting_categories, "sb-crafting-handonly")
  end
end

-- Adds handcrafting recipes because crafting category "electronics" is no longer craftable by hand
local handcrafting_recipes = {
  "electronic-circuit",
  "copper-cable",
  "advanced-circuit",
  "bob-tinned-copper-cable",
  "bob-insulated-cable",
  "bob-gilded-copper-cable",
  "bob-wooden-board",
  "bob-basic-circuit-board",
  "bob-robot-brain",
  "bob-robot-brain-2",
  "bob-robot-brain-3",
  "bob-robot-brain-4",
  "angels-wire-gold",
  "angels-wire-platinum",
  "angels-wire-silver",
  "angels-wire-tin"
}

if mods["bobmodules"] then
  table.insert(handcrafting_recipes, "bob-module-case")
  table.insert(handcrafting_recipes, "bob-module-contact")
  table.insert(handcrafting_recipes, "bob-speed-processor")
  table.insert(handcrafting_recipes, "bob-efficiency-processor")
  table.insert(handcrafting_recipes, "bob-productivity-processor")
end

if mods["CircuitProcessing"] then
  table.insert(handcrafting_recipes, "cp-electronic-circuit-board")
  table.insert(handcrafting_recipes, "cp-advanced-circuit-board")
end

for _, name in pairs(handcrafting_recipes) do
  seablock.lib.add_recipe_category(name, "crafting")
end

if mods["bobelectronics"] and mods["bobassembly"] then
  -- Recipe was craftable with assembling-machine-1 even though it required a fluid
  data.raw.recipe["bob-phenolic-board"].category = "electronics-with-fluid"
  data.raw.recipe["bob-phenolic-board"].additional_categories = nil
end

--- TODO
--- This fix is only temporary
--- Needed because angelspetrochem moved the global_replace_item function to
--- data-updates stage (was in data-final-fixes stage)
if mods["bobplates"] and mods["angelspetrochem"] then
  local OV = angelsmods.functions.OV

  OV.global_replace_item("carbon", "angels-solid-carbon")
  OV.execute()
end
