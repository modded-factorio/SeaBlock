-- Decrease amount of crushed stone for slag-slurry so it's still better than mineralized water crystallization
seablock.lib.substingredient("stone-crushed-dissolution", "stone-crushed", nil, 20)

-- Angels sludge crystalization usually gives normal smeltable ores. This would be far too easy,
-- so change recipes to give the weird ores that need extra processing steps.
for i = 1, 6 do
  local recipe = data.raw.recipe["slag-processing-" .. i]
  seablock.lib.copy_icon(recipe, {})
  recipe.localised_name = { "recipe-name.slag-processing", { "item-name.angels-ore" .. i } }
  recipe.order = "a-a [angels-ore-" .. i .. "]"

  recipe.ingredients = nil
  recipe.results = nil
  recipe.energy_required = nil
  recipe.category = "crystallizing"

  recipe.normal = {
    energy_required = 4,
    ingredients = { { type = "fluid", name = "mineral-sludge", amount = 25 } },
    results = { { type = "item", name = "angels-ore" .. i, amount = 1 } },
    enabled = false,
  }

  recipe.expensive = {
    energy_required = 8,
    ingredients = { { type = "fluid", name = "mineral-sludge", amount = 50 } },
    results = { { type = "item", name = "angels-ore" .. i, amount = 1 } },
    enabled = false,
  }
end

-- Angels ores 1, 3 (Saphirite, Stiratite) available from tutorial tech 1,
-- Angels ores 5, 6 (Rubyte, Bobmonium) available from Slag processing 1
-- Angels ores 2, 4 (Jivolite, Crotinnium) available from Advanced mechanical refining
bobmods.lib.recipe.enabled("angelsore1-crushed-smelting", false)
bobmods.lib.recipe.enabled("angelsore3-crushed-smelting", false)
seablock.lib.moveeffect("catalysator-brown", "slag-processing-1", "advanced-ore-refining-1", 3)
local slag1start = seablock.lib.findeffectidx(data.raw.technology["slag-processing-1"].effects, "slag-processing-1")
seablock.lib.moveeffect("slag-processing-5", "slag-processing-2", "slag-processing-1", slag1start + 3)
seablock.lib.moveeffect("slag-processing-6", "slag-processing-2", "slag-processing-1", slag1start + 4)

local slag2start = 0
seablock.lib.moveeffect("slag-processing-2", "slag-processing-1", "ore-advanced-crushing", slag2start + 1)
seablock.lib.moveeffect("slag-processing-4", "slag-processing-2", "ore-advanced-crushing", slag2start + 2)
seablock.lib.moveeffect("angelsore2-crushed", "ore-crushing", "ore-advanced-crushing", slag2start + 3)
seablock.lib.moveeffect("angelsore4-crushed", "ore-crushing", "ore-advanced-crushing", slag2start + 4)

seablock.lib.add_recipe_unlock("ore-crushing", "angelsore5-crushed", 3)
seablock.lib.add_recipe_unlock("ore-crushing", "angelsore6-crushed", 4)
seablock.lib.add_recipe_unlock("ore-crushing", "iron-plate")
seablock.lib.add_recipe_unlock("ore-crushing", "copper-plate")
seablock.lib.add_recipe_unlock("ore-crushing", "lead-plate")
seablock.lib.add_recipe_unlock("ore-crushing", "tin-plate")
seablock.lib.add_recipe_unlock("ore-crushing", "quartz-glass")

seablock.lib.unhide_recipe("iron-plate")
seablock.lib.unhide_recipe("copper-plate")
seablock.lib.unhide_recipe("lead-plate")
seablock.lib.unhide_recipe("tin-plate")

-- Hide unwanted recipes
bobmods.lib.recipe.hide("silver-plate")
bobmods.lib.tech.remove_recipe_unlock("ore-crushing", "angelsore2-crushed-processing")
bobmods.lib.tech.remove_recipe_unlock("ore-crushing", "angelsore4-crushed-processing")
bobmods.lib.recipe.hide("angelsore2-crushed-processing")
bobmods.lib.recipe.hide("angelsore4-crushed-processing")
bobmods.lib.recipe.hide("angelsore5-crushed-smelting")
bobmods.lib.recipe.hide("angelsore6-crushed-smelting")

