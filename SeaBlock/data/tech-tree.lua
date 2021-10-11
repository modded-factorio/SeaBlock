-- Move garden duplication recipes to a tech that doesn't require bio science

seablock.lib.moveeffect('desert-garden-cultivating-b', 'bio-desert-farm', 'bio-farm-alien')
seablock.lib.moveeffect('swamp-garden-cultivating-b', 'bio-swamp-farm', 'bio-farm-alien')
seablock.lib.moveeffect('temperate-garden-cultivating-b', 'bio-temperate-farm', 'bio-farm-alien')

-- Swap environment and T2 Farming techs

bobmods.lib.tech.replace_prerequisite('bio-desert-farm', 'bio-desert-farming-2', 'bio-desert-farming-1')
bobmods.lib.tech.replace_prerequisite('bio-swamp-farm', 'bio-swamp-farming-2', 'bio-swamp-farming-1')
bobmods.lib.tech.replace_prerequisite('bio-temperate-farm', 'bio-temperate-farming-2', 'bio-temperate-farming-1')

bobmods.lib.tech.replace_prerequisite('bio-desert-farming-2', 'bio-desert-farming-1', 'bio-desert-farm')
bobmods.lib.tech.replace_prerequisite('bio-swamp-farming-2', 'bio-swamp-farming-1', 'bio-swamp-farm')
bobmods.lib.tech.replace_prerequisite('bio-temperate-farming-2', 'bio-temperate-farming-1', 'bio-temperate-farm')

-- Add bio science to techs
-- Don't add to techs on the path to Alien Farming. This is where garden / bio token duplication is unlocked
-- Also need Fish refugium 2 available
bobmods.lib.tech.add_new_science_pack('bio-refugium-biter-1', 'token-bio', 1)
bobmods.lib.tech.add_new_science_pack('bio-refugium-biter-2', 'token-bio', 1)
bobmods.lib.tech.add_new_science_pack('bio-refugium-biter-3', 'token-bio', 1)
bobmods.lib.tech.add_new_science_pack('bio-refugium-puffer-1', 'token-bio', 1)
bobmods.lib.tech.add_new_science_pack('bio-refugium-puffer-2', 'token-bio', 1)
bobmods.lib.tech.add_new_science_pack('bio-refugium-puffer-3', 'token-bio', 1)
bobmods.lib.tech.add_new_science_pack('bio-refugium-puffer-4', 'token-bio', 1)
bobmods.lib.tech.add_new_science_pack('bio-pressing-1', 'token-bio', 1)
bobmods.lib.tech.add_new_science_pack('bio-pressing-2', 'token-bio', 1)
bobmods.lib.tech.add_new_science_pack('bio-pressing-fish-1', 'token-bio', 1)
bobmods.lib.tech.add_new_science_pack('bio-pressing-fish-2', 'token-bio', 1)
bobmods.lib.tech.add_new_science_pack('bio-refugium-butchery-2', 'token-bio', 1)
bobmods.lib.tech.add_new_science_pack('bio-processing-alien-2', 'token-bio', 1)
bobmods.lib.tech.add_new_science_pack('bio-processing-alien-3', 'token-bio', 1)
bobmods.lib.tech.add_new_science_pack('bio-processing-crystal-shard-1', 'token-bio', 1)
bobmods.lib.tech.add_new_science_pack('bio-processing-crystal-shard-2', 'token-bio', 1)
bobmods.lib.tech.add_new_science_pack('bio-processing-crystal-full', 'token-bio', 1)
bobmods.lib.tech.add_new_science_pack('bio-fermentation', 'token-bio', 1)
bobmods.lib.tech.add_new_science_pack('bio-plastic-1', 'token-bio', 1)
bobmods.lib.tech.add_new_science_pack('bio-plastic-2', 'token-bio', 1)
if mods['SpaceMod'] then
  bobmods.lib.tech.add_new_science_pack('habitation', 'token-bio', 1)
  bobmods.lib.tech.add_new_science_pack('life-support-systems', 'token-bio', 1)
end

-- At least one of these is required to feed fish
data.raw.technology['bio-desert-farming-1'].ignore_tech_cost_multiplier = true
data.raw.technology['bio-swamp-farming-1'].ignore_tech_cost_multiplier = true
data.raw.technology['bio-temperate-farming-1'].ignore_tech_cost_multiplier = true

