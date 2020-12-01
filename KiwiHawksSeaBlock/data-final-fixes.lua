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

require "data-final-fixes/unobtainable_items"
require "data-final-fixes/mapgen"
require "data-final-fixes/SpaceMod"
