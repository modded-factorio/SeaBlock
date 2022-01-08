-- Adjust resin production amount to how it was in petrochem 0.7.9.
-- TODO: Revisit this after Angel adds more liquid rubber recipes
seablock.lib.substresult('liquid-rubber-1', 'liquid-rubber', nil, 20)


-- Electric Engines: Move to green science
bobmods.lib.tech.remove_prerequisite('electric-engine', 'angels-advanced-oil-processing')
bobmods.lib.tech.remove_prerequisite('electric-engine', 'chemical-science-pack')
bobmods.lib.tech.remove_science_pack('electric-engine', 'chemical-science-pack')


-- Reduce burner heat source neighbour bonus
local reactors = {
  'burner-reactor',
  'burner-reactor-2',
  'burner-reactor-3',
  'fluid-reactor',
  'fluid-reactor-2',
  'fluid-reactor-3'
}

for _, v in pairs(reactors) do
  local r = data.raw.reactor[v]
  if r then
    r.neighbour_bonus = 0.125
  end
end


-- Refresh circuit board icon as it may have been overwritten
if data.raw.tool['sb-basic-circuit-board-tool'] and data.raw.item['basic-circuit-board'] then
  seablock.lib.copy_icon(data.raw.tool['sb-basic-circuit-board-tool'], data.raw.item['basic-circuit-board'])
end

require "data-final-fixes/logistics"
require "data-final-fixes/icons"
require "data-final-fixes/recipe"
require "data-final-fixes/tech-tree"
require "data-final-fixes/unobtainable_items"
require "data-final-fixes/mapgen"
require "data-final-fixes/SpaceMod"
require "data-final-fixes/descriptions"

data.raw.recipe['copper-cable'].allow_decomposition = true
data.raw.recipe['paper-bleaching-1'].allow_decomposition = true

for _,v in pairs(data.raw.character) do
  if v.crafting_categories then
    table.insert(v.crafting_categories, "crafting-handonly")
  end
end

bobmods.lib.tech.prerequisite_cleanup()
