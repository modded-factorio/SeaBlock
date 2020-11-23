seablock = {}

seablock.giveresearch = function(force)
  local techs = {
    'landfill',
    'bio-paper-1',
    'bio-processing-brown'
  }
  local newforce = force.technologies['sb-startup1'].researched == false
  for _,v in ipairs(techs) do
    force.technologies[v].researched = true
  end
  if newforce then
    force.add_research("sb-startup1")
  end
end

seablock.giveitems = function(entity)
  local landfill = 'landfill'
  if game.item_prototypes['landfill-sand-3'] then
    landfill = 'landfill-sand-3'
  end
  local stuff = {
    {landfill, 1000},
    {"stone", 50},
    {"small-electric-pole", 50},
    {"small-lamp", 12},

    {"iron-plate", 1200},
    {"basic-circuit-board", 200},
    {"stone-pipe", 100},
    {"stone-pipe-to-ground", 50},
    {"stone-brick", 500},
    {"pipe", 27},
    {"copper-pipe", 5},
    {"iron-gear-wheel", 25},
    {"iron-stick", 96},
    {"pipe-to-ground", 2},
    {"electronic-circuit", 10}
  }
  if game.item_prototypes["wind-turbine-2"] then
    table.insert(stuff, {"wind-turbine-2", 120})
  else
    table.insert(stuff, {"solar-panel", 38})
    table.insert(stuff, {"accumulator", 32})
  end
  for _,v in ipairs(stuff) do
    entity.insert{name = v[1], count = v[2]}
  end
end

script.on_event(defines.events.on_player_joined_game, function(e)
  seablock.giveresearch(game.players[e.player_index].force)
end)

script.on_event(defines.events.on_force_created, function(e)
  seablock.giveresearch(e.force)
end)

script.on_event(defines.events.on_player_created, function(e)
  local player = game.players[e.player_index]
  player.remove_item{name = 'burner-mining-drill', count = 1}
  player.remove_item{name = 'wood', count = 1}
end)

script.on_event(defines.events.on_chunk_generated, function(e)
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
      seablock.giveitems(chest)
    end
  end
end)

local function setpvp()
  if remote.interfaces.pvp then
    remote.call("pvp", "set_config", {silo_offset = {x = 16, y = 16}})
  end
end

local function init()
  setpvp()
  if remote.interfaces.freeplay and remote.interfaces.freeplay.set_disable_crashsite then
    remote.call("freeplay", "set_disable_crashsite", true)
  end
  global.unlocks = {
    ['angels-ore3-crushed'] = 'sb-startup1',
    ['basic-circuit-board'] = 'sb-startup2',
    ['algae-green'] = 'bio-wood-processing',
  }
  if game.technology_prototypes['sct-automation-science-pack'] then
    global.unlocks['lab'] = 'sct-automation-science-pack'
  else
    global.unlocks['lab'] = 'sb-startup4'
  end
end
local function haveitem(player, itemname, crafted)
  local unlock = global.unlocks[itemname]
  -- Special case for basic-circuit because it is part of starting equipment
  if unlock and (itemname ~= 'basic-circuit-board' or crafted) then
    player.force.technologies[unlock].researched = true
  end
end

script.on_event(defines.events.on_player_crafted_item, function(e)
  local player = game.players[e.player_index]
  if e.item_stack.valid_for_read then
    haveitem(player, e.item_stack.name, true)
  end
end)

script.on_event(defines.events.on_picked_up_item, function(e)
  local player = game.players[e.player_index]
  if e.item_stack.valid_for_read then
    haveitem(player, e.item_stack.name, false)
  end
end)

script.on_event(defines.events.on_player_cursor_stack_changed, function(e)
  local player = game.players[e.player_index]
  if player.cursor_stack and player.cursor_stack.valid_for_read then
    haveitem(player, player.cursor_stack.name, false)
  end
end)

script.on_event(defines.events.on_player_main_inventory_changed, function(e)
  local player = game.players[e.player_index]
  local inv = player.get_inventory(defines.inventory.character_main)
  if not inv then -- Compatibility with BlueprintLab_Bud17
    return
  end
  for k,v in pairs(global.unlocks) do
    if not player.force.technologies[v].researched and inv.get_item_count(k) > 0 then
      haveitem(player, k, false)
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
end)

script.on_load(function()
  setpvp()
end)
