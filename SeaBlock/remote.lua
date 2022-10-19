require("__core__/lualib/util")

local function get_unlocks()
  return util.table.deepcopy(global.unlocks)
end

local function set_unlock(item, techs)
  global.unlocks[item] = techs
end

local function get_starting_items()
  return util.table.deepcopy(global.starting_items)
end

local function set_starting_item(item, quantity)
  global.starting_items[item] = quantity
end

local function set_starting_items(items)
  global.starting_items = items
end

remote.add_interface("SeaBlock", {
  get_unlocks = get_unlocks,
  set_unlock = set_unlock,
  get_starting_items = get_starting_items,
  set_starting_item = set_starting_item,
  set_starting_items = set_starting_items,
})
