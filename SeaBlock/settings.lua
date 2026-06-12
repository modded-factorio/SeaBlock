seablock = seablock or {}

if mods["LandfillPainting"] then
  local tiletypes = {
    "landfill-dirt",
    "landfill-dry-dirt",
    "landfill-grass",
    "landfill",
    "landfill-red-desert",
    "landfill-sand",
  }

  data:extend({
    {
      type = "string-setting",
      name = "sb-default-landfill",
      setting_type = "startup",
      default_value = tiletypes[6],
      allowed_values = tiletypes,
    },
  })
end