-- Remove empty tech Thermal water processing
bobmods.lib.tech.remove_prerequisite('water-treatment-4', 'thermal-water-processing')
seablock.lib.hide_technology('thermal-water-processing')

-- Smelting techs don't need to depend on Coal processing 2 as carbon is unlocked earlier
bobmods.lib.tech.remove_prerequisite('angels-aluminium-smelting-1', 'angels-coal-processing-2')
bobmods.lib.tech.remove_prerequisite('angels-cobalt-smelting-1', 'angels-coal-processing-2')
bobmods.lib.tech.remove_prerequisite('angels-lead-smelting-2', 'angels-coal-processing-2')
bobmods.lib.tech.remove_prerequisite('angels-manganese-smelting-1', 'angels-coal-processing-2')
bobmods.lib.tech.remove_prerequisite('angels-tin-smelting-2', 'angels-coal-processing-2')
bobmods.lib.tech.remove_prerequisite('angels-titanium-smelting-1', 'angels-coal-processing-2')
bobmods.lib.tech.remove_prerequisite('angels-zinc-smelting-2', 'angels-coal-processing-2')
bobmods.lib.tech.remove_prerequisite('angels-chrome-smelting-1', 'angels-coal-processing-2')
bobmods.lib.tech.remove_prerequisite('angels-iron-smelting-2', 'angels-coal-processing-2')

-- Add a new prerequisite so Coal processing 2 isn't a dead end
-- Probably will want this for Carbon monoxide
bobmods.lib.tech.add_prerequisite('gas-synthesis', 'angels-coal-processing-2')
bobmods.lib.tech.replace_prerequisite('angels-coal-processing-2', 'water-treatment-2', 'basic-chemistry-3')

-- Add other prerequisites
bobmods.lib.tech.add_prerequisite('gardens', 'electronics')
bobmods.lib.tech.add_prerequisite('uranium-processing', 'ore-leaching')
if mods['ScienceCostTweakerM'] then
  bobmods.lib.tech.add_prerequisite('sct-bio-science-pack', 'bio-arboretum-1')
  bobmods.lib.tech.add_prerequisite('sb-bio-processing-advanced', 'sct-bio-science-pack')
  bobmods.lib.tech.add_prerequisite('utility-science-pack', 'rubber')
end
bobmods.lib.tech.add_prerequisite('tungsten-alloy-processing', 'powder-metallurgy-3')
bobmods.lib.tech.add_prerequisite('angels-glass-smelting-1', 'silicon-processing')
bobmods.lib.tech.add_prerequisite('angels-stone-smelting-2', 'silicon-processing')

-- Clear prerequisites so it's available at end of tutorial
bobmods.lib.tech.remove_prerequisite('bio-wood-processing-2', 'bio-wood-processing')
bobmods.lib.tech.remove_prerequisite('bio-wood-processing-2', 'angels-coal-processing')
bobmods.lib.tech.remove_prerequisite('bio-wood-processing-2', 'advanced-material-processing')

local tech = {
  'bob-artillery-turret-3',
  'bob-artillery-wagon-3',
  'bob-energy-shield-equipment-3',
  'radars-4'
}
if mods['CircuitProcessing'] then
  table.insert(tech, 'rocket-control-unit')
end
for _,v in pairs(tech) do
  if data.raw.technology[v] then
    bobmods.lib.tech.add_new_science_pack(v, 'production-science-pack', 1)
  end
end

bobmods.lib.tech.add_new_science_pack('resin-3', 'utility-science-pack', 1)

-- Move Manganese down a tier
-- T1:
bobmods.lib.tech.remove_science_pack('angels-manganese-smelting-1', 'logistic-science-pack')
bobmods.lib.tech.replace_prerequisite('angels-manganese-smelting-1', 'angels-metallurgy-2', 'angels-metallurgy-1')
bobmods.lib.tech.add_prerequisite('angels-manganese-smelting-1', 'angels-iron-smelting-1')
if bobmods.lib.tech.has_recipe_unlock('angels-iron-smelting-2', 'molten-iron-smelting-2') then
  seablock.lib.moveeffect('molten-iron-smelting-2', 'angels-iron-smelting-2', 'angels-manganese-smelting-1')
else
  seablock.lib.moveeffect('molten-iron-smelting-2', 'angels-iron-casting-2', 'angels-manganese-smelting-1')
end
seablock.lib.set_recipe_category('molten-iron-smelting-2', 'induction-smelting')

