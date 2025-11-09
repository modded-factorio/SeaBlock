-- Washing plant sulfur byproduct
local washing_fluid_box = { --TODO: check correctness of washing plant fluid box
  production_type = "output",
  pipe_covers = pipecoverspictures(),
  --base_level = 1,
  volume = 100, --TODO: decide the correct value
  pipe_connections = { { position = { -2, 0 }, flow_direction = "output", direction = defines.direction.west } },
}
for _, v in pairs({ "", "-2", "-3", "-4" }) do
  local washingplant = data.raw["assembling-machine"]["angels-washing-plant" .. v]
  if washingplant then
    table.insert(washingplant.fluid_boxes, washing_fluid_box)
  end
end
seablock.lib.addresult("angels-water-heavy-mud", { type = "fluid", name = "angels-gas-hydrogen-sulfide", amount = 2 })

-- Sulfuric acid prerequisites
bobmods.lib.tech.add_prerequisite("angels-sulfur-processing-1", "angels-water-washing-1")

-- Sulfur 1 tech: Remove prerequisite Advanced lead smelting 1
bobmods.lib.tech.remove_prerequisite("angels-sulfur-processing-1", "angels-lead-smelting-1")

-- Move Sulfur Dioxide Gas from Sulfur processing 2 to Sulfur processing 1
bobmods.lib.tech.remove_recipe_unlock("angels-sulfur-processing-2", "angels-gas-sulfur-dioxide")
bobmods.lib.tech.add_recipe_unlock("angels-sulfur-processing-1", "angels-gas-sulfur-dioxide")

-- Move Sulfur from Sulfur processing 3 to Sulfur processing 1
bobmods.lib.tech.remove_recipe_unlock("angels-sulfur-processing-3", "angels-solid-sulfur")
bobmods.lib.tech.add_recipe_unlock("angels-sulfur-processing-1", "angels-solid-sulfur")

-- Sulfur is now available sooner so no longer need Sulfur 2 as a prerequisite
-- Basic chem 2 isn't strictly required but don't want too many techs to depend directly on Green Science tech
bobmods.lib.tech.remove_prerequisite("explosives", "angels-sulfur-processing-2")
bobmods.lib.tech.add_prerequisite("explosives", "angels-basic-chemistry-2")

bobmods.lib.tech.remove_prerequisite("battery", "angels-sulfur-processing-2")

-- Combine Sulfur 3 and 4 and move to Blue Science
seablock.lib.add_recipe_unlock("angels-sulfur-processing-3", "angels-filter-lime", 1)
seablock.lib.add_recipe_unlock("angels-sulfur-processing-3", "angels-sulfur-air-scrubbing", 2)
seablock.lib.add_recipe_unlock("angels-sulfur-processing-3", "angels-filter-lime-used-recycling", 3)

bobmods.lib.tech.hide("angels-sulfur-processing-4")
bobmods.lib.tech.add_new_science_pack("angels-sulfur-processing-3", "chemical-science-pack", 1)
bobmods.lib.tech.add_prerequisite("angels-sulfur-processing-3", "angels-advanced-chemistry-2")
