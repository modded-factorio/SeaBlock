require "util"

local function regensurface(surface)
surface.regenerate_entity({'alien-fish-1', 'alien-fish-2', 'alien-fish-3'})

-- Adding puffers in a complicated way because of the complicated way
-- autoplace handles placement order and collision. 
local wormnames =
{
  'small-worm-turret',
  'medium-worm-turret',
  'big-worm-turret',
  'bob-big-explosive-worm-turret',
  'bob-big-fire-worm-turret',
  'bob-big-poison-worm-turret',
  'bob-big-piercing-worm-turret',
  'bob-big-electric-worm-turret',
  'bob-giant-worm-turret',
  'behemoth-worm-turret'
}
-- Delete all worms and save positions to restore them after puffers are created
local wormssave = {}
for _,v in pairs(surface.find_entities_filtered{name = wormnames}) do
  table.insert(wormssave, {v.name, v.position})
  v.destroy()
end

-- Regenerate all worms and puffers to get good puffer positions
local regennames = table.deepcopy(wormnames)
table.insert(regennames, "puffer-nest")
surface.regenerate_entity(regennames)

-- Delete regenerated worms, they'll be in places they player has already cleared
for _,v in pairs(surface.find_entities_filtered{name = wormnames}) do
  v.destroy()
end

-- Don't want puffers spawning in already cleared worm locations
-- Prepare table to delete unwanted nests
local pufferslookup = {}
for _,v in pairs(surface.find_entities_filtered{name = 'puffer-nest'}) do
  -- puffer-nests are trees and don't have unit_number identifier. Identify them by position.
  pufferslookup[v.position.x .. " " .. v.position.y] = v
end

-- Restore worms
for _,v in pairs(wormssave) do
  if surface.can_place_entity{name=v[1], position=v[2]} then
    surface.create_entity{name=v[1], position=v[2]}
  else
    -- Can't restore worm, position is probably now occupied by a puffer nest
    local ents = surface.find_entities_filtered{area = {{x = v[2].x - 5, y = v[2].y - 5}, {x = v[2].x + 5, y = v[2].y + 5}}}
    for _, ent in pairs(ents) do
      if ent.name == 'puffer-nest' then
        -- Nest is close to worms, allow it to stay
        local str = ent.position.x .. " " .. ent.position.y
        pufferslookup[str] = nil
      end
    end
  end
end

-- Delete puffer nests that aren't near worm clusters
for _,v in pairs(pufferslookup) do
  v.destroy()
end
end

regensurface(game.surfaces['nauvis'])
if game.surfaces['battle_surface_1'] then
  regensurface(game.surfaces['battle_surface_1'])
end
