if mods["LandfillPainting"] then
  local tiletypes = {
    'landfill',
    'landfill-dry-dirt',
    'landfill-dirt-4',
    'landfill-grass-1',
    'landfill-red-desert-1',
    'landfill-sand-3'
  }

  data:extend({
    {
      type = 'string-setting',
      name = 'sb-default-landfill',
      setting_type = 'startup',
      default_value = tiletypes[1],
      allowed_values = tiletypes
    }
  })
end

if mods['SpaceMod'] and data.raw['string-setting']['sct-difficulty-cost'] then
  data:extend({
    {
      type = 'string-setting',
      name = 'sb-difficulty-cost-override',
      localised_name = {'mod-setting-name.sb-difficulty-cost-override', 'ScienceCostTweaker', {'mod-setting-name.sct-difficulty-cost'}},
      localised_description = {'mod-setting-description.sct-difficulty-cost'},
      setting_type = 'startup',
      default_value = 'noadjustment',
      allowed_values = data.raw['string-setting']['sct-difficulty-cost'].allowed_values
    }
  })
end