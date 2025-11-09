-- seablock.scripted_techs
-- Techs here are expected to be unlocked by the tutorial system
-- They will not have prerequisites added
seablock.scripted_techs = {
  ["sb-startup1"] = true,
  ["sb-startup2"] = true,
  ["angels-bio-wood-processing"] = true,
  ["sb-startup3"] = true,
  ["sb-startup4"] = true,
}

if data.raw.technology["sct-lab-t1"] then
  seablock.scripted_techs["sct-lab-t1"] = true
end
if data.raw.technology["sct-automation-science-pack"] then
  seablock.scripted_techs["sct-automation-science-pack"] = true
end

-- seablock.startup_techs
-- These techs will depend on the final startup tech
-- Their time will be standardized to 15 and they  will ignore tech cost modifier
-- If {true} then their cost will be set to 20 red science
-- Any other tech with no prerequisites will depend on Slag Processing 1
seablock.startup_techs = {
  ["angels-fluid-control"] = { true },
  ["angels-sulfur-processing-1"] = { true },
  ["automation"] = { true },
  ["angels-basic-chemistry"] = { true },
  -- Don't reduce the science pack cost of green algae
  ["angels-bio-processing-green"] = { false },
  ["angels-bio-wood-processing-2"] = { true },
  ["bob-long-inserters-1"] = { true },
  ["military"] = { true },
  ["lamp"] = { true },
  ["angels-slag-processing-1"] = { true },
  ["steam-power"] = { true },
  ["angels-water-washing-1"] = { true },
}

if data.raw.technology["logistics-0"] then
  seablock.startup_techs["logistics-0"] = { true }
else
  seablock.startup_techs["logistics"] = { true }
end

-- seablock.startup_recipes
-- These recipes will be available at the start of the game
seablock.startup_recipes = {
  ["angels-electrolyser"] = true,
  ["angels-flare-stack"] = true,
  ["angels-burner-ore-crusher"] = true,
  ["angels-crystallizer"] = true,
  ["angels-dirt-water-separation"] = true,
  ["angels-liquifier"] = true,
  ["offshore-pump"] = true,
  ["sb-wood-foraging"] = true,
  ["sb-water-mineralized-crystallization"] = true,
  ["angels-stone-from-crushed-stone"] = true,
  ["angels-stone-pipe"] = true,
  ["angels-stone-pipe-to-ground"] = true,
  ["stone-brick"] = true,
  ["angels-stone-crushed"] = true,
  ["angels-water-mineralized"] = true,
}

if
  settings.startup["bobmods-assembly-multipurposefurnaces"]
  and settings.startup["bobmods-assembly-multipurposefurnaces"].value
then
  seablock.startup_recipes["bob-stone-mixing-furnace"] = true
end

-- seablock.final_scripted_tech
-- Startup techs will depend on this tech
seablock.final_scripted_tech = "sb-startup4"
if data.raw.technology["sct-automation-science-pack"] then
  seablock.final_scripted_tech = "sct-automation-science-pack"
end

seablock.final_startup_tech = "angels-slag-processing-1"
