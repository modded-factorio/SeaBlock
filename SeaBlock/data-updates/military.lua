-- Hide most military stuff as there's no real need for it in Sea Block as the only enemies are Worms
local mil_items = {
  { type = "ammo-turret", name = "bob-gun-turret-3" },
  { type = "ammo-turret", name = "bob-gun-turret-4" },
  { type = "ammo-turret", name = "bob-gun-turret-5" },
  { type = "ammo-turret", name = "bob-sniper-turret-3" },
  --{ type = "armor", name = "modular-armor" },
  --{ type = "armor", name = "heavy-armor-3" },
  { type = "artillery-turret", name = "bob-artillery-turret-3" },
  { type = "artillery-wagon", name = "bob-artillery-wagon-3" },
  { type = "car", name = "bob-tank-2" },
  { type = "car", name = "bob-tank-3" },
  { type = "cargo-wagon", name = "bob-armoured-cargo-wagon-2" },
  { type = "cargo-wagon", name = "bob-armoured-cargo-wagon" },
  { type = "combat-robot", name = "defender" },
  { type = "combat-robot", name = "destroyer" },
  { type = "combat-robot", name = "distractor" },
  { type = "electric-turret", name = "bob-laser-turret-2" },
  { type = "electric-turret", name = "bob-laser-turret-3" },
  { type = "electric-turret", name = "bob-laser-turret-4" },
  { type = "electric-turret", name = "bob-laser-turret-5" },
  { type = "electric-turret", name = "bob-plasma-turret-3" },
  { type = "electric-turret", name = "bob-plasma-turret-4" },
  { type = "electric-turret", name = "bob-plasma-turret-5" },
  { type = "fluid-turret", name = "flamethrower-turret" },
  { type = "fluid-wagon", name = "bob-armoured-fluid-wagon-2" },
  { type = "fluid-wagon", name = "bob-armoured-fluid-wagon" },
  { type = "fluid", name = "alien-acid" },
  { type = "fluid", name = "bob-alien-explosive" },
  { type = "fluid", name = "bob-alien-fire" },
  { type = "fluid", name = "bob-alien-poison" },
  { type = "fluid", name = "angels-liquid-glycerol" },
  { type = "fluid", name = "angels-liquid-toluene" },
  { type = "fluid", name = "bob-nitroglycerin" },
  { type = "gun", name = "combat-shotgun" },
  { type = "gun", name = "flamethrower" },
  { type = "gun", name = "bob-laser-rifle" },
  { type = "gun", name = "bob-rifle" },
  { type = "gun", name = "shotgun" },
  { type = "item-with-entity-data", name = "bob-armoured-cargo-wagon-2" },
  { type = "item-with-entity-data", name = "bob-armoured-cargo-wagon" },
  { type = "item-with-entity-data", name = "bob-armoured-fluid-wagon-2" },
  { type = "item-with-entity-data", name = "bob-armoured-fluid-wagon" },
  { type = "item-with-entity-data", name = "bob-armoured-locomotive-2" },
  { type = "item-with-entity-data", name = "bob-armoured-locomotive" },
  { type = "item-with-entity-data", name = "bob-artillery-wagon-3" },
  { type = "item-with-entity-data", name = "bob-tank-2" },
  { type = "item-with-entity-data", name = "bob-tank-3" },
  { type = "item", name = "bob-acid-bullet-projectile" },
  { type = "item", name = "bob-acid-bullet" },
  { type = "item", name = "bob-acid-rocket-warhead" },
  { type = "item", name = "bob-alien-acid-barrel" },
  { type = "item", name = "bob-alien-blue-alloy" },
  { type = "item", name = "bob-alien-explosive-barrel" },
  { type = "item", name = "bob-alien-fire-barrel" },
  { type = "item", name = "bob-alien-orange-alloy" },
  { type = "item", name = "bob-alien-poison-barrel" },
  { type = "item", name = "bob-ap-bullet-projectile" },
  { type = "item", name = "bob-ap-bullet" },
  { type = "item", name = "bob-artillery-turret-3" },
  { type = "item", name = "bob-gun-turret-3" },
  { type = "item", name = "bob-gun-turret-4" },
  { type = "item", name = "bob-gun-turret-5" },
  { type = "item", name = "bob-laser-turret-2" },
  { type = "item", name = "bob-laser-turret-3" },
  { type = "item", name = "bob-laser-turret-4" },
  { type = "item", name = "bob-laser-turret-5" },
  { type = "item", name = "bob-plasma-turret-3" },
  { type = "item", name = "bob-plasma-turret-4" },
  { type = "item", name = "bob-plasma-turret-5" },
  { type = "item", name = "bob-robot-flamethrower-drone" },
  { type = "item", name = "bob-robot-gun-drone" },
  { type = "item", name = "bob-robot-laser-drone" },
  { type = "item", name = "bob-robot-plasma-drone" },
  { type = "item", name = "bob-sniper-turret-3" },
  { type = "item", name = "bob-bullet-casing" },
  { type = "item", name = "bob-bullet-projectile" },
  { type = "item", name = "bob-bullet" },
  { type = "item", name = "combat-robot-dispenser-equipment" },
  { type = "item", name = "bob-cordite" },
  { type = "item", name = "discharge-defense-equipment" },
  { type = "item", name = "bob-distractor-mine" },
  { type = "item", name = "bob-electric-bullet-projectile" },
  { type = "item", name = "bob-electric-bullet" },
  { type = "item", name = "bob-electric-rocket-warhead" },
  { type = "item", name = "explosive-rocket-warhead" },
  { type = "item", name = "bob-flame-bullet-projectile" },
  { type = "item", name = "bob-flame-bullet" },
  { type = "item", name = "flame-rocket-warhead" },
  { type = "item", name = "flamethrower-turret" },
  { type = "item", name = "bob-gun-cotton" },
  { type = "item", name = "bob-gunmetal-alloy" },
  { type = "item", name = "bob-he-bullet-projectile" },
  { type = "item", name = "bob-he-bullet" },
  { type = "item", name = "bob-lab-alien" },
  { type = "item", name = "land-mine" },
  { type = "item", name = "bob-laser-rifle-battery-case" },
  { type = "item", name = "angels-liquid-glycerol-barrel" },
  { type = "item", name = "angels-liquid-toluene-barrel" },
  { type = "item", name = "bob-magazine" },
  { type = "item", name = "bob-nitroglycerin-barrel" },
  { type = "item", name = "bob-petroleum-jelly" },
  { type = "item", name = "bob-piercing-rocket-warhead" },
  { type = "item", name = "bob-plasma-bullet-projectile" },
  { type = "item", name = "bob-plasma-bullet" },
  { type = "item", name = "bob-plasma-rocket-warhead" },
  { type = "item", name = "bob-poison-bullet-projectile" },
  { type = "item", name = "bob-poison-bullet" },
  { type = "item", name = "bob-poison-mine" },
  { type = "item", name = "bob-poison-rocket-warhead" },
  { type = "item", name = "bob-robot-drone-frame-large" },
  { type = "item", name = "bob-robot-drone-frame" },
  { type = "item", name = "bob-rocket-body" },
  { type = "item", name = "bob-rocket-warhead" },
  { type = "item", name = "bob-shot" },
  { type = "item", name = "bob-shotgun-shell-casing" },
  { type = "item", name = "bob-slowdown-mine" },
  { type = "item", name = "bob-uranium-bullet-projectile" },
  { type = "item", name = "bob-uranium-bullet" },
  { type = "lab", name = "bob-lab-alien" },
  { type = "land-mine", name = "bob-distractor-mine" },
  { type = "land-mine", name = "bob-land-mine" },
  { type = "land-mine", name = "bob-poison-mine" },
  { type = "land-mine", name = "bob-slowdown-mine" },
  { type = "locomotive", name = "bob-armoured-locomotive-2" },
  { type = "locomotive", name = "bob-armoured-locomotive" },
  { type = "tool", name = "bob-alien-science-pack-blue" },
  { type = "tool", name = "bob-alien-science-pack-green" },
  { type = "tool", name = "bob-alien-science-pack-orange" },
  { type = "tool", name = "bob-alien-science-pack-purple" },
  { type = "tool", name = "bob-alien-science-pack-red" },
  { type = "tool", name = "bob-alien-science-pack-yellow" },
  { type = "tool", name = "bob-alien-science-pack" },
  { type = "tool", name = "bob-science-pack-gold" },
  { type = "unit", name = "bob-robot-flamethrower-drone" },
  { type = "unit", name = "bob-robot-gun-drone" },
  { type = "unit", name = "bob-robot-laser-drone" },
  { type = "unit", name = "bob-robot-plasma-drone" },
}

