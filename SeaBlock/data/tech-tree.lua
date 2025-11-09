-- Add bio science to techs
if mods["SpaceMod"] then
  bobmods.lib.tech.add_new_science_pack("habitation", "angels-token-bio", 1)
  bobmods.lib.tech.add_new_science_pack("life-support-systems", "angels-token-bio", 1)
end

-- Remove empty tech Thermal water processing
bobmods.lib.tech.remove_prerequisite("angels-water-treatment-4", "angels-thermal-water-processing")
seablock.lib.hide_technology("angels-thermal-water-processing")

-- Smelting techs don't need to depend on Coal processing 2 as carbon is unlocked earlier
bobmods.lib.tech.remove_prerequisite("angels-aluminium-smelting-1", "angels-coal-processing-2")
bobmods.lib.tech.remove_prerequisite("angels-cobalt-smelting-1", "angels-coal-processing-2")
bobmods.lib.tech.remove_prerequisite("angels-lead-smelting-2", "angels-coal-processing-2")
bobmods.lib.tech.remove_prerequisite("angels-manganese-smelting-1", "angels-coal-processing")
bobmods.lib.tech.remove_prerequisite("angels-tin-smelting-2", "angels-coal-processing-2")
bobmods.lib.tech.remove_prerequisite("angels-titanium-smelting-1", "angels-coal-processing-2")
bobmods.lib.tech.remove_prerequisite("angels-zinc-smelting-2", "angels-coal-processing-2")
bobmods.lib.tech.remove_prerequisite("angels-chrome-smelting-1", "angels-coal-processing-3")
bobmods.lib.tech.remove_prerequisite("angels-iron-smelting-2", "angels-coal-processing-2")

bobmods.lib.tech.replace_prerequisite("angels-coal-processing-2", "angels-water-treatment-2", "angels-basic-chemistry-3")

-- Add other prerequisites
bobmods.lib.tech.add_prerequisite("angels-gardens", "bob-electronics")
if mods["ScienceCostTweakerM"] then
  bobmods.lib.tech.add_prerequisite("sct-bio-science-pack", "angels-bio-arboretum-1")
  bobmods.lib.tech.add_prerequisite("sb-bio-processing-advanced", "sct-bio-science-pack")
  bobmods.lib.tech.add_prerequisite("utility-science-pack", "angels-rubber")
end
bobmods.lib.tech.add_prerequisite("angels-glass-smelting-1", "bob-silicon-processing")
bobmods.lib.tech.add_prerequisite("angels-stone-smelting-2", "bob-silicon-processing")

-- Add missing Science Pack Tech prerequisites

-- Bio
if mods["ScienceCostTweakerM"] then
  bobmods.lib.tech.add_prerequisite("angels-bio-desert-farming-1", "sct-bio-science-pack")
  bobmods.lib.tech.add_prerequisite("angels-bio-swamp-farming-1", "sct-bio-science-pack")
  bobmods.lib.tech.add_prerequisite("angels-bio-temperate-farming-1", "sct-bio-science-pack")
  bobmods.lib.tech.add_prerequisite("angels-bio-pressing-1", "sct-bio-science-pack")
  bobmods.lib.tech.add_prerequisite("angels-bio-arboretum-2", "sct-bio-science-pack")
  bobmods.lib.tech.add_prerequisite("angels-bio-arboretum-desert-1", "sct-bio-science-pack")
  bobmods.lib.tech.add_prerequisite("angels-bio-arboretum-swamp-1", "sct-bio-science-pack")
  bobmods.lib.tech.add_prerequisite("angels-bio-processing-alien-2", "sct-bio-science-pack")
  bobmods.lib.tech.add_prerequisite("angels-bio-refugium-hatchery", "sct-bio-science-pack")
  bobmods.lib.tech.add_prerequisite("angels-bio-fermentation", "sct-bio-science-pack")
  bobmods.lib.tech.add_prerequisite("angels-bio-processing-crystal-splinter-1", "sct-bio-science-pack")
  bobmods.lib.tech.add_prerequisite("angels-gardens-3", "sct-bio-science-pack")
end

