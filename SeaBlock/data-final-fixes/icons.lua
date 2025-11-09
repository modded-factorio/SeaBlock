-- Revert Artisanal Reskins recipe icons
if mods["reskins-angels"] then
  local slag_processing_list = {
    "angels-slag-processing-1",
    "angels-slag-processing-2",
    "angels-slag-processing-3",
    "angels-slag-processing-4",
    "angels-slag-processing-5",
    "angels-slag-processing-6",
  }
  for _, name in pairs(slag_processing_list) do
    seablock.reskins.clear_icon_specification(name, "recipe")
  end
end

-- Remove I overlay from recipes
seablock.reskins.clear_icon_specification("explosives", "recipe")
seablock.reskins.clear_icon_specification("angels-liquid-rubber", "recipe")
seablock.reskins.clear_icon_specification("angels-solid-rubber", "recipe")
