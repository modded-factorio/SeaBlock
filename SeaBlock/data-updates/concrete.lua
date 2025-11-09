-- Swap out concrete for bricks

if data.raw.recipe["bob-burner-reactor-2"] then
  seablock.lib.substingredient("bob-burner-reactor-2", "concrete", "angels-concrete-brick", nil)
  bobmods.lib.tech.remove_prerequisite("bob-burner-reactor-2", "concrete")
  bobmods.lib.tech.add_prerequisite("bob-burner-reactor-2", "angels-stone-smelting-2")
end
seablock.lib.substingredient("centrifuge", "concrete", "angels-concrete-brick", nil)
if data.raw.recipe["fluid-reactor-2"] then
  seablock.lib.substingredient("fluid-reactor-2", "concrete", "angels-concrete-brick", nil)
end
seablock.lib.substingredient("nuclear-reactor", "concrete", "angels-concrete-brick", nil)
seablock.lib.substingredient("rocket-silo", "concrete", "angels-reinforced-concrete-brick", nil)

bobmods.lib.tech.replace_prerequisite("uranium-processing", "concrete", "angels-stone-smelting-2")
bobmods.lib.tech.replace_prerequisite("rocket-silo", "concrete", "angels-stone-smelting-3")

-- Swap concrete tiles
local item = data.raw.item["angels-concrete-brick"]
if item and item.place_as_tile then
  item.place_as_tile["result"] = "concrete"
end
item = data.raw.item["angels-reinforced-concrete-brick"]
if item and item.place_as_tile then
  item.place_as_tile["result"] = "refined-concrete"
end
item = data.raw.item["concrete"]
if item and item.place_as_tile then
  item.place_as_tile["result"] = "angels-tile-concrete-brick"
end
item = data.raw.item["refined-concrete"]
if item and item.place_as_tile then
  item.place_as_tile["result"] = "angels-tile-reinforced-concrete-brick"
end

local tile = data.raw.tile["concrete"]
if tile then
  tile.minable["result"] = "angels-concrete-brick"
  tile.placeable_by = { item = "angels-concrete-brick", count = 1 }
  tile.walking_speed_modifier = 1.4
end
tile = data.raw.tile["refined-concrete"]
if tile then
  tile.minable["result"] = "angels-reinforced-concrete-brick"
  tile.placeable_by = { item = "angels-reinforced-concrete-brick", count = 1 }
  tile.walking_speed_modifier = 1.55
end
tile = data.raw.tile["angels-tile-concrete-brick"]
if tile then
  tile.minable["result"] = "concrete"
  tile.placeable_by = { item = "concrete", count = 1 }
  tile.walking_speed_modifier = 1.4
end
tile = data.raw.tile["angels-tile-reinforced-concrete-brick"]
if tile then
  tile.minable["result"] = "refined-concrete"
  tile.placeable_by = { item = "refined-concrete", count = 1 }
  tile.walking_speed_modifier = 1.55
end
tile = data.raw.tile["hazard-concrete-left"]
if tile then
  tile.walking_speed_modifier = 1.4
end
tile = data.raw.tile["hazard-concrete-right"]
if tile then
  tile.walking_speed_modifier = 1.4
end
tile = data.raw.tile["refined-hazard-concrete-left"]
if tile then
  tile.walking_speed_modifier = 1.55
end
tile = data.raw.tile["refined-hazard-concrete-right"]
if tile then
  tile.walking_speed_modifier = 1.55
end
