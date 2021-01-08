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
