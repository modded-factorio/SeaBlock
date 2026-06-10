data:extend({
  {
    type = "item",
    name = "sb-catalyst-metal-purple",
    icon = "__SeaBlock__/graphics/icons/catalyst-metal-purple.png",
    icon_size = 32,
    subgroup = "angels-petrochem-catalysts",
    order = "c[catalyst-metal]-d[purple]",
    stack_size = 200,
  },
  {
    type = "item",
    name = "sb-stone-pipe",
    icon = "__boblogistics__/graphics/icons/pipe/stone-pipe.png",
    icon_size = 64,
    subgroup = "bob-pipe",
    order = "a[pipe]-a[pipe]-1-0",
    place_result = "sb-stone-pipe",
    stack_size = 100,
    drop_sound = {
      filename = "__base__/sound/item/metal-small-inventory-move.ogg",
      volume = 0.8,
    },
    inventory_move_sound = {
      filename = "__base__/sound/item/metal-small-inventory-move.ogg",
      volume = 0.8,
    },
    pick_sound = {
      filename = "__base__/sound/item/metal-small-inventory-pickup.ogg",
      volume = 0.8,
    },
    weight = 5000,
  },
  {
    type = "item",
    name = "sb-stone-pipe-to-ground",
    icon = "__boblogistics__/graphics/icons/pipe/stone-pipe-to-ground.png",
    icon_size = 64,
    subgroup = "bob-pipe-to-ground",
    order = "a[pipe]-b[pipe-to-ground]-1-0",
    place_result = "sb-stone-pipe-to-ground",
    stack_size = 50,
    drop_sound = {
      filename = "__base__/sound/item/metal-small-inventory-move.ogg",
      volume = 0.8,
    },
    inventory_move_sound = {
      filename = "__base__/sound/item/metal-small-inventory-move.ogg",
      volume = 0.8,
    },
    pick_sound = {
      filename = "__base__/sound/item/metal-small-inventory-pickup.ogg",
      volume = 0.8,
    },
    weight = 20000,
  },
})