local mil_tech = {
  "bob-alien-blue-research",
  "bob-alien-green-research",
  "bob-alien-orange-research",
  "bob-alien-purple-research",
  "bob-alien-red-research",
  "bob-alien-research",
  "bob-alien-yellow-research",
  "angels-explosives-1",
  "angels-explosives-2",
  "bob-acid-bullets",
  "bob-acid-rocket",
  "bob-ap-bullets",
  "bob-armor-making-3",
  "bob-armor-making-4",
  "bob-armoured-fluid-wagon",
  "bob-armoured-fluid-wagon-2",
  "bob-armoured-railway",
  "bob-armoured-railway-2",
  "bob-artillery-turret-3",
  "bob-artillery-wagon-3",
  "bob-bullets",
  "bob-distractor-artillery-shells",
  "bob-electric-bullets",
  "bob-electric-rocket",
  "bob-explosive-artillery-shells",
  "bob-explosive-rocket",
  "bob-fire-artillery-shells",
  "bob-flame-bullets",
  "bob-flame-rocket",
  "bob-he-bullets",
  "bob-laser-rifle",
  "bob-laser-rifle-ammo-1",
  "bob-laser-rifle-ammo-2",
  "bob-laser-rifle-ammo-3",
  "bob-laser-rifle-ammo-4",
  "bob-laser-rifle-ammo-5",
  "bob-laser-rifle-ammo-6",
  "bob-laser-turrets-2",
  "bob-laser-turrets-3",
  "bob-laser-turrets-4",
  "bob-laser-turrets-5",
  "bob-piercing-rocket",
  "bob-plasma-rocket",
  "bob-plasma-bullets",
  "bob-plasma-turrets-3",
  "bob-plasma-turrets-4",
  "bob-plasma-turrets-5",
  "bob-poison-artillery-shells",
  "bob-poison-bullets",
  "bob-poison-rocket",
  "bob-robot-flamethrower-drones",
  "bob-robot-gun-drones",
  "bob-robot-laser-drones",
  "bob-robot-plasma-drones",
  "bob-rocket",
  "bob-scatter-cannon-shells",
  "bob-shotgun-acid-shells",
  "bob-shotgun-ap-shells",
  "bob-shotgun-electric-shells",
  "bob-shotgun-flame-shells",
  "bob-shotgun-explosive-shells",
  "bob-shotgun-plasma-shells",
  "bob-shotgun-poison-shells",
  "bob-shotgun-shells",
  "bob-sniper-turrets-3",
  "bob-tanks-2",
  "bob-tanks-3",
  "bob-turrets-3",
  "bob-turrets-4",
  "bob-turrets-5",
  "bob-cordite-processing",
  "defender",
  "destroyer",
  "discharge-defense-equipment",
  "distractor",
  "bob-distractor-mine",
  "energy-weapons-damage-7", -- Infinite
  "explosive-rocketry",
  "flamethrower",
  "follower-robot-count-1",
  "follower-robot-count-2",
  "follower-robot-count-3",
  "follower-robot-count-4",
  "follower-robot-count-5",
  "follower-robot-count-6",
  "follower-robot-count-7", -- Infinite
  "land-mine",
  "laser-shooting-speed-7",
  "bob-nitroglycerin-processing",
  "physical-projectile-damage-7", -- Infinite
  "bob-poison-mine",
  "refined-flammables-1",
  "refined-flammables-2",
  "refined-flammables-3",
  "refined-flammables-4",
  "refined-flammables-5",
  "refined-flammables-6",
  "refined-flammables-7", -- Infinite
  "sct-alien-science-pack",
  "sct-lab-alien",
  "sct-science-pack-gold",
  "bob-slowdown-mine",
  "stronger-explosives-7", -- Infinite
  "uranium-ammo",
}