-- T2:
bobmods.lib.tech.remove_science_pack('angels-manganese-smelting-2', 'chemical-science-pack')
bobmods.lib.tech.replace_prerequisite('angels-manganese-smelting-2', 'ore-processing-2', 'ore-processing-1')
bobmods.lib.tech.replace_prerequisite('angels-steel-smelting-2', 'angels-manganese-smelting-1', 'angels-manganese-smelting-2')
bobmods.lib.tech.replace_prerequisite('angels-aluminium-smelting-2', 'angels-manganese-smelting-1', 'angels-manganese-smelting-2')

-- T3:
bobmods.lib.tech.remove_science_pack('angels-manganese-smelting-3', 'production-science-pack')
bobmods.lib.tech.replace_prerequisite('angels-manganese-smelting-3', 'ore-processing-3', 'ore-processing-2')
bobmods.lib.tech.replace_prerequisite('angels-titanium-smelting-2', 'angels-manganese-smelting-2', 'angels-manganese-smelting-3')
bobmods.lib.tech.replace_prerequisite('angels-titanium-casting-2', 'angels-manganese-smelting-2', 'angels-manganese-smelting-3')

-- Move Silicon up a tier
-- T1:
bobmods.lib.tech.add_new_science_pack('angels-silicon-smelting-1', 'logistic-science-pack', 1)
bobmods.lib.tech.replace_prerequisite('angels-silicon-smelting-1', 'angels-metallurgy-1', 'angels-metallurgy-2')
bobmods.lib.tech.replace_prerequisite('angels-steel-smelting-2', 'angels-silicon-smelting-2', 'angels-silicon-smelting-1')

-- T2:
bobmods.lib.tech.add_new_science_pack('angels-silicon-smelting-2', 'chemical-science-pack', 1)
bobmods.lib.tech.replace_prerequisite('angels-silicon-smelting-2', 'ore-processing-1', 'ore-processing-2')
bobmods.lib.tech.replace_prerequisite('angels-aluminium-smelting-3', 'angels-silicon-smelting-3', 'angels-silicon-smelting-2')
bobmods.lib.tech.replace_prerequisite('angels-aluminium-casting-3', 'angels-silicon-smelting-3', 'angels-silicon-smelting-2')

-- T3:
bobmods.lib.tech.add_new_science_pack('angels-silicon-smelting-3', 'production-science-pack', 1)
bobmods.lib.tech.replace_prerequisite('angels-silicon-smelting-3', 'ore-processing-2', 'ore-processing-3')
bobmods.lib.tech.replace_prerequisite('angels-silicon-smelting-3', 'angels-aluminium-smelting-1', 'angels-aluminium-smelting-2')

-- Move Nickel up a tier
-- T1:
bobmods.lib.tech.add_new_science_pack('angels-nickel-smelting-1', 'logistic-science-pack', 1)
bobmods.lib.tech.replace_prerequisite('angels-nickel-smelting-1', 'angels-metallurgy-1', 'angels-metallurgy-2')
bobmods.lib.tech.replace_prerequisite('angels-iron-casting-3', 'angels-nickel-smelting-2', 'angels-nickel-smelting-1')

-- T2:
bobmods.lib.tech.add_new_science_pack('angels-nickel-smelting-2', 'chemical-science-pack', 1)
bobmods.lib.tech.replace_prerequisite('angels-nickel-smelting-2', 'ore-processing-1', 'ore-processing-2')
bobmods.lib.tech.replace_prerequisite('angels-nickel-smelting-2', 'strand-casting-1', 'strand-casting-2')
bobmods.lib.tech.replace_prerequisite('angels-steel-smelting-3', 'angels-nickel-smelting-3', 'angels-nickel-smelting-2')
bobmods.lib.tech.replace_prerequisite('angels-titanium-smelting-2', 'angels-nickel-smelting-3', 'angels-nickel-smelting-2')
bobmods.lib.tech.replace_prerequisite('angels-tungsten-smelting-2', 'angels-nickel-smelting-3', 'angels-nickel-smelting-2')

bobmods.lib.tech.add_new_science_pack('angels-nickel-casting-2', 'chemical-science-pack', 1)
bobmods.lib.tech.replace_prerequisite('angels-nickel-casting-2', 'ore-processing-1', 'ore-processing-2')
bobmods.lib.tech.replace_prerequisite('angels-nickel-casting-2', 'strand-casting-1', 'strand-casting-2')
bobmods.lib.tech.replace_prerequisite('angels-steel-smelting-3', 'angels-nickel-casting-3', 'angels-nickel-smelting-2')
bobmods.lib.tech.replace_prerequisite('angels-titanium-casting-2', 'angels-nickel-smelting-3', 'angels-nickel-smelting-2')

