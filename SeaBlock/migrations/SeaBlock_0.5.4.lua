for _,v in pairs({
  'angels-platinum-smelting-1',
  'angels-platinum-smelting-2',
  'angels-platinum-smelting-3'
}) do
  if game.forces['player'].technologies[v] then
    game.forces['player'].technologies[v].enabled = true
  end
end
