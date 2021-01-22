-- Will need a lot of landfill
data.raw.recipe['landfill'].ingredients = {{ "stone-crushed", 10 }}
for k,v in pairs(data.raw.item) do
  if string.sub(k, 1, 8) == "landfill" then
    v.stack_size = 1000
  end
end

-- Set prefered type for basic landfill crafting
if settings.startup['sb-default-landfill'] and data.raw.item[settings.startup['sb-default-landfill'].value] then
  data.raw.recipe['landfill'].result = settings.startup['sb-default-landfill'].value
end
