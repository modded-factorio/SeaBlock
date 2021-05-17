local SOLID_TIER0 = 0.375 --0-75
local SOLID_TIER1 = 0.5   --1.0
local SOLID_TIER2 = 0.6   --1.2
local SOLID_TIER3 = 0.7   --1-4
local SOLID_TIER4 = 0.8   --1.6
local SOLID_TIER5 = 0.9   --1.8

local FLUID_TIER2 = 1.0
local FLUID_TIER3 = 1.2
local FLUID_TIER4 = 1.4
local FLUID_TIER5 = 1.6

if data.raw["boiler"]["boiler"] then
    data.raw["boiler"]["boiler"].energy_source.effectivity = SOLID_TIER1
end

if mods['bobpower'] then
    if data.raw["boiler"]["boiler-2"] then
        data.raw["boiler"]["boiler-2"].energy_source.effectivity = SOLID_TIER2
    end
    if data.raw["boiler"]["boiler-3"] then
        data.raw["boiler"]["boiler-3"].energy_source.effectivity = SOLID_TIER3
    end
    if data.raw["boiler"]["boiler-4"] then
        data.raw["boiler"]["boiler-4"].energy_source.effectivity = SOLID_TIER4
    end
    if data.raw["boiler"]["boiler-5"] then
        data.raw["boiler"]["boiler-5"].energy_source.effectivity = SOLID_TIER5
    end

    if data.raw["boiler"]["oil-boiler"] then
        data.raw["boiler"]["oil-boiler"].energy_source.effectivity = FLUID_TIER2
    end
    if data.raw["boiler"]["oil-boiler-2"] then
        data.raw["boiler"]["oil-boiler-2"].energy_source.effectivity = FLUID_TIER3
    end
    if data.raw["boiler"]["oil-boiler-3"] then
        data.raw["boiler"]["oil-boiler-3"].energy_source.effectivity = FLUID_TIER4
    end
    if data.raw["boiler"]["oil-boiler-4"] then
        data.raw["boiler"]["oil-boiler-4"].energy_source.effectivity = FLUID_TIER5
    end

    if data.raw["burner-generator"]["bob-burner-generator"] then
        data.raw["burner-generator"]["bob-burner-generator"].burner.effectivity = SOLID_TIER1
    end

    if data.raw["generator"]["fluid-generator"] then
        data.raw["generator"]["fluid-generator"].effectivity = FLUID_TIER2
    end
    if data.raw["generator"]["fluid-generator-2"] then
        data.raw["generator"]["fluid-generator-2"].effectivity = FLUID_TIER3
    end
    if data.raw["generator"]["fluid-generator-3"] then
        data.raw["generator"]["fluid-generator-3"].effectivity = FLUID_TIER4
    end

    if data.raw["generator"]["hydrazine-generator"] then
        data.raw["generator"]["hydrazine-generator"].effectivity = FLUID_TIER5 * 1.103 -- 1.103 is the original effectivity from bobs power
    end

    -- don't change heat exchanger, bc they are needed for nuclear too
    --data.raw.["boiler"]["heat-exchanger"].energy_source.effectivity = SOLID_TIER3
    
    if data.raw["reactor"]["burner-reactor"] then
        data.raw["reactor"]["burner-reactor"].energy_source.effectivity = SOLID_TIER3
    end
    if data.raw["reactor"]["burner-reactor-2"] then
        data.raw["reactor"]["burner-reactor-2"].energy_source.effectivity = SOLID_TIER4
    end
    if data.raw["reactor"]["burner-reactor-3"] then
        data.raw["reactor"]["burner-reactor-3"].energy_source.effectivity = SOLID_TIER5
    end

    -- for some reason, all bob's fluid-reactors share the same energy_source instance. So, first copy before adjusting
    if data.raw["reactor"]["fluid-reactor"] then
        data.raw["reactor"]["fluid-reactor"].energy_source = table.deepcopy(data.raw["reactor"]["fluid-reactor"].energy_source)
        data.raw["reactor"]["fluid-reactor"].energy_source.effectivity = FLUID_TIER3
    end
    if data.raw["reactor"]["fluid-reactor-2"] then
        data.raw["reactor"]["fluid-reactor-2"].energy_source = table.deepcopy(data.raw["reactor"]["fluid-reactor-2"].energy_source)
        data.raw["reactor"]["fluid-reactor-2"].energy_source.effectivity = FLUID_TIER4
    end
    if data.raw["reactor"]["fluid-reactor-3"] then
        data.raw["reactor"]["fluid-reactor-3"].energy_source = table.deepcopy(data.raw["reactor"]["fluid-reactor-3"].energy_source)
        data.raw["reactor"]["fluid-reactor-3"].energy_source.effectivity = FLUID_TIER5
    end
end

--ks power
if data.raw["boiler"]["oil-steam-boiler"] then
    data.raw["boiler"]["oil-steam-boiler"].energy_source.effectivity = FLUID_TIER3
end

if data.raw["generator"]["petroleum-generator"] then
    data.raw["generator"]["petroleum-generator"].effectivity = FLUID_TIER5
end

if data.raw["burner-generator"]["burner-generator"] then
    data.raw["burner-generator"]["burner-generator"].burner.effectivity = SOLID_TIER0
end

if data.raw["burner-generator"]["big-burner-generator"] then
    data.raw["burner-generator"]["big-burner-generator"].burner.effectivity = SOLID_TIER3
end

log("changed boiler effectivity")
