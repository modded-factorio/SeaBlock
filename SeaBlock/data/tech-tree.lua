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
