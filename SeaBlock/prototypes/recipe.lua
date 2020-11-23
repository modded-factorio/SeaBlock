data:extend({
  {
    type = "recipe",
    name = "sb-wood-bricks-charcoal",
    category = "smelting",
    enabled = false,
    energy_required = 3.5,
    ingredients = {{"wood-bricks", 1}},
    result = "wood-charcoal",
    result_count = 5,
    subgroup = "petrochem-coal"
  },
  {
    type = "recipe",
    name = "thermal-bore-water",
    category = "thermal-bore",
    subgroup = "water-treatment",
    order = "h[thermal-bore-water]",
    energy_required = 10,
    enabled = false,
    ingredients = {
      {type = "item", name = "lithium-chloride", amount = 1}
    },
    results = {
      {type = "fluid", name = "thermal-water", amount = 5}
    }
  },
  {
    type = "recipe",
    name = "thermal-extractor-water",
    category = "thermal-extractor",
    subgroup = "water-treatment",
    order = "h[thermal-extractor-water]",
    energy_required = 5,
    enabled = false,
    ingredients = {
      {type = "fluid", name = "steam", amount = 100},
      {type = "item", name = "lithium-chloride", amount = 2}
    },
    results = {
      {type = "fluid", name = "thermal-water", amount = 100}
    }
  },
  {
    type = "recipe",
    name = "sb-water-mineralized-crystallization",
    category = "crystallizing",
    subgroup = "slag-processing-1",
    order = "z[slag-processing]",
    enabled = true,
    energy_required = 2,
    ingredients = {
      {type = "fluid", name = "water-mineralized", amount = 200}
    },
    results = {
      {type = "item", name = "angels-ore1", amount = 2, probability = 0.55},
      {type = "item", name = "angels-ore3", amount = 1, probability = 0.7},
    },
    icons = {
      { icon = data.raw.item['angels-ore3'].icon, icon_size = data.raw.item['angels-ore3'].icon_size, scale = 0.5, shift = { 4, 4 } },
      { icon = data.raw.item['angels-ore1'].icon, icon_size = data.raw.item['angels-ore1'].icon_size, scale = 0.5, shift = { -4, -4 }}
    },
    icon_size = 32
  },
  {
    type = "recipe",
    name = "sb-cellulose-foraging",
    localised_name = {"recipe-name.sb-cellulose-foraging"},
    category = "crafting-handonly",
    subgroup = "bio-processing-green",
    enabled = true,
    energy_required = 2,
    ingredients = {},
    results = {
      {type = "item", name = "cellulose-fiber", amount = 1}
    },
    order = "ab[sb-cellulose-foraging]"
  },
  {
    -- Balance assuming blue algae is about equal to green algae in MJ value.
    -- 1 blue cellulose = 2MJ (1 green cellulose = 1MJ but converting to wood pellets doubles it.
    --   Wrong, but I'll stick with it to avoid increasing the cost of all petrochem recipes)
    -- Now for multi phase oil MJ value:
    -- 100 naphtha = 50MJ
    -- 50 fuel oil = 50MJ
    -- basic oil refining is 100 crude oil -> 30 fuel oil + 50 naphtha (and other stuff i'll ignore)
    -- 100 crude oil = 30MJ (fuel oil) + 25MJ (naphtha) = 55MJ
    -- 100 multiphase oil = 55*70/100 = 38.5 MJ.
    -- Let's round that up to 40MJ or 20 blue cellulose fiber.
    -- This is being generous, haven't counted natural gas liquids and base mineral oil.

    -- 100 sulfuric waste water -> 40 blue algae
    -- 40 blue algae -> 20 blue cellulose
    -- 20 blue cellulose -> 100 multi phase oil + 60 sulfuric waste water
    -- 100 multi phase oil -> 10 sulfuric waste water
    -- 70% of sulfuric waste water is recycled
    -- Almost forgot +20 raw gas
    -- 20 raw gas -> 4 acid gas
    -- 4 acid gas -> 2.4 hydrogen sulfide
    -- 2.4 hydrogen sulfide -> 0.12 sulfur
    -- 0.12 sulfur -> 7.2 sulfur dioxide
    -- 7.2 sulfur dioxide -> 4.8 sulfuric acid
    -- 4.8 sulfuric acid -> 16 slag slurry
    -- 16 slag slurry -> 12.8 sulfuric waste water (coal filtering)
    -- So closer to 80% sulfur return
    type = "recipe",
    name = "sb-blue-algae-liquefaction",
    localised_name = {"recipe-name.sb-blue-algae-liquefaction",
      {"fluid-name.liquid-multi-phase-oil"}, {"fluid-name.water-yellow-waste"}, {"fluid-name.gas-carbon-dioxide"}},
    icon = "__angelspetrochem__/graphics/icons/liquid-multi-phase-oil.png",
    icon_size = 32,
    category = "oil-processing",
    enabled = false,
    energy_required = 5,
    ingredients = {
      {type = "item", name = "blue-cellulose-fiber", amount = 20},
      {type = "fluid", name = "steam", amount = 100}
    },
    results = {
      {type = "fluid", name = "liquid-multi-phase-oil", amount = 100},
      {type = "fluid", name = "water-yellow-waste", amount = 60},
      {type = "fluid", name = "gas-carbon-dioxide", amount = 20}
    },
    subgroup = "bio-processing-blue",
    order = "d[blue-algae-liquefaction]"
  }
})

table.insert(data.raw.technology['angels-oil-processing'].prerequisites, 'bio-processing-blue')
table.insert(data.raw.technology['angels-oil-processing'].effects,
  {type = "unlock-recipe", recipe = "sb-blue-algae-liquefaction"})
