local setting_updates = {} -- [setting-name] = {setting-type, setting-value

function update_settings(arr)
  for _,b in ipairs(arr) do
    setting_updates[b[1]] = {b[2], b[3]}
  end
end

-- Angel's Petrochemical Processing
update_settings({
  {'angels-disable-bobs-electrolysers', 'bool-setting', true},
  {'angels-disable-bobs-chemical-plants', 'bool-setting', true},
  {'angels-disable-bobs-distilleries', 'bool-setting', true}
})

-- Bob's Assembling Machines
update_settings({
  {'bobmods-assembly-chemicalplants', 'bool-setting', false},
  {'bobmods-assembly-electrolysers', 'bool-setting', false},
  {'bobmods-assembly-distilleries', 'bool-setting', false}
})

-- Bob's Enemies
update_settings({
  {'bobmods-enemies-enableartifacts', 'bool-setting', true},
  {'bobmods-enemies-enablesmallartifacts', 'bool-setting', true},
  {'bobmods-enemies-enablenewartifacts', 'bool-setting', true},
  {'bobmods-enemies-aliensdropartifacts', 'bool-setting', false}
})

-- Bob's Mining
update_settings({
  {'bobmods-mining-miningdrills', 'bool-setting', false},
  {'bobmods-mining-areadrills', 'bool-setting', false},
  {'bobmods-mining-pumpjacks', 'bool-setting', false},
  {'bobmods-mining-waterminers', 'bool-setting', false}
})

-- Bob's Modules
update_settings({
  {'bobmods-modules-enablegreenmodules', 'bool-setting', false},
  {'bobmods-modules-enablerawspeedmodules', 'bool-setting', false},
  {'bobmods-modules-enablerawproductivitymodules', 'bool-setting', false},
  {'bobmods-modules-enablegodmodules', 'bool-setting', false},
  {'bobmods-modules-enableproductivitylimitation', 'bool-setting', true},
  {'bobmods-modules-productivityhasspeed', 'bool-setting', true},
  {'bobmods-modules-transmitproductivity', 'bool-setting', false},
  {'bobmods-modules-perlevel-bonus-speed', 'double-setting', 0.05},
  {'bobmods-modules-perlevel-bonus-pollution', 'double-setting', 0.025},
  {'bobmods-modules-perlevel-bonus-consumption', 'double-setting', 0.05},
  {'bobmods-modules-perlevel-bonus-productivity', 'double-setting', 0.015},
  {'bobmods-modules-perlevel-bonus-pollutioncreate', 'double-setting', 0.2},
  {'bobmods-modules-perlevel-penalty-speed', 'double-setting', 0},
  {'bobmods-modules-perlevel-penalty-pollution', 'double-setting', 0.01},
  {'bobmods-modules-perlevel-penalty-consumption', 'double-setting', 0.05},
  {'bobmods-modules-start-bonus-speed', 'double-setting', 0.2},
  {'bobmods-modules-start-bonus-pollution', 'double-setting', 0},
  {'bobmods-modules-start-bonus-consumption', 'double-setting', 0.2},
  {'bobmods-modules-start-bonus-productivity', 'double-setting', 0},
  {'bobmods-modules-start-bonus-pollutioncreate', 'double-setting', 0},
  {'bobmods-modules-start-penalty-speed', 'double-setting', 0.15},
  {'bobmods-modules-start-penalty-pollution', 'double-setting', 0.02},
  {'bobmods-modules-start-penalty-consumption', 'double-setting', 0.4}
})

-- Bob's Metals, Chemicals and Intermediates
update_settings({
  {'bobmods-plates-cheapersteel', 'bool-setting', false},
  {'bobmods-plates-nuclearupdate', 'bool-setting', true}
})

-- Artisanal Reskins: Bob's Mods
update_settings({
  {'reskins-bobs-do-bobelectronics-circuit-style', 'string-setting', 'colored-vanilla'}
})

-- ScienceCostTweaker Mod (mexmer)
update_settings({
  {'sct-recipes', 'string-setting', 'bobsmods'}
})

-- Sets SeaBlock preferred settings in other mods
-- Hide the settings as our override values will not show in the UI
for k,v in pairs(setting_updates) do
  local t = v[1] -- t:setting-type (bool-setting | int-setting | double-setting | string-setting)
  if data.raw[t] then
    local s = data.raw[t][k]
    if s then
      s.hidden = true
      s.value = v[2]
    end
  end
end

if data.raw['bool-setting']['bobmods-assembly-burner'] then
   data.raw['bool-setting']['bobmods-assembly-burner'].default_value = false
end
