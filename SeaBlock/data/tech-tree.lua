local lib = require "lib"

-- Move garden duplication recipes to a tech that doesn't require bio science

lib.moveeffect('desert-garden-cultivating-b', 'bio-desert-farm', 'bio-farm-alien')
lib.moveeffect('swamp-garden-cultivating-b', 'bio-swamp-farm', 'bio-farm-alien')
lib.moveeffect('temperate-garden-cultivating-b', 'bio-temperate-farm', 'bio-farm-alien')

bobmods.lib.tech.remove_prerequisite('bio-desert-farm', 'bio-farm-alien')
bobmods.lib.tech.remove_prerequisite('bio-swamp-farm', 'bio-farm-alien')
bobmods.lib.tech.remove_prerequisite('bio-temperate-farm', 'bio-farm-alien')

-- Move storage tanks so bob's techs can be removed
local i = lib.findeffectidx(data.raw.technology['angels-fluid-control'].effects, 'angels-storage-tank-3')
lib.moveeffect('bob-small-inline-storage-tank', 'electrolysis-1', 'angels-fluid-control', i)
lib.moveeffect('bob-small-storage-tank', 'electrolysis-1', 'angels-fluid-control', i + 1)

-- Add bio science to techs
-- Don't add to techs on the path to Alien Farming. This is where garden / bio token duplication is unlocked
bobmods.lib.tech.add_new_science_pack('bio-refugium-biter-1', 'token-bio', 1)
bobmods.lib.tech.add_new_science_pack('bio-refugium-biter-2', 'token-bio', 1)
bobmods.lib.tech.add_new_science_pack('bio-refugium-biter-3', 'token-bio', 1)
bobmods.lib.tech.add_new_science_pack('bio-refugium-puffer-1', 'token-bio', 1)
bobmods.lib.tech.add_new_science_pack('bio-refugium-puffer-2', 'token-bio', 1)
bobmods.lib.tech.add_new_science_pack('bio-refugium-puffer-3', 'token-bio', 1)
bobmods.lib.tech.add_new_science_pack('bio-refugium-puffer-4', 'token-bio', 1)
bobmods.lib.tech.add_new_science_pack('bio-pressing', 'token-bio', 1)
bobmods.lib.tech.add_new_science_pack('bio-pressing-fish', 'token-bio', 1)
bobmods.lib.tech.add_new_science_pack('bio-refugium-butchery-2', 'token-bio', 1)
bobmods.lib.tech.add_new_science_pack('bio-refugium-fish-2', 'token-bio', 1)
bobmods.lib.tech.add_new_science_pack('bio-processing-alien-2', 'token-bio', 1)
bobmods.lib.tech.add_new_science_pack('bio-processing-alien-3', 'token-bio', 1)

-- Remove empty tech Thermal water processing
bobmods.lib.tech.remove_prerequisite('water-treatment-4', 'thermal-water-processing')
data.raw.technology['thermal-water-processing'].hidden = true

-- Smelting techs don't need to depend on Coal processing 2 as carbon is unlocked earlier
bobmods.lib.tech.remove_prerequisite('angels-aluminium-smelting-1', 'angels-coal-processing-2')
bobmods.lib.tech.remove_prerequisite('angels-cobalt-smelting-1', 'angels-coal-processing-2')
bobmods.lib.tech.remove_prerequisite('angels-lead-smelting-2', 'angels-coal-processing-2')
bobmods.lib.tech.remove_prerequisite('angels-manganese-smelting-1', 'angels-coal-processing-2')
bobmods.lib.tech.remove_prerequisite('angels-tin-smelting-2', 'angels-coal-processing-2')
bobmods.lib.tech.remove_prerequisite('angels-titanium-smelting-1', 'angels-coal-processing-2')
bobmods.lib.tech.remove_prerequisite('angels-zinc-smelting-2', 'angels-coal-processing-2')
bobmods.lib.tech.remove_prerequisite('angels-chrome-smelting-1', 'angels-coal-processing-2')
bobmods.lib.tech.remove_prerequisite('angels-iron-smelting-2', 'angels-coal-processing-2')
-- Add a new prerequisite so Coal processing 2 isn't a dead end
-- Probably will want this for Carbon monoxide
bobmods.lib.tech.add_prerequisite('gas-synthesis', 'angels-coal-processing-2')

-- Move Manganese down a tier
-- T1:
bobmods.lib.tech.remove_science_pack('angels-manganese-smelting-1', 'logistic-science-pack')
bobmods.lib.tech.replace_prerequisite('angels-manganese-smelting-1', 'angels-metallurgy-2', 'angels-metallurgy-1')
bobmods.lib.tech.add_prerequisite('angels-manganese-smelting-1', 'angels-iron-smelting-1')
lib.moveeffect('molten-iron-smelting-2', 'angels-iron-smelting-2', 'angels-manganese-smelting-1')
data.raw.recipe['molten-iron-smelting-2'].category = 'induction-smelting'

-- T2:
bobmods.lib.tech.remove_science_pack('angels-manganese-smelting-2', 'chemical-science-pack')
bobmods.lib.tech.replace_prerequisite('angels-manganese-smelting-2', 'ore-processing-2', 'ore-processing-1')
bobmods.lib.tech.replace_prerequisite('angels-steel-smelting-2', 'angels-manganese-smelting-1', 'angels-manganese-smelting-2')
bobmods.lib.tech.replace_prerequisite('angels-aluminium-smelting-2', 'angels-manganese-smelting-1', 'angels-manganese-smelting-2')

-- T3:
bobmods.lib.tech.remove_science_pack('angels-manganese-smelting-3', 'production-science-pack')
bobmods.lib.tech.replace_prerequisite('angels-manganese-smelting-3', 'ore-processing-3', 'ore-processing-2')
bobmods.lib.tech.replace_prerequisite('angels-titanium-smelting-2', 'angels-manganese-smelting-2', 'angels-manganese-smelting-3')
