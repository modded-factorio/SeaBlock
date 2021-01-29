local lib = require "lib"
local FUEL_FACTOR = 2

local function multiply_fuel_value(fuel_value, factor)
    local count, unit = fuel_value:match("([%d\\.]+)([%a]+)")
    return (count*factor) .. unit
end

-- No fuel value on these because they are also smelting inputs
-- https://forums.factorio.com/viewtopic.php?f=23&t=46634
data.raw.item['wood-bricks'].fuel_value = nil
data.raw.item['wood-bricks'].fuel_category = nil

-- Reduce angels charcoal fuel value
data.raw.item['wood-charcoal'].fuel_value = multiply_fuel_value("4MJ", FUEL_FACTOR)
data.raw.item['pellet-coke'].fuel_value = multiply_fuel_value("24MJ", FUEL_FACTOR)

-- multiply other fuel values with factor
data.raw.item['cellulose-fiber'].fuel_value = multiply_fuel_value(data.raw.item['cellulose-fiber'].fuel_value, FUEL_FACTOR)
data.raw.item['wood'].fuel_value = multiply_fuel_value(data.raw.item['wood'].fuel_value, FUEL_FACTOR)
data.raw.item['wood-pellets'].fuel_value = multiply_fuel_value(data.raw.item['wood-pellets'].fuel_value, FUEL_FACTOR)
data.raw.item['solid-fuel'].fuel_value = multiply_fuel_value(data.raw.item['solid-fuel'].fuel_value, FUEL_FACTOR)
data.raw.item['solid-carbon'].fuel_value = multiply_fuel_value(data.raw.item['solid-carbon'].fuel_value, FUEL_FACTOR)

if data.raw.fluid['hydrazine'] then
  data.raw.fluid['hydrazine'].fuel_value = multiply_fuel_value(data.raw.fluid['hydrazine'].fuel_value, FUEL_FACTOR)
end

-- don't increase vehicle fuels, because vehicle effectivity remain unchanged
-- rocket-booster, rocket-fuel, nuclear-fuel

-- don't increase fuel cells, as nuclear reactors remain unchanged
-- uranium-fuel-cell, deuterium-fuel-cell, plutonium-fuel-cell, thorium-fuel-cell, thorium-plutonium-fuel-cell

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
data.raw.fluid['liquid-fuel-oil'].fuel_value = multiply_fuel_value("1MJ", FUEL_FACTOR)
data.raw.fluid['liquid-fuel'].fuel_value = multiply_fuel_value("1MJ", FUEL_FACTOR)
data.raw.fluid['liquid-naphtha'].fuel_value = multiply_fuel_value("0.5MJ", FUEL_FACTOR)
data.raw.fluid['gas-methane'].fuel_value = multiply_fuel_value("0.5MJ", FUEL_FACTOR)
data.raw.fluid['crude-oil'].fuel_value = multiply_fuel_value("0.5MJ", FUEL_FACTOR)
-- 20 petroleum gas + 20 light fuel = 30 diesel
-- 20/100*21.5 + 20/50*21.5 = 12.9MJ = 30 diesel
if data.raw.fluid['diesel-fuel'] then
  data.raw.fluid['diesel-fuel'].fuel_value = multiply_fuel_value("1MJ", FUEL_FACTOR)
end
data.raw.item['enriched-fuel'].fuel_value = multiply_fuel_value("50MJ", FUEL_FACTOR)
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
    bobmods.lib.tech.add_prerequisite('petroleum-generator', 'fluid-generator-3')
    bobmods.lib.tech.add_new_science_pack('petroleum-generator', 'production-science-pack', 1)
  end
end
