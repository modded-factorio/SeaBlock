seablock = seablock or {}
seablock.lib = {}
seablock.reskins = {}

function seablock.lib.findname(t, name)
  for i, v in ipairs(t) do
    if v.name == name then
      return v
    end
  end
end

function seablock.lib.removename(t, name)
  for i, v in ipairs(t) do
    if v.name == name then
      table.remove(t, i)
      return
    end
  end
end

function seablock.lib.takeeffect(tech, name)
  if not data.raw.technology[tech] then
    log("Warning: seablock.lib.takeeffect - can't find technology : " .. tech)
    log(debug.traceback())
    return nil
  end
  local effects = data.raw.technology[tech].effects or {}
  for i, v in ipairs(effects) do
    if v.recipe == name then
      return table.remove(effects, i)
    end
  end
end

function seablock.lib.findeffectidx(effects, name)
  for i, v in ipairs(effects) do
    if v.recipe == name then
      return i
    end
  end
end

function seablock.lib.moveeffect(name, fromtech, totech, insertindex)
  local effect = seablock.lib.takeeffect(fromtech, name)
  if not effect then
    log("Warning : seablock.lib.moveeffect - Effect " .. name .. " not found in tech " .. fromtech)
    log(debug.traceback())
    return
  end
  if insertindex then
    table.insert(data.raw.technology[totech].effects, insertindex, effect)
  else
    table.insert(data.raw.technology[totech].effects, effect)
  end
end

local function add_recipe_unlock(technology, recipe, insertindex)
  local addit = true
  if not technology.effects then
    technology.effects = {}
  end
  for i, effect in pairs(technology.effects) do
    if effect.type == "unlock-recipe" and effect.recipe == recipe then
      addit = false
    end
  end
  if addit then
    bobmods.lib.recipe.enabled(recipe, false)
    if insertindex then
      table.insert(technology.effects, insertindex, { type = "unlock-recipe", recipe = recipe })
    else
      table.insert(technology.effects, { type = "unlock-recipe", recipe = recipe })
    end
  end
end

function seablock.lib.add_recipe_unlock(technology, recipe, insertindex)
  if
    type(technology) == "string"
    and type(recipe) == "string"
    and data.raw.technology[technology]
    and data.raw.recipe[recipe]
  then
    add_recipe_unlock(data.raw.technology[technology], recipe, insertindex)

    if data.raw.technology[technology].normal then
      add_recipe_unlock(data.raw.technology[technology].normal, recipe, insertindex)
    end
    if data.raw.technology[technology].expensive then
      add_recipe_unlock(data.raw.technology[technology].expensive, recipe, insertindex)
    end
  else
    log(debug.traceback())
    bobmods.lib.error.technology(technology)
    bobmods.lib.error.recipe(recipe)
  end
end

function seablock.lib.iteraterecipes(recipe, func)
  if recipe.ingredients then
    func(recipe)
  end
end

function seablock.lib.recipeforeach(recipename, itemname, func, tablename)
  local doline = function(recipe)
    for _, line in pairs(recipe[tablename]) do
      local nameidx = 1
      local amountidx = 2
      if line.name then
        nameidx = "name"
      end
      if line.amount then
        amountidx = "amount"
      end
      if line[nameidx] == itemname then
        func(line, nameidx, amountidx)
      end
    end
  end
  seablock.lib.iteraterecipes(data.raw.recipe[recipename], doline)
end

function seablock.lib.substingredient(name, from, to, count)
  local t = data.raw.recipe[name]
  if t then
    local dosubst = function(ingredient, nameidx, amountidx)
      if to ~= nil then
        ingredient[nameidx] = to
      end
      if count ~= nil then
        ingredient[amountidx] = count
      end
    end
    seablock.lib.recipeforeach(name, from, dosubst, "ingredients")
  else
    log("Warning : seablock.lib.substingredient - can't find recipe : " .. name)
    log(debug.traceback())
  end
end

