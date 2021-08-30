if mods['ScienceCostTweakerM'] then
  if data.raw.item['lab-2'] then
    -- Update lab MK2 ingredients and energy usage
    seablock.lib.substingredient('lab-2', 'advanced-circuit', 'advanced-processing-unit')
    data.raw.lab['lab-2'].energy_usage = "3MW"
    -- Only two module slots for lab-2 if s.c.t. is installed (other labs have no module slots)
    data.raw.lab['lab-2'].module_specification.module_slots = 2
  end

  -- Change tech to use lab icon from SCT
  data.raw.tool['sb-lab-tool'].icon = '__ScienceCostTweakerM__/graphics/sct-lab-t1/icon-64.png'

  -- Reduce processing unit cost of S.C.T. high-tech science
  seablock.lib.substingredient('sct-htech-injector', 'processing-unit', nil, 3)
end
