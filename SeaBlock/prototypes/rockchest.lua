data:extend({
  {
    type = "container",
    name = "sb-rock-chest",
    localised_name = { "entity-name.home" },
    icon = "__base__/graphics/icons/stone.png",
    icon_size = 32,
    flags = { "placeable-neutral", "player-creation" },
    order = "b[decorative]-l[rock]-a[medium]",
    minable = {
      mining_particle = "stone-particle",
      mining_time = 2,
      result = "stone",
      count = 20,
    },
    max_health = 100,
    corpse = "small-remnants",
    collision_box = { { 0.0, 0.0 }, { 0.35, 0.35 } },
    selection_box = { { -0.5, -0.5 }, { 0.5, 0.5 } },
    inventory_size = 60,
    open_sound = { filename = "__base__/sound/deconstruct-bricks.ogg" },
    close_sound = { filename = "__base__/sound/deconstruct-bricks.ogg" },
    vehicle_impact_sound = { filename = "__base__/sound/car-stone-impact.ogg", volume = 1.0 },
    picture = {
      filename = "__base__/graphics/decorative/big-rock/big-rock-18.png",
      -- width = 71, --old non hr version
      -- height = 64,
      -- shift = { 0.3125, 0.046875 },
      width = 141, --taken from the old hr version
      height = 128,
      scale = 0.5,
      shift = { 0.304688, 0.0390625 },
    },

    circuit_wire_connection_point = circuit_connector_definitions["chest"].points,
    circuit_connector_sprites = circuit_connector_definitions["chest"].sprites,
    circuit_wire_max_distance = default_circuit_wire_max_distance,
  },
})
