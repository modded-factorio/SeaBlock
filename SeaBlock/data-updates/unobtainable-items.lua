seablock.lib.hide("mining-drill", "burner-mining-drill")
seablock.lib.hide("mining-drill", "electric-mining-drill")
seablock.lib.hide("mining-drill", "pumpjack")

-- Hide Oil & Gas Separator
-- Hide Advanced Gas Refinery
-- Hide Electrowinning Cell
-- Hide Chlormethane Gas
-- Hide Multi-phase oil
-- Hide gas fractioning - synthesis (only recipe available in advanced gas refinery)
for _, item in pairs({
  { type = "assembling-machine", name = "angels-electro-whinning-cell" },
  { type = "assembling-machine", name = "angels-electro-whinning-cell-2" },
  { type = "assembling-machine", name = "angels-gas-refinery" },
  { type = "assembling-machine", name = "angels-gas-refinery-2" },
  { type = "assembling-machine", name = "angels-gas-refinery-3" },
  { type = "assembling-machine", name = "angels-gas-refinery-4" },
  { type = "assembling-machine", name = "angels-separator" },
  { type = "assembling-machine", name = "angels-separator-2" },
  { type = "assembling-machine", name = "angels-separator-3" },
  { type = "assembling-machine", name = "angels-separator-4" },
  { type = "fluid", name = "angels-gas-chlor-methane" },
  { type = "fluid", name = "angels-liquid-multi-phase-oil" },
  { type = "item", name = "angels-electro-whinning-cell" },
  { type = "item", name = "angels-electro-whinning-cell-2" },
  { type = "item", name = "angels-gas-chlor-methane-barrel" },
  { type = "item", name = "angels-gas-refinery" },
  { type = "item", name = "angels-gas-refinery-2" },
  { type = "item", name = "angels-gas-refinery-3" },
  { type = "item", name = "angels-gas-refinery-4" },
  { type = "item", name = "angels-liquid-multi-phase-oil-barrel" },
  { type = "item", name = "angels-separator" },
  { type = "item", name = "angels-separator-2" },
  { type = "item", name = "angels-separator-3" },
  { type = "item", name = "angels-separator-4" },
}) do
  seablock.lib.hide(item.type, item.name)
end

bobmods.lib.recipe.hide("angels-chemical-void-angels-gas-chlor-methane")
bobmods.lib.recipe.hide("angels-chemical-void-angels-liquid-multi-phase-oil")
bobmods.lib.recipe.hide("angels-electro-whinning-cell")
bobmods.lib.recipe.hide("angels-electro-whinning-cell-2")
bobmods.lib.recipe.hide("empty-angels-gas-chlor-methane-barrel")
bobmods.lib.recipe.hide("empty-angels-liquid-multi-phase-oil-barrel")
bobmods.lib.recipe.hide("angels-gas-chlor-methane-barrel")
bobmods.lib.recipe.hide("angels-liquid-multi-phase-oil-barrel")
bobmods.lib.recipe.hide("angels-gas-chlor-methane")
bobmods.lib.recipe.hide("angels-gas-fractioning-synthesis")
bobmods.lib.recipe.hide("angels-gas-refinery")
bobmods.lib.recipe.hide("angels-gas-refinery-2")
bobmods.lib.recipe.hide("angels-gas-refinery-3")
bobmods.lib.recipe.hide("angels-gas-refinery-4")
bobmods.lib.recipe.hide("angels-oil-separation")
bobmods.lib.recipe.hide("angels-separator")
bobmods.lib.recipe.hide("angels-separator-2")
bobmods.lib.recipe.hide("angels-separator-3")
bobmods.lib.recipe.hide("angels-separator-4")