local mil_ammo = {
  { type = "ammo", name = "bob-acid-bullet-magazine" },
  { type = "ammo", name = "bob-ap-bullet-magazine" },
  { type = "ammo", name = "bob-better-shotgun-shell" },
  { type = "ammo", name = "bob-acid-rocket" },
  { type = "ammo", name = "bob-electric-rocket" },
  { type = "ammo", name = "bob-explosive-rocket" },
  { type = "ammo", name = "bob-flame-rocket" },
  { type = "ammo", name = "bob-piercing-rocket" },
  { type = "ammo", name = "bob-plasma-rocket" },
  { type = "ammo", name = "bob-poison-rocket" },
  { type = "ammo", name = "bob-rocket" },
  { type = "ammo", name = "bob-bullet-magazine" },
  { type = "ammo", name = "bob-distractor-artillery-shell" },
  { type = "ammo", name = "bob-electric-bullet-magazine" },
  { type = "ammo", name = "explosive-artillery-shell" },
  { type = "ammo", name = "explosive-rocket" },
  { type = "ammo", name = "bob-explosive-uranium-cannon-shell" },
  { type = "ammo", name = "bob-fire-artillery-shell" },
  { type = "ammo", name = "bob-flame-bullet-magazine" },
  { type = "ammo", name = "flamethrower-ammo" },
  { type = "ammo", name = "bob-he-bullet-magazine" },
  { type = "ammo", name = "bob-laser-rifle-battery-amethyst" },
  { type = "ammo", name = "bob-laser-rifle-battery-diamond" },
  { type = "ammo", name = "bob-laser-rifle-battery-emerald" },
  { type = "ammo", name = "bob-laser-rifle-battery-ruby" },
  { type = "ammo", name = "bob-laser-rifle-battery-sapphire" },
  { type = "ammo", name = "bob-laser-rifle-battery-topaz" },
  { type = "ammo", name = "bob-laser-rifle-battery" },
  { type = "ammo", name = "piercing-shotgun-shell" },
  { type = "ammo", name = "bob-plasma-bullet-magazine" },
  { type = "ammo", name = "bob-poison-artillery-shell" },
  { type = "ammo", name = "bob-poison-bullet-magazine" },
  { type = "ammo", name = "bob-scatter-cannon-shell" },
  { type = "ammo", name = "bob-shotgun-acid-shell" },
  { type = "ammo", name = "bob-shotgun-ap-shell" },
  { type = "ammo", name = "bob-shotgun-electric-shell" },
  { type = "ammo", name = "bob-shotgun-explosive-shell" },
  { type = "ammo", name = "bob-shotgun-flame-shell" },
  { type = "ammo", name = "bob-shotgun-plasma-shell" },
  { type = "ammo", name = "bob-shotgun-poison-shell" },
  { type = "ammo", name = "shotgun-shell" },
  { type = "ammo", name = "bob-shotgun-uranium-shell" },
  { type = "ammo", name = "bob-uranium-cannon-shell" },
  { type = "ammo", name = "uranium-rounds-magazine" },
  { type = "capsule", name = "cluster-grenade" },
  { type = "capsule", name = "defender-capsule" },
  { type = "capsule", name = "destroyer-capsule" },
  { type = "capsule", name = "discharge-defense-remote" },
  { type = "capsule", name = "distractor-capsule" },
  { type = "capsule", name = "bob-fire-capsule" },
  { type = "capsule", name = "poison-capsule" },
  { type = "capsule", name = "slowdown-capsule" },
}

local mil_recipes = {
  "bob-acid-bullet",
  "bob-acid-bullet-magazine",
  "bob-acid-bullet-projectile",
  "bob-acid-rocket-warhead",
  "bob-alien-acid",
  "bob-alien-blue-alloy",
  "bob-alien-explosive",
  "bob-alien-fire",
  "bob-alien-orange-alloy",
  "bob-alien-poison",
  "bob-alien-science-pack",
  "bob-alien-science-pack-blue",
  "bob-alien-science-pack-green",
  "bob-alien-science-pack-orange",
  "bob-alien-science-pack-purple",
  "bob-alien-science-pack-red",
  "bob-alien-science-pack-yellow",
  "angels-chemical-void-angels-liquid-glycerol",
  "angels-chemical-void-angels-liquid-toluene",
  "bob-ap-bullet",
  "bob-ap-bullet-magazine",
  "bob-ap-bullet-projectile",
  "bob-better-shotgun-shell",
  "bob-acid-rocket",
  "bob-armoured-cargo-wagon",
  "bob-armoured-cargo-wagon-2",
  "bob-armoured-fluid-wagon",
  "bob-armoured-fluid-wagon-2",
  "bob-armoured-locomotive",
  "bob-armoured-locomotive-2",
  "bob-artillery-turret-3",
  "bob-artillery-wagon-3",
  "bob-electric-rocket",
  "bob-explosive-rocket",
  "bob-flame-rocket",
  "bob-gun-turret-3",
  "bob-gun-turret-4",
  "bob-gun-turret-5",
  "bob-laser-turret-2",
  "bob-laser-turret-3",
  "bob-laser-turret-4",
  "bob-laser-turret-5",
  "bob-piercing-rocket",
  "bob-plasma-rocket",
  "bob-plasma-turret-3",
  "bob-plasma-turret-4",
  "bob-poison-rocket",
  "bob-robot-flamethrower-drone",
  "bob-robot-gun-drone",
  "bob-robot-laser-drone",
  "bob-robot-plasma-drone",
  "bob-rocket",
  "bob-sniper-turret-3",
  "bob-tank-2",
  "bob-tank-3",
  "bob-bullet",
  "bob-bullet-casing",
  "bob-bullet-magazine",
  "bob-bullet-projectile",
  "cluster-grenade",
  "combat-shotgun",
  "bob-cordite",
  "defender-capsule",
  "destroyer-capsule",
  "discharge-defense-equipment",
  "bob-distractor-artillery-shell",
  "distractor-capsule",
  "bob-distractor-mine",
  "bob-electric-bullet",
  "bob-electric-bullet-magazine",
  "bob-electric-bullet-projectile",
  "electric-energy-interface",
  "bob-electric-rocket-warhead",
  "empty-bob-alien-acid-barrel",
  "empty-bob-alien-explosive-barrel",
  "empty-bob-alien-fire-barrel",
  "empty-bob-alien-poison-barrel",
  "empty-angels-liquid-glycerol-barrel",
  "empty-angels-liquid-toluene-barrel",
  "empty-bob-nitroglycerin-barrel",
  "bob-explosive-artillery-shell",
  "explosive-rocket",
  "bob-explosive-rocket-warhead",
  "explosive-uranium-cannon-shell",
  "bob-alien-acid-barrel",
  "bob-alien-explosive-barrel",
  "bob-alien-fire-barrel",
  "bob-alien-poison-barrel",
  "angels-liquid-glycerol-barrel",
  "angels-liquid-toluene-barrel",
  "bob-nitroglycerin-barrel",
  "bob-fire-artillery-shell",
  "bob-fire-capsule",
  "bob-flame-bullet",
  "bob-flame-bullet-magazine",
  "bob-flame-bullet-projectile",
  "bob-flame-rocket-warhead",
  "flamethrower",
  "flamethrower-ammo",
  "flamethrower-turret",
  "angels-gas-fractioning-residual",
  "bob-gun-cotton",
  "bob-gunmetal-alloy",
  "bob-he-bullet",
  "bob-he-bullet-magazine",
  "bob-he-bullet-projectile",
  --"modular-armor",
  --"heavy-armor-3",
  "bob-lab-alien",
  "land-mine",
  "bob-laser-rifle",
  "bob-laser-rifle-battery",
  "bob-laser-rifle-battery-amethyst",
  "bob-laser-rifle-battery-case",
  "bob-laser-rifle-battery-diamond",
  "bob-laser-rifle-battery-emerald",
  "bob-laser-rifle-battery-ruby",
  "bob-laser-rifle-battery-sapphire",
  "bob-laser-rifle-battery-topaz",
  "angels-liquid-glycerol",
  "angels-liquid-toluene-from-benzene",
  "angels-liquid-toluene",
  "bob-magazine",
  "bob-nitroglycerin",
  "bob-petroleum-jelly",
  "bob-piercing-rocket-warhead",
  "piercing-shotgun-shell",
  "bob-plasma-bullet",
  "bob-plasma-bullet-magazine",
  "bob-plasma-bullet-projectile",
  "bob-plasma-rocket-warhead",
  "bob-poison-artillery-shell",
  "bob-poison-bullet",
  "bob-poison-bullet-magazine",
  "bob-poison-bullet-projectile",
  "poison-capsule",
  "bob-poison-mine",
  "bob-poison-rocket-warhead",
  "bob-rifle",
  "bob-robot-drone-frame",
  "bob-robot-drone-frame-large",
  "bob-rocket-body",
  "bob-rocket-warhead",
  "bob-scatter-cannon-shell",
  "bob-science-pack-gold",
  "bob-shot",
  "shotgun",
  "bob-shotgun-acid-shell",
  "bob-shotgun-ap-shell",
  "bob-shotgun-electric-shell",
  "bob-shotgun-explosive-shell",
  "bob-shotgun-flame-shell",
  "bob-shotgun-plasma-shell",
  "bob-shotgun-poison-shell",
  "shotgun-shell",
  "bob-shotgun-shell-casing",
  "bob-shotgun-uranium-shell",
  "slowdown-capsule",
  "bob-slowdown-mine",
  "angels-solid-nitroglycerin",
  "angels-solid-trinitrotoluene",
  "bob-uranium-bullet",
  "bob-uranium-bullet-projectile",
  "uranium-cannon-shell",
  "uranium-rounds-magazine",
}