function seablock.lib.removeingredient(name, ingredient)
  local t = data.raw.recipe[name]
  if t then
    local doremove = function(recipe)
      for k, v in pairs(recipe.ingredients) do
        if v[1] == ingredient or v.name == ingredient then
          table.remove(recipe.ingredients, k)
          return
        end
      end
    end
    seablock.lib.iteraterecipes(t, doremove)
  else
    log("Warning : seablock.lib.removeingredient - can't find recipe : " .. name)
    log(debug.traceback())
  end
end

function seablock.lib.substresult(name, from, to, count)
  local t = data.raw.recipe[name]
  if t then
    local dosubst = function(result, nameidx, amountidx)
      if to ~= nil then
        result[nameidx] = to
      end
      if count ~= nil then
        result[amountidx] = count
      end
    end
    seablock.lib.recipeforeach(name, from, dosubst, "results")
  else
    log("Warning : seablock.lib.substresult - can't find recipe : " .. name)
    log(debug.traceback())
  end
end

function seablock.lib.addresult(name, resulttable)
  local t = data.raw.recipe[name]
  if t then
    local doadd = function(recipe)
      table.insert(recipe.results, resulttable)
    end
    seablock.lib.iteraterecipes(t, doadd)
  else
    log("Warning: seablock.lib.addresult - can't find recipe : " .. name)
    log(debug.traceback())
  end
end

function seablock.lib.findtechunlock(recipename)
  for _, tech in pairs(data.raw.technology) do
    for _, effect in pairs(tech.effects or {}) do
      if effect.type == "unlock-recipe" and effect.recipe == recipename then
        return tech
      end
    end
  end
end

function seablock.lib.tablefind(table, item)
  for k, v in pairs(table) do
    if v == item then
      return k
    end
  end
  return nil
end

function seablock.lib.unhide_recipe(recipe_name)
  local recipe = data.raw.recipe[recipe_name]
  if recipe then
    if recipe.normal then
      recipe.normal.hidden = false
    end
    if recipe.expensive then
      recipe.expensive.hidden = false
    end
    if not recipe.normal and not recipe.expensive then
      recipe.hidden = false
    end
  else
    log("Warning: seablock.lib.unhide_recipe - can't find recipe : " .. recipe_name)
    log(debug.traceback())
  end
end

function seablock.lib.hide_technology(technology_name)
  local technology = data.raw.technology[technology_name]
  if technology then
    if technology.normal then
      technology.normal.hidden = true
      technology.normal.enabled = false
    end
    if technology.expensive then
      technology.expensive.hidden = true
      technology.expensive.enabled = false
    end
    if not technology.normal and not technology.expensive then
      technology.hidden = true
      technology.enabled = false
    end
  else
    log("Warning: seablock.lib.hide_technology - Hide non existing tech : " .. technology_name)
    log(debug.traceback())
  end
end

function seablock.lib.copy_icon(to, from)
  if to and from then
    to.icon = from.icon
    to.icons = from.icons
    to.icon_size = from.icon_size
    to.icon_mipmaps = from.icon_mipmaps
  end
end

function seablock.lib.hide_item(item_name)
  local item = data.raw.item[item_name]
  if item then
    item.hidden = true
    -- if not item.flags then
    --   item.flags = {}
    -- end
    -- if not seablock.lib.tablefind(item.flags, "hidden") then
    --   table.insert(item.flags, "hidden")
    -- end
  else
    item = data.raw.fluid[item_name]
    if item then
      item.hidden = true
    else
      log("Warning: seablock.lib.hide_item - can't find item or fluid : " .. item_name)
      log(debug.traceback())
    end
  end
end

function seablock.lib.hide(type_name, name)
  if not data.raw[type_name] then
    log("Warning: seablock.lib.hide - Unknown type: " .. type_name)
    log(debug.traceback())
  else
    local item = data.raw[type_name][name]
    if not item then
      log("Warning: seablock.lib.hide - Unknown " .. type_name .. ": " .. name)
      log(debug.traceback())
    else
      if type_name == "fluid" then
        item.hidden = true
      else
        if not item.flags then
          item.flags = {}
        end
        -- if not seablock.lib.tablefind(item.flags, "hidden") then
        --   table.insert(item.flags, "hidden")
        -- end
        item.hidden = true

        if type_name == "item" then
          table.insert(item.flags, "hide-from-bonus-gui")
        end

        item.next_upgrade = nil
      end
    end
  end
end

function seablock.lib.remove_effect(technology_name, effect_type, effect_key, effect_value)
  local tech = data.raw.technology[technology_name]
  if not tech then
    log("Warning: seablock.lib.remove_effect - Unknown technology: " .. technology_name)
    log(debug.traceback())
    return
  end

  if tech.effects then
    for i, effect in pairs(tech.effects) do
      if effect.type == effect_type and effect[effect_key] == effect_value then
        table.remove(tech.effects, i)
        return
      end
    end
  end
end

function seablock.lib.add_flag(type, name, flag)
  if not data.raw[type] then
    log("Warning : seablock.lib.add_flag - Unknown type: " .. type)
    log(debug.traceback())
    return
  end

  local item = data.raw[type][name]
  if not item then
    log("Warning : seablock.lib.add_flag - Unknown " .. type .. ": " .. name)
    log(debug.traceback())
    return
  end

  if item.flags then
    table.insert(item.flags, flag)
  else
    item.flags = { flag }
  end
end

--[[
  Modified from code copied from Artisanal Reskins: Library v1.1.2
  With permission from Kira
  https://mods.factorio.com/mod/reskins-library
  https://github.com/kirazy/reskins-library/
--]]
function seablock.reskins.composite_existing_icons(target_name, target_type, icons)
  -- icons = table of ["name"] = {type, shift, scale} or ["name"] = {icon or icons}, where type, shift, and scale are optional, and icon/icons ignores other param values

  -- Check to ensure the target is available
  local target = data.raw[target_type][target_name]
  if not target then
    return
  end

  -- Initialize the icons table
  local composite_icon = {}

  -- Iterate through the list of icons to composite
  for name, params in pairs(icons) do
    if params.icons then
      for _, layer in pairs(params.icons) do
        table.insert(composite_icon, {
          icon = layer.icon,
          icon_size = layer.icon_size,
          icon_mipmaps = layer.icon_mipmaps,
          scale = layer.scale or (32 / layer.icon_size),
          shift = layer.shift,
          tint = layer.tint,
        })
      end
    elseif params.icon then
      table.insert(composite_icon, {
        icon = params.icon.icon,
        icon_size = params.icon.icon_size,
        icon_mipmaps = params.icon.icon_mipmaps,
        scale = params.icon.scale or (32 / params.icon.icon_size),
        shift = params.icon.shift,
        tint = params.icon.tint,
      })
    else
      -- Check to ensure the object is available to copy from; abort if not
      local source_type = params.type or "item"

      -- Copy the current entity, return if it doesn't exist
      if not data.raw[source_type][name] then
        return
      end
      local entity = util.copy(data.raw[source_type][name])

      -- Check for icons definition
      if entity.icons then
        -- Transcribe layers to the composite_icon table
        for _, layer in pairs(entity.icons) do
          local icon_size = layer.icon_size or entity.icon_size
          table.insert(composite_icon, {
            icon = layer.icon,
            icon_size = icon_size,
            icon_mipmaps = layer.icon_mipmaps or entity.icon_mipmaps,
            tint = layer.tint,
            scale = layer.scale or (32 / icon_size) * (params.scale or 1),
            shift = {
              (layer.shift and (layer.shift[1] or layer.shift.x) or 0) * (params.scale or 1)
                + (params.shift and (params.shift[1] or params.shift.x) or 0),
              (layer.shift and (layer.shift[2] or layer.shift.y) or 0) * (params.scale or 1)
                + (params.shift and (params.shift[2] or params.shift.y) or 0),
            },
          })
        end
        -- Standard icon
      else
        -- Fully define an icons layer
        table.insert(composite_icon, {
          icon = entity.icon,
          icon_size = entity.icon_size,
          icon_mipmaps = entity.icon_mipmaps,
          scale = params.scale and (params.scale * 32 / entity.icon_size) or (32 / entity.icon_size),
          shift = {
            (params.shift and (params.shift[1] or params.shift.x) or 0),
            (params.shift and (params.shift[2] or params.shift.y) or 0),
          },
        })
      end
    end
  end

  -- Assign the composite icon
  seablock.reskins.assign_icons(target_name, { type = target_type, icon = composite_icon })
