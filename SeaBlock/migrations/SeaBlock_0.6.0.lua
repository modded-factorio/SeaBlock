local angelsmods = require("__angelsrefining__/prototypes/migration-functions")

for _, surface in pairs(game.surfaces) do
  for chunk in surface.get_chunks() do
    angelsmods.migration.replace_item(surface.find_entities(chunk.area), {
      ["angels-crushed-stone"] = "stone",
    })
  end
end
