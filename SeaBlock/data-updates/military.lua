-- Hide most military stuff as there's no real need for it in Sea Block as the only enemies are Worms
local mil_items = {
  {type = 'ammo-turret', name = 'bob-gun-turret-3'},
  {type = 'ammo-turret', name = 'bob-gun-turret-4'},
  {type = 'ammo-turret', name = 'bob-gun-turret-5'},
  {type = 'ammo-turret', name = 'bob-sniper-turret-3'},
  {type = 'armor', name = 'heavy-armor-2'},
  {type = 'armor', name = 'heavy-armor-3'},
  {type = 'artillery-turret', name = 'bob-artillery-turret-3'},
  {type = 'artillery-wagon', name = 'bob-artillery-wagon-3'},
  {type = 'car', name = 'bob-tank-2'},
  {type = 'car', name = 'bob-tank-3'},
  {type = 'cargo-wagon', name = 'bob-armoured-cargo-wagon-2'},
  {type = 'cargo-wagon', name = 'bob-armoured-cargo-wagon'},
  {type = 'combat-robot', name = 'bob-laser-robot'},
  {type = 'combat-robot', name = 'defender'},
  {type = 'combat-robot', name = 'destroyer'},
  {type = 'combat-robot', name = 'distractor'},
  {type = 'electric-turret', name = 'bob-laser-turret-2'},
  {type = 'electric-turret', name = 'bob-laser-turret-3'},
  {type = 'electric-turret', name = 'bob-laser-turret-4'},
  {type = 'electric-turret', name = 'bob-laser-turret-5'},
  {type = 'electric-turret', name = 'bob-plasma-turret-3'},
  {type = 'electric-turret', name = 'bob-plasma-turret-4'},
  {type = 'electric-turret', name = 'bob-plasma-turret-5'},
  {type = 'fluid-turret', name = 'flamethrower-turret'},
  {type = 'fluid-wagon', name = 'bob-armoured-fluid-wagon-2'},
  {type = 'fluid-wagon', name = 'bob-armoured-fluid-wagon'},
  {type = 'fluid', name = 'alien-acid'},
  {type = 'fluid', name = 'alien-explosive'},
  {type = 'fluid', name = 'alien-fire'},
  {type = 'fluid', name = 'alien-poison'},
  {type = 'fluid', name = 'liquid-glycerol'},
  {type = 'fluid', name = 'liquid-toluene'},
  {type = 'fluid', name = 'nitroglycerin'},
  {type = 'gun', name = 'combat-shotgun'},
  {type = 'gun', name = 'flamethrower'},
  {type = 'gun', name = 'laser-rifle'},
  {type = 'gun', name = 'rifle'},
  {type = 'gun', name = 'shotgun'},
  {type = 'item-with-entity-data', name = 'bob-armoured-cargo-wagon-2'},
  {type = 'item-with-entity-data', name = 'bob-armoured-cargo-wagon'},
  {type = 'item-with-entity-data', name = 'bob-armoured-fluid-wagon-2'},
  {type = 'item-with-entity-data', name = 'bob-armoured-fluid-wagon'},
  {type = 'item-with-entity-data', name = 'bob-armoured-locomotive-2'},
  {type = 'item-with-entity-data', name = 'bob-armoured-locomotive'},
  {type = 'item-with-entity-data', name = 'bob-artillery-wagon-3'},
  {type = 'item-with-entity-data', name = 'bob-tank-2'},
  {type = 'item-with-entity-data', name = 'bob-tank-3'},
  {type = 'item', name = 'acid-bullet-projectile'},
  {type = 'item', name = 'acid-bullet'},
  {type = 'item', name = 'acid-rocket-warhead'},
  {type = 'item', name = 'alien-acid-barrel'},
  {type = 'item', name = 'alien-blue-alloy'},
  {type = 'item', name = 'alien-explosive-barrel'},
  {type = 'item', name = 'alien-fire-barrel'},
  {type = 'item', name = 'alien-orange-alloy'},
  {type = 'item', name = 'alien-poison-barrel'},
  {type = 'item', name = 'ap-bullet-projectile'},
  {type = 'item', name = 'ap-bullet'},
  {type = 'item', name = 'bob-artillery-turret-3'},
  {type = 'item', name = 'bob-gun-turret-3'},
  {type = 'item', name = 'bob-gun-turret-4'},
  {type = 'item', name = 'bob-gun-turret-5'},
  {type = 'item', name = 'bob-laser-robot'},
  {type = 'item', name = 'bob-laser-turret-2'},
  {type = 'item', name = 'bob-laser-turret-3'},
  {type = 'item', name = 'bob-laser-turret-4'},
  {type = 'item', name = 'bob-laser-turret-5'},
  {type = 'item', name = 'bob-plasma-turret-3'},
  {type = 'item', name = 'bob-plasma-turret-4'},
  {type = 'item', name = 'bob-plasma-turret-5'},
  {type = 'item', name = 'bob-robot-flamethrower-drone'},
  {type = 'item', name = 'bob-robot-gun-drone'},
  {type = 'item', name = 'bob-robot-laser-drone'},
  {type = 'item', name = 'bob-robot-plasma-drone'},
  {type = 'item', name = 'bob-sniper-turret-3'},
  {type = 'item', name = 'bullet-casing'},
  {type = 'item', name = 'bullet-projectile'},
  {type = 'item', name = 'bullet'},
  {type = 'item', name = 'combat-robot-dispenser-equipment'},
  {type = 'item', name = 'cordite'},
  {type = 'item', name = 'defender-robot'},
  {type = 'item', name = 'destroyer-robot'},
  {type = 'item', name = 'discharge-defense-equipment'},
  {type = 'item', name = 'distractor-mine'},
  {type = 'item', name = 'distractor-robot'},
  {type = 'item', name = 'electric-bullet-projectile'},
  {type = 'item', name = 'electric-bullet'},
  {type = 'item', name = 'electric-rocket-warhead'},
  {type = 'item', name = 'explosive-rocket-warhead'},
  {type = 'item', name = 'flame-bullet-projectile'},
  {type = 'item', name = 'flame-bullet'},
  {type = 'item', name = 'flame-rocket-warhead'},
  {type = 'item', name = 'flamethrower-turret'},
  {type = 'item', name = 'gun-cotton'},
  {type = 'item', name = 'gunmetal-alloy'},
  {type = 'item', name = 'he-bullet-projectile'},
  {type = 'item', name = 'he-bullet'},
  {type = 'item', name = 'lab-alien'},
  {type = 'item', name = 'land-mine'},
  {type = 'item', name = 'laser-rifle-battery-case'},
  {type = 'item', name = 'liquid-glycerol-barrel'},
  {type = 'item', name = 'liquid-toluene-barrel'},
  {type = 'item', name = 'magazine'},
  {type = 'item', name = 'nitroglycerin-barrel'},
  {type = 'item', name = 'petroleum-jelly'},
  {type = 'item', name = 'piercing-rocket-warhead'},
  {type = 'item', name = 'plasma-bullet-projectile'},
  {type = 'item', name = 'plasma-bullet'},
  {type = 'item', name = 'plasma-rocket-warhead'},
  {type = 'item', name = 'poison-bullet-projectile'},
  {type = 'item', name = 'poison-bullet'},
  {type = 'item', name = 'poison-mine'},
  {type = 'item', name = 'poison-rocket-warhead'},
  {type = 'item', name = 'robot-brain-combat-2'},
  {type = 'item', name = 'robot-brain-combat-3'},
  {type = 'item', name = 'robot-brain-combat-4'},
  {type = 'item', name = 'robot-brain-combat'},
  {type = 'item', name = 'robot-drone-frame-large'},
  {type = 'item', name = 'robot-drone-frame'},
  {type = 'item', name = 'robot-tool-combat-2'},
  {type = 'item', name = 'robot-tool-combat-3'},
  {type = 'item', name = 'robot-tool-combat-4'},
  {type = 'item', name = 'robot-tool-combat'},
  {type = 'item', name = 'rocket-body'},
  {type = 'item', name = 'rocket-warhead'},
  {type = 'item', name = 'shot'},
  {type = 'item', name = 'shotgun-shell-casing'},
  {type = 'item', name = 'slowdown-mine'},
  {type = 'item', name = 'uranium-bullet-projectile'},
  {type = 'item', name = 'uranium-bullet'},
  {type = 'lab', name = 'lab-alien'},
  {type = 'land-mine', name = 'distractor-mine'},
  {type = 'land-mine', name = 'land-mine'},
  {type = 'land-mine', name = 'poison-mine'},
  {type = 'land-mine', name = 'slowdown-mine'},
  {type = 'locomotive', name = 'bob-armoured-locomotive-2'},
  {type = 'locomotive', name = 'bob-armoured-locomotive'},
  {type = 'tool', name = 'alien-science-pack-blue'},
  {type = 'tool', name = 'alien-science-pack-green'},
  {type = 'tool', name = 'alien-science-pack-orange'},
  {type = 'tool', name = 'alien-science-pack-purple'},
  {type = 'tool', name = 'alien-science-pack-red'},
  {type = 'tool', name = 'alien-science-pack-yellow'},
  {type = 'tool', name = 'alien-science-pack'},
  {type = 'tool', name = 'science-pack-gold'},
  {type = 'unit', name = 'bob-robot-flamethrower-drone'},
  {type = 'unit', name = 'bob-robot-gun-drone'},
  {type = 'unit', name = 'bob-robot-laser-drone'},
  {type = 'unit', name = 'bob-robot-plasma-drone'}
}

