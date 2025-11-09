seablock = seablock or {}

require("starting-items")
require("remote")

function seablock.give_research(force)
  if not force.technologies["sb-startup1"].researched then
    force.add_research("sb-startup1")
  end
end

function seablock.create_rock_chest(surface, pos)
  local has_items = false

  if storage.starting_items and (not game.is_multiplayer()) then
    for item, quantity in pairs(storage.starting_items) do
      if quantity > 0 then
        has_items = true
        break
      end
    end
  end

  if has_items then
    local chest = surface.create_entity({ name = "sb-rock-chest", position = pos, force = game.forces.neutral })
    for item, quantity in pairs(storage.starting_items) do
      if quantity > 0 then
        chest.insert({ name = item, count = quantity })
      end
    end
  end
end

function seablock.have_item(player, itemname, crafted)
  local unlock = storage.unlocks[itemname]
  -- Special case for basic-circuit because it is part of starting equipment
  if unlock and (itemname ~= "bob-basic-circuit-board" or crafted) then
    for _, v in ipairs(unlock) do
      if player.force.technologies[v] then
        player.force.technologies[v].researched = true
      end
    end
  end
end

local function set_pvp()
  if remote.interfaces.pvp then
    remote.call("pvp", "set_config", { silo_offset = { x = 16, y = 16 } })
  end
end

local function init()
  set_pvp()
  storage.starting_items = seablock.populate_starting_items(prototypes.item)
  if remote.interfaces.freeplay then
    if remote.interfaces.freeplay.set_disable_crashsite then
      remote.call("freeplay", "set_disable_crashsite", true)
    end
  end
  storage.unlocks = {
    ["angels-ore3-crushed"] = { "sb-startup1", "angels-bio-wood-processing" },
    ["bob-basic-circuit-board"] = { "sb-startup3", "sct-lab-t1" },
  }
  if prototypes.technology["sct-automation-science-pack"] then
    storage.unlocks["lab"] = { "sct-automation-science-pack" }
  else
    storage.unlocks["lab"] = { "sb-startup4" }
  end

  if remote.interfaces["freeplay"] then
    local created_items = remote.call("freeplay", "get_created_items")
    created_items["iron-plate"] = nil
    created_items["burner-mining-drill"] = nil
    created_items["burner-ore-crusher"] = nil
    created_items["stone-furnace"] = nil
    created_items["iron-plate"] = nil
    created_items["wood"] = nil
    remote.call("freeplay", "set_created_items", created_items)
  end
end

script.on_event(defines.events.on_player_joined_game, function(e)
  seablock.give_research(game.players[e.player_index].force)
end)

script.on_event(defines.events.on_force_created, function(e)
  seablock.give_research(e.force)
end)

script.on_event(defines.events.on_chunk_generated, function(e)
  local surface = e.surface
  if surface.name ~= "nauvis" and surface.name:sub(1, 14) ~= "battle_surface" then
    return
  end
  local ltx = e.area.left_top.x
  local lty = e.area.left_top.y
  local rbx = e.area.right_bottom.x
  local rby = e.area.right_bottom.y
  for _, pos in pairs(surface.map_gen_settings.starting_points) do
    if pos.x >= ltx and pos.y >= lty and pos.x < rbx and pos.y < rby then
      seablock.create_rock_chest(surface, pos)
    end
  end
end)

script.on_event(defines.events.on_player_crafted_item, function(e)
  local player = game.players[e.player_index]
  if e.item_stack.valid_for_read then
    seablock.have_item(player, e.item_stack.name, true)
  end
end)

script.on_event(defines.events.on_picked_up_item, function(e)
  local player = game.players[e.player_index]
  if e.item_stack.valid_for_read then
    seablock.have_item(player, e.item_stack.name, false)
  end
end)

script.on_event(defines.events.on_player_cursor_stack_changed, function(e)
  local player = game.players[e.player_index]
  if player.cursor_stack and player.cursor_stack.valid_for_read then
    seablock.have_item(player, player.cursor_stack.name, false)
  end
end)

script.on_event(defines.events.on_player_main_inventory_changed, function(e)
  local player = game.players[e.player_index]
  local inv = player.get_inventory(defines.inventory.character_main)
  if not inv then -- Compatibility with BlueprintLab_Bud17
    return
  end
  for k, v in pairs(storage.unlocks) do
    for _, v2 in ipairs(v) do
      if
        player.force.technologies[v2]
        and not player.force.technologies[v2].researched
        and inv.get_item_count(k) > 0
      then
        seablock.have_item(player, k, false)
      end
    end
  end
end)

script.on_init(init)

script.on_configuration_changed(function(cfg)
  init()
  -- Heavy handed fix for mods that forget migration scripts
  for _, force in pairs(game.forces) do
    force.reset_technologies()
    force.reset_recipes()
    for tech_name, tech in pairs(force.technologies) do
      if tech.researched then
        for tech_name, effect in pairs(tech.prototype.effects) do
          if effect.type == "unlock-recipe" then
            force.recipes[effect.recipe].enabled = true
          end
        end
      end
      if prototypes.technology[tech_name].enabled then
        force.technologies[tech_name].enabled = true
      end
    end
    if force.technologies["kovarex-enrichment-process"] then
      force.technologies["kovarex-enrichment-process"].enabled = true
    end

    if
      force.technologies["sct-automation-science-pack"]
      and force.technologies["sb-startup4"]
      and force.technologies["sb-startup4"].researched
    then
      force.technologies["sct-lab-t1"].researched = true
      force.technologies["sct-automation-science-pack"].researched = true
    end
  end
end)

script.on_load(function()
  set_pvp()
end)

script.on_event(defines.events.on_player_created, function(e)
  if storage.starting_items and game.is_multiplayer() then
    local inv = game.players[e.player_index].get_main_inventory()
    for item, quantity in pairs(storage.starting_items) do
      if quantity > 0 then
        inv.insert({ name = item, count = quantity })
      end
    end
  end
end)

if script.active_mods["Companion_Drones"] then
  script.on_event(defines.events.on_player_created, function(e)
    local s = game.surfaces["nauvis"]
    if s then
      local companions = s.find_entities_filtered({ name = "companion" })
      for _, companion in pairs(companions) do
        local inventory = companion.get_main_inventory()
        local i = companion.remove_item("coal")
        -- Only do drone inventory cleanup if coal is found
        -- Else players will get free wood pellets any time a new player joins
        if i > 0 then
          companion.insert("wood-pellets")
          local grid = companion.grid
          for _, item in pairs(grid.equipment) do
            if (item.name == "companion-defense-equipment") or (item.name == "companion-shield-equipment") then
              grid.take({ equipment = item })
            end
          end
        end
      end
    end
  end)
end

script.on_load(function()
  set_pvp()
end)

script.on_event(defines.events.on_player_created, function(e)
  if storage.starting_items and game.is_multiplayer() then
    local inv = game.players[e.player_index].get_main_inventory()
    for item, quantity in pairs(storage.starting_items) do
      if quantity > 0 then
        inv.insert({ name = item, count = quantity })
      end
    end
  end

  if script.active_mods["Companion_Drones"] then
    local s = game.surfaces["nauvis"]
    if s then
      local companions = s.find_entities_filtered({ name = "companion" })
      for _, companion in pairs(companions) do
        companion.remove_item("coal")
        companion.insert("wood-pellets")
        local grid = companion.grid
        for _, item in pairs(grid.equipment) do
          if (item.name == "companion-defense-equipment") or (item.name == "companion-shield-equipment") then
            grid.take({ equipment = item })
          end
        end
      end
    end
  end
end)
