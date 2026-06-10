data:extend({
  {
    type = "pipe",
    name = "sb-stone-pipe",
    icon = "__boblogistics__/graphics/icons/pipe/stone-pipe.png",
    icon_size = 64,
    flags = { "placeable-neutral", "player-creation" },
    minable = { mining_time = 0.3, result = "sb-stone-pipe" },
    max_health = 100,
    corpse = "small-remnants",
    icon_draw_specification = { scale = 0.5 },
    resistances = {
      {
        type = "fire",
        percent = 90,
      },
    },
    fast_replaceable_group = "pipe",
    collision_box = { { -0.29, -0.29 }, { 0.29, 0.29 } },
    selection_box = { { -0.5, -0.5 }, { 0.5, 0.5 } },
    fluid_box = {
      volume = 100,
      pipe_connections = {
        { position = { 0, 0 }, direction = defines.direction.north },
        { position = { 0, 0 }, direction = defines.direction.east },
        { position = { 0, 0 }, direction = defines.direction.south },
        { position = { 0, 0 }, direction = defines.direction.west },
      },
      hide_connection_info = true,
    },
    pictures = bobmods.logistics.pipepictures("stone"),
    impact_category = "metal",
    working_sound = {
      sound = {
        {
          filename = "__base__/sound/pipe.ogg",
          volume = 0.65,
        },
      },
      match_volume_to_activity = true,
      max_sounds_per_prototype = 3,
    },
    horizontal_window_bounding_box = { { -0.25, -0.25 }, { 0.25, 0.15625 } },
    vertical_window_bounding_box = { { -0.28125, -0.5 }, { 0.03125, 0.125 } },
  },
  {
    type = "pipe-to-ground",
    name = "sb-stone-pipe-to-ground",
    icon = "__boblogistics__/graphics/icons/pipe/stone-pipe-to-ground.png",
    icon_size = 64,
    flags = { "placeable-neutral", "player-creation" },
    minable = { mining_time = 0.3, result = "sb-stone-pipe-to-ground" },
    max_health = 150,
    corpse = "small-remnants",
    icon_draw_specification = { scale = 0.5 },
    resistances = {
      {
        type = "fire",
        percent = 80,
      },
    },
    fast_replaceable_group = "pipe",
    collision_box = { { -0.29, -0.29 }, { 0.29, 0.2 } },
    selection_box = { { -0.5, -0.5 }, { 0.5, 0.5 } },
    fluid_box = {
      volume = 100,
      pipe_covers = bobmods.logistics.pipecoverspictures("stone"),
      pipe_connections = {
        { position = { 0, 0 }, direction = defines.direction.north },
        {
          position = { 0, 0 },
          direction = defines.direction.south,
          connection_type = "underground",
          max_underground_distance = 10,
        },
      },
      hide_connection_info = true,
    },
    pictures = bobmods.logistics.pipetogroundpictures("stone"),
    visualization = bobmods.logistics.pipetoground_visualization(),
    disabled_visualization = bobmods.logistics.pipetoground_disabled_visualizaton(),
    impact_category = "metal",
  },
})