local mil_tech = {
  'advanced-research',
  'alien-blue-research',
  'alien-green-research',
  'alien-orange-research',
  'alien-purple-research',
  'alien-red-research',
  'alien-research',
  'alien-yellow-research',
  'angels-explosives-1',
  'angels-explosives-2',
  'bob-acid-bullets',
  'bob-acid-rocket',
  'bob-ap-bullets',
  'bob-armor-making-3',
  'bob-armor-making-4',
  'bob-armoured-fluid-wagon',
  'bob-armoured-fluid-wagon-2',
  'bob-armoured-railway',
  'bob-armoured-railway-2',
  'bob-artillery-turret-3',
  'bob-artillery-wagon-3',
  'bob-bullets',
  'bob-distractor-artillery-shells',
  'bob-electric-bullets',
  'bob-electric-rocket',
  'bob-explosive-artillery-shells',
  'bob-explosive-rocket',
  'bob-fire-artillery-shells',
  'bob-flame-bullets',
  'bob-flame-rocket',
  'bob-he-bullets',
  'bob-laser-rifle',
  'bob-laser-rifle-ammo-1',
  'bob-laser-rifle-ammo-2',
  'bob-laser-rifle-ammo-3',
  'bob-laser-rifle-ammo-4',
  'bob-laser-rifle-ammo-5',
  'bob-laser-rifle-ammo-6',
  'bob-laser-robot',
  'bob-laser-turrets-2',
  'bob-laser-turrets-3',
  'bob-laser-turrets-4',
  'bob-laser-turrets-5',
  'bob-piercing-rocket',
  'bob-plasma-rocket',
  'bob-plasma-bullets',
  'bob-plasma-turrets-3',
  'bob-plasma-turrets-4',
  'bob-plasma-turrets-5',
  'bob-poison-artillery-shells',
  'bob-poison-bullets',
  'bob-poison-rocket',
  'bob-robot-flamethrower-drones',
  'bob-robot-gun-drones',
  'bob-robot-laser-drones',
  'bob-robot-plasma-drones',
  'bob-rocket',
  'bob-scatter-cannon-shells',
  'bob-shotgun-acid-shells',
  'bob-shotgun-ap-shells',
  'bob-shotgun-electric-shells',
  'bob-shotgun-flame-shells',
  'bob-shotgun-explosive-shells',
  'bob-shotgun-plasma-shells',
  'bob-shotgun-poison-shells',
  'bob-shotgun-shells',
  'bob-sniper-turrets-3',
  'bob-tanks-2',
  'bob-tanks-3',
  'bob-turrets-3',
  'bob-turrets-4',
  'bob-turrets-5',
  'cordite-processing',
  'defender',
  'destroyer',
  'discharge-defense-equipment',
  'distractor',
  'distractor-mine',
  'energy-weapons-damage-7', -- Infinite
  'explosive-rocketry',
  'flamethrower',
  'follower-robot-count-1',
  'follower-robot-count-2',
  'follower-robot-count-3',
  'follower-robot-count-4',
  'follower-robot-count-5',
  'follower-robot-count-6',
  'follower-robot-count-7', -- Infinite
  'land-mine',
  'laser-shooting-speed-7',
  'nitroglycerin-processing',
  'physical-projectile-damage-7', -- Infinite
  'poison-mine',
  'refined-flammables-1',
  'refined-flammables-2',
  'refined-flammables-3',
  'refined-flammables-4',
  'refined-flammables-5',
  'refined-flammables-6',
  'refined-flammables-7', -- Infinite
  'sct-alien-science-pack',
  'sct-lab-alien',
  'sct-science-pack-gold',
  'slowdown-mine',
  'stronger-explosives-7', -- Infinite
  'uranium-ammo'
}

