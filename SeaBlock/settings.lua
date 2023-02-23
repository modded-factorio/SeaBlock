seablock = seablock or {}

if mods["LandfillPainting"] then
  local tiletypes = {
    "landfill-dirt-4",
    "landfill-dry-dirt",
    "landfill-grass-1",
    "landfill-landfill",
    "landfill-red-desert-1",
    "landfill-sand-3",
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

data:extend({
    {
      type = "bool-setting",
      name = "Landblock-mode-Seablock-setting",
      setting_type = "startup",
      default_value = false
    }
})

      