bobmods.lib.tech.remove_recipe_unlock("angels-advanced-ore-refining-4", "angels-electro-whinning-cell-2")
bobmods.lib.tech.remove_recipe_unlock("angels-advanced-chemistry-2", "angels-separator-2")
bobmods.lib.tech.remove_recipe_unlock("angels-advanced-chemistry-3", "angels-gas-refinery-2")
bobmods.lib.tech.remove_recipe_unlock("angels-advanced-chemistry-3", "angels-separator-3")
bobmods.lib.tech.remove_recipe_unlock("angels-advanced-chemistry-4", "angels-gas-refinery-3")
bobmods.lib.tech.remove_recipe_unlock("angels-advanced-chemistry-4", "angels-separator-4")
bobmods.lib.tech.remove_recipe_unlock("angels-advanced-gas-processing", "angels-gas-fractioning-synthesis")
bobmods.lib.tech.remove_recipe_unlock("angels-advanced-gas-processing", "angels-gas-refinery")
bobmods.lib.tech.remove_recipe_unlock("angels-nitrogen-processing-4", "angels-gas-refinery-4")
bobmods.lib.tech.remove_recipe_unlock("angels-chlorine-processing-2", "angels-gas-chlor-methane")
bobmods.lib.tech.remove_recipe_unlock("bob-fluid-barrel-processing", "empty-angels-liquid-multi-phase-oil-barrel")
bobmods.lib.tech.remove_recipe_unlock("bob-fluid-barrel-processing", "angels-liquid-multi-phase-oil-barrel")
bobmods.lib.tech.remove_recipe_unlock("bob-gas-canisters", "empty-angels-gas-chlor-methane-barrel")
bobmods.lib.tech.remove_recipe_unlock("bob-gas-canisters", "fill-gas-chlor-methane-barrel")
bobmods.lib.tech.remove_recipe_unlock("angels-ore-electro-whinning-cell", "angels-electro-whinning-cell")

bobmods.lib.recipe.replace_ingredient("angels-paste-cellulose", "angels-gas-chlor-methane", "angels-gas-chlorine")

-- Hide recipes that take Chrome Ingots
bobmods.lib.recipe.hide("angels-liquid-molten-iron-5")
bobmods.lib.tech.hide("angels-iron-casting-4")

bobmods.lib.recipe.hide("angels-liquid-molten-steel-5")
bobmods.lib.tech.hide("angels-steel-smelting-4")

bobmods.lib.recipe.hide("angels-liquid-molten-titanium-5")
bobmods.lib.tech.remove_recipe_unlock("angels-titanium-casting-3", "angels-liquid-molten-titanium-5")
bobmods.lib.tech.remove_prerequisite("angels-titanium-casting-3", "angels-chrome-smelting-1")

-- Hide steam inserter
seablock.lib.hide("inserter", "bob-steam-inserter")
bobmods.lib.recipe.hide("bob-steam-inserter")
seablock.lib.hide_item("bob-steam-inserter")
if data.raw.inserter["bob-steam-inserter"] then
  data.raw.inserter["bob-steam-inserter"].next_upgrade = nil
  bobmods.lib.recipe.replace_ingredient_in_all("bob-steam-inserter", "burner-inserter")
end
bobmods.lib.tech.remove_recipe_unlock(seablock.final_scripted_tech, "bob-steam-inserter")

-- Hide Liquid Fuel
if data.raw.recipe["bob-enriched-fuel"] then
  bobmods.lib.recipe.set_ingredients("bob-enriched-fuel", {
    { type = "fluid", name = "angels-liquid-fuel-oil", amount = 80 },
    { type = "fluid", name = "angels-gas-residual", amount = 20 },
  })
  data.raw.recipe["bob-enriched-fuel"].icons =
    angelsmods.functions.create_solid_recipe_icon({ "angels-liquid-fuel-oil", "angels-gas-residual" }, "bob-enriched-fuel")
