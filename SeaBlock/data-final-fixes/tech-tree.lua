-- Remove empty bob's techs
bobmods.lib.tech.remove_prerequisite('cobalt-processing', 'chemical-processing-1')
bobmods.lib.tech.remove_prerequisite('cobalt-processing', 'electrolysis-1')
bobmods.lib.tech.remove_prerequisite('lithium-processing', 'electrolysis-1')
bobmods.lib.tech.replace_prerequisite('lithium-processing', 'chemical-processing-1', 'chlorine-processing-3')
bobmods.lib.tech.add_new_science_pack('lithium-processing', 'chemical-science-pack', 1)

bobmods.lib.tech.remove_prerequisite('plastics', 'electrolysis-2')
bobmods.lib.tech.remove_prerequisite('cobalt-processing', 'chemical-processing-2')
bobmods.lib.tech.remove_prerequisite('silicon-processing', 'chemical-processing-2')

seablock.lib.hide_technology('electrolysis-1')
seablock.lib.hide_technology('electrolysis-2')
seablock.lib.hide_technology('chemical-processing-1')
seablock.lib.hide_technology('chemical-processing-2')