local mil_ammo = {
  {type = 'ammo', name = 'acid-bullet-magazine'},
  {type = 'ammo', name = 'ap-bullet-magazine'},
  {type = 'ammo', name = 'better-shotgun-shell'},
  {type = 'ammo', name = 'bob-acid-rocket'},
  {type = 'ammo', name = 'bob-electric-rocket'},
  {type = 'ammo', name = 'bob-explosive-rocket'},
  {type = 'ammo', name = 'bob-flame-rocket'},
  {type = 'ammo', name = 'bob-piercing-rocket'},
  {type = 'ammo', name = 'bob-plasma-rocket'},
  {type = 'ammo', name = 'bob-poison-rocket'},
  {type = 'ammo', name = 'bob-rocket'},
  {type = 'ammo', name = 'bullet-magazine'},
  {type = 'ammo', name = 'distractor-artillery-shell'},
  {type = 'ammo', name = 'electric-bullet-magazine'},
  {type = 'ammo', name = 'explosive-artillery-shell'},
  {type = 'ammo', name = 'explosive-rocket'},
  {type = 'ammo', name = 'explosive-uranium-cannon-shell'},
  {type = 'ammo', name = 'fire-artillery-shell'},
  {type = 'ammo', name = 'flame-bullet-magazine'},
  {type = 'ammo', name = 'flamethrower-ammo'},
  {type = 'ammo', name = 'he-bullet-magazine'},
  {type = 'ammo', name = 'laser-rifle-battery-amethyst'},
  {type = 'ammo', name = 'laser-rifle-battery-diamond'},
  {type = 'ammo', name = 'laser-rifle-battery-emerald'},
  {type = 'ammo', name = 'laser-rifle-battery-ruby'},
  {type = 'ammo', name = 'laser-rifle-battery-sapphire'},
  {type = 'ammo', name = 'laser-rifle-battery-topaz'},
  {type = 'ammo', name = 'laser-rifle-battery'},
  {type = 'ammo', name = 'piercing-shotgun-shell'},
  {type = 'ammo', name = 'plasma-bullet-magazine'},
  {type = 'ammo', name = 'poison-artillery-shell'},
  {type = 'ammo', name = 'poison-bullet-magazine'},
  {type = 'ammo', name = 'scatter-cannon-shell'},
  {type = 'ammo', name = 'shotgun-acid-shell'},
  {type = 'ammo', name = 'shotgun-ap-shell'},
  {type = 'ammo', name = 'shotgun-electric-shell'},
  {type = 'ammo', name = 'shotgun-explosive-shell'},
  {type = 'ammo', name = 'shotgun-flame-shell'},
  {type = 'ammo', name = 'shotgun-plasma-shell'},
  {type = 'ammo', name = 'shotgun-poison-shell'},
  {type = 'ammo', name = 'shotgun-shell'},
  {type = 'ammo', name = 'shotgun-uranium-shell'},
  {type = 'ammo', name = 'uranium-cannon-shell'},
  {type = 'ammo', name = 'uranium-rounds-magazine'},
  {type = 'capsule', name = 'bob-laser-robot-capsule'},
  {type = 'capsule', name = 'cluster-grenade'},
  {type = 'capsule', name = 'defender-capsule'},
  {type = 'capsule', name = 'destroyer-capsule'},
  {type = 'capsule', name = 'discharge-defense-remote'},
  {type = 'capsule', name = 'distractor-capsule'},
  {type = 'capsule', name = 'fire-capsule'},
  {type = 'capsule', name = 'poison-capsule'},
  {type = 'capsule', name = 'slowdown-capsule'}
}