for _, v in pairs(mil_items) do
  if data.raw[v.type] and data.raw[v.type][v.name] then
    seablock.lib.hide(v.type, v.name)
  end
end

for _, v in pairs(mil_ammo) do
  if data.raw[v.type] and data.raw[v.type][v.name] then
    seablock.lib.hide(v.type, v.name)
    seablock.lib.add_flag(v.type, v.name, "hide-from-bonus-gui")
  end
end

-- except = {
--   ["follower-robot-count-1"] = true,
--   ["follower-robot-count-2"] = true,
--   ["follower-robot-count-3"] = true,
--   ["follower-robot-count-4"] = true,
--   ["follower-robot-count-5"] = true,
--   ["follower-robot-count-6"] = true,
--   ["follower-robot-count-7"] = true,
--   ["energy-weapons-damage-7"] = true,
--   ["physical-projectile-damage-7"] = true,
--   ["refined-flammables-1"] = true,
--   ["refined-flammables-2"] = true,
--   ["refined-flammables-3"] = true,
--   ["refined-flammables-4"] = true,
--   ["refined-flammables-5"] = true,
--   ["refined-flammables-6"] = true,
--   ["refined-flammables-7"] = true,
--   ["stronger-explosives-7"] = true,
--   ["laser-shooting-speed-7"] = true,
-- }
for _, v in pairs(mil_tech) do
  if data.raw.technology[v] then
    seablock.lib.hide_technology(v)
    -- if not except[v] then
    --   data.raw.technology[v].unit.ingredients = {} --remove 
    -- end
  end
end

for _, v in pairs(mil_recipes) do
  bobmods.lib.recipe.hide(v)
end

-- Remove hidden upgrade
if mods["bobwarfare"] then
  data.raw["ammo-turret"]["bob-gun-turret-2"].next_upgrade = nil
  data.raw["ammo-turret"]["bob-sniper-turret-2"].next_upgrade = nil
  data.raw["electric-turret"]["bob-plasma-turret-2"].next_upgrade = nil
  data.raw["artillery-turret"]["bob-artillery-turret-2"].next_upgrade = nil
  data.raw["artillery-wagon"]["bob-artillery-wagon-2"].next_upgrade = nil
end
data.raw["electric-turret"]["laser-turret"].next_upgrade = nil


bobmods.lib.tech.remove_recipe_unlock("angels-advanced-gas-processing", "gas-fractioning-residual")
bobmods.lib.tech.remove_recipe_unlock("bob-fluid-barrel-processing", "empty-liquid-glycerol-barrel")
bobmods.lib.tech.remove_recipe_unlock("bob-fluid-barrel-processing", "empty-liquid-toluene-barrel")
bobmods.lib.tech.remove_recipe_unlock("bob-fluid-barrel-processing", "empty-bob-nitroglycerin-barrel")
bobmods.lib.tech.remove_recipe_unlock("bob-fluid-barrel-processing", "liquid-glycerol-barrel")
bobmods.lib.tech.remove_recipe_unlock("bob-fluid-barrel-processing", "liquid-toluene-barrel")
bobmods.lib.tech.remove_recipe_unlock("bob-fluid-barrel-processing", "bob-nitroglycerin-barrel")
bobmods.lib.tech.remove_recipe_unlock("bob-fluid-canister-processing", "empty-bob-alien-acid-barrel")
bobmods.lib.tech.remove_recipe_unlock("bob-fluid-canister-processing", "empty-bob-alien-explosive-barrel")
bobmods.lib.tech.remove_recipe_unlock("bob-fluid-canister-processing", "empty-bob-alien-fire-barrel")
bobmods.lib.tech.remove_recipe_unlock("bob-fluid-canister-processing", "empty-bob-alien-poison-barrel")
bobmods.lib.tech.remove_recipe_unlock("bob-fluid-canister-processing", "bob-alien-acid-barrel")
bobmods.lib.tech.remove_recipe_unlock("bob-fluid-canister-processing", "bob-alien-explosive-barrel")
bobmods.lib.tech.remove_recipe_unlock("bob-fluid-canister-processing", "bob-alien-fire-barrel")
bobmods.lib.tech.remove_recipe_unlock("bob-fluid-canister-processing", "bob-alien-poison-barrel")
bobmods.lib.tech.remove_recipe_unlock("military", "shotgun")
bobmods.lib.tech.remove_recipe_unlock("military", "shotgun-shell")
bobmods.lib.tech.remove_recipe_unlock("military-3", "combat-shotgun")
bobmods.lib.tech.remove_recipe_unlock("military-3", "bob-fire-capsule")
bobmods.lib.tech.remove_recipe_unlock("military-3", "poison-capsule")
bobmods.lib.tech.remove_recipe_unlock("military-3", "bob-rifle")
bobmods.lib.tech.remove_recipe_unlock("military-3", "slowdown-capsule")
bobmods.lib.tech.remove_recipe_unlock("military-3", "bob-sniper-rifle") -- Unlocked by it's own earlier tech
bobmods.lib.tech.remove_recipe_unlock("military-4", "cluster-grenade")
bobmods.lib.tech.remove_recipe_unlock("military-4", "piercing-shotgun-shell")
bobmods.lib.tech.remove_recipe_unlock("robotics", "bob-robot-drone-frame")
bobmods.lib.tech.remove_recipe_unlock("robotics", "bob-robot-drone-frame-large")
bobmods.lib.tech.remove_recipe_unlock("uranium-ammo", "explosive-uranium-cannon-shell")
bobmods.lib.tech.remove_recipe_unlock("uranium-ammo", "bob-shotgun-uranium-shell")
bobmods.lib.tech.remove_recipe_unlock("uranium-ammo", "bob-uranium-bullet")
bobmods.lib.tech.remove_recipe_unlock("uranium-ammo", "bob-uranium-bullet-projectile")
bobmods.lib.tech.remove_recipe_unlock("uranium-ammo", "uranium-cannon-shell")
bobmods.lib.tech.remove_recipe_unlock("uranium-ammo", "uranium-rounds-magazine")
bobmods.lib.tech.remove_recipe_unlock("bob-zinc-processing", "bob-gunmetal-alloy")

