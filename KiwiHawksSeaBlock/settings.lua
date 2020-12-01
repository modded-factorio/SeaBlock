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
