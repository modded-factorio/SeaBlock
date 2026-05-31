-- Adjust rubber production amount to how it was in petrochem 0.7.9.
-- TODO: Revisit this after Angel adds more liquid rubber recipes
seablock.lib.substresult("liquid-rubber-1", "liquid-rubber", nil, 20)

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

-- Refresh circuit board icon as it may have been overwritten
if data.raw.tool["sb-basic-circuit-board-tool"] and data.raw.item["basic-circuit-board"] then
  seablock.lib.copy_icon(data.raw.tool["sb-basic-circuit-board-tool"], data.raw.item["basic-circuit-board"])
end

require("data-final-fixes/logistics")
require("data-final-fixes/icons")
require("data-final-fixes/recipe")
require("data-final-fixes/tech-tree")
require("data-final-fixes/unobtainable_items")
require("data-final-fixes/mapgen")
require("data-final-fixes/SpaceMod")

data.raw.recipe["copper-cable"].allow_decomposition = true
data.raw.recipe["paper-bleaching-1"].allow_decomposition = true

for _, v in pairs(data.raw.character) do
  if v.crafting_categories then
    table.insert(v.crafting_categories, "crafting-handonly")
  end
end

-- Bob's dev branch does not always expose every 1.1 helper that SeaBlock used.
-- The cleanup is useful when present, but it is no longer safe to call blindly.
if bobmods.lib.tech.prerequisite_cleanup then
  bobmods.lib.tech.prerequisite_cleanup()
end

-- Run the 2.0 compatibility pass again after final fixes.  Several Angel/Bob
-- helpers mutate prototypes late, so the second pass catches new legacy shapes
-- created after data.lua required the shim.
seablock.factorio_2_0_compat()