end
bobmods.lib.tech.remove_recipe_unlock("bob-fluid-canister-processing", "empty-bob-liquid-fuel-barrel")
bobmods.lib.tech.remove_recipe_unlock("bob-fluid-canister-processing", "bob-liquid-fuel-barrel")
bobmods.lib.tech.remove_recipe_unlock("flammables", "bob-liquid-fuel")
bobmods.lib.recipe.hide("empty-bob-liquid-fuel-barrel")
bobmods.lib.recipe.hide("bob-liquid-fuel-barrel")
bobmods.lib.recipe.hide("bob-liquid-fuel")
seablock.lib.hide("fluid", "bob-liquid-fuel")
seablock.lib.hide("item", "bob-liquid-fuel-barrel")

-- Swap out Nickel and Zinc plates
seablock.lib.substingredient("bob-roboport-antenna-3", "bob-nickel-plate", "bob-titanium-plate", nil)
bobmods.lib.recipe.remove_ingredient("bob-roboport-antenna-4", "bob-nickel-plate")
seablock.lib.substingredient("bob-silver-zinc-battery", "bob-zinc-plate", "angels-solid-zinc-oxide", nil)

seablock.lib.unhide_recipe("angels-solid-zinc-oxide")
bobmods.lib.tech.add_recipe_unlock("angels-zinc-smelting-2", "angels-solid-zinc-oxide")
bobmods.lib.tech.add_prerequisite("bob-battery-3", "angels-zinc-smelting-2")
if data.raw.recipe["angels-pellet-zinc-smelting"] then
  data.raw.recipe["angels-pellet-zinc-smelting"].icons = angelsmods.functions.add_number_icon_layer(
    angelsmods.functions.get_object_icons("angels-solid-zinc-oxide"),
    2,
    angelsmods.smelting.number_tint
  )
end

if mods["angelsindustries"] then
  seablock.lib.substingredient("angels-thorium-fuel-cell", "angels-plate-zinc", "bob-lead-plate", nil)
  seablock.lib.substingredient("angels-deuterium-fuel-cell", "angels-plate-zinc", "bob-lead-plate", nil)
end

seablock.lib.hide_item("bob-nickel-plate")
seablock.lib.hide_item("bob-zinc-plate")
bobmods.lib.recipe.hide("bob-zinc-plate")
bobmods.lib.tech.remove_recipe_unlock("bob-zinc-processing", "bob-zinc-plate")

if mods["cargo-ships"] then
  seablock.lib.hide_item("oil_rig")
end

-- Hide the farm environment kits
seablock.lib.hide("item", "angels-desert-upgrade")
seablock.lib.hide("item", "angels-swamp-upgrade")
seablock.lib.hide("item", "angels-temperate-upgrade")
bobmods.lib.tech.remove_recipe_unlock("angels-bio-desert-farm", "angels-desert-upgrade")
bobmods.lib.tech.remove_recipe_unlock("angels-bio-swamp-farm", "angels-swamp-upgrade")
bobmods.lib.tech.remove_recipe_unlock("angels-bio-temperate-farm", "angels-temperate-upgrade")
bobmods.lib.recipe.hide("angels-desert-upgrade")
bobmods.lib.recipe.hide("angels-swamp-upgrade")
bobmods.lib.recipe.hide("angels-temperate-upgrade")

bobmods.lib.recipe.remove_ingredient("angels-desert-farm", "angels-desert-upgrade")
bobmods.lib.recipe.add_ingredient("angels-desert-farm", { type = "item", name = "angels-token-bio", amount = 5 })
bobmods.lib.recipe.remove_ingredient("angels-swamp-farm", "angels-swamp-upgrade")
bobmods.lib.recipe.add_ingredient("angels-swamp-farm", { type = "item", name = "angels-token-bio", amount = 5 })
bobmods.lib.recipe.remove_ingredient("angels-temperate-farm", "angels-temperate-upgrade")
bobmods.lib.recipe.add_ingredient("angels-temperate-farm", { type = "item", name = "angels-token-bio", amount = 5 })
