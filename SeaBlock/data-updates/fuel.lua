local lib = require "lib"

-- No fuel value on these because they are also smelting inputs
-- https://forums.factorio.com/viewtopic.php?f=23&t=46634
data.raw.item['wood-bricks'].fuel_value = nil
data.raw.item['wood-bricks'].fuel_category = nil

-- Reduce angels charcoal fuel value
data.raw.item['wood-charcoal'].fuel_value = '4MJ'
data.raw.item['pellet-coke'].fuel_value = '24MJ'

-- Make hydrazine solid fuel match fuel_value
if data.raw.fluid['hydrazine'] then
  local hydrazinevalue = data.raw.fluid['hydrazine'].fuel_value
  data.raw.fluid['gas-hydrazine'].fuel_value = hydrazinevalue
  if hydrazinevalue:sub(-2) == 'kJ' then
    local hydrazinevaluekj = tonumber(hydrazinevalue:sub(1, -3))
    lib.substingredient('solid-fuel-hydrazine', 'gas-hydrazine', nil, math.floor(24000 / hydrazinevaluekj))
  end
end

-- petroleum gas/methane has same solid fuel value as naphtha.
data.raw.fluid['liquid-fuel-oil'].fuel_value = '1MJ'
data.raw.fluid['liquid-fuel'].fuel_value = '1MJ'
data.raw.fluid['liquid-naphtha'].fuel_value = '0.5MJ'
data.raw.fluid['gas-methane'].fuel_value = '0.5MJ'
data.raw.fluid['crude-oil'].fuel_value = '0.5MJ'
-- 20 petroleum gas + 20 light fuel = 30 diesel
-- 20/100*21.5 + 20/50*21.5 = 12.9MJ = 30 diesel
if data.raw.fluid['diesel-fuel'] then
  data.raw.fluid['diesel-fuel'].fuel_value = '1MJ'
end
data.raw.item['enriched-fuel'].fuel_value = '50MJ'
data.raw.item['enriched-fuel'].stack_size = 50

lib.substingredient('solid-fuel-methane', 'gas-methane', nil, 40)
lib.substingredient('solid-fuel-naphtha', 'liquid-naphtha', nil, 40)
lib.substingredient('solid-fuel-fuel-oil', 'liquid-fuel-oil', nil, 20)

for _,v in pairs({
  'hydrogen',
  'gas-hydrogen',
  'gas-ethane',
  'gas-butane',
  'gas-propene',
  'gas-methanol',
  'gas-ethylene',
  'gas-benzene',
  'gas-ethanol',
  'heavy-oil',
  'light-oil',
  'petroleum-gas',
  'sour-gas',
  'deuterium',
  'hydrazine',
  'alien-fire',
  'glycerol'
  }) do
  if data.raw.fluid[v] then
    data.raw.fluid[v].fuel_value = nil
  end
end

-- Make bobpower hydrazine generator use angels hydrazine
if data.raw.generator['hydrazine-generator'] then
  data.raw.generator['hydrazine-generator'].fluid_box.filter = 'gas-hydrazine'
end

-- Increase consumption of generators, sea block fuel values are lower than other mods expect.
if data.raw.generator['petroleum-generator'] then
  data.raw.generator['petroleum-generator'].fluid_usage_per_tick = 10/60
  -- KS_Power diesel generator is 100% efficient, put it after bob's fluid generators in tech tree
  if data.raw.technology['fluid-generator-3'] then
    table.insert(data.raw.technology['petroleum-generator'].prerequisites, "fluid-generator-3")
    table.insert(data.raw.technology['petroleum-generator'].unit.ingredients, {"production-science-pack", 1})
  end
end
