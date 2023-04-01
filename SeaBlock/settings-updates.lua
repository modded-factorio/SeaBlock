function seablock.set_setting_default_value(setting_type, setting_name, value)
  if data.raw[setting_type] then
    local s = data.raw[setting_type][setting_name]
    if s then
      s.default_value = value
    end
  end
end

function seablock.overwrite_setting(setting_type, setting_name, value)
  -- setting_type: [bool-setting | int-setting | double-setting | string-setting]
  if data.raw[setting_type] then
    local s = data.raw[setting_type][setting_name]
    if s then
      if setting_type == 'bool-setting' then
        s.forced_value = value
      else
        s.default_value = value
        s.allowed_values = {value}
      end
      s.hidden = true
    else
      log('Error: missing setting ' .. setting_name)
    end
  else
    log('Error: missing setting type ' .. setting_type)
  end
end

require('settings-updates/angelsbioprocessing')
require('settings-updates/angelsindustries')
require('settings-updates/angelspetrochem')
require('settings-updates/angelsrefining')
require('settings-updates/bobassembly')
require('settings-updates/bobenemies')
require('settings-updates/boblibrary')
require('settings-updates/boblogistics')
require('settings-updates/bobmining')
require('settings-updates/bobores')
require('settings-updates/bobplates')
require('settings-updates/bobpower')
require('settings-updates/bobrevamp')
require('settings-updates/bobtech')
require('settings-updates/bobwarfare')
require('settings-updates/reskins-angels')
require('settings-updates/ScienceCostTweakerM')
require('settings-updates/SpaceMod')
