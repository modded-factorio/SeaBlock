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
bobmods.lib.tech.replace_prerequisite("uranium-processing", "slag-processing-2", "ore-leaching")
bobmods.lib.tech.add_prerequisite("thorium-processing", "ore-electro-whinning-cell")
if mods["ScienceCostTweakerM"] then
  bobmods.lib.tech.add_prerequisite("sct-bio-science-pack", "bio-arboretum-1")
  bobmods.lib.tech.add_prerequisite("sb-bio-processing-advanced", "sct-bio-science-pack")
  bobmods.lib.tech.add_prerequisite("utility-science-pack", "rubber")
end
bobmods.lib.tech.add_prerequisite("tungsten-alloy-processing", "powder-metallurgy-3")
bobmods.lib.tech.add_prerequisite("angels-glass-smelting-1", "silicon-processing")
bobmods.lib.tech.add_prerequisite("angels-stone-smelting-2", "silicon-processing")
bobmods.lib.tech.add_prerequisite("resin-2", "angels-nitrogen-processing-3")

-- Clear prerequisites so it's available at end of tutorial
bobmods.lib.tech.remove_prerequisite("bio-wood-processing-2", "bio-wood-processing")
bobmods.lib.tech.remove_prerequisite("bio-wood-processing-2", "angels-coal-processing")
bobmods.lib.tech.remove_prerequisite("bio-wood-processing-2", "advanced-material-processing")

local tech = {
  "bob-artillery-turret-3",
  "bob-artillery-wagon-3",
  "bob-energy-shield-equipment-3",
  "radars-4",
}
if mods["CircuitProcessing"] then
  table.insert(tech, "rocket-control-unit")
end
for _, v in pairs(tech) do
  if data.raw.technology[v] then
    bobmods.lib.tech.add_new_science_pack(v, "production-science-pack", 1)
  end
end

bobmods.lib.tech.add_new_science_pack("resin-3", "utility-science-pack", 1)

-- Move Manganese down a tier
-- T1:
bobmods.lib.tech.remove_science_pack("angels-manganese-smelting-1", "logistic-science-pack")
bobmods.lib.tech.replace_prerequisite("angels-manganese-smelting-1", "angels-metallurgy-2", "angels-metallurgy-1")
bobmods.lib.tech.add_prerequisite("angels-manganese-smelting-1", "angels-iron-smelting-1")
if bobmods.lib.tech.has_recipe_unlock("angels-iron-smelting-2", "molten-iron-smelting-2") then
  seablock.lib.moveeffect("molten-iron-smelting-2", "angels-iron-smelting-2", "angels-manganese-smelting-1")
else
  seablock.lib.moveeffect("molten-iron-smelting-2", "angels-iron-casting-2", "angels-manganese-smelting-1")
end
seablock.lib.set_recipe_category("molten-iron-smelting-2", "induction-smelting")

-- T2:
bobmods.lib.tech.remove_science_pack("angels-manganese-smelting-2", "chemical-science-pack")
bobmods.lib.tech.replace_prerequisite("angels-manganese-smelting-2", "ore-processing-2", "ore-processing-1")
bobmods.lib.tech.replace_prerequisite(
  "angels-steel-smelting-2",
  "angels-manganese-smelting-1",
  "angels-manganese-smelting-2"
)
bobmods.lib.tech.replace_prerequisite(
  "angels-aluminium-smelting-2",
  "angels-manganese-smelting-1",
  "angels-manganese-smelting-2"
)

-- T3:
bobmods.lib.tech.remove_science_pack("angels-manganese-smelting-3", "production-science-pack")
bobmods.lib.tech.replace_prerequisite("angels-manganese-smelting-3", "ore-processing-3", "ore-processing-2")
bobmods.lib.tech.replace_prerequisite(
  "angels-titanium-smelting-2",
  "angels-manganese-smelting-2",
  "angels-manganese-smelting-3"
)
bobmods.lib.tech.replace_prerequisite(
  "angels-titanium-casting-2",
  "angels-manganese-smelting-2",
  "angels-manganese-smelting-3"
)

-- Move Silicon up a tier
-- T1:
bobmods.lib.tech.add_new_science_pack("angels-silicon-smelting-1", "logistic-science-pack", 1)
bobmods.lib.tech.replace_prerequisite("angels-silicon-smelting-1", "angels-metallurgy-1", "angels-metallurgy-2")
bobmods.lib.tech.replace_prerequisite(
  "angels-steel-smelting-2",
  "angels-silicon-smelting-2",
  "angels-silicon-smelting-1"
)