-- Logistics / Green
bobmods.lib.tech.add_prerequisite("angels-water-washing-2", "logistic-science-pack")
bobmods.lib.tech.add_prerequisite("angels-advanced-ore-refining-1", "logistic-science-pack")
bobmods.lib.tech.add_prerequisite("angels-bio-processing-blue", "logistic-science-pack")
bobmods.lib.tech.add_prerequisite("angels-basic-chemistry-2", "logistic-science-pack")

-- Chemical / Blue

-- Production
bobmods.lib.tech.add_prerequisite("logistic-system", "production-science-pack")

-- Utility / Yellow
bobmods.lib.tech.add_prerequisite("bob-radar-5", "utility-science-pack")

-- Space / White
if mods["bobequipment"] then
  bobmods.lib.tech.add_prerequisite("bob-energy-shield-equipment-6", "space-science-pack")
  bobmods.lib.tech.add_prerequisite("bob-fission-reactor-equipment-4", "space-science-pack")
end
if mods["bobwarfare"] then
  bobmods.lib.tech.add_prerequisite("bob-power-armor-5", "space-science-pack")
end

-- Hide KS Power techs
if mods["KS_Power"] then
  seablock.lib.hide_technology("OilBurning")
  seablock.lib.hide_technology("big-burner-generator")
  seablock.lib.hide_technology("petroleum-generator")
end

-- Add unlocks for starting military techs
seablock.lib.add_recipe_unlock("military", "pistol", 1)
seablock.lib.add_recipe_unlock("military", "firearm-magazine", 3)
seablock.lib.add_recipe_unlock("military", "light-armor", 4)
seablock.lib.add_recipe_unlock("military", "repair-pack", nil)

bobmods.lib.tech.add_prerequisite("gun-turret", "military")
bobmods.lib.tech.add_prerequisite("stone-wall", "military")
bobmods.lib.tech.add_prerequisite("space-science-pack", "military")

-- Steam power
bobmods.lib.tech.add_prerequisite("automation", "steam-power")
bobmods.lib.tech.add_prerequisite("lamp", "steam-power")
if data.raw.technology["bob-greenhouse"] then
  bobmods.lib.tech.add_prerequisite("bob-greenhouse", "steam-power")
end
bobmods.lib.tech.add_prerequisite("angels-coal-processing", "steam-power")

-- Gems are needed to make higher tier modules
if data.raw.technology["bob-gem-processing-3"] then
  --Module with 2 dots has the tech name of 3
  bobmods.lib.tech.add_prerequisite("speed-module-3", "bob-gem-processing-3")
  bobmods.lib.tech.add_prerequisite("productivity-module-3", "bob-gem-processing-3")
  bobmods.lib.tech.add_prerequisite("efficiency-module-3", "bob-gem-processing-3")
end


bobmods.lib.tech.remove_prerequisite("automation-science-pack", "electronics")
seablock.lib.hide_technology("automation-science-pack")

seablock.lib.hide_technology("electronics") --new trigger tech in base game, we don't want it in seablock
-- I think i found a bug: trigger techs still research even if hidden and disabled --TODO: check this
-- data.raw["technology"]["electronics"] = nil -- multiple different techs and shortcut will complain if we do that
data.raw["technology"]["electronics"].research_trigger = nil
data.raw["technology"]["electronics"].unit = {time = 1, count = 1, ingredients = {}}
bobmods.lib.tech.remove_prerequisite("bob-electronics", "electronics")
bobmods.lib.tech.remove_prerequisite("bob-electronics", "automation-science-pack")

seablock.lib.hide_technology("electric-mining-drill")
seablock.lib.hide_technology("repair-pack")

bobmods.lib.tech.add_prerequisite("radar", "military")
bobmods.lib.tech.remove_prerequisite("military", "automation-science-pack")
bobmods.lib.tech.remove_prerequisite("gun-turret", "automation-science-pack")
bobmods.lib.tech.remove_prerequisite("stone-wall", "automation-science-pack")
bobmods.lib.tech.remove_prerequisite("radar", "automation-science-pack")
bobmods.lib.tech.remove_prerequisite("automation", "automation-science-pack")


-- Change order for esthetics of the tech tree 
data.raw["technology"]["military"].order = "z-[military]"

if data.raw["technology"]["logistics-0"] then
  data.raw["technology"]["logistics-0"].research_trigger = nil
  data.raw["technology"]["logistics-0"].unit = {
    ingredients = {{"automation-science-pack", 1}},
    time = 5,
    count = 10
  }
end