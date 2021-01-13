-- Copied from https://mods.factorio.com/mod/extended-descriptions
if not mods['extended-descriptions'] then
  local function add_to_description(prototype, localised_string)
    if recurse ~= false and prototype.place_result and not prototype.localised_description then
      for _, data in pairs(data.raw) do
        for _, entity in pairs(data) do
          if entity.minable and entity.minable.result == prototype.name then
            if entity.localised_description then
              prototype.localised_description = entity.localised_description
              goto done
            end
          end
        end
      end
      ::done::
    end
    
    if prototype.localised_description and prototype.localised_description ~= '' then
      prototype.localised_description = {'', prototype.localised_description, '\n', localised_string}
    else
      prototype.localised_description = localised_string
    end
  end

  for _, fluid in pairs(data.raw.fluid) do
    if fluid.fuel_value then
      add_to_description(fluid, {'description.fluid-fuel', fluid.fuel_value})
    end
  end
end
