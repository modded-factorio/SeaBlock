seablock = seablock or {}

require "starting-items"

function seablock.give_research(force)
  if not force.technologies['sb-startup1'].researched then
    force.add_research("sb-startup1")
  end
end

function seablock.give_items(entity)
  for _,v in pairs(global.starting_items) do
    entity.insert{name = v[1], count = v[2]}
  end
end

local function set_pvp()
  if remote.interfaces.pvp then
    remote.call("pvp", "set_config", {silo_offset = {x = 16, y = 16}})
  end
end

local function init()
  set_pvp()
  seablock.populate_starting_items(global, game.item_prototypes)
  if remote.interfaces.freeplay and remote.interfaces.freeplay.set_disable_crashsite then
    remote.call("freeplay", "set_disable_crashsite", true)
  end
  global.unlocks = {
    ['angels-ore3-crushed'] = {'sb-startup1', 'landfill'},
    ['algae-brown'] = {'sb-startup2', 'bio-wood-processing', 'bio-paper-1'},
    ['basic-circuit-board'] = {'sb-startup3', 'sct-lab-t1'},
  }
  if game.technology_prototypes['sct-automation-science-pack'] then
    global.unlocks['lab'] = {'sct-automation-science-pack'}
  else
    global.unlocks['lab'] = {'sb-startup4'}
  end

  if remote.interfaces["freeplay"] then
    local created_items = remote.call("freeplay", "get_created_items")
    created_items['iron-plate'] = nil
    created_items['burner-mining-drill'] = nil
    created_items['burner-ore-crusher'] = nil
    created_items['stone-furnace'] = nil
    created_items['iron-plate'] = nil
    created_items['wood'] = nil
    remote.call("freeplay", "set_created_items", created_items)
  end

  -- Add event handlers
  script.on_event(defines.events.on_player_joined_game,
    function(e)
      seablock.give_research(game.players[e.player_index].force)
    end
  )

  script.on_event(defines.events.on_force_created,
    function(e)
      seablock.give_research(e.force)
    end
  )

  script.on_event(defines.events.on_chunk_generated,
    function(e)
      local surface = e.surface;
      if surface.name ~= "nauvis" and surface.name:sub(1, 14) ~= "battle_surface" then
        return
      end
      local ltx = e.area.left_top.x
      local lty = e.area.left_top.y
      local rbx = e.area.right_bottom.x
      local rby = e.area.right_bottom.y
      for k,v in pairs(surface.map_gen_settings.starting_points) do
        if v.x >= ltx and v.y >= lty and v.x < rbx and v.y < rby then
          local chest = surface.create_entity({name = "rock-chest", position = v, force = game.forces.neutral})
          seablock.give_items(chest)
          script.on_event(defines.events.on_chunk_generated, nil)
        end
      end
    end
  )

  script.on_event(defines.events.on_player_crafted_item,
    function(e)
      local player = game.players[e.player_index]
      if e.item_stack.valid_for_read then
        seablock.haveitem(player, e.item_stack.name, true)
      end
    end
  )

  script.on_event(defines.events.on_picked_up_item,
    function(e)
      local player = game.players[e.player_index]
      if e.item_stack.valid_for_read then
        seablock.haveitem(player, e.item_stack.name, false)
      end
    end
  )

  script.on_event(defines.events.on_player_cursor_stack_changed,
    function(e)
      local player = game.players[e.player_index]
      if player.cursor_stack and player.cursor_stack.valid_for_read then
        seablock.haveitem(player, player.cursor_stack.name, false)
      end
    end
  )

  script.on_event(defines.events.on_player_main_inventory_changed,
    function(e)
      local player = game.players[e.player_index]
      local inv = player.get_inventory(defines.inventory.character_main)
      if not inv then -- Compatibility with BlueprintLab_Bud17
        return
      end
      for k,v in pairs(global.unlocks) do
        for _,v2 in ipairs(v) do
          if player.force.technologies[v2] and not player.force.technologies[v2].researched and inv.get_item_count(k) > 0 then
            seablock.haveitem(player, k, false)
          end
        end
      end
    end
  )
end

local function check_tutorial_complete(player)
  -- Check if all tutorial techs have been unlocked
  -- If so, unsubscribe from events
  local I = 0
  for item,techs in pairs(global.unlocks) do
    for _,tech in pairs(techs) do
      if not player.force.technologies[tech].researched then
        I = I + 1
      end
    end
  end
  
  if I == 0 then 
    script.on_event(defines.events.on_player_crafted_item, nil)
    script.on_event(defines.events.on_picked_up_item, nil)
    script.on_event(defines.events.on_player_cursor_stack_changed, nil)
    script.on_event(defines.events.on_player_main_inventory_changed, nil)
    script.on_event(defines.events.on_player_joined_game, nil)
    script.on_event(defines.events.on_force_created, nil)
  end
end

function seablock.haveitem(player, itemname, crafted)
  local unlock = global.unlocks[itemname]
  -- Special case for basic-circuit because it is part of starting equipment
  if unlock and (itemname ~= 'basic-circuit-board' or crafted) then
    for _,v in ipairs(unlock) do
      if player.force.technologies[v] then
        player.force.technologies[v].researched = true
        check_tutorial_complete(player)
      end
    end
  end
end

script.on_init(init)
script.on_configuration_changed(
  function(cfg)
    init()
    -- Heavy handed fix for mods that forget migration scripts
    for _, force in pairs(game.forces) do
      force.reset_technologies()
      force.reset_recipes()
      for _,tech in pairs(force.technologies) do
        if tech.researched then
          for _, effect in pairs(tech.effects) do
            if effect.type == "unlock-recipe" then
              force.recipes[effect.recipe].enabled = true
            end
          end
        end
      end
      if force.technologies['kovarex-enrichment-process'] then
        force.technologies['kovarex-enrichment-process'].enabled = true
      end
    end
  end
)

script.on_load(
  function()
    set_pvp()
  end
)
