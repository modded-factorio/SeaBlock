-- seablock.scripted_techs
-- Techs here are expected to be unlocked by the tutorial system
-- They will not have prerequisites added
seablock.scripted_techs = {
  ["sb-startup1"] = true,
  landfill = true,
  ["sb-startup2"] = true,
  ["bio-paper-1"] = true,
  ["bio-wood-processing"] = true,
  ["sb-startup3"] = true,
  ["sb-startup4"] = true
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
  ["angels-fluid-control"] = {true},
  ["angels-sulfur-processing-1"] = {true},
  automation = {true},
  ["basic-chemistry"] = {true},
  -- Don't reduce the science pack cost of green algae
  ["bio-processing-green"] = {false},
  ["bio-wood-processing-2"] = {true},
  ["long-inserters-1"] = {true},
  military = {true},
  optics = {true},
  ["sb-steam-power"] = {true},
  ["slag-processing-1"] = {true},
  ["water-washing-1"] = {true}
}

if data.raw.technology["logistics-0"] then
  seablock.startup_techs["logistics-0"] = {true}
else
  seablock.startup_techs["logistics"] = {true}
end

-- seablock.startup_recipes
-- These recipes will be available at the start of the game
seablock.startup_recipes = {
  ["angels-electrolyser"] = true,
  ["angels-flare-stack"] = true,
  ["burner-ore-crusher"] = true,
  crystallizer = true,
  ["dirt-water-separation"] = true,
  liquifier = true,
  ["offshore-pump"] = true,
  ["sb-cellulose-foraging"] = true,
  ["sb-water-mineralized-crystallization"] = true,
  ["slag-processing-stone"] = true,
  ["stone-pipe"] = true,
  ["stone-pipe-to-ground"] = true,
  ["stone-brick"] = true,
  ["stone-crushed"] = true,
  ["water-mineralized"] = true
}

if settings.startup["bobmods-assembly-multipurposefurnaces"] and settings.startup["bobmods-assembly-multipurposefurnaces"].value then
  seablock.startup_recipes["stone-mixing-furnace"] = true
end

-- seablock.final_scripted_tech
-- Startup techs will depend on this tech
seablock.final_scripted_tech = "sb-startup4"
if data.raw.technology["sct-automation-science-pack"] then
  seablock.final_scripted_tech = "sct-automation-science-pack"
end

seablock.final_startup_tech = "slag-processing-1"