end

function seablock.reskins.assign_icons(name, inputs)
  -- Inputs required by this function
  -- type            - Entity type
  -- icon            - Table or string defining icon
  -- icon_size       - Pixel size of icons
  -- icon_mipmaps    - Number of mipmaps present in the icon image file

  -- Initialize paths
  local entity
  if inputs.type then
    entity = data.raw[inputs.type][name]
  end

  -- Recipes are exceptions to the usual pattern
  local item, item_with_data, explosion, remnant
  if inputs.type ~= "recipe" then
    item = data.raw["item"][name]
    item_with_data = data.raw["item-with-entity-data"][name]
    explosion = data.raw["explosion"][name .. "-explosion"]
    remnant = data.raw["corpse"][name .. "-remnants"]
  end

  -- Check whether icon or icons, ensure the key we're not using is erased
  if type(inputs.icon) == "table" then
    -- Set icon_size and icon_mipmaps per icons specification
    for n = 1, #inputs.icon do
      if not inputs.icon[n].icon_size then
        inputs.icon[n].icon_size = inputs.icon_size
      end

      if not inputs.icon[n].icon_mipmaps then
        inputs.icon[n].icon_mipmaps = inputs.icon_mipmaps or 1
      end
    end

    -- Create icons that have multiple layers
    if entity then
      entity.icon = nil
      entity.icons = inputs.icon
    end

    if item then
      item.icon = nil
      item.icons = inputs.icon
    end

    if item_with_data then
      item_with_data.icon = nil
      item_with_data.icons = inputs.icon
    end

    if explosion then
      explosion.icon = nil
      explosion.icons = inputs.icon
    end

    if remnant then
      remnant.icon = nil
      remnant.icons = inputs.icon
    end
  else
    -- Create icons that do not have multiple layers
    if entity then
      entity.icons = nil
      entity.icon = inputs.icon
      entity.icon_size = inputs.icon_size
      entity.icon_mipmaps = inputs.icon_mipmaps
    end

    if item then
      item.icons = nil
      item.icon = inputs.icon
      item.icon_size = inputs.icon_size
      item.icon_mipmaps = inputs.icon_mipmaps
    end

    if item_with_data then
      item_with_data.icons = nil
      item_with_data.icon = inputs.icon
      item_with_data.icon_size = inputs.icon_size
      item_with_data.icon_mipmaps = inputs.icon_mipmaps
    end

    if explosion then
      explosion.icons = nil
      explosion.icon = inputs.icon
      explosion.icon_size = inputs.icon_size
      explosion.icon_mipmaps = inputs.icon_mipmaps
    end

    if remnant then
      remnant.icons = nil
      remnant.icon = inputs.icon
      remnant.icon_size = inputs.icon_size
      remnant.icon_mipmaps = inputs.icon_mipmaps
    end
  end

  -- Handle picture definitions
  if entity then
    if inputs.icon_picture and inputs.make_entity_pictures then
      entity.pictures = inputs.icon_picture
    end
  end

  if item then
    if inputs.icon_picture and inputs.make_icon_pictures then
      item.pictures = inputs.icon_picture
    end
  end

  -- item-with-entity-data prototypes ignore pictures field as of 1.0
  -- this has been left active in the hopes the default behavior is adjusted
  if item_with_data then
    if inputs.icon_picture and inputs.make_icon_pictures then
      item_with_data.pictures = inputs.icon_picture
    end
  end

  -- Clear out recipe so that icon is inherited properly
  if inputs.type ~= "recipe" then
    seablock.reskins.clear_icon_specification(name, "recipe")
  end
end

function seablock.reskins.clear_icon_specification(name, type)
  -- Inputs required by this function:
  -- type        - Entity type

  -- Fetch entity
  local entity = data.raw[type][name]

  -- If the entity exists, clear the icon specification
  if entity then
    entity.icon = nil
    entity.icons = nil
    entity.icon_size = nil
    entity.icon_mipmaps = nil
  end
end
