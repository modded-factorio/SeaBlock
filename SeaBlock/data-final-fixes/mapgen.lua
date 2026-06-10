-- No resource placement
for k, _ in pairs(data.raw.resource) do
  data.raw.resource[k].autoplace = nil
end

data.raw["planet"]["nauvis"].map_gen_settings.autoplace_settings = {
  tile = {
    settings = {
      deepwater = {},
      water = {},
      ["sand-4"] = {},
      ["sand-5"] = {},
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

      ["angels-puffer-nest"] = {},
      ["small-worm-turret"] = {},
      ["medium-worm-turret"] = {},
      ["big-worm-turret"] = {},
      ["behemoth-worm-turret"] = {},

      ["angels-alien-fish-1"] = {},
      ["angels-alien-fish-2"] = {},
      ["angels-alien-fish-3"] = {},

      ["fish"] = {}
    }
  }
}
data.raw["planet"]["nauvis"].map_gen_settings.autoplace_controls = nil

-- Enemies
for _,name in pairs({ "bob-big-explosive-worm-turret", "bob-big-fire-worm-turret", "bob-big-poison-worm-turret", "bob-big-piercing-worm-turret", "bob-giant-worm-turret" }) do
    if (data.raw.turret[name]) then
        data.raw["planet"]["nauvis"].map_gen_settings.autoplace_settings.entity.settings[name] = {}
    end
end

-- No spawners
for _, v in pairs(data.raw["unit-spawner"]) do
  v.autoplace = nil
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
    and k ~= "angels-puffer-nest"
  then
    v.autoplace = nil
    seablock.lib.add_flag("tree", v.name, "not-deconstructable")
  else
    v.autoplace.control = nil
  end
end

-- No rocks
for _, v in pairs(data.raw["simple-entity"]) do
  v.autoplace = nil
  seablock.lib.add_flag("simple-entity", v.name, "not-deconstructable")
end

for _, v in pairs(data.raw["optimized-decorative"]) do
  v.autoplace = nil
  seablock.lib.add_flag("optimized-decorative", v.name, "not-deconstructable")
end

local keepcontrols = {}
local turrets = data.raw["turret"]
for _, turret in pairs(turrets) do
  if turret.autoplace and turret.autoplace.control then
    keepcontrols[turret.autoplace.control] = true
  end
end

local controls = data.raw["autoplace-control"]
for k, _ in pairs(controls) do
  if k ~= "enemy-base" and not keepcontrols[k] then
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