-- T3:
bobmods.lib.tech.add_new_science_pack('angels-nickel-smelting-3', 'production-science-pack', 1)
bobmods.lib.tech.replace_prerequisite('angels-nickel-smelting-3', 'strand-casting-2', 'strand-casting-3')
bobmods.lib.tech.replace_prerequisite('angels-nickel-smelting-3', 'ore-processing-2', 'ore-processing-3')

bobmods.lib.tech.add_new_science_pack('angels-nickel-casting-3', 'production-science-pack', 1)
bobmods.lib.tech.replace_prerequisite('angels-nickel-casting-3', 'strand-casting-2', 'strand-casting-3')
bobmods.lib.tech.replace_prerequisite('angels-nickel-casting-3', 'ore-processing-2', 'ore-processing-3')


-- Add missing Science Pack Tech prerequisites

-- Bio
if mods['ScienceCostTweakerM'] then
  bobmods.lib.tech.add_prerequisite('bio-desert-farming-1', 'sct-bio-science-pack')
  bobmods.lib.tech.add_prerequisite('bio-swamp-farming-1', 'sct-bio-science-pack')
  bobmods.lib.tech.add_prerequisite('bio-temperate-farming-1', 'sct-bio-science-pack')
  if data.raw.technology['bio-pressing'] then
    bobmods.lib.tech.add_prerequisite('bio-pressing', 'sct-bio-science-pack')
  else
    bobmods.lib.tech.add_prerequisite('bio-pressing-1', 'sct-bio-science-pack')
  end
  bobmods.lib.tech.add_prerequisite('bio-arboretum-2', 'sct-bio-science-pack')
  bobmods.lib.tech.add_prerequisite('bio-arboretum-desert-1', 'sct-bio-science-pack')
  bobmods.lib.tech.add_prerequisite('bio-arboretum-swamp-1', 'sct-bio-science-pack')
  bobmods.lib.tech.add_prerequisite('bio-processing-alien-2', 'sct-bio-science-pack')
  bobmods.lib.tech.add_prerequisite('bio-refugium-hatchery', 'sct-bio-science-pack')
  bobmods.lib.tech.add_prerequisite('bio-fermentation', 'sct-bio-science-pack')
end

-- Logistics / Green
bobmods.lib.tech.add_prerequisite('water-washing-2', 'logistic-science-pack')
bobmods.lib.tech.add_prerequisite('bio-fermentation', 'logistic-science-pack')
bobmods.lib.tech.add_prerequisite('bio-nutrient-paste', 'logistic-science-pack')
bobmods.lib.tech.add_prerequisite('advanced-ore-refining-1', 'logistic-science-pack')
bobmods.lib.tech.add_prerequisite('bio-paper-2', 'logistic-science-pack')
bobmods.lib.tech.add_prerequisite('bio-processing-blue', 'logistic-science-pack')
bobmods.lib.tech.add_prerequisite('bio-wood-processing-3', 'logistic-science-pack')
bobmods.lib.tech.add_prerequisite('angels-metallurgy-2', 'logistic-science-pack')
bobmods.lib.tech.add_prerequisite('basic-chemistry-2', 'logistic-science-pack')
if mods['angelsaddons-storage'] then
  bobmods.lib.tech.add_prerequisite('pressure-tanks', 'logistic-science-pack')
end

-- Chemical / Blue
bobmods.lib.tech.add_prerequisite('thermal-water-extraction-2', 'chemical-science-pack')
bobmods.lib.tech.add_prerequisite('water-treatment-4', 'chemical-science-pack')
bobmods.lib.tech.add_prerequisite('bio-plastic-2', 'chemical-science-pack')
bobmods.lib.tech.add_prerequisite('slag-processing-2', 'chemical-science-pack')
bobmods.lib.tech.add_prerequisite('angels-advanced-gas-processing', 'chemical-science-pack')
bobmods.lib.tech.add_prerequisite('angels-advanced-oil-processing', 'chemical-science-pack')
bobmods.lib.tech.add_prerequisite('bio-paper-3', 'chemical-science-pack')
bobmods.lib.tech.add_prerequisite('gas-steam-cracking-2', 'chemical-science-pack')
bobmods.lib.tech.add_prerequisite('oil-steam-cracking-2', 'chemical-science-pack')
bobmods.lib.tech.add_prerequisite('bob-robo-modular-2', 'chemical-science-pack')
if mods['bobequipment'] then
  bobmods.lib.tech.add_prerequisite('exoskeleton-equipment-2', 'chemical-science-pack')