seablock.lib.substresult("angels-nutrients-refining-2", "angels-liquid-glycerol", "water", nil)
if data.raw.recipe["angels-nutrients-refining-2"] then
  data.raw.recipe["angels-nutrients-refining-2"].icons = angelsmods.functions.create_liquid_recipe_icon({
    "angels-liquid-fuel-oil",
    { "__base__/graphics/icons/fluid/water.png", 64 },
  }, { { 214, 146, 040 }, { 169, 130, 039 }, { 120, 083, 004 } })
end

for i = 1, 6 do
  seablock.lib.remove_effect("physical-projectile-damage-" .. i, "turret-attack", "turret_id", "bob-gun-turret-3")
  seablock.lib.remove_effect("physical-projectile-damage-" .. i, "turret-attack", "turret_id", "bob-gun-turret-4")
  seablock.lib.remove_effect("physical-projectile-damage-" .. i, "turret-attack", "turret_id", "bob-gun-turret-5")
  seablock.lib.remove_effect("physical-projectile-damage-" .. i, "turret-attack", "turret_id", "bob-sniper-turret-3")
  seablock.lib.remove_effect("physical-projectile-damage-" .. i, "ammo-damage", "ammo_category", "shotgun-shell")
  seablock.lib.remove_effect("laser-weapons-damage-" .. i, "ammo-damage", "ammo_category", "bob-laser-rifle")
  seablock.lib.remove_effect("laser-weapons-damage-" .. i, "ammo-damage", "ammo_category", "beam")
  seablock.lib.remove_effect("weapon-shooting-speed-" .. i, "gun-speed", "ammo_category", "shotgun-shell")
  seablock.lib.remove_effect("laser-shooting-speed-" .. i, "gun-speed", "ammo_category", "bob-laser-rifle")
  seablock.lib.remove_effect("stronger-explosives-" .. i, "ammo-damage", "ammo_category", "landmine")
end