local mil_recipes = {
  'acid-bullet',
  'acid-bullet-magazine',
  'acid-bullet-projectile',
  'acid-rocket-warhead',
  'alien-acid',
  'alien-blue-alloy',
  'alien-explosive',
  'alien-fire',
  'alien-orange-alloy',
  'alien-poison',
  'alien-science-pack',
  'alien-science-pack-blue',
  'alien-science-pack-green',
  'alien-science-pack-orange',
  'alien-science-pack-purple',
  'alien-science-pack-red',
  'alien-science-pack-yellow',
  'angels-chemical-void-liquid-glycerol',
  'angels-chemical-void-liquid-toluene',
  'ap-bullet',
  'ap-bullet-magazine',
  'ap-bullet-projectile',
  'better-shotgun-shell',
  'bob-acid-rocket',
  'bob-armoured-cargo-wagon',
  'bob-armoured-cargo-wagon-2',
  'bob-armoured-fluid-wagon',
  'bob-armoured-fluid-wagon-2',
  'bob-armoured-locomotive',
  'bob-armoured-locomotive-2',
  'bob-artillery-turret-3',
  'bob-artillery-wagon-3',
  'bob-electric-rocket',
  'bob-explosive-rocket',
  'bob-flame-rocket',
  'bob-gun-turret-3',
  'bob-gun-turret-4',
  'bob-gun-turret-5',
  'bob-laser-robot',
  'bob-laser-robot-capsule',
  'bob-laser-turret-2',
  'bob-laser-turret-3',
  'bob-laser-turret-4',
  'bob-laser-turret-5',
  'bob-piercing-rocket',
  'bob-plasma-rocket',
  'bob-plasma-turret-3',
  'bob-plasma-turret-4',
  'bob-plasma-turret-5',
  'bob-poison-rocket',
  'bob-robot-flamethrower-drone',
  'bob-robot-gun-drone',
  'bob-robot-laser-drone',
  'bob-robot-plasma-drone',
  'bob-rocket',
  'bob-sniper-turret-3',
  'bob-tank-2',
  'bob-tank-3',
  'bullet',
  'bullet-casing',
  'bullet-magazine',
  'bullet-projectile',
  'cluster-grenade',
  'combat-shotgun',
  'cordite',
  'defender-capsule',
  'defender-robot',
  'destroyer-capsule',
  'destroyer-robot',
  'discharge-defense-equipment',
  'discharge-defense-remote',
  'distractor-artillery-shell',
  'distractor-capsule',
  'distractor-mine',
  'distractor-robot',
  'electric-bullet',
  'electric-bullet-magazine',
  'electric-bullet-projectile',
  'electric-energy-interface',
  'electric-rocket-warhead',
  'empty-alien-acid-barrel',
  'empty-alien-explosive-barrel',
  'empty-alien-fire-barrel',
  'empty-alien-poison-barrel',
  'empty-liquid-glycerol-barrel',
  'empty-liquid-toluene-barrel',
  'empty-nitroglycerin-barrel',
  'explosive-artillery-shell',
  'explosive-rocket',
  'explosive-rocket-warhead',
  'explosive-uranium-cannon-shell',
  'fill-alien-acid-barrel',
  'fill-alien-explosive-barrel',
  'fill-alien-fire-barrel',
  'fill-alien-poison-barrel',
  'fill-liquid-glycerol-barrel',
  'fill-liquid-toluene-barrel',
  'fill-nitroglycerin-barrel',
  'fire-artillery-shell',
  'fire-capsule',
  'flame-bullet',
  'flame-bullet-magazine',
  'flame-bullet-projectile',
  'flame-rocket-warhead',
  'flamethrower',
  'flamethrower-ammo',
  'flamethrower-turret',
  'gas-fractioning-residual',
  'gun-cotton',
  'gunmetal-alloy',
  'he-bullet',
  'he-bullet-magazine',
  'he-bullet-projectile',
  'heavy-armor-2',
  'heavy-armor-3',
  'lab-alien',
  'land-mine',
  'laser-rifle',
  'laser-rifle-battery',
  'laser-rifle-battery-amethyst',
  'laser-rifle-battery-case',
  'laser-rifle-battery-diamond',
  'laser-rifle-battery-emerald',
  'laser-rifle-battery-ruby',
  'laser-rifle-battery-sapphire',
  'laser-rifle-battery-topaz',
  'liquid-glycerol',
  'liquid-toluene-from-benzene',
  'liquid-toluene-from-naphtha',
  'magazine',
  'nitroglycerin',
  'petroleum-jelly',
  'piercing-rocket-warhead',
  'piercing-shotgun-shell',
  'plasma-bullet',
  'plasma-bullet-magazine',
  'plasma-bullet-projectile',
  'plasma-rocket-warhead',
  'poison-artillery-shell',
  'poison-bullet',
  'poison-bullet-magazine',
  'poison-bullet-projectile',
  'poison-capsule',
  'poison-mine',
  'poison-rocket-warhead',
  'rifle',
  'robot-brain-combat',
  'robot-brain-combat-2',
  'robot-brain-combat-3',
  'robot-brain-combat-4',
  'robot-drone-frame',
  'robot-drone-frame-large',
  'robot-tool-combat',
  'robot-tool-combat-2',
  'robot-tool-combat-3',
  'robot-tool-combat-4',
  'rocket-body',
  'rocket-warhead',
  'scatter-cannon-shell',
  'science-pack-gold',
  'shot',
  'shotgun',
  'shotgun-acid-shell',
  'shotgun-ap-shell',
  'shotgun-electric-shell',
  'shotgun-explosive-shell',
  'shotgun-flame-shell',
  'shotgun-plasma-shell',
  'shotgun-poison-shell',
  'shotgun-shell',
  'shotgun-shell-casing',
  'shotgun-uranium-shell',
  'slowdown-capsule',
  'slowdown-mine',
  'solid-nitroglycerin',
  'solid-trinitrotoluene',
  'uranium-bullet',
  'uranium-bullet-projectile',
  'uranium-cannon-shell',
  'uranium-rounds-magazine'
}

