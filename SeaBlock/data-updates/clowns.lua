if mods['Clowns-Extended-Minerals'] then
  data:extend(
    {
      {
        type = "item-subgroup",
        name = "resource-refining-2",
        group = "resource-refining",
        order = "i-a"
      },
      {
        type = "item-subgroup",
        name = "slag-processing-2",
        group = "resource-refining",
        order = "i-b"
      },
      {
        type = "recipe",
        name = "sb-slag-processing-clowns-1",
        localised_name={"recipe-name.slag-processing", {"item-name.clown-mat", {"entity-name.clowns-ore1"}, "Ore"}},
        category = "crystallizing",
        subgroup = "slag-processing-2",
        enabled = false,
        allow_decomposition = false,
        normal = {
          energy_required = 4,
          ingredients = {
            {type = "fluid", name = "mineral-sludge", amount = 25}
          },
          results = {
            {type = "item", name = "clowns-ore1", amount = 1}
          }
        },
        expensive = {
          energy_required = 8,
          ingredients = {
            {type = "fluid", name = "mineral-sludge", amount = 50}
          },
          results = {
            {type = "item", name = "clowns-ore1", amount = 1}
          }
        },
        icon_size = 32,
        order = "a"
      },
      {
        type = "recipe",
        name = "sb-slag-processing-clowns-2",
        localised_name={"recipe-name.slag-processing", {"item-name.clown-mat", {"entity-name.clowns-ore2"}, "Ore"}},
        category = "crystallizing",
        subgroup = "slag-processing-2",
        enabled = false,
        allow_decomposition = false,
        normal = {
          energy_required = 4,
          ingredients = {
            {type = "fluid", name = "mineral-sludge", amount = 25}
          },
          results = {
            {type = "item", name = "clowns-ore2", amount = 1}
          }
        },
        expensive = {
          energy_required = 8,
          ingredients = {
            {type = "fluid", name = "mineral-sludge", amount = 50}
          },
          results = {
            {type = "item", name = "clowns-ore2", amount = 1}
          }
        },
        icon_size = 32,
        order = "b"
      },
      {
        type = "recipe",
        name = "sb-slag-processing-clowns-3",
        localised_name={"recipe-name.slag-processing", {"item-name.clown-mat", {"entity-name.clowns-ore3"}, "Ore"}},
        category = "crystallizing",
        subgroup = "slag-processing-2",
        enabled = false,
        allow_decomposition = false,
        normal = {
          energy_required = 4,
          ingredients = {
            {type = "fluid", name = "mineral-sludge", amount = 25}
          },
          results = {
            {type = "item", name = "clowns-ore3", amount = 1}
          }
        },
        expensive = {
          energy_required = 8,
          ingredients = {
            {type = "fluid", name = "mineral-sludge", amount = 50}
          },
          results = {
            {type = "item", name = "clowns-ore3", amount = 1}
          }
        },
        icon_size = 32,
        order = "c"
      },
      {
        type = "recipe",
        name = "sb-slag-processing-clowns-4",
        localised_name={"recipe-name.slag-processing", {"item-name.clown-mat", {"entity-name.clowns-ore4"}, "Ore"}},
        category = "crystallizing",
        subgroup = "slag-processing-2",
        enabled = false,
        allow_decomposition = false,
        normal = {
          energy_required = 4,
          ingredients = {
            {type = "fluid", name = "mineral-sludge", amount = 25}
          },
          results = {
            {type = "item", name = "clowns-ore4", amount = 1}
          }
        },
        expensive = {
          energy_required = 8,
          ingredients = {
            {type = "fluid", name = "mineral-sludge", amount = 50}
          },
          results = {
            {type = "item", name = "clowns-ore4", amount = 1}
          }
        },
        icon_size = 32,
        order = "d"
      },
      {
        type = "recipe",
        name = "sb-slag-processing-clowns-5",
        localised_name={"recipe-name.slag-processing", {"item-name.clown-mat", {"entity-name.clowns-ore5"}, "Ore"}},
        category = "crystallizing",
        subgroup = "slag-processing-2",
        enabled = false,
        allow_decomposition = false,
        normal = {
          energy_required = 4,
          ingredients = {
            {type = "fluid", name = "mineral-sludge", amount = 25}
          },
          results = {
            {type = "item", name = "clowns-ore5", amount = 1}
          }
        },
        expensive = {
          energy_required = 8,
          ingredients = {
            {type = "fluid", name = "mineral-sludge", amount = 50}
          },
          results = {
            {type = "item", name = "clowns-ore5", amount = 1}
          }
        },
        icon_size = 32,
        order = "e"
      },
      {
        type = "recipe",
        name = "sb-slag-processing-clowns-6",
        localised_name={"recipe-name.slag-processing", {"item-name.clown-mat", {"entity-name.clowns-ore6"}, "Ore"}},
        category = "crystallizing",
        subgroup = "slag-processing-2",
        enabled = false,
        allow_decomposition = false,
        normal = {
          energy_required = 4,
          ingredients = {
            {type = "fluid", name = "mineral-sludge", amount = 25}
          },
          results = {
            {type = "item", name = "clowns-ore6", amount = 1}
          }
        },
        expensive = {
          energy_required = 8,
          ingredients = {
            {type = "fluid", name = "mineral-sludge", amount = 50}
          },
          results = {
            {type = "item", name = "clowns-ore6", amount = 1}
          }
        },
        icon_size = 32,
        order = "f"
      },
      {
        type = "recipe",
        name = "sb-slag-processing-clowns-7",
        localised_name={"recipe-name.slag-processing", {"item-name.clown-mat", {"entity-name.clowns-ore7"}, "Ore"}},
        category = "crystallizing",
        subgroup = "slag-processing-2",
        enabled = false,
        allow_decomposition = false,
        normal = {
          energy_required = 4,
          ingredients = {
            {type = "fluid", name = "mineral-sludge", amount = 25}
          },
          results = {
            {type = "item", name = "clowns-ore7", amount = 1}
          }
        },
        expensive = {
          energy_required = 8,
          ingredients = {
            {type = "fluid", name = "mineral-sludge", amount = 50}
          },
          results = {
            {type = "item", name = "clowns-ore7", amount = 1}
          }
        },
        icon_size = 32,
        order = "g"
      },
      {
        type = "recipe",
        name = "sb-slag-processing-clowns-8",
        localised_name={"recipe-name.slag-processing", {"item-name.clown-mat", {"entity-name.clowns-ore8"}, "Ore"}},
        category = "crystallizing",
        subgroup = "slag-processing-2",
        enabled = false,
        allow_decomposition = false,
        normal = {
          energy_required = 4,
          ingredients = {
            {type = "fluid", name = "mineral-sludge", amount = 25}
          },
          results = {
            {type = "item", name = "clowns-ore8", amount = 1}
          }
        },
        expensive = {
          energy_required = 8,
          ingredients = {
            {type = "fluid", name = "mineral-sludge", amount = 50}
          },
          results = {
            {type = "item", name = "clowns-ore8", amount = 1}
          }
        },
        icon_size = 32,
        order = "h"
      },
      {
        type = "recipe",
        name = "sb-slag-processing-clowns-9",
        localised_name={"recipe-name.slag-processing", {"item-name.clown-mat", {"entity-name.clowns-ore9"}, "Ore"}},
        category = "crystallizing",
        subgroup = "slag-processing-2",
        enabled = false,
        allow_decomposition = false,
        normal = {
          energy_required = 4,
          ingredients = {
            {type = "fluid", name = "mineral-sludge", amount = 25}
          },
          results = {
            {type = "item", name = "clowns-ore9", amount = 1}
          }
        },
        expensive = {
          energy_required = 8,
          ingredients = {
            {type = "fluid", name = "mineral-sludge", amount = 50}
          },
          results = {
            {type = "item", name = "clowns-ore9", amount = 1}
          }
        },
        icon_size = 32,
        order = "i"
      },
      {
        type = "recipe",
        name = "sb-clowns-resource-1",
        category = "ore-sorting-t1",
        subgroup = "resource-refining-2",
        enabled = false,
        allow_decomposition = false,
        normal = {
          energy_required = 4,
          ingredients = {
            {type = "item", name = "solid-sand", amount = 1},
            {type = "item", name = "stone-crushed", amount = 6}
          },
          results = {
            {type = "item", name = "clowns-resource1", amount = 1}
          }
        },
        expensive = {
          energy_required = 8,
          ingredients = {
            {type = "item", name = "solid-sand", amount = 1},
            {type = "item", name = "stone-crushed", amount = 12}
          },
          results = {
            {type = "item", name = "clowns-resource1", amount = 1}
          }
        },
        icon_size = 32,
        order = "j"
      },
      {
        type = "recipe",
        name = "sb-clowns-resource-2",
        category = "ore-sorting-t1",
        subgroup = "resource-refining-2",
        enabled = false,
        allow_decomposition = false,
        normal = {
          energy_required = 4,
          ingredients = {
            {type = "item", name = "solid-sand", amount = 5},
            {type = "item", name = "blue-cellulose-fiber", amount = 1}
          },
          results = {
            {type = "item", name = "clowns-resource2", amount = 5}
          }
        },
        expensive = {
          energy_required = 8,
          ingredients = {
            {type = "item", name = "solid-sand", amount = 5},
            {type = "item", name = "blue-cellulose-fiber", amount = 2}
          },
          results = {
            {type = "item", name = "clowns-resource2", amount = 5}
          }
        },
        icon_size = 32,
        order = "k"
      }
    }
  )

  seablock.lib.add_recipe_unlock('clowns-ore-crushing', 'sb-slag-processing-clowns-9', 23)
  seablock.lib.add_recipe_unlock('clowns-ore-crushing', 'sb-slag-processing-clowns-8', 21)
  seablock.lib.add_recipe_unlock('clowns-ore-crushing', 'sb-slag-processing-clowns-7', 19)
  seablock.lib.add_recipe_unlock('clowns-ore-crushing', 'sb-slag-processing-clowns-6', 16)
  seablock.lib.add_recipe_unlock('clowns-ore-crushing', 'sb-slag-processing-clowns-5', 13)
  seablock.lib.add_recipe_unlock('clowns-ore-crushing', 'sb-slag-processing-clowns-4', 10)
  seablock.lib.add_recipe_unlock('clowns-ore-crushing', 'sb-slag-processing-clowns-3', 7)
  seablock.lib.add_recipe_unlock('clowns-ore-crushing', 'sb-slag-processing-clowns-2', 4)
  seablock.lib.add_recipe_unlock('clowns-ore-crushing', 'sb-slag-processing-clowns-1', 1)
  seablock.lib.add_recipe_unlock('water-washing-2', 'sb-clowns-resource-1')
  seablock.lib.add_recipe_unlock('oil-gas-extraction', 'sb-clowns-resource-2')
end
