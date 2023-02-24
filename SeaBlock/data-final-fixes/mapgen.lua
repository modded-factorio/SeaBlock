--header
if settings.startup["No-minerals-mode-setting"].value == true then
	-- No resource placement
	for k, v in pairs(data.raw.resource) do
		v.autoplace = nil
	end
end

if settings.startup["No-trees-mode-setting"].value == true then
	-- No trees
	for k, v in pairs(data.raw.tree) do
	  if
		k ~= "temperate-garden"
		and k ~= "desert-garden"
		and k ~= "swamp-garden"
		and k ~= "temperate-tree"
		and k ~= "desert-tree"
		and k ~= "swamp-tree"
		and k ~= "puffer-nest"
	  then
		v.autoplace = nil
		seablock.lib.add_flag("tree", v.name, "not-deconstructable")
	  end
	end

	-- No rocks
	for k, v in pairs(data.raw["simple-entity"]) do
	  v.autoplace = nil
	  seablock.lib.add_flag("simple-entity", v.name, "not-deconstructable")
	end
end

if settings.startup["Landblock-mode-Seablock-setting"].value == false then
  -- No spawners
  for k, v in pairs(data.raw["unit-spawner"]) do
    v.autoplace = nil
    v.control = nil
  end
end

--if settings.startup["Landblock-mode-Seablock-setting"].value == true then

--else

local keepcontrols = {}
local turrets = data.raw["turret"]
for turret_name, turret in pairs(turrets) do
if turret.autoplace and turret.autoplace.control then
  keepcontrols[turret.autoplace.control] = true
end
end

if settings.startup["Landblock-mode-Seablock-setting"].value == true then
local enem = data.raw["unit-spawner"]
for enemies_name, turret in pairs(enem) do
if turret.autoplace and turret.autoplace.control then
  keepcontrols[turret.autoplace.control] = true
end
end

keepcontrols["angels-biter-slider"] = true

end

if settings.startup["No-minerals-mode-setting"].value == false then
local resources = data.raw["resource"]
for resource_name, turret in pairs(resources) do
  if turret.autoplace and turret.autoplace.control then
	keepcontrols[turret.autoplace.control] = true
  end
end
end

if settings.startup["No-trees-mode-setting"].value == false then
local trees = data.raw["tree"]
for tree_name, turret in pairs(trees) do
  if turret.autoplace and turret.autoplace.control then
	keepcontrols[turret.autoplace.control] = true
  end
end

local trees = data.raw["simple-entity"]
for tree_name, turret in pairs(trees) do
  if turret.autoplace and turret.autoplace.control then
	keepcontrols[turret.autoplace.control] = true
  end
end

end

local controls = data.raw["autoplace-control"]
--if settings.startup["No-minerals-mode-setting"].value == true then
--if settings.startup["No-trees-mode-setting"].value == true then
for k, v in pairs(controls) do
  if k ~= "enemy-base" and not keepcontrols[k] then
	controls[k] = nil
  end
end


local presets = data.raw["map-gen-presets"]["default"]
for k, v in pairs(presets) do
  -- Check for order as this is a manditory property for a MapGenPreset (so we skip type and name)
  if k ~= "default" and k ~= "marathon" and v.order then
    data.raw["map-gen-presets"]["default"][k] = nil
  end
end