seablock = seablock or {}
seablock.trigger = seablock.trigger or {}

if mods['seablock-mining'] then
  seablock.trigger.mining_productivity = true
end

require "prototypes/recipe"
require "prototypes/recipe-category"
require "prototypes/technology"
require "prototypes/rockchest"
require "mapgen"
require "data/tech-tree"

table.insert(data.raw.character.character.crafting_categories, "crafting-handonly")

if settings.startup['sb-difficulty-cost-override'] then
  settings.startup['sct-difficulty-cost'].value = settings.startup['sb-difficulty-cost-override'].value
end
