-- Reduce angels charcoal fuel value
data.raw.item["angels-wood-bricks"].fuel_value = "18MJ"
data.raw.item["angels-wood-charcoal"].fuel_value = "4MJ"
data.raw.item["angels-pellet-coke"].fuel_value = "24MJ"

-- Make hydrazine solid fuel match fuel_value
if data.raw.fluid["angels-gas-hydrazine"] then
  local hydrazinevalue = data.raw.fluid["angels-gas-hydrazine"].fuel_value
  data.raw.fluid["angels-gas-hydrazine"].fuel_value = hydrazinevalue
  if hydrazinevalue:sub(-2) == "kJ" then
    local hydrazinevaluekj = tonumber(hydrazinevalue:sub(1, -3))
    seablock.lib.substingredient("angels-solid-fuel-hydrazine", "angels-gas-hydrazine", nil, math.floor(24000 / hydrazinevaluekj))
  end
end

-- petroleum gas/methane has same solid fuel value as naphtha.
data.raw.fluid["angels-liquid-fuel-oil"].fuel_value = "1MJ"
data.raw.fluid["angels-liquid-naphtha"].fuel_value = "0.5MJ"
data.raw.fluid["angels-gas-methane"].fuel_value = "0.5MJ"
data.raw.fluid["crude-oil"].fuel_value = "0.5MJ"
data.raw.item["bob-enriched-fuel"].fuel_value = "50MJ"
data.raw.item["bob-enriched-fuel"].stack_size = 50
data.raw.item["angels-solid-carbon"].fuel_value = "2.5MJ"

seablock.lib.substingredient("angels-solid-fuel-methane", "angels-gas-methane", nil, 40)
seablock.lib.substingredient("angels-solid-fuel-naphtha", "angels-liquid-naphtha", nil, 40)
seablock.lib.substingredient("angels-solid-fuel-fuel-oil", "angels-liquid-fuel-oil", nil, 20)

for _, v in pairs({
  "bob-hydrogen",
  "angels-gas-hydrogen",
  "angels-gas-ethane",
  "angels-gas-butane",
  "angels-gas-propene",
  "angels-gas-methanol",
  "angels-gas-ethylene",
  "angels-gas-benzene",
  "angels-gas-ethanol",
  "heavy-oil",
  "light-oil",
  "petroleum-gas",
  "bob-sour-gas",
  "bob-deuterium",
  "angels-gas-deuterium",
  "angels-gas-hydrazine",
  "bob-alien-fire",
  "angels-glycerol",
  "diesel-fuel",
}) do
  if data.raw.fluid[v] then
    data.raw.fluid[v].fuel_value = nil
    data.raw.fluid[v].emissions_multiplier = nil
  end
end

if mods["KS_Power"] then
  seablock.lib.hide("boiler", "oil-steam-boiler")
  seablock.lib.hide("burner-generator", "big-burner-generator")
  seablock.lib.hide("burner-generator", "burner-generator")
  seablock.lib.hide("generator", "petroleum-generator")
  local turbine = data.raw["electric-energy-interface"]["wind-turbine-2"]
  if turbine and turbine.energy_source then
    turbine.energy_source.output_flow_limit = "15kW"
  end
end
