-- Add resin prerequisite for advanced electronics
bobmods.lib.tech.add_prerequisite('advanced-electronics', 'resin-1')

-- Merge tech Resins into Resin-1
bobmods.lib.tech.remove_prerequisite('resin-1', 'resins')
bobmods.lib.tech.remove_prerequisite('angels-stone-smelting-2', 'resins')
bobmods.lib.tech.remove_recipe_unlock('bio-arboretum-temperate-1', 'solid-resin')
bobmods.lib.tech.replace_prerequisite('bio-arboretum-temperate-1', 'resins', 'resin-1')
seablock.lib.hide_technology('resins')

bobmods.lib.tech.add_recipe_unlock('resin-1', 'bio-resin-wood-reprocessing')