for _,v in pairs(mil_items) do
  if data.raw[v.type] and data.raw[v.type][v.name] then
    seablock.lib.hide(v.type, v.name)
  end
end

for _,v in pairs(mil_ammo) do
  if data.raw[v.type] and data.raw[v.type][v.name] then
    seablock.lib.hide(v.type, v.name)
    seablock.lib.add_flag(v.type, v.name, 'hide-from-bonus-gui')
  end
end

for _,v in pairs(mil_tech) do
  if data.raw.technology[v] then
    seablock.lib.hide_technology(v)
  end
end

for _,v in pairs(mil_recipes) do
  seablock.lib.remove_recipe(v)
end

bobmods.lib.tech.remove_recipe_unlock('angels-advanced-gas-processing', 'gas-fractioning-residual')
bobmods.lib.tech.remove_recipe_unlock('chlorine-processing-2', 'liquid-glycerol')
bobmods.lib.tech.remove_recipe_unlock('fluid-handling', 'empty-alien-acid-barrel')
bobmods.lib.tech.remove_recipe_unlock('fluid-handling', 'empty-alien-explosive-barrel')
bobmods.lib.tech.remove_recipe_unlock('fluid-handling', 'empty-alien-fire-barrel')
bobmods.lib.tech.remove_recipe_unlock('fluid-handling', 'empty-alien-poison-barrel')
bobmods.lib.tech.remove_recipe_unlock('fluid-handling', 'empty-liquid-glycerol-barrel')
bobmods.lib.tech.remove_recipe_unlock('fluid-handling', 'empty-liquid-toluene-barrel')
bobmods.lib.tech.remove_recipe_unlock('fluid-handling', 'empty-nitroglycerin-barrel')
bobmods.lib.tech.remove_recipe_unlock('fluid-handling', 'fill-alien-acid-barrel')
bobmods.lib.tech.remove_recipe_unlock('fluid-handling', 'fill-alien-explosive-barrel')
bobmods.lib.tech.remove_recipe_unlock('fluid-handling', 'fill-alien-fire-barrel')
bobmods.lib.tech.remove_recipe_unlock('fluid-handling', 'fill-alien-poison-barrel')
bobmods.lib.tech.remove_recipe_unlock('fluid-handling', 'fill-liquid-glycerol-barrel')
bobmods.lib.tech.remove_recipe_unlock('fluid-handling', 'fill-liquid-toluene-barrel')
bobmods.lib.tech.remove_recipe_unlock('fluid-handling', 'fill-nitroglycerin-barrel')
bobmods.lib.tech.remove_recipe_unlock('gas-steam-cracking-2', 'liquid-toluene-from-benzene')
bobmods.lib.tech.remove_recipe_unlock('military-3', 'combat-shotgun')
bobmods.lib.tech.remove_recipe_unlock('military-3', 'fire-capsule')
bobmods.lib.tech.remove_recipe_unlock('military-3', 'poison-capsule')
bobmods.lib.tech.remove_recipe_unlock('military-3', 'rifle')
bobmods.lib.tech.remove_recipe_unlock('military-3', 'slowdown-capsule')
bobmods.lib.tech.remove_recipe_unlock('military-3', 'sniper-rifle') -- Unlocked by it's own earlier tech
bobmods.lib.tech.remove_recipe_unlock('military-4', 'cluster-grenade')
bobmods.lib.tech.remove_recipe_unlock('military-4', 'piercing-shotgun-shell')
bobmods.lib.tech.remove_recipe_unlock('military', 'shotgun-shell')
bobmods.lib.tech.remove_recipe_unlock('military', 'shotgun')
bobmods.lib.tech.remove_recipe_unlock('oil-steam-cracking-2', 'liquid-toluene-from-naphtha')
bobmods.lib.tech.remove_recipe_unlock('robotics', 'robot-drone-frame-large')
bobmods.lib.tech.remove_recipe_unlock('robotics', 'robot-drone-frame')
bobmods.lib.tech.remove_recipe_unlock('uranium-ammo', 'explosive-uranium-cannon-shell')
bobmods.lib.tech.remove_recipe_unlock('uranium-ammo', 'shotgun-uranium-shell')
bobmods.lib.tech.remove_recipe_unlock('uranium-ammo', 'uranium-bullet-projectile')
bobmods.lib.tech.remove_recipe_unlock('uranium-ammo', 'uranium-bullet')
bobmods.lib.tech.remove_recipe_unlock('uranium-ammo', 'uranium-cannon-shell')
bobmods.lib.tech.remove_recipe_unlock('uranium-ammo', 'uranium-rounds-magazine')
bobmods.lib.tech.remove_recipe_unlock('zinc-processing', 'gunmetal-alloy')

