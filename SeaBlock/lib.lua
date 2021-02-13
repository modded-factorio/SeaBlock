local lib = {}
lib.findname = function(t, name)
  for i,v in ipairs(t) do
    if v.name == name then
      return v
    end
  end
end
lib.removename = function(t, name)
  for i,v in ipairs(t) do
    if v.name == name then
      table.remove(t, i)
      return
    end
  end
end
lib.takeeffect = function(tech, name)
  if not data.raw.technology[tech] then
    return nil
  end
  local effects = data.raw.technology[tech].effects or {}
  for i,v in ipairs(effects) do
    if v.recipe == name then
      return table.remove(effects, i)
    end
  end
end
lib.findeffectidx = function(effects, name)
  for i,v in ipairs(effects) do
    if v.recipe == name then
      return i
    end
  end
end
lib.moveeffect = function(name, fromtech, totech, insertindex)
  local effect = lib.takeeffect(fromtech, name)
  if not effect then
    log('Effect ' .. name .. ' not found in tech ' .. fromtech)
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
      table.insert(technology.effects, insertindex, {type = "unlock-recipe", recipe = recipe})
    else
      table.insert(technology.effects, {type = "unlock-recipe", recipe = recipe})
    end
  end
end

lib.add_recipe_unlock = function(technology, recipe, insertindex)
  if
    type(technology) == "string" and
    type(recipe) == "string" and
    data.raw.technology[technology] and
    data.raw.recipe[recipe]
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

lib.iteraterecipes = function(recipe, func)
  if recipe.normal then
    func(recipe.normal)
  end
  if recipe.expensive then
    func(recipe.expensive)
  end
  if recipe.ingredients then
    func(recipe)
  end
end
lib.recipeforeach = function(recipename, itemname, func, tablename)
  local doline = function(recipe)
    for _, line in pairs(recipe[tablename]) do
      local nameidx = 1
      local amountidx = 2
      if line.name then nameidx = 'name' end
      if line.amount then amountidx = 'amount' end
      if line[nameidx] == itemname then
        func(line, nameidx, amountidx)
      end
    end
  end
  lib.iteraterecipes(data.raw.recipe[recipename], doline)
end
lib.substingredient = function(name, from, to, count)
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
    lib.recipeforeach(name, from, dosubst, 'ingredients')
  end
end
lib.removeingredient = function(name, ingredient)
  local t = data.raw.recipe[name]
  if t then
    local doremove = function(recipe)
      for k,v in pairs(recipe.ingredients) do
        if v[1] == ingredient or v.name == ingredient then
          table.remove(recipe.ingredients, k)
          return
        end
      end
    end
    lib.iteraterecipes(t, doremove)
  end
end
lib.substresult = function(name, from, to, count)
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
    lib.recipeforeach(name, from, dosubst, 'results')
  end
end
lib.addresult = function(name, resulttable)
  local t = data.raw.recipe[name]
  if t then
    local doadd = function(recipe)
      table.insert(recipe.results, resulttable)
    end
    lib.iteraterecipes(t, doadd)
  end
end
lib.findtechunlock = function(recipename)
  for _,tech in pairs(data.raw.technology) do
    for _,effect in pairs(tech.effects or {}) do
      if effect.type == "unlock-recipe" and effect.recipe == recipename then
        return tech
      end
    end
  end
end
lib.tablefind = function(table, item)
  for k, v in pairs(table) do
    if v == item then
      return k
    end
  end
  return nil
end

lib.remove_recipe = function(recipe)
  if data.raw.recipe[recipe] then
    bobmods.lib.recipe.enabled(recipe, false)
    if data.raw.recipe[recipe].normal then
      data.raw.recipe[recipe].normal.hidden = true
    end
    if data.raw.recipe[recipe].expensive then
      data.raw.recipe[recipe].expensive.hidden = true
    end
    if not data.raw.recipe[recipe].normal and not data.raw.recipe[recipe].expensive then
      data.raw.recipe[recipe].hidden = true
    end
  end
end

lib.hide_technology = function(technology)
  if data.raw.technology[technology] then
    if data.raw.technology[technology].normal then
      data.raw.technology[technology].normal.hidden = true
      data.raw.technology[technology].normal.enabled = false
    end
    if data.raw.technology[technology].expensive then
      data.raw.technology[technology].expensive.hidden = true
      data.raw.technology[technology].expensive.enabled = false
    end
    if not data.raw.technology[technology].normal and not data.raw.technology[technology].expensive then
      data.raw.technology[technology].hidden = true
      data.raw.technology[technology].enabled = false
    end
  end
end

lib.copy_icon = function(to, from)
  if to and from then
    to.icon = from.icon
    to.icons = from.icons
    to.icon_size = from.icon_size
    to.icon_mipmaps = from.icon_mipmaps
  end
end

lib.hide_item = function(item)
  local _item = data.raw.item[item]
  if not _item then
    _item = data.raw.fluid[item]
  end
  if _item then
    if not _item.flags then
      _item.flags = {}
    end
    if not lib.tablefind(_item.flags, "hidden") then
      table.insert(_item.flags, "hidden")
    end
  end
end

return lib