-- Swap out alien research packs
local mil_techswap = {
  -- 150 Red, Green, Blue, Purple
  {
    tech_name = "bob-battery-equipment-4",
    science_packs = {
      { "automation-science-pack", 1 },
      { "logistic-science-pack", 1 },
      { "chemical-science-pack", 1 },
      { "production-science-pack", 1 },
    },
  },
  -- 200 Red, Green, Blue, Purple, Pink
  {
    tech_name = "bob-battery-equipment-5",
    science_packs = {
      { "automation-science-pack", 1 },
      { "logistic-science-pack", 1 },
      { "chemical-science-pack", 1 },
      { "production-science-pack", 1 },
      { "bob-advanced-logistic-science-pack", 1 },
    },
  },
  -- 250 Red, Green, Blue, Purple, Pink, Yellow
  {
    tech_name = "bob-battery-equipment-6",
    science_packs = {
      { "automation-science-pack", 1 },
      { "logistic-science-pack", 1 },
      { "chemical-science-pack", 1 },
      { "production-science-pack", 1 },
      { "bob-advanced-logistic-science-pack", 1 },
      { "utility-science-pack", 1 },
    },
  },
  -- 200 Red, Green, Military, Blue, Purple, Pink
  {
    tech_name = "bob-energy-shield-equipment-4",
    science_packs = {
      { "automation-science-pack", 1 },
      { "logistic-science-pack", 1 },
      { "military-science-pack", 1 },
      { "chemical-science-pack", 1 },
      { "production-science-pack", 1 },
      { "bob-advanced-logistic-science-pack", 1 },
    },
  },
  -- 250 Red, Green, Military, Blue, Purple, Pink, Yellow
  {
    tech_name = "bob-energy-shield-equipment-5",
    science_packs = {
      { "automation-science-pack", 1 },
      { "logistic-science-pack", 1 },
      { "military-science-pack", 1 },
      { "chemical-science-pack", 1 },
      { "production-science-pack", 1 },
      { "bob-advanced-logistic-science-pack", 1 },
      { "utility-science-pack", 1 },
    },
  },
  -- 300 Red, Green, Military, Blue, Purple, Pink, Yellow, White
  {
    tech_name = "bob-energy-shield-equipment-6",
    science_packs = {
      { "automation-science-pack", 1 },
      { "logistic-science-pack", 1 },
      { "military-science-pack", 1 },
      { "chemical-science-pack", 1 },
      { "production-science-pack", 1 },
      { "bob-advanced-logistic-science-pack", 1 },
      { "utility-science-pack", 1 },
      { "space-science-pack", 1 },
    },
  },
  -- 200 Red, Green, Military, Blue, Pink / Purple
  {
    tech_name = "bob-power-armor-3",
    science_packs = {
      { "automation-science-pack", 1 },
      { "logistic-science-pack", 1 },
      { "military-science-pack", 1 },
      { "chemical-science-pack", 1 },
      { mods["bobtech"] and "bob-advanced-logistic-science-pack" or "production-science-pack", 1 },
    },
  },
  -- 250 Red, Green, Military, Blue, Purple, Pink, Yellow
  {
    tech_name = "bob-power-armor-4",
    science_packs = {
      { "automation-science-pack", 1 },
      { "logistic-science-pack", 1 },
      { "military-science-pack", 1 },
      { "chemical-science-pack", 1 },
      { "production-science-pack", 1 },
      { "bob-advanced-logistic-science-pack", 1 },
      { "utility-science-pack", 1 },
    },
  },
  -- 300 Red, Green, Military, Blue, Purple, Pink, Yellow, White
  {
    tech_name = "bob-power-armor-5",
    science_packs = {
      { "automation-science-pack", 1 },
      { "logistic-science-pack", 1 },
      { "military-science-pack", 1 },
      { "chemical-science-pack", 1 },
      { "production-science-pack", 1 },
      { "bob-advanced-logistic-science-pack", 1 },
      { "utility-science-pack", 1 },
      { "space-science-pack", 1 },
    },
  },
  -- 250 Red, Green, Military, Blue, Purple, Pink
  {
    tech_name = "bob-fission-reactor-equipment-2",
    science_packs = {
      { "automation-science-pack", 1 },
      { "logistic-science-pack", 1 },
      { "military-science-pack", 1 },
      { "chemical-science-pack", 1 },
      { "production-science-pack", 1 },
      { "bob-advanced-logistic-science-pack", 1 },
    },
  },
  -- 300 Red, Green, Military, Blue, Purple, Pink, Yellow
  {
    tech_name = "bob-fission-reactor-equipment-3",
    science_packs = {
      { "automation-science-pack", 1 },
      { "logistic-science-pack", 1 },
      { "military-science-pack", 1 },
      { "chemical-science-pack", 1 },
      { "production-science-pack", 1 },
      { "bob-advanced-logistic-science-pack", 1 },
      { "utility-science-pack", 1 },
    },
  },
  -- 350 Red, Green, Military, Blue, Purple, Pink, Yellow, White
  {
    tech_name = "bob-fission-reactor-equipment-4",
    science_packs = {
      { "automation-science-pack", 1 },
      { "logistic-science-pack", 1 },
      { "military-science-pack", 1 },
      { "chemical-science-pack", 1 },
      { "production-science-pack", 1 },
      { "bob-advanced-logistic-science-pack", 1 },
      { "utility-science-pack", 1 },
      { "space-science-pack", 1 },
    },
  },
  -- 150 Red, Green, Blue, Purple
  {
    tech_name = "vehicle-battery-equipment-4",
    science_packs = {
      { "automation-science-pack", 1 },
      { "logistic-science-pack", 1 },
      { "chemical-science-pack", 1 },
      { "production-science-pack", 1 },
    },
  },
  -- 200 Red, Green, Blue, Purple, Pink
  {
    tech_name = "vehicle-battery-equipment-5",
    science_packs = {
      { "automation-science-pack", 1 },
      { "logistic-science-pack", 1 },
      { "chemical-science-pack", 1 },
      { "production-science-pack", 1 },
      { "bob-advanced-logistic-science-pack", 1 },
    },
  },
  -- 250 Red, Green, Blue, Purple, Pink, Yellow
  {
    tech_name = "vehicle-battery-equipment-6",
    science_packs = {
      { "automation-science-pack", 1 },
      { "logistic-science-pack", 1 },
      { "chemical-science-pack", 1 },
      { "production-science-pack", 1 },
      { "bob-advanced-logistic-science-pack", 1 },
      { "utility-science-pack", 1 },
    },
  },
  -- 200 Red, Green, Military, Blue, Purple, Pink
  {
    tech_name = "vehicle-energy-shield-equipment-4",
    science_packs = {
      { "automation-science-pack", 1 },
      { "logistic-science-pack", 1 },
      { "military-science-pack", 1 },
      { "chemical-science-pack", 1 },
      { "production-science-pack", 1 },
      { "bob-advanced-logistic-science-pack", 1 },
    },
  },
  -- 250 Red, Green, Military, Blue, Purple, Pink, Yellow
  {
    tech_name = "vehicle-energy-shield-equipment-5",
    science_packs = {
      { "automation-science-pack", 1 },
      { "logistic-science-pack", 1 },
      { "military-science-pack", 1 },
      { "chemical-science-pack", 1 },
      { "production-science-pack", 1 },
      { "bob-advanced-logistic-science-pack", 1 },
      { "utility-science-pack", 1 },
    },
  },
  -- 300 Red, Green, Military, Blue, Purple, Pink, Yellow, White
  {
    tech_name = "vehicle-energy-shield-equipment-6",
    science_packs = {
      { "automation-science-pack", 1 },
      { "logistic-science-pack", 1 },
      { "military-science-pack", 1 },
      { "chemical-science-pack", 1 },
      { "production-science-pack", 1 },
      { "bob-advanced-logistic-science-pack", 1 },
      { "utility-science-pack", 1 },
      { "space-science-pack", 1 },
    },
  },
  -- 200 Red, Green, Blue, Purple, Yellow
  {
    tech_name = "vehicle-fusion-cell-equipment-4",
    science_packs = {
      { "automation-science-pack", 1 },
      { "logistic-science-pack", 1 },
      { "chemical-science-pack", 1 },
      { "production-science-pack", 1 },
      { "utility-science-pack", 1 },
    },
  },
  -- 250 Red, Green, Blue, Purple, Pink, Yellow
  {
    tech_name = "vehicle-fusion-cell-equipment-5",
    science_packs = {
      { "automation-science-pack", 1 },
      { "logistic-science-pack", 1 },
      { "chemical-science-pack", 1 },
      { "production-science-pack", 1 },
      { "bob-advanced-logistic-science-pack", 1 },
      { "utility-science-pack", 1 },
    },
  },
  -- 300 Red, Green, Blue, Purple, Pink, Yellow, White
  {
    tech_name = "vehicle-fusion-cell-equipment-6",
    science_packs = {
      { "automation-science-pack", 1 },
      { "logistic-science-pack", 1 },
      { "chemical-science-pack", 1 },
      { "production-science-pack", 1 },
      { "bob-advanced-logistic-science-pack", 1 },
      { "utility-science-pack", 1 },
      { "space-science-pack", 1 },
    },
  },
  -- 250 Red, Green, Military, Blue, Purple
  {
    tech_name = "vehicle-big-turret-equipment-3",
    science_packs = {
      { "automation-science-pack", 1 },
      { "logistic-science-pack", 1 },
      { "military-science-pack", 1 },
      { "chemical-science-pack", 1 },
      { "production-science-pack", 1 },
    },
  },
  -- 300 Red, Green, Military, Blue, Purple
  {
    tech_name = "vehicle-big-turret-equipment-4",
    science_packs = {
      { "automation-science-pack", 1 },
      { "logistic-science-pack", 1 },
      { "military-science-pack", 1 },
      { "chemical-science-pack", 1 },
      { "production-science-pack", 1 },
    },
  },
  -- 350 Red, Green, Military, Blue, Purple, Pink
  {
    tech_name = "vehicle-big-turret-equipment-5",
    science_packs = {
      { "automation-science-pack", 1 },
      { "logistic-science-pack", 1 },
      { "military-science-pack", 1 },
      { "chemical-science-pack", 1 },
      { "production-science-pack", 1 },
      { "bob-advanced-logistic-science-pack", 1 },
    },
  },
  -- 400 Red, Green, Military, Blue, Purple, Pink, Yellow
  {
    tech_name = "vehicle-big-turret-equipment-6",
    science_packs = {
      { "automation-science-pack", 1 },
      { "logistic-science-pack", 1 },
      { "military-science-pack", 1 },
      { "chemical-science-pack", 1 },
      { "production-science-pack", 1 },
      { "bob-advanced-logistic-science-pack", 1 },
      { "utility-science-pack", 1 },
    },
  },
  -- 350 Red, Green, Blue, Purple, Yellow
  {
    tech_name = "bob-vehicle-fission-reactor-equipment-4",
    science_packs = {
      { "automation-science-pack", 1 },
      { "logistic-science-pack", 1 },
      { "chemical-science-pack", 1 },
      { "production-science-pack", 1 },
      { "utility-science-pack", 1 },
    },
  },
  -- 400 Red, Green, Blue, Purple, Pink, Yellow
  {
    tech_name = "bob-vehicle-fission-reactor-equipment-5",
    science_packs = {
      { "automation-science-pack", 1 },
      { "logistic-science-pack", 1 },
      { "chemical-science-pack", 1 },
      { "production-science-pack", 1 },
      { "bob-advanced-logistic-science-pack", 1 },
      { "utility-science-pack", 1 },
    },
  },
  -- 450 Red, Green, Blue, Purple, Pink, Yellow, White
  {
    tech_name = "bob-vehicle-fission-reactor-equipment-6",
    science_packs = {
      { "automation-science-pack", 1 },
      { "logistic-science-pack", 1 },
      { "chemical-science-pack", 1 },
      { "production-science-pack", 1 },
      { "bob-advanced-logistic-science-pack", 1 },
      { "utility-science-pack", 1 },
      { "space-science-pack", 1 },
    },
  },
  -- 400 Red, Green, Military, Blue, Purple, Pink, Yellow, White
  {
    tech_name = "personal-laser-defense-equipment-6",
    science_packs = {
      { "automation-science-pack", 1 },
      { "logistic-science-pack", 1 },
      { "military-science-pack", 1 },
      { "chemical-science-pack", 1 },
      { "production-science-pack", 1 },
      { "utility-science-pack", 1 },
      { "space-science-pack", 1 },
    },
  },
}

