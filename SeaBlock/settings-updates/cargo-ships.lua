-- Cargo Ships
if mods['cargo-ships'] then
  seablock.overwrite_setting('string-setting', 'oil_frequency', 'none')
  seablock.overwrite_setting('string-setting', 'oil_richness', 'regular')
  seablock.overwrite_setting('bool-setting', 'no_oil_for_oil_rig', false)
  seablock.overwrite_setting('int-setting', 'oil_rig_capacity', 100)
end
