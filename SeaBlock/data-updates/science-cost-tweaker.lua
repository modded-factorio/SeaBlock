local lib = require "lib"

-- Move misc sciencey things over to science tab
if data.raw['item-group']['sct-science'] then
  if data.raw.item['lab-2'] then
    -- Update lab MK2 ingredients and energy usage
    lib.substingredient('lab-2', 'advanced-circuit', 'advanced-processing-unit')
    data.raw.lab['lab-2'].energy_usage = "3MW"
    -- Only two module slots for lab-2 if s.c.t. is installed (other labs have no module slots)
    data.raw.lab['lab-2'].module_specification.module_slots = 2
  end
  -- Put centrifuge next to nuclear components
  data.raw.item['centrifuge'].subgroup = "energy"
  data.raw.item['centrifuge'].order = "f[nuclear-energy]-a[centrifuge]"

  -- Remove bob's gems item group. This reduces the total number of groups
  -- to 18, 3 rows of 6.
  data.raw['item-group']['bob-gems'] = nil
  data.raw['item-group']['bob-fluid-products'] = nil
  for k,v in pairs(data.raw['item-subgroup']) do
    if v.group == 'bob-gems' or v.group == 'bob-fluid-products' then
      v.group = 'bob-resource-products'
    end
  end

  -- Change tech to use lab icon from SCT
  data.raw.tool['sb-lab-tool'].icon = '__ScienceCostTweakerM__/graphics/sct-lab-t1/icon-64.png'
end

-- Reduce processing unit cost of S.C.T. high-tech science
lib.substingredient('sct-htech-injector', 'processing-unit', nil, 3)
