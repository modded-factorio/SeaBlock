seablock = seablock or {}
seablock.trigger = seablock.trigger or {}
angelsmods.trigger.early_sulfuric_acid = true

if mods["seablock-mining"] then
  seablock.trigger.mining_productivity = true
end

require"lib"
require"prototypes/recipe"
require"prototypes/recipe-category"
require"prototypes/technology"
require"prototypes/rockchest"
require"mapgen"
require"data-updates/Companion_Drones"
require"data/tables"
require"data/misc"
require"data/ScienceCostTweakerM"
require"data/recipe"
require"data/tech-tree"