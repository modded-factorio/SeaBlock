-- Washing plant sulfur byproduct
local washing_fluid_box = {
  production_type = "output",
  pipe_covers = pipecoverspictures(),
  base_level = 1,
  pipe_connections = { { position = { -3, 0 } } },
}
for _, v in pairs({ "", "-2", "-3", "-4" }) do
  local washingplant = data.raw["assembling-machine"]["washing-plant" .. v]
  if washingplant then
    table.insert(washingplant.fluid_boxes, washing_fluid_box)
  end
end
seablock.lib.addresult("washing-1", { type = "fluid", name = "gas-hydrogen-sulfide", amount = 2 })

-- Sulfuric acid prerequisites
bobmods.lib.tech.add_prerequisite("angels-sulfur-processing-1", "water-washing-1")

-- Sulfur 1 tech: Remove prerequisite Advanced lead smelting 1
bobmods.lib.tech.remove_prerequisite("angels-sulfur-processing-1", "angels-lead-smelting-1")

-- Move Sulfur Dioxide Gas from Sulfur processing 2 to Sulfur processing 1
bobmods.lib.tech.remove_recipe_unlock("angels-sulfur-processing-2", "gas-sulfur-dioxide")
bobmods.lib.tech.add_recipe_unlock("angels-sulfur-processing-1", "gas-sulfur-dioxide")

-- Move Sulfur from Sulfur processing 3 to Sulfur processing 1
bobmods.lib.tech.remove_recipe_unlock("angels-sulfur-processing-3", "solid-sulfur")
bobmods.lib.tech.add_recipe_unlock("angels-sulfur-processing-1", "solid-sulfur")
