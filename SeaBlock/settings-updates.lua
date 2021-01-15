if not seablock then
  seablock = {}
end

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
        s.allowed_values = {value}
      end
      s.default_value = value
      s.hidden = true
    else
      log('Error: missing setting ' .. setting_name)
    end
  else
    log('Error: missing setting type ' .. setting_type)
  end
end

require "settings-updates/angelspetrochem"
require "settings-updates/bobassembly"
require "settings-updates/bobenemies"
require "settings-updates/bobmining"
require "settings-updates/bobmodules"
require "settings-updates/bobplates"
require "settings-updates/bobtech"
require "settings-updates/reskins-bobs"
require "settings-updates/ScienceCostTweaker"