seablock.lib.substresult('nutrients-refining-2', 'liquid-glycerol', 'water', nil)
if data.raw.recipe['nutrients-refining-2'] then
  data.raw.recipe['nutrients-refining-2'].icons =
    angelsmods.functions.create_liquid_recipe_icon(
        {
          "liquid-fuel-oil",
          {"__base__/graphics/icons/fluid/water.png", 64}
        },
        {{214, 146, 040}, {169, 130, 039}, {120, 083, 004}}
      )
end

for i = 1, 6 do
  seablock.lib.remove_effect('physical-projectile-damage-' .. i, 'turret-attack', 'turret_id', 'bob-gun-turret-3')
  seablock.lib.remove_effect('physical-projectile-damage-' .. i, 'turret-attack', 'turret_id', 'bob-gun-turret-4')
  seablock.lib.remove_effect('physical-projectile-damage-' .. i, 'turret-attack', 'turret_id', 'bob-gun-turret-5')
  seablock.lib.remove_effect('physical-projectile-damage-' .. i, 'turret-attack', 'turret_id', 'bob-sniper-turret-3')
  seablock.lib.remove_effect('physical-projectile-damage-' .. i, 'ammo-damage', 'ammo_category', 'shotgun-shell')
  seablock.lib.remove_effect('energy-weapons-damage-' .. i, 'ammo-damage', 'ammo_category', 'laser-rifle')
  seablock.lib.remove_effect('energy-weapons-damage-' .. i, 'ammo-damage', 'ammo_category', 'beam')
  seablock.lib.remove_effect('weapon-shooting-speed-' .. i, 'gun-speed', 'ammo_category', 'shotgun-shell')
  seablock.lib.remove_effect('laser-shooting-speed-' .. i, 'gun-speed', 'ammo_category', 'laser-rifle')
  seablock.lib.remove_effect('stronger-explosives-' .. i, 'ammo-damage', 'ammo_category', 'landmine')
end

