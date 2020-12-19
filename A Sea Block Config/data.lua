require "setup"

for k,v in pairs(seablockconfig.data) do
  if not settings.startup[k] then
    settings.startup[k] = {}
    settings.startup[k].value = v[2]
  end
end

if settings.startup['sb-difficulty-cost-override'] then
  settings.startup['sct-difficulty-cost'].value =
    settings.startup['sb-difficulty-cost-override'].value
end
