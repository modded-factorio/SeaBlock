-- No resource placement
for k,v in pairs(data.raw.resource) do
  v.autoplace = nil
end
-- No spawners
for k,v in pairs(data.raw["unit-spawner"]) do
  v.autoplace = nil
  v.control = nil
end
-- No trees
for k,v in pairs(data.raw.tree) do
  if k ~= 'temperate-garden' and k ~= 'desert-garden' and k ~= 'swamp-garden' and
    k ~= 'temperate-tree' and k ~= 'desert-tree' and k ~= 'swamp-tree' and
    k ~= 'puffer-nest' then
    v.autoplace = nil
  end
end
-- No rocks
for k,v in pairs(data.raw["simple-entity"]) do
  v.autoplace = nil
end

local keepcontrols = {}
for _,v in pairs(data.raw) do
  for _,v2 in pairs(v) do
    if v2.autoplace and v2.autoplace.control then
      keepcontrols[v2.autoplace.control] = true
    end
  end
end
---[[
log('KH dat')
local controls = data.raw['autoplace-control']
for k,v in pairs(controls) do
  if k ~= "enemy-base" and not keepcontrols[k] then
    controls[k] = nil
  else
    log(k)
  end
end
---]]
for k,v in pairs(data.raw['map-gen-presets']['default']) do
  if v.autoplace_controls then
    for k2,v2 in pairs(v.autoplace_controls) do
      if k2 ~= "enemy-base" and not keepcontrols[k2] then
        v.autoplace_controls[k] = nil
      else
        log(k2)
      end 
    end
  end
end

data.raw['map-gen-presets']['default']['death-world'] = nil
data.raw['map-gen-presets']['default']['death-world-marathon'] = nil
data.raw['map-gen-presets']['default']['rail-world'] = nil
data.raw['map-gen-presets']['default']['rich-resources'] = nil
data.raw['map-gen-presets']['default']['ribbon-world'] = nil
data.raw['map-gen-presets']['default']['island'] = nil

--data.raw['map-settings']['map-settings']['enemy_evolution'].enabled = false
--data.raw['map-settings']['map-settings']['enemy_expansion'].enabled = false