-- T2:
bobmods.lib.tech.add_new_science_pack("angels-silicon-smelting-2", "chemical-science-pack", 1)
bobmods.lib.tech.replace_prerequisite("angels-silicon-smelting-2", "ore-processing-1", "ore-processing-2")
bobmods.lib.tech.replace_prerequisite(
  "angels-aluminium-smelting-3",
  "angels-silicon-smelting-3",
  "angels-silicon-smelting-2"
)
bobmods.lib.tech.replace_prerequisite(
  "angels-aluminium-casting-3",
  "angels-silicon-smelting-3",
  "angels-silicon-smelting-2"
)

-- T3:
bobmods.lib.tech.add_new_science_pack("angels-silicon-smelting-3", "production-science-pack", 1)
bobmods.lib.tech.replace_prerequisite("angels-silicon-smelting-3", "ore-processing-2", "ore-processing-3")
bobmods.lib.tech.replace_prerequisite(
  "angels-silicon-smelting-3",
  "angels-aluminium-smelting-1",
  "angels-aluminium-smelting-2"
)

-- Move Nickel up a tier
-- T1:
bobmods.lib.tech.add_new_science_pack("angels-nickel-smelting-1", "logistic-science-pack", 1)
bobmods.lib.tech.replace_prerequisite("angels-nickel-smelting-1", "angels-metallurgy-1", "angels-metallurgy-2")
bobmods.lib.tech.replace_prerequisite("angels-iron-casting-3", "angels-nickel-smelting-2", "angels-nickel-smelting-1")
bobmods.lib.tech.add_prerequisite("angels-nickel-smelting-1", "basic-chemistry-3")

-- T2:
bobmods.lib.tech.add_new_science_pack("angels-nickel-smelting-2", "chemical-science-pack", 1)
bobmods.lib.tech.replace_prerequisite("angels-nickel-smelting-2", "ore-processing-1", "ore-processing-2")
bobmods.lib.tech.replace_prerequisite("angels-nickel-smelting-2", "strand-casting-1", "strand-casting-2")
bobmods.lib.tech.replace_prerequisite("angels-steel-smelting-3", "angels-nickel-smelting-3", "angels-nickel-smelting-2")
bobmods.lib.tech.replace_prerequisite(
  "angels-titanium-smelting-2",
  "angels-nickel-smelting-3",
  "angels-nickel-smelting-2"
)
bobmods.lib.tech.replace_prerequisite(
  "angels-tungsten-smelting-2",
  "angels-nickel-smelting-3",
  "angels-nickel-smelting-2"
)

bobmods.lib.tech.add_new_science_pack("angels-nickel-casting-2", "chemical-science-pack", 1)
bobmods.lib.tech.replace_prerequisite("angels-nickel-casting-2", "ore-processing-1", "ore-processing-2")
bobmods.lib.tech.replace_prerequisite("angels-nickel-casting-2", "strand-casting-1", "strand-casting-2")
bobmods.lib.tech.replace_prerequisite("angels-steel-smelting-3", "angels-nickel-casting-3", "angels-nickel-smelting-2")
bobmods.lib.tech.replace_prerequisite(
  "angels-titanium-casting-2",
  "angels-nickel-smelting-3",
  "angels-nickel-smelting-2"
)

-- T3:
bobmods.lib.tech.add_new_science_pack("angels-nickel-smelting-3", "production-science-pack", 1)
bobmods.lib.tech.replace_prerequisite("angels-nickel-smelting-3", "strand-casting-2", "strand-casting-3")
bobmods.lib.tech.replace_prerequisite("angels-nickel-smelting-3", "ore-processing-2", "ore-processing-3")

bobmods.lib.tech.add_new_science_pack("angels-nickel-casting-3", "production-science-pack", 1)
bobmods.lib.tech.replace_prerequisite("angels-nickel-casting-3", "strand-casting-2", "strand-casting-3")
bobmods.lib.tech.replace_prerequisite("angels-nickel-casting-3", "ore-processing-2", "ore-processing-3")

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
  bobmods.lib.tech.add_prerequisite("personal-laser-defense-equipment-5", "power-armor-mk2")
  bobmods.lib.tech.add_prerequisite("bob-battery-equipment-6", "power-armor-mk2")
  bobmods.lib.tech.add_prerequisite("bob-energy-shield-equipment-5", "power-armor-mk2")
end

seablock.lib.hide_technology("sulfur-processing")
seablock.lib.hide_technology("oil-processing")
seablock.lib.hide_technology("advanced-oil-processing")
seablock.lib.hide_technology("coal-liquefaction")

if mods["bobpower"] then
  bobmods.lib.tech.add_prerequisite("bob-boiler-2", "sb-steam-power")
  bobmods.lib.tech.add_prerequisite("bob-steam-engine-2", "sb-steam-power")
end
bobmods.lib.tech.add_prerequisite("angels-coal-processing", "sb-steam-power")
