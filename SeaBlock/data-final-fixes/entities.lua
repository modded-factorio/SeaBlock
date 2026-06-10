-- crafting category "electronics" got removed from assembling machines since it is now part of Fulgora
if mods["bobassembly"] then
  seablock.lib.add_category("assembling-machine", "assembling-machine-1", "electronics")

  seablock.lib.add_category("assembling-machine", "assembling-machine-2", "electronics")
  seablock.lib.add_category("assembling-machine", "assembling-machine-2", "electronics-with-fluid")

  seablock.lib.add_category("assembling-machine", "assembling-machine-3", "electronics")
  seablock.lib.add_category("assembling-machine", "assembling-machine-3", "electronics-with-fluid")

  seablock.lib.add_category("assembling-machine", "bob-assembling-machine-4", "electronics")
  seablock.lib.add_category("assembling-machine", "bob-assembling-machine-4", "electronics-with-fluid")

  seablock.lib.add_category("assembling-machine", "bob-assembling-machine-5", "electronics")
  seablock.lib.add_category("assembling-machine", "bob-assembling-machine-5", "electronics-with-fluid")

  seablock.lib.add_category("assembling-machine", "bob-assembling-machine-6", "electronics")
  seablock.lib.add_category("assembling-machine", "bob-assembling-machine-6", "electronics-with-fluid")
end
