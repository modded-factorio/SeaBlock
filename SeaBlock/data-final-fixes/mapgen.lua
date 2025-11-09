-- No resource placement
for k, v in pairs(data.raw.resource) do
  v.autoplace = nil
  -- if v.autoplace then
  --   data.raw.resource[k].autoplace.default_enabled = false
  -- end
end

-- log("HELLO")
-- log(serpent.block(data.raw["planet"]["nauvis"].map_gen_settings))
data.raw["planet"]["nauvis"].map_gen_settings.autoplace_settings = {
  tile = {
    settings = {
      deepwater = {},
      water = {},
      ["sand-4"] = {},
      -- ["sand-5"] = {},
    }
  },
  entity = {
    settings = {
      ["angels-desert-garden"] = {},
      ["angels-temperate-garden"] = {},
      ["angels-swamp-garden"] = {},
      
      ["angels-desert-tree"] = {},
      ["angels-temperate-tree"] = {},
      ["angels-swamp-tree"] = {},
    }
  }
}
data.raw["planet"]["nauvis"].map_gen_settings.autoplace_controls = nil


-- No spawners
for k, v in pairs(data.raw["unit-spawner"]) do
  v.autoplace = nil
  -- v.control = nil
  if v.autoplace then
    v.autoplace.default_enabled = false
  end
end

-- No trees
for k, v in pairs(data.raw.tree) do
  if
    k ~= "angels-temperate-garden"
    and k ~= "angels-desert-garden"
    and k ~= "angels-swamp-garden"
    and k ~= "angels-temperate-tree"
    and k ~= "angels-desert-tree"
    and k ~= "angels-swamp-tree"
    and k ~= "puffer-nest"
  then
    v.autoplace = nil
    seablock.lib.add_flag("tree", v.name, "not-deconstructable")
  else
    v.autoplace.control = nil
  end
end

-- No rocks
for k, v in pairs(data.raw["simple-entity"]) do
  v.autoplace = nil
  -- if v.autoplace then
  --   v.autoplace.default_enabled = false
  -- end
  seablock.lib.add_flag("simple-entity", v.name, "not-deconstructable")
end

for k, v in pairs(data.raw["optimized-decorative"]) do
  v.autoplace = nil
  -- if v.autoplace then
  --   v.autoplace.default_enabled = false
  -- end
  seablock.lib.add_flag("optimized-decorative", v.name, "not-deconstructable")
end

local keepcontrols = {}
local turrets = data.raw["turret"]
for turret_name, turret in pairs(turrets) do
  if turret.autoplace and turret.autoplace.control then
    keepcontrols[turret.autoplace.control] = true
  end
end

--keepcontrols["angels-fissure"] = true

local controls = data.raw["autoplace-control"]
for k, v in pairs(controls) do
  if k ~= "enemy-base" and not keepcontrols[k] then
    -- data.raw["autoplace-control"][k].hidden = true
    data.raw["autoplace-control"][k] = nil
  end
end

local presets = data.raw["map-gen-presets"]["default"]
for k, v in pairs(presets) do
  -- Check for order as this is a manditory property for a MapGenPreset (so we skip type and name)
  if k ~= "default" and k ~= "marathon" and v.order then
    data.raw["map-gen-presets"]["default"][k] = nil
  end
end
