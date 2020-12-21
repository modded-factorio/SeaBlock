-- Change resin item icon to match resin recipe icon
local resinrecipe = data.raw.recipe['solid-resin']
if resinrecipe and (resinrecipe.icon or resinrecipe.icons) then
  data.raw.item['resin'].icon = resinrecipe.icon
  data.raw.item['resin'].icons = resinrecipe.icons
  data.raw.item['resin'].icon_size = resinrecipe.icon_size
  data.raw.item['resin'].icon_mipmaps = resinrecipe.icon_mipmaps
end

-- Add resin prerequisite for advanced electronics
table.insert(data.raw.technology['advanced-electronics'].prerequisites, "resin-1")