end
bobmods.lib.tech.add_prerequisite('ore-leaching', 'chemical-science-pack')
bobmods.lib.tech.add_prerequisite('bob-robotics-2', 'chemical-science-pack')
bobmods.lib.tech.add_prerequisite('personal-roboport-mk2-equipment', 'chemical-science-pack')
bobmods.lib.tech.add_prerequisite('bio-arboretum-desert-3', 'chemical-science-pack')
bobmods.lib.tech.add_prerequisite('bio-arboretum-swamp-3', 'chemical-science-pack')
bobmods.lib.tech.add_prerequisite('bio-arboretum-temperate-3', 'chemical-science-pack')
bobmods.lib.tech.add_prerequisite('angels-metallurgy-3', 'chemical-science-pack')

-- Military / Gray
bobmods.lib.tech.add_prerequisite('angels-explosives-1', 'military-science-pack')

-- Production
bobmods.lib.tech.add_prerequisite('angels-metallurgy-4', 'production-science-pack')
bobmods.lib.tech.add_prerequisite('logistic-system', 'production-science-pack')
if mods['bobequipment'] then
  bobmods.lib.tech.add_prerequisite('fusion-reactor-equipment-2', 'production-science-pack')
end
if mods['bobwarfare'] then
  bobmods.lib.tech.add_prerequisite('bob-power-armor-3', 'production-science-pack')
end

-- Advanced Logistics / Pink
if mods['bobtech'] then
  if mods['bobequipment'] then
    bobmods.lib.tech.add_prerequisite('bob-battery-equipment-5', 'advanced-logistic-science-pack')
    bobmods.lib.tech.add_prerequisite('bob-energy-shield-equipment-4', 'advanced-logistic-science-pack')
    bobmods.lib.tech.add_prerequisite('fusion-reactor-equipment-3', 'advanced-logistic-science-pack')
  end
  if mods['bobwarfare'] then
    bobmods.lib.tech.add_prerequisite('bob-power-armor-4', 'advanced-logistic-science-pack')
  end
end

-- Utility / Yellow
bobmods.lib.tech.add_prerequisite('angels-advanced-chemistry-4', 'utility-science-pack')
if mods['bobequipment'] then
  bobmods.lib.tech.add_prerequisite('personal-laser-defense-equipment-4', 'utility-science-pack')
  bobmods.lib.tech.add_prerequisite('bob-battery-equipment-6', 'utility-science-pack')
  bobmods.lib.tech.add_prerequisite('bob-energy-shield-equipment-5', 'utility-science-pack')
end
bobmods.lib.tech.add_prerequisite('angels-nuclear-fuel', 'utility-science-pack')
if mods['bobwarfare'] then
  bobmods.lib.tech.add_prerequisite('logistic-spidertron', 'utility-science-pack')
end
bobmods.lib.tech.add_prerequisite('angels-metallurgy-5', 'utility-science-pack')

-- Space / White
if mods['bobequipment'] then
  bobmods.lib.tech.add_prerequisite('bob-energy-shield-equipment-6', 'space-science-pack')
  bobmods.lib.tech.add_prerequisite('fusion-reactor-equipment-4', 'space-science-pack')
end
if mods['bobwarfare'] then
  bobmods.lib.tech.add_prerequisite('bob-power-armor-5', 'space-science-pack')
end

-- Hide KS Power techs
if mods['KS_Power'] then
  seablock.lib.hide_technology('OilBurning')
  seablock.lib.hide_technology('big-burner-generator')
  seablock.lib.hide_technology('petroleum-generator')
end

-- Add unlocks for starting military techs
seablock.lib.add_recipe_unlock('military', 'pistol', 1)
seablock.lib.add_recipe_unlock('military', 'firearm-magazine', 3)
seablock.lib.add_recipe_unlock('military', 'light-armor', 4)
seablock.lib.add_recipe_unlock('military', 'radar', 5)

bobmods.lib.tech.add_prerequisite('gun-turret', 'military')
bobmods.lib.tech.add_prerequisite('stone-wall', 'military')