-- Swap out alien research packs
local mil_techswap = {
   -- 150 Red, Green, Blue, Purple
  {
    tech_name = 'bob-battery-equipment-4',
    science_packs = {{'automation-science-pack', 1},
                     {'logistic-science-pack', 1},
                     {'chemical-science-pack', 1},
                     {'production-science-pack', 1}}
  },
  -- 200 Red, Green, Blue, Purple, Pink
  {
    tech_name = 'bob-battery-equipment-5',
    science_packs = {{'automation-science-pack', 1},
                     {'logistic-science-pack', 1},
                     {'chemical-science-pack', 1},
                     {'production-science-pack', 1},
                     {'advanced-logistic-science-pack', 1}}
  },
  -- 250 Red, Green, Blue, Purple, Pink, Yellow
  {
    tech_name = 'bob-battery-equipment-6',
    science_packs = {{'automation-science-pack', 1},
                     {'logistic-science-pack', 1},
                     {'chemical-science-pack', 1},
                     {'production-science-pack', 1},
                     {'advanced-logistic-science-pack', 1},
                     {'utility-science-pack', 1}}
  },
  -- 200 Red, Green, Military, Blue, Purple, Pink
  {
    tech_name = 'bob-energy-shield-equipment-4',
    science_packs = {{'automation-science-pack', 1},
                     {'logistic-science-pack', 1},
                     {'military-science-pack', 1},
                     {'chemical-science-pack', 1},
                     {'production-science-pack', 1},
                     {'advanced-logistic-science-pack', 1}}
  },
  -- 250 Red, Green, Military, Blue, Purple, Pink, Yellow
  {
    tech_name = 'bob-energy-shield-equipment-5',
    science_packs = {{'automation-science-pack', 1},
                     {'logistic-science-pack', 1},
                     {'military-science-pack', 1},
                     {'chemical-science-pack', 1},
                     {'production-science-pack', 1},
                     {'advanced-logistic-science-pack', 1},
                     {'utility-science-pack', 1}}
  },
  -- 300 Red, Green, Military, Blue, Purple, Pink, Yellow, White
  {
    tech_name = 'bob-energy-shield-equipment-6',
    science_packs = {{'automation-science-pack', 1},
                     {'logistic-science-pack', 1},
                     {'military-science-pack', 1},
                     {'chemical-science-pack', 1},
                     {'production-science-pack', 1},
                     {'advanced-logistic-science-pack', 1},
                     {'utility-science-pack', 1},
                     {'space-science-pack', 1}}
  },
  -- 200 Red, Green, Military, Blue, Purple, Yellow
  {
    tech_name = 'bob-power-armor-3',
    science_packs = {{'automation-science-pack', 1},
                     {'logistic-science-pack', 1},
                     {'military-science-pack', 1},
                     {'chemical-science-pack', 1},
                     {'production-science-pack', 1},
                     {'utility-science-pack', 1}}
  },
  -- 250 Red, Green, Military, Blue, Purple, Pink, Yellow
  {
    tech_name = 'bob-power-armor-4',
    science_packs = {{'automation-science-pack', 1},
                     {'logistic-science-pack', 1},
                     {'military-science-pack', 1},
                     {'chemical-science-pack', 1},
                     {'production-science-pack', 1},
                     {'advanced-logistic-science-pack', 1},
                     {'utility-science-pack', 1}}
  },
  -- 300 Red, Green, Military, Blue, Purple, Pink, Yellow, White
  {
    tech_name = 'bob-power-armor-5',
    science_packs = {{'automation-science-pack', 1},
                     {'logistic-science-pack', 1},
                     {'military-science-pack', 1},
                     {'chemical-science-pack', 1},
                     {'production-science-pack', 1},
                     {'advanced-logistic-science-pack', 1},
                     {'utility-science-pack', 1},
                     {'space-science-pack', 1}}
  },
  -- 250 Red, Green, Military, Blue, Purple, Yellow
  {
    tech_name = 'fusion-reactor-equipment-2',
    science_packs = {{'automation-science-pack', 1},
                     {'logistic-science-pack', 1},
                     {'military-science-pack', 1},
                     {'chemical-science-pack', 1},
                     {'production-science-pack', 1},
                     {'utility-science-pack', 1}}
  },
  -- 300 Red, Green, Military, Blue, Purple, Pink, Yellow
  {
    tech_name = 'fusion-reactor-equipment-3',
    science_packs = {{'automation-science-pack', 1},
                     {'logistic-science-pack', 1},
                     {'military-science-pack', 1},
                     {'chemical-science-pack', 1},
                     {'production-science-pack', 1},
                     {'advanced-logistic-science-pack', 1},
                     {'utility-science-pack', 1}}
  },
  -- 350 Red, Green, Military, Blue, Purple, Pink, Yellow, White
  {
    tech_name = 'fusion-reactor-equipment-4',
    science_packs = {{'automation-science-pack', 1},
                     {'logistic-science-pack', 1},
                     {'military-science-pack', 1},
                     {'chemical-science-pack', 1},
                     {'production-science-pack', 1},
                     {'advanced-logistic-science-pack', 1},
                     {'utility-science-pack', 1},
                     {'space-science-pack', 1}}
  }
}

for _,v in pairs(mil_techswap) do
  if data.raw.technology[v.tech_name] then
    bobmods.lib.tech.clear_science_packs(v.tech_name)
    for _,science_pack in pairs(v.science_packs) do
      if data.raw.tool[science_pack[1]] then
        bobmods.lib.tech.add_new_science_pack(v.tech_name, science_pack[1], science_pack[2])
      end
    end
  end
end


-- Remove tank flamethrower
if data.raw.car and data.raw.car['tank'] then
  local guns = data.raw.car['tank'].guns
  for i, gun in pairs(guns) do
    if gun == 'tank-flamethrower' then
      table.remove(guns, i)
      break
    end
  end
end

-- Move Tank earlier. Add acid resistance
bobmods.lib.tech.remove_science_pack('tank', 'chemical-science-pack')
bobmods.lib.tech.replace_prerequisite('tank', 'military-3', 'military-science-pack')
local resistances = data.raw.car['tank'].resistances
for _,v in pairs(resistances) do
  if v.type == 'acid' then
    v.decrease = 25
    break
  end
