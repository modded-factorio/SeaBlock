-- Remove empty bob's techs
bobmods.lib.tech.remove_prerequisite('lithium-processing', 'electrolysis-1')
bobmods.lib.tech.replace_prerequisite('lithium-processing', 'chemical-processing-1', 'chlorine-processing-3')
bobmods.lib.tech.add_new_science_pack('lithium-processing', 'chemical-science-pack', 1)

bobmods.lib.tech.remove_prerequisite('plastics', 'electrolysis-2')
bobmods.lib.tech.remove_prerequisite('cobalt-processing', 'chemical-processing-2')
bobmods.lib.tech.remove_prerequisite('silicon-processing', 'chemical-processing-2')

data.raw.technology['electrolysis-1'].hidden = true
data.raw.technology['electrolysis-2'].hidden = true
data.raw.technology['chemical-processing-1'].hidden = true
data.raw.technology['chemical-processing-2'].hidden = true
