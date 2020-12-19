-- ScienceCostTweaker Mod (mexmer)
seablockconfig:extend({
  {'sct-recipes', 'string-setting', 'bobsmods'},
})
if mods['SpaceMod'] then
  seablockconfig:extend({
    -- Replaced with value from sb-difficulty-cost-override in data.lua
    {'sct-difficulty-cost', 'string-setting', 'normal'},
  })
end
