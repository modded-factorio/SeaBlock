-- Revert Artisanal Reskins recipe icons
if mods['reskins-angels'] then
  local slag_processing_list = {
      'slag-processing-1',
      'slag-processing-2',
      'slag-processing-3',
      'slag-processing-4',
      'slag-processing-5',
      'slag-processing-6'
  }
  for _,name in pairs(slag_processing_list) do
    seablock.reskins.clear_icon_specification(name, 'recipe')
  end
end

-- Remove I overlay from explosives recipe
seablock.reskins.clear_icon_specification('explosives', 'recipe')
