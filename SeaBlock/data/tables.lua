-- seablock.scripted_techs
-- Techs here are expected to be unlocked by the tutorial system
-- They will not have prerequisites added
seablock.scripted_techs = {
  ['sb-startup1'] = true,
  ['landfill'] = true,
  ['sb-startup2'] = true,
  ['bio-paper-1'] = true,
  ['bio-wood-processing'] = true,
  ['sb-startup3'] = true,
  ['sb-startup4'] = true
}

if data.raw.technology['sct-lab-t1'] then
  seablock.scripted_techs['sct-lab-t1'] = true
end
if data.raw.technology['sct-automation-science-pack'] then
  seablock.scripted_techs['sct-automation-science-pack'] = true
end

-- seablock.startup_techs
-- These techs will depend on the final startup tech
-- Their time will be standardized to 15 and they  will ignore tech cost modifier
-- If {true} then thir cost will be set to 20 red science
-- Any other tech with no prerequisites will depend on Slag Processing 1
seablock.startup_techs = {
  ['automation'] = {true},
  ['optics'] = {true},
  ['basic-chemistry'] = {true},
  ['military'] = {true},
  ['angels-sulfur-processing-1'] = {true},
  ['water-washing-1'] = {true},
  ['slag-processing-1'] = {true},
  ['angels-fluid-control'] = {true},
  ['bio-wood-processing-2'] = {true},
  -- Don't reduce the science pack cost of green algae
  ['bio-processing-green'] = {false},
  ['long-inserters-1'] = {true}
}

if data.raw.technology['logistics-0'] then
  seablock.startup_techs['logistics-0'] = {true}
else
  seablock.startup_techs['logistics'] = {true}
end
if data.raw.technology['basic-automation'] then
  seablock.startup_techs['basic-automation'] = {true}
end

-- seablock.startup_recipes
-- These recipes will be available at the start of the game
seablock.startup_recipes = {
  ['angels-electrolyser'] = true,
  ['liquifier'] = true,
  ['offshore-pump'] = true,
  ['angels-flare-stack'] = true,
  ['burner-ore-crusher'] = true,
  ['stone-crushed'] = true,
  ['stone-brick'] = true,
  ['crystallizer'] = true,
  ['dirt-water-separation'] = true,
  ['sb-cellulose-foraging'] = true,
  ['sb-water-mineralized-crystallization'] = true,
  ['slag-processing-stone'] = true,
  ['water-mineralized'] = true,
  ['stone-pipe'] = true,
  ['stone-pipe-to-ground'] = true
}

if settings.startup['bobmods-assembly-multipurposefurnaces'] and settings.startup['bobmods-assembly-multipurposefurnaces'].value then
  seablock.startup_recipes['stone-mixing-furnace'] = true
end

-- seablock.final_scripted_tech
-- Startup techs will depend on this tech
seablock.final_scripted_tech = 'sb-startup4'
if data.raw.technology['sct-automation-science-pack'] then
  seablock.final_scripted_tech = 'sct-automation-science-pack'
end
