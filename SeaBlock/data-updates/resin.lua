local lib = require "lib"

-- Change resin item icon to match resin recipe icon
local resinrecipe = data.raw.recipe['solid-resin']
if resinrecipe and (resinrecipe.icon or resinrecipe.icons) then
  lib.copy_icon(data.raw.item['resin'], resinrecipe)
end

-- Add resin prerequisite for advanced electronics
table.insert(data.raw.technology['advanced-electronics'].prerequisites, "resin-1")
