-- Add bio science to techs
if mods["SpaceMod"] then
  bobmods.lib.tech.add_new_science_pack("habitation", "token-bio", 1)
  bobmods.lib.tech.add_new_science_pack("life-support-systems", "token-bio", 1)
end

-- Remove empty tech Thermal water processing
bobmods.lib.tech.remove_prerequisite("water-treatment-4", "thermal-water-processing")
seablock.lib.hide_technology("thermal-water-processing")

-- Smelting techs don't need to depend on Coal processing 2 as carbon is unlocked earlier
bobmods.lib.tech.remove_prerequisite("angels-aluminium-smelting-1", "angels-coal-processing-2")
bobmods.lib.tech.remove_prerequisite("angels-cobalt-smelting-1", "angels-coal-processing-2")
bobmods.lib.tech.remove_prerequisite("angels-lead-smelting-2", "angels-coal-processing-2")
bobmods.lib.tech.remove_prerequisite("angels-manganese-smelting-1", "angels-coal-processing")
bobmods.lib.tech.remove_prerequisite("angels-tin-smelting-2", "angels-coal-processing-2")
bobmods.lib.tech.remove_prerequisite("angels-titanium-smelting-1", "angels-coal-processing-2")
bobmods.lib.tech.remove_prerequisite("angels-zinc-smelting-2", "angels-coal-processing-2")
bobmods.lib.tech.remove_prerequisite("angels-chrome-smelting-1", "angels-coal-processing-2")
bobmods.lib.tech.remove_prerequisite("angels-iron-smelting-2", "angels-coal-processing-2")

-- Add a new prerequisite so Coal processing 2 isn't a dead end
-- Probably will want this for Carbon monoxide
bobmods.lib.tech.add_prerequisite("gas-synthesis", "angels-coal-processing-2")
bobmods.lib.tech.replace_prerequisite("angels-coal-processing-2", "water-treatment-2", "basic-chemistry-3")

-- Add other prerequisites
bobmods.lib.tech.add_prerequisite("gardens", "electronics")
if mods["ScienceCostTweakerM"] then
  bobmods.lib.tech.add_prerequisite("sct-bio-science-pack", "bio-arboretum-1")
  bobmods.lib.tech.add_prerequisite("sb-bio-processing-advanced", "sct-bio-science-pack")
  bobmods.lib.tech.add_prerequisite("utility-science-pack", "rubber")
end
bobmods.lib.tech.add_prerequisite("angels-glass-smelting-1", "silicon-processing")
bobmods.lib.tech.add_prerequisite("angels-stone-smelting-2", "silicon-processing")

-- Clear prerequisites so it's available at end of tutorial
bobmods.lib.tech.remove_prerequisite("bio-wood-processing-2", "bio-wood-processing")
bobmods.lib.tech.remove_prerequisite("bio-wood-processing-2", "angels-coal-processing")
bobmods.lib.tech.remove_prerequisite("bio-wood-processing-2", "advanced-material-processing")

-- Add missing Science Pack Tech prerequisites

-- Bio
if mods["ScienceCostTweakerM"] then
  bobmods.lib.tech.add_prerequisite("bio-desert-farming-1", "sct-bio-science-pack")
  bobmods.lib.tech.add_prerequisite("bio-swamp-farming-1", "sct-bio-science-pack")
  bobmods.lib.tech.add_prerequisite("bio-temperate-farming-1", "sct-bio-science-pack")
  bobmods.lib.tech.add_prerequisite("bio-pressing-1", "sct-bio-science-pack")
  bobmods.lib.tech.add_prerequisite("bio-arboretum-2", "sct-bio-science-pack")
  bobmods.lib.tech.add_prerequisite("bio-arboretum-desert-1", "sct-bio-science-pack")
  bobmods.lib.tech.add_prerequisite("bio-arboretum-swamp-1", "sct-bio-science-pack")
  bobmods.lib.tech.add_prerequisite("bio-processing-alien-2", "sct-bio-science-pack")
  bobmods.lib.tech.add_prerequisite("bio-refugium-hatchery", "sct-bio-science-pack")
  bobmods.lib.tech.add_prerequisite("bio-fermentation", "sct-bio-science-pack")
  bobmods.lib.tech.add_prerequisite("bio-processing-crystal-splinter-1", "sct-bio-science-pack")
  bobmods.lib.tech.add_prerequisite("gardens-3", "sct-bio-science-pack")
end

-- Logistics / Green
bobmods.lib.tech.add_prerequisite("water-washing-2", "logistic-science-pack")
bobmods.lib.tech.add_prerequisite("advanced-ore-refining-1", "logistic-science-pack")
bobmods.lib.tech.add_prerequisite("bio-processing-blue", "logistic-science-pack")
bobmods.lib.tech.add_prerequisite("bio-wood-processing-3", "logistic-science-pack")
bobmods.lib.tech.add_prerequisite("basic-chemistry-2", "logistic-science-pack")

-- Chemical / Blue

-- Production
bobmods.lib.tech.add_prerequisite("logistic-system", "production-science-pack")

-- Utility / Yellow
bobmods.lib.tech.add_prerequisite("radars-5", "utility-science-pack")

-- Space / White
if mods["bobequipment"] then
  bobmods.lib.tech.add_prerequisite("bob-energy-shield-equipment-6", "space-science-pack")
  bobmods.lib.tech.add_prerequisite("fusion-reactor-equipment-4", "space-science-pack")
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
seablock.lib.add_recipe_unlock("military", "radar", 5)
seablock.lib.add_recipe_unlock("military", "repair-pack", nil)

bobmods.lib.tech.add_prerequisite("gun-turret", "military")
bobmods.lib.tech.add_prerequisite("stone-wall", "military")

if mods["bobequipment"] then
  if mods["bobwarfare"] then
    bobmods.lib.tech.add_prerequisite("bob-battery-equipment-6", "bob-power-armor-3")
    bobmods.lib.tech.add_prerequisite("bob-energy-shield-equipment-5", "bob-power-armor-3")
    bobmods.lib.tech.add_prerequisite("personal-laser-defense-equipment-5", "bob-power-armor-3")
  else
    bobmods.lib.tech.add_prerequisite("bob-battery-equipment-6", "power-armor-mk2")
    bobmods.lib.tech.add_prerequisite("personal-laser-defense-equipment-5", "power-armor-mk2")
  end
end

if mods["bobpower"] then
  bobmods.lib.tech.add_prerequisite("bob-boiler-2", "sb-steam-power")
  bobmods.lib.tech.add_prerequisite("bob-steam-engine-2", "sb-steam-power")
end
bobmods.lib.tech.add_prerequisite("angels-coal-processing", "sb-steam-power")