end

if mods['bobwarfare'] then
  -- Move Plasma turrets later
  bobmods.lib.tech.add_new_science_pack('bob-plasma-turrets-1', 'chemical-science-pack', 1)
  bobmods.lib.tech.add_prerequisite('bob-plasma-turrets-1', 'military-3')
  bobmods.lib.tech.add_prerequisite('bob-plasma-turrets-1', 'angels-cobalt-steel-smelting-1')
  seablock.lib.substingredient('bob-plasma-turret-1', 'electronic-circuit', 'advanced-circuit', 40)
  seablock.lib.substingredient('bob-plasma-turret-1', 'steel-plate', 'cobalt-steel-alloy', nil)

  bobmods.lib.tech.add_new_science_pack('bob-plasma-turrets-2', 'chemical-science-pack', 1)
  bobmods.lib.tech.add_new_science_pack('bob-plasma-turrets-2', 'production-science-pack', 1)
  bobmods.lib.tech.add_prerequisite('bob-plasma-turrets-2', 'military-4')
  bobmods.lib.tech.add_prerequisite('bob-plasma-turrets-2', 'battery-2')
  bobmods.lib.tech.add_prerequisite('bob-plasma-turrets-2', 'angels-titanium-smelting-1')
  seablock.lib.substingredient('bob-plasma-turret-2', 'battery', 'lithium-ion-battery', nil)
  seablock.lib.substingredient('bob-plasma-turret-2', 'advanced-circuit', 'processing-unit', 40)
  seablock.lib.substingredient('bob-plasma-turret-2', 'steel-plate', 'titanium-plate', nil)
 
  -- Make Military 4 take Purple science rather than Yellow science
  bobmods.lib.tech.remove_science_pack('military-4', 'utility-science-pack')
  bobmods.lib.tech.add_new_science_pack('military-4', 'production-science-pack', 1)
  bobmods.lib.tech.replace_prerequisite('military-4', 'utility-science-pack', 'production-science-pack')

  -- Walking Vehicle (Antron) can now depend on Military 4
  bobmods.lib.tech.replace_prerequisite('walking-vehicle', 'military-3', 'military-4')

  -- Keep Power Armor MK2 accessible without Purple science
  bobmods.lib.tech.replace_prerequisite('power-armor-mk2', 'military-4', 'military-3')

  -- Move Artillery later
  bobmods.lib.tech.remove_science_pack('bob-artillery-turret-2', 'utility-science-pack', 1)
  bobmods.lib.tech.remove_science_pack('bob-artillery-wagon-2', 'utility-science-pack', 1)
  bobmods.lib.tech.add_new_science_pack('bob-artillery-turret-2', 'production-science-pack', 1)
  bobmods.lib.tech.add_new_science_pack('bob-artillery-wagon-2', 'production-science-pack', 1)
  bobmods.lib.tech.add_prerequisite('artillery', 'military-3')
  bobmods.lib.tech.add_prerequisite('artillery', 'cobalt-processing')
  bobmods.lib.tech.add_prerequisite('artillery', 'angels-stone-smelting-3')
  seablock.lib.substingredient('artillery-turret', 'iron-gear-wheel', 'cobalt-steel-gear-wheel', nil)
  seablock.lib.substingredient('artillery-turret', 'concrete', 'reinforced-concrete-brick', nil)
  seablock.lib.substingredient('artillery-turret', 'steel-plate', 'cobalt-steel-alloy', nil)
  seablock.lib.substingredient('artillery-wagon', 'iron-gear-wheel', 'cobalt-steel-gear-wheel', nil)
  seablock.lib.substingredient('artillery-wagon', 'pipe', 'brass-pipe', nil)
  seablock.lib.substingredient('artillery-wagon', 'steel-plate', 'cobalt-steel-alloy', nil)

  bobmods.lib.tech.add_prerequisite('artillery', 'radars-3')
  seablock.lib.substingredient('artillery-targeting-remote', 'radar', 'radar-4')
  
  bobmods.lib.tech.add_prerequisite('spidertron', 'radars-4')
  seablock.lib.substingredient('spidertron-remote', 'radar', 'radar-5')
  
  bobmods.lib.tech.add_prerequisite('bob-atomic-artillery-shell', 'utility-science-pack')
  
  -- Remove prerequisite as gunmetal smelting tech won't exist as we have disabled the trigger
  bobmods.lib.tech.remove_prerequisite('bob-armor-making-3', 'angels-gunmetal-smelting-1')

  -- Remove dependencies on Alien Research
  bobmods.lib.tech.remove_prerequisite('bob-power-armor-3', 'alien-research')
end

if mods['bobequipment'] then
  -- Remove dependencies on Alien Research
  bobmods.lib.tech.remove_prerequisite('bob-energy-shield-equipment-4', 'alien-research')
  bobmods.lib.tech.remove_prerequisite('bob-battery-equipment-4', 'alien-research')
  bobmods.lib.tech.remove_prerequisite('fusion-reactor-equipment-2', 'alien-research')

  bobmods.lib.tech.add_prerequisite('fusion-reactor-equipment-2', 'utility-science-pack')
end
