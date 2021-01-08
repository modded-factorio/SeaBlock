local lib = require "lib"

-- Move garden duplication recipes to a tech that doesn't require bio science

lib.moveeffect('desert-garden-cultivating-b', 'bio-desert-farm', 'bio-farm-alien')
lib.moveeffect('swamp-garden-cultivating-b', 'bio-swamp-farm', 'bio-farm-alien')
lib.moveeffect('temperate-garden-cultivating-b', 'bio-temperate-farm', 'bio-farm-alien')

bobmods.lib.tech.remove_prerequisite('bio-desert-farm', 'bio-farm-alien')
bobmods.lib.tech.remove_prerequisite('bio-swamp-farm', 'bio-farm-alien')
bobmods.lib.tech.remove_prerequisite('bio-temperate-farm', 'bio-farm-alien')