for _, v in pairs(mil_techswap) do
  if data.raw.technology[v.tech_name] then
    bobmods.lib.tech.clear_science_packs(v.tech_name)
    for _, science_pack in pairs(v.science_packs) do
      if data.raw.tool[science_pack[1]] then
        bobmods.lib.tech.add_new_science_pack(v.tech_name, science_pack[1], science_pack[2])
      end
    end
  end
end

-- Remove tank flamethrower
if data.raw.car and data.raw.car["tank"] then
  local guns = data.raw.car["tank"].guns
  for i, gun in pairs(guns) do
    if gun == "tank-flamethrower" then
      table.remove(guns, i)
      break
    end
  end
end

-- Move Tank earlier. Add acid resistance
bobmods.lib.tech.remove_science_pack("tank", "chemical-science-pack")
bobmods.lib.tech.replace_prerequisite("tank", "military-3", "military-science-pack")
local resistances = data.raw.car["tank"].resistances
for _, v in pairs(resistances) do
  if v.type == "acid" then
    v.decrease = 25
    break
  end
end

if mods["bobwarfare"] then
  -- Make sniper turrets tech more expensive
  bobmods.lib.tech.set_science_pack_count("bob-sniper-turrets-1", 100)
  bobmods.lib.tech.set_science_pack_count("bob-sniper-turrets-2", 100)

  -- Move Plasma turrets later
  bobmods.lib.tech.add_new_science_pack("bob-plasma-turrets-1", "chemical-science-pack", 1)
  bobmods.lib.tech.add_prerequisite("bob-plasma-turrets-1", "military-3")
  bobmods.lib.tech.add_prerequisite("bob-plasma-turrets-1", "angels-cobalt-steel-smelting-1")
  seablock.lib.substingredient("bob-plasma-turret-1", "electronic-circuit", "advanced-circuit", 40)
  seablock.lib.substingredient("bob-plasma-turret-1", "steel-plate", "bob-cobalt-steel-alloy", nil)

  bobmods.lib.tech.add_new_science_pack("bob-plasma-turrets-2", "chemical-science-pack", 1)
  bobmods.lib.tech.add_new_science_pack("bob-plasma-turrets-2", "production-science-pack", 1)
  bobmods.lib.tech.add_prerequisite("bob-plasma-turrets-2", "military-4")
  bobmods.lib.tech.add_prerequisite("bob-plasma-turrets-2", "bob-battery-2")
  bobmods.lib.tech.add_prerequisite("bob-plasma-turrets-2", "angels-titanium-smelting-1")
  seablock.lib.substingredient("bob-plasma-turret-2", "battery", "bob-lithium-ion-battery", nil)
  seablock.lib.substingredient("bob-plasma-turret-2", "advanced-circuit", "processing-unit", 40)
  seablock.lib.substingredient("bob-plasma-turret-2", "steel-plate", "bob-titanium-plate", nil)

  -- Make Military 4 take Purple science rather than Yellow science
  bobmods.lib.tech.remove_science_pack("military-4", "utility-science-pack")
  bobmods.lib.tech.add_new_science_pack("military-4", "production-science-pack", 1)
  bobmods.lib.tech.replace_prerequisite("military-4", "utility-science-pack", "production-science-pack")

  -- Walking Vehicle (Antron) can now depend on Military 4
  bobmods.lib.tech.replace_prerequisite("bob-walking-vehicle", "military-3", "military-4")

  -- Move Artillery later
  bobmods.lib.tech.remove_science_pack("bob-artillery-turret-2", "utility-science-pack", 1)
  bobmods.lib.tech.remove_science_pack("bob-artillery-wagon-2", "utility-science-pack", 1)
  bobmods.lib.tech.add_new_science_pack("bob-artillery-turret-2", "production-science-pack", 1)
  bobmods.lib.tech.add_new_science_pack("bob-artillery-wagon-2", "production-science-pack", 1)
  bobmods.lib.tech.add_prerequisite("artillery", "military-3")
  bobmods.lib.tech.add_prerequisite("artillery", "bob-cobalt-processing")
  bobmods.lib.tech.add_prerequisite("artillery", "angels-stone-smelting-2")
  seablock.lib.substingredient("artillery-turret", "iron-gear-wheel", "bob-cobalt-steel-gear-wheel", nil)
  seablock.lib.substingredient("artillery-turret", "concrete", "angels-concrete-brick", nil)
  seablock.lib.substingredient("artillery-turret", "steel-plate", "bob-cobalt-steel-alloy", nil)
  seablock.lib.substingredient("artillery-wagon", "iron-gear-wheel", "bob-cobalt-steel-gear-wheel", nil)
  seablock.lib.substingredient("artillery-wagon", "pipe", "bob-brass-pipe", nil)
  seablock.lib.substingredient("artillery-wagon", "steel-plate", "bob-cobalt-steel-alloy", nil)

  bobmods.lib.tech.add_prerequisite("artillery", "bob-radar-3")

  bobmods.lib.tech.add_prerequisite("spidertron", "bob-radar-5")

  -- Remove dependencies on Alien Research
  --bobmods.lib.tech.remove_prerequisite("bob-power-armor-3", "alien-research")

  -- Adjust Power Armor
  bobmods.lib.tech.remove_science_pack("power-armor", "chemical-science-pack")
  bobmods.lib.tech.add_science_pack("power-armor", "military-science-pack", 1)
  bobmods.lib.tech.add_prerequisite("power-armor", "military-science-pack")
  bobmods.lib.tech.set_science_pack_count("power-armor", 150)
  bobmods.lib.recipe.replace_ingredient("power-armor", "processing-unit", "advanced-circuit")
  bobmods.lib.tech.remove_prerequisite("power-armor", "processing-unit")

  bobmods.lib.tech.remove_science_pack("power-armor-mk2", "utility-science-pack")
  bobmods.lib.tech.remove_prerequisite("power-armor-mk2", "utility-science-pack")
  bobmods.lib.tech.add_prerequisite("power-armor-mk2", "low-density-structure")
  bobmods.lib.tech.add_prerequisite("power-armor-mk2", "processing-unit")
  bobmods.lib.tech.set_science_pack_count("power-armor-mk2", 200)
  bobmods.lib.tech.replace_prerequisite("power-armor-mk2", "military-4", "military-3")

  if mods["bobtech"] then
    bobmods.lib.tech.remove_prerequisite("bob-power-armor-3", "production-science-pack")
    bobmods.lib.tech.add_prerequisite("bob-power-armor-3", "bob-advanced-logistic-science-pack")
  else
    bobmods.lib.tech.add_prerequisite("bob-power-armor-3", "military-4")
  end
  bobmods.lib.tech.add_prerequisite("bob-power-armor-4", "utility-science-pack")
