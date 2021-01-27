local TIER0 = 0.375
local TIER1 = 0.50
local TIER2 = 0.55
local TIER3 = 0.60
local TIER4 = 0.65
local TIER5 = 0.70

-- type = "boiler",
-- name = "boiler",
-- energy_consumption = "1.8MW",
-- energy_source =
-- {
--     type = "burner",
--     fuel_category = "chemical",
--     effectivity = 0.5,

data.raw["boiler"]["boiler"].energy_source.effectivity = TIER1

if mods['bobpower'] then
    data.raw["boiler"]["boiler-2"].energy_source.effectivity = TIER2
    data.raw["boiler"]["boiler-3"].energy_source.effectivity = TIER3
    data.raw["boiler"]["boiler-4"].energy_source.effectivity = TIER4
    data.raw["boiler"]["boiler-5"].energy_source.effectivity = TIER5

    data.raw["boiler"]["oil-boiler"].energy_source.effectivity = TIER2
    data.raw["boiler"]["oil-boiler-2"].energy_source.effectivity = TIER3
    data.raw["boiler"]["oil-boiler-3"].energy_source.effectivity = TIER4
    data.raw["boiler"]["oil-boiler-4"].energy_source.effectivity = TIER5

    data.raw["burner-generator"]["bob-burner-generator"].burner.effectivity = TIER0

    data.raw["generator"]["fluid-generator"].effectivity = TIER2
    data.raw["generator"]["fluid-generator-2"].effectivity = TIER3
    data.raw["generator"]["fluid-generator-3"].effectivity = TIER4
    
    data.raw["generator"]["hydrazine-generator"].effectivity = TIER5 * 1.103 -- 1.103 is the original effectivity from bobs power

    -- don't change heat exchanger, bc they are needed for nuclear too
    --data.raw.["boiler"]["heat-exchanger"].energy_source.effectivity = TIER3
    
    data.raw["reactor"]["burner-reactor"].energy_source.effectivity = TIER3
    data.raw["reactor"]["burner-reactor-2"].energy_source.effectivity = TIER4
    data.raw["reactor"]["burner-reactor-3"].energy_source.effectivity = TIER5

    data.raw["reactor"]["fluid-reactor"].energy_source.effectivity = TIER3
    data.raw["reactor"]["fluid-reactor-2"].energy_source.effectivity = TIER4
    data.raw["reactor"]["fluid-reactor-3"].energy_source.effectivity = TIER5

    log("changed boiler effectivity")
end

--ks power
if data.raw["boiler"]["oil-steam-boiler"] then
    data.raw["boiler"]["oil-steam-boiler"].energy_source.effectivity = TIER2
end

if data.raw["generator"]["petroleum-generator"] then
    data.raw["generator"]["petroleum-generator"].energy_source.effectivity = TIER5
end

if data.raw["burner-generator"]["burner-generator"] then
    data.raw["burner-generator"]["burner-generator"].burner.effectivity = TIER0
end

if data.raw["burner-generator"]["big-burner-generator"] then
    data.raw["burner-generator"]["big-burner-generator"].burner.effectivity = TIER3
end