-- Add prerequisites
bobmods.lib.tech.add_prerequisite("ore-floatation", "ore-advanced-crushing")
bobmods.lib.tech.add_prerequisite("advanced-ore-refining-1", "ore-advanced-crushing")

-- Move Mechanical Refining under Slag Processing 1
seablock.lib.moveeffect("ore-crusher", "ore-crushing", "automation")
bobmods.lib.tech.remove_prerequisite("slag-processing-1", "ore-crushing")
bobmods.lib.tech.remove_prerequisite("slag-processing-1", "logistic-science-pack")
bobmods.lib.tech.remove_prerequisite("ore-crushing", "basic-chemistry")
bobmods.lib.tech.add_prerequisite("ore-crushing", "slag-processing-1")

-- Move crystallization ore recipes up above crushed ores
data.raw["item-subgroup"]["slag-processing-1"].order = "ab"

-- Red science level research for slag processing 1
data.raw.technology["slag-processing-1"].unit = {
  count = 20,
  ingredients = { { "automation-science-pack", 1 } },
  time = 15,
}

if data.raw["assembling-machine"]["ore-sorting-facility-4"] then
  data.raw["assembling-machine"]["ore-sorting-facility-4"].next_upgrade = "sb-ore-sorting-facility-5"
end

bobmods.lib.tech.add_prerequisite("advanced-ore-refining-2", "ore-powderizer")
bobmods.lib.tech.add_prerequisite("advanced-ore-refining-2", "advanced-electronics")
bobmods.lib.tech.add_prerequisite("advanced-ore-refining-4", "advanced-electronics-3")
bobmods.lib.tech.add_prerequisite("advanced-ore-refining-4", "angels-tungsten-smelting-1")
seablock.lib.add_recipe_unlock("advanced-ore-refining-4", "sb-ore-sorting-facility-5", 3)

local buildingmulti = angelsmods.marathon.buildingmulti
local buildingtime = angelsmods.marathon.buildingtime

angelsmods.functions.RB.build({
  {
    type = "recipe",
    name = "sb-ore-sorting-facility-5",
    normal = {
      energy_required = 5,
      enabled = false,
      ingredients = {
        { type = "item", name = "ore-sorting-facility-4", amount = 1 },
        { type = "item", name = "t5-plate", amount = 12 },
        { type = "item", name = "t5-circuit", amount = 12 },
        { type = "item", name = "t5-brick", amount = 12 },
        { type = "item", name = "t5-gears", amount = 8 },
      },
      result = "sb-ore-sorting-facility-5",
    },
    expensive = {
      energy_required = 5 * buildingtime,
      enabled = false,
      ingredients = {
        { type = "item", name = "ore-sorting-facility-4", amount = 1 },
        { type = "item", name = "t5-plate", amount = 12 * buildingmulti },
        { type = "item", name = "t5-circuit", amount = 12 * buildingmulti },
        { type = "item", name = "t5-brick", amount = 12 * buildingmulti },
        { type = "item", name = "t5-gears", amount = 8 * buildingmulti },
      },
      result = "sb-ore-sorting-facility-5",
    },
  },
})

-- Make ore sorting recipes require a higher tier ore sorting facility
for _, v in pairs({
  "angelsore1-chunk-processing",
  "angelsore2-chunk-processing",
  "angelsore3-chunk-processing",
  "angelsore4-chunk-processing",
  "angelsore5-chunk-processing",
  "angelsore6-chunk-processing",
}) do
  bobmods.lib.recipe.set_category(v, "ore-sorting-2")
end
bobmods.lib.tech.add_prerequisite("ore-floatation", "advanced-ore-refining-1")

for _, v in pairs({
  "angelsore1-crystal-processing",
  "angelsore2-crystal-processing",
  "angelsore3-crystal-processing",
  "angelsore4-crystal-processing",
  "angelsore5-crystal-processing",
  "angelsore6-crystal-processing",
}) do
  bobmods.lib.recipe.set_category(v, "ore-sorting-3")
