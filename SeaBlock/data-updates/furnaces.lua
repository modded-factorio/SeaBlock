-- Fix up furnace tech icons
if not mods["reskins-bobs"] then
  for _, v in pairs({
    "bob-fluid-mixing-furnace",
    "bob-steel-mixing-furnace",
  }) do
    seablock.lib.copy_icon(data.raw.technology[v], data.raw.technology["advanced-material-processing"])
  end

  for _, v in pairs({
    "bob-electric-mixing-furnace",
    "bob-multi-purpose-furnace-1",
    "bob-multi-purpose-furnace-2",
    "advanced-material-processing-3",
    "advanced-material-processing-4",
  }) do
    seablock.lib.copy_icon(data.raw.technology[v], data.raw.technology["advanced-material-processing-2"])
  end
end

bobmods.lib.tech.remove_prerequisite("bob-steel-mixing-furnace", "angels-steel-smelting-1")