end

if mods["bobequipment"] then
  -- Batteries
  bobmods.lib.tech.remove_prerequisite("battery-mk2-equipment", "power-armor")
  bobmods.lib.tech.add_prerequisite("battery-mk2-equipment", "processing-unit")
  if mods["bobtech"] then
    bobmods.lib.tech.add_prerequisite("bob-battery-equipment-5", "bob-advanced-logistic-science-pack")
  end

  -- Personal Laser Defense
  bobmods.lib.tech.add_prerequisite("bob-personal-laser-defense-equipment-5", "utility-science-pack")
  bobmods.lib.tech.add_prerequisite("bob-personal-laser-defense-equipment-6", "space-science-pack")

  -- Energy Shield
  bobmods.lib.tech.add_prerequisite("energy-shield-mk2-equipment", "processing-unit")

  -- Remove dependencies on Alien Research
  bobmods.lib.tech.remove_prerequisite("bob-energy-shield-equipment-4", "bob-alien-research")
  bobmods.lib.tech.remove_prerequisite("bob-battery-equipment-4", "bob-alien-research")
  bobmods.lib.tech.remove_prerequisite("bob-fission-reactor-equipment-2", "bob-alien-research")
  bobmods.lib.tech.remove_prerequisite("bob-personal-laser-defense-equipment-6", "bob-alien-research")
end

if mods["bobvehicleequipment"] then
  -- Remove dependencies on Alien Research
  bobmods.lib.tech.remove_prerequisite("bob-vehicle-battery-equipment-4", "bob-alien-research")
  bobmods.lib.tech.remove_prerequisite("bob-vehicle-big-turret-equipment-4", "bob-alien-research")
  bobmods.lib.tech.remove_prerequisite("bob-vehicle-shield-equipment-4", "bob-alien-research")
  bobmods.lib.tech.remove_prerequisite("bob-vehicle-fission-cell-equipment-4", "bob-alien-research")
  bobmods.lib.tech.remove_prerequisite("bob-vehicle-fission-reactor-equipment-4", "bob-alien-research")

  bobmods.lib.tech.add_prerequisite("bob-vehicle-big-turret-equipment-4", "military-4")
  bobmods.lib.tech.add_prerequisite("bob-vehicle-laser-defense-equipment-5", "utility-science-pack")

  if mods["bobtech"] then
    bobmods.lib.tech.add_prerequisite("bob-vehicle-battery-equipment-5", "bob-advanced-logistic-science-pack")
    bobmods.lib.tech.add_prerequisite("bob-vehicle-big-turret-equipment-5", "bob-advanced-logistic-science-pack")
    bobmods.lib.tech.add_prerequisite("bob-vehicle-shield-equipment-4", "bob-advanced-logistic-science-pack")
    bobmods.lib.tech.add_prerequisite("bob-vehicle-fission-cell-equipment-4", "bob-advanced-logistic-science-pack")
    bobmods.lib.tech.add_prerequisite("bob-vehicle-fission-reactor-equipment-4", "bob-advanced-logistic-science-pack")
  end

  bobmods.lib.tech.add_prerequisite("bob-vehicle-battery-equipment-6", "utility-science-pack")
  bobmods.lib.tech.add_prerequisite("bob-vehicle-big-turret-equipment-6", "utility-science-pack")
  bobmods.lib.tech.add_prerequisite("bob-vehicle-shield-equipment-5", "utility-science-pack")
  bobmods.lib.tech.add_prerequisite("bob-vehicle-fission-cell-equipment-5", "utility-science-pack")
  bobmods.lib.tech.add_prerequisite("bob-vehicle-fission-reactor-equipment-5", "utility-science-pack")

  bobmods.lib.tech.add_prerequisite("bob-vehicle-shield-equipment-6", "space-science-pack")
  bobmods.lib.tech.add_prerequisite("bob-vehicle-fission-cell-equipment-6", "space-science-pack")
  bobmods.lib.tech.add_prerequisite("bob-vehicle-fission-reactor-equipment-6", "space-science-pack")
end