end
bobmods.lib.tech.add_prerequisite("ore-leaching", "advanced-ore-refining-2")

for _, v in pairs({
  "angelsore1-pure-processing",
  "angelsore2-pure-processing",
  "angelsore3-pure-processing",
  "angelsore4-pure-processing",
  "angelsore5-pure-processing",
  "angelsore6-pure-processing",
}) do
  bobmods.lib.recipe.set_category(v, "ore-sorting-4")
end
bobmods.lib.tech.add_prerequisite("ore-refining", "advanced-ore-refining-3")

for _, v in pairs({
  "angelsore-pure-mix1-processing",
  "angelsore-pure-mix2-processing",
}) do
  bobmods.lib.recipe.set_category(v, "ore-sorting-5")
end

-- Slow down Ore Sorting Facilities to make space for our new top tier
data.raw["assembling-machine"]["ore-sorting-facility"].crafting_speed = 0.5
data.raw["assembling-machine"]["ore-sorting-facility-2"].crafting_speed = 0.75
data.raw["assembling-machine"]["ore-sorting-facility-3"].crafting_speed = 1.0
data.raw["assembling-machine"]["ore-sorting-facility-4"].crafting_speed = 1.5

-- Add an additional slag to the mixed sorting recipes
for _, v in pairs({
  -- Saphirite
  "angelsore1-crushed-processing",
  "angelsore1-chunk-processing",
  "angelsore1-crystal-processing",
  -- Jivolite
  "angelsore2-chunk-processing",
  "angelsore2-crystal-processing",
  -- Stiratite
  "angelsore3-crushed-processing",
  "angelsore3-chunk-processing",
  "angelsore3-crystal-processing",
  -- Crotinnium
  "angelsore4-chunk-processing",
  "angelsore4-crystal-processing",
  -- Rubyte
  "angelsore5-crushed-processing",
  "angelsore5-chunk-processing",
  "angelsore5-crystal-processing",
  -- Bobmonium
  "angelsore6-crushed-processing",
  "angelsore6-chunk-processing",
  "angelsore6-crystal-processing",
}) do
  seablock.lib.substresult(v, "slag", nil, 2)
end

--Reduce sulfuric-acid needed to dissolve slag/stone/geodes to make sulfur generation from washing a viable early game source
seablock.lib.substingredient("stone-crushed-dissolution", "sulfuric-acid", nil, 3)
seablock.lib.substingredient("slag-processing-dissolution", "sulfuric-acid", nil, 3)
seablock.lib.substingredient("geode-blue-liquify", "sulfuric-acid", nil, 3)
seablock.lib.substingredient("geode-red-liquify", "sulfuric-acid", nil, 3)
seablock.lib.substingredient("geode-yellow-liquify", "sulfuric-acid", nil, 3)
seablock.lib.substingredient("geode-purple-liquify", "sulfuric-acid", nil, 3)
seablock.lib.substingredient("geode-cyan-liquify", "sulfuric-acid", nil, 3)
seablock.lib.substingredient("geode-lightgreen-liquify", "sulfuric-acid", nil, 3)
seablock.lib.substingredient("crystal-dust-liquify", "sulfuric-acid", nil, 3)

--Reduce amount of sulfuric waste water returned on charcoal filtering to balance out the reduction in sulfuric acid consumed
seablock.lib.substresult("crystal-slurry-filtering-1", "water-yellow-waste", nil, 15)
seablock.lib.substresult("crystal-slurry-filtering-conversion-1", "water-yellow-waste", nil, 15)
seablock.lib.substresult("slag-processing-filtering-1", "water-yellow-waste", nil, 15)

--Remove sulfuric waste water from output of ceramic filtering recipies since the balanced value would become negative
bobmods.lib.recipe.remove_result("crystal-slurry-filtering-2", "water-yellow-waste")
bobmods.lib.recipe.remove_result("crystal-slurry-filtering-conversion-2", "water-yellow-waste")
bobmods.lib.recipe.remove_result("slag-processing-filtering-2", "water-yellow-waste")
