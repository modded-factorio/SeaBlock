local lib = require("lib")

-- Adjust resin production amount to how it was in petrochem 0.7.9.
-- TODO: Revisit this after Angel adds more liquid rubber recipes
lib.substresult('liquid-rubber-1', 'liquid-rubber', nil, 20)


-- Reset solid-resin recipe icon to remove the II stamp
data.raw.recipe['solid-resin'].icon = nil
data.raw.recipe['solid-resin'].icons = nil


-- Electric Engines: Move to green science
bobmods.lib.tech.remove_prerequisite('electric-engine', 'angels-advanced-oil-processing')
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
  data.raw.tool['sb-basic-circuit-board-tool'].icon = data.raw.item['basic-circuit-board'].icon
  data.raw.tool['sb-basic-circuit-board-tool'].icon_size = data.raw.item['basic-circuit-board'].icon_size
  data.raw.tool['sb-basic-circuit-board-tool'].icon_mipmaps = data.raw.item['basic-circuit-board'].icon_mipmaps
end

require "data-final-fixes/logistics"
require "data-final-fixes/unobtainable_items"
require "data-final-fixes/mapgen"
require "data-final-fixes/SpaceMod"

bobmods.lib.tech.prerequisite_cleanup()
