if mods["bobmodules"] and not bobmods.modules.ModulesLab then
  bobmods.lib.tech.add_recipe_unlock("modules", "module-processor-board")
  bobmods.lib.tech.add_recipe_unlock("modules", "speed-processor")
  bobmods.lib.tech.add_recipe_unlock("modules", "effectivity-processor")
  bobmods.lib.tech.add_recipe_unlock("modules", "productivity-processor")
  bobmods.lib.tech.remove_prerequisite("modules", "sct-lab-modules")
  bobmods.lib.tech.add_prerequisite("modules", "advanced-electronics")
end
