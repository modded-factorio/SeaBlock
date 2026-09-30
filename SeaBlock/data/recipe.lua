-- Buff Lead 3
seablock.lib.substresult("angels-ingot-lead-3", "angels-slag", "bob-quartz", 1)
seablock.lib.substingredient("angels-ingot-lead-3", "angels-liquid-hexafluorosilicic-acid", nil, 20)

-- Compost void recipe
angelsmods.functions.make_void("angels-solid-compost", "bio", 5)

-- Remove recipe Wood pellets > Carbon dioxide
-- Move recipe Charcoal > Carbon dioxide from Basic chemistry to Wood processing 2
bobmods.lib.tech.remove_recipe_unlock("angels-bio-wood-processing-2", "angels-gas-carbon-dioxide-from-wood")
bobmods.lib.recipe.hide("angels-gas-carbon-dioxide-from-wood")
bobmods.lib.tech.remove_recipe_unlock("angels-basic-chemistry", "angels-gas-carbon-dioxide")

local function make_plate_recipe(metal_name)
end

data:extend({
  {
    type = "recipe",
    name = "sb-iron-plate-from-ore",
    ingredients = {{ type = "item", name = "iron-ore", amount = 4 }},
    results = {{ type = "item", name = "iron-plate", amount = 3 }},
    energy_required = 10.5,
    category = "smelting",
    subgroup = "angels-iron-casting",
    main_product = "iron-plate"
  },
  {
    type = "recipe",
    name = "sb-copper-plate-from-ore",
    ingredients = {{ type = "item", name = "copper-ore", amount = 4 }},
    results = {{ type = "item", name = "copper-plate", amount = 3 }},
    energy_required = 10.5,
    category = "smelting",
    subgroup = "angels-copper-casting",
    main_product = "copper-plate"
  },
  {
    type = "recipe",
    name = "sb-bob-lead-plate-from-ore",
    ingredients = {{ type = "item", name = "bob-lead-ore", amount = 4 }},
    results = {{ type = "item", name = "bob-lead-plate", amount = 3 }},
    energy_required = 10.5,
    category = "smelting",
    subgroup = "angels-lead-casting",
    main_product = "bob-lead-plate"
  },
  {
    type = "recipe",
    name = "sb-bob-tin-plate-from-ore",
    ingredients = {{ type = "item", name = "bob-tin-ore", amount = 4 }},
    results = {{ type = "item", name = "bob-tin-plate", amount = 3 }},
    energy_required = 10.5,
    category = "smelting",
    subgroup = "angels-tin-casting",
    main_product = "bob-tin-plate"
  },
  {
    type = "recipe",
    name = "sb-glass-from-ore",
    ingredients = {{ type = "item", name = "bob-quartz", amount = 10 }},
    results = {{ type = "item", name = "bob-glass", amount = 1 }},
    energy_required = 10.5,
    category = "smelting",
    subgroup = "angels-glass-casting",
    main_product = "bob-glass"
  }
})
