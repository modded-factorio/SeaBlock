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

-- Presets for Milestones mod
local function milestones_presets()
  local grouped_milestones = {}

  -- Science
  local bio_science_pack = script.active_mods["ScienceCostTweakerM"] and "sct-bio-science-pack" or "token-bio"
  grouped_milestones["science"] = {
    { type = "group", name = "Science" },
    { type = "item", name = "automation-science-pack", quantity = 1 },
    { type = "item", name = bio_science_pack, quantity = 1 },
    { type = "item", name = "logistic-science-pack", quantity = 1 },
    { type = "item", name = "military-science-pack", quantity = 1 },
    { type = "item", name = "chemical-science-pack", quantity = 1 },
    script.active_mods["bobtech"] and { type = "item", name = "advanced-logistic-science-pack", quantity = 1 } or nil,
    { type = "item", name = "production-science-pack", quantity = 1 },
    { type = "item", name = "utility-science-pack", quantity = 1 },
    { type = "item", name = "space-science-pack", quantity = 1 },
    { type = "item", name = "automation-science-pack", quantity = 1000, next = "x10" },
    { type = "item", name = bio_science_pack, quantity = 1000, next = "x10" },
    { type = "item", name = "logistic-science-pack", quantity = 1000, next = "x10" },
    { type = "item", name = "military-science-pack", quantity = 1000, next = "x10" },
    { type = "item", name = "chemical-science-pack", quantity = 1000, next = "x10" },
    script.active_mods["bobtech"]
        and { type = "item", name = "advanced-logistic-science-pack", quantity = 1000, next = "x10" }
      or nil,
    { type = "item", name = "production-science-pack", quantity = 1000, next = "x10" },
    { type = "item", name = "utility-science-pack", quantity = 1000, next = "x10" },
    { type = "item", name = "space-science-pack", quantity = 10000, next = "x10" },
  }

  -- Resources
  grouped_milestones["resorces"] = {
    { type = "group", name = "Resources" },
    { type = "item", name = "wood-charcoal", quantity = 1 },
    { type = "item", name = "basic-circuit-board", quantity = 1 },
    { type = "item", name = "electronic-circuit", quantity = 1 },
    { type = "item", name = "advanced-circuit", quantity = 1 },
    { type = "item", name = "processing-unit", quantity = 1 },
    { type = "item", name = "advanced-processing-unit", quantity = 1 },

    { type = "item", name = "basic-circuit-board", quantity = 10000, next = "x10" },
    { type = "item", name = "electronic-circuit", quantity = 10000, next = "x10" },
    { type = "item", name = "advanced-circuit", quantity = 10000, next = "x10" },
    { type = "item", name = "processing-unit", quantity = 1000, next = "x10" },
    { type = "item", name = "advanced-processing-unit", quantity = 100, next = "x10" },

    { type = "item", name = "steel-plate", quantity = 1 },
    { type = "item", name = "bronze-alloy", quantity = 1 },
    { type = "item", name = "invar-alloy", quantity = 1 },
    { type = "item", name = "brass-alloy", quantity = 1 },
    { type = "item", name = "glass", quantity = 1 },
    { type = "item", name = "silver-plate", quantity = 1 },

    { type = "item", name = "aluminium-plate", quantity = 1 },
    { type = "item", name = "titanium-plate", quantity = 1 },
    { type = "item", name = "gold-plate", quantity = 1 },
    { type = "item", name = "cobalt-steel-alloy", quantity = 1 },
    { type = "item", name = "angels-plate-chrome", quantity = 1 },
    { type = "item", name = "angels-plate-platinum", quantity = 1 },

    { type = "item", name = "tungsten-plate", quantity = 1 },
    { type = "item", name = "copper-tungsten-alloy", quantity = 1 },
    { type = "item", name = "tungsten-carbide", quantity = 1 },
    { type = "item", name = "nitinol-alloy", quantity = 1 },

    { type = "item", name = "plastic-bar", quantity = 1 },
    { type = "item", name = "resin", quantity = 1 },
    { type = "item", name = "rubber", quantity = 1 },
    { type = "item", name = "alien-bacteria", quantity = 1 },
    { type = "item", name = "sulfur", quantity = 1 },
    { type = "fluid", name = "mineral-sludge", quantity = 1 },
    { type = "fluid", name = "mineral-sludge", quantity = 10000, next = "x10" },
  }

  -- Progress
  local seablock_default_landfill = script.active_mods["LandfillPainting"]
      and settings.startup["sb-default-landfill"]
      and settings.startup["sb-default-landfill"].value
    or "landfill"
  grouped_milestones["progress1"] = {
    { type = "group", name = "Progress" },
    { type = "item", name = "lab", quantity = 1 },
    { type = "item", name = seablock_default_landfill, quantity = 1 },
    { type = "item", name = seablock_default_landfill, quantity = 1000, next = "x10" },
    { type = "alias", name = "landfill-dirt-4", equals = seablock_default_landfill, quantity = 1 },
    { type = "alias", name = "landfill-dry-dirt", equals = seablock_default_landfill, quantity = 1 },
    { type = "alias", name = "landfill-grass-1", equals = seablock_default_landfill, quantity = 1 },
    { type = "alias", name = "landfill-red-desert-1", equals = seablock_default_landfill, quantity = 1 },
    { type = "alias", name = "landfill-sand-3", equals = seablock_default_landfill, quantity = 1 },
    { type = "alias", name = "landfill", equals = seablock_default_landfill, quantity = 1 },
    { type = "fluid", name = "liquid-fuel-oil", quantity = 1 },
    { type = "item", name = "locomotive", quantity = 1 },
    { type = "item", name = "construction-robot", quantity = 1 },
    { type = "item", name = "logistic-chest-requester", quantity = 1 },
  }

  if not script.active_mods["bobmodules"] then
    -- Vanilla modules
    grouped_milestones["modules"] = {
      { type = "item", name = "productivity-module", quantity = 1 },
      { type = "item", name = "productivity-module-4", quantity = 1 },
      { type = "item", name = "productivity-module-6", quantity = 1 },
    }
  elseif script.active_mods["CircuitProcessing"] then
    -- Circuit Processing modules
    grouped_milestones["modules"] = {
      { type = "item", name = "productivity-module-2", quantity = 1 },
      { type = "item", name = "productivity-module-4", quantity = 1 },
      { type = "item", name = "productivity-module-6", quantity = 1 },
      { type = "item", name = "productivity-module-8", quantity = 1 },
    }
  else
    -- Bob's Modules
    grouped_milestones["modules"] = {
      { type = "item", name = "productivity-module", quantity = 1 },
      { type = "item", name = "productivity-module-8", quantity = 1 },
    }
  end

  grouped_milestones["progress2"] = {
    { type = "item", name = "beacon", quantity = 1 },
    script.active_mods["bobmodules"] and { type = "item", name = "beacon-2", quantity = 1 } or nil,
    script.active_mods["bobmodules"] and { type = "item", name = "beacon-3", quantity = 1 } or nil,
    { type = "item", name = "rocket-fuel", quantity = 1 },
    { type = "technology", name = "rocket-silo", quantity = 1 },
    { type = "item", name = "nuclear-reactor", quantity = 1 },
  }

  -- SpaceX
  if script.active_mods["SpaceMod"] then
    grouped_milestones["SpaceX"] = {
      { type = "group", name = "SpaceX" },
      { type = "item", name = "drydock-structural", quantity = 10 },
      { type = "item", name = "drydock-assembly", quantity = 2 },
      { type = "item", name = "protection-field", quantity = 1 },
      { type = "item", name = "fusion-reactor", quantity = 1 },
      { type = "item", name = "habitation", quantity = 1 },
      { type = "item", name = "life-support", quantity = 1 },
      { type = "item", name = "command", quantity = 1 },
      { type = "item", name = "fuel-cell", quantity = 2 },
      { type = "item", name = "space-thruster", quantity = 4 },
      { type = "item", name = "hull-component", quantity = 10 },
      { type = "technology", name = "ftl-theory-A", quantity = 1 },
      { type = "technology", name = "ftl-theory-B", quantity = 1 },
      { type = "technology", name = "ftl-theory-C", quantity = 1 },
      { type = "technology", name = "ftl-theory-D1", quantity = 1 },
      script.active_mods["bobtech"] and { type = "technology", name = "ftl-theory-D", quantity = 1 } or nil,
      { type = "technology", name = "ftl-theory-D2", quantity = 1 },
      { type = "technology", name = "ftl-propulsion", quantity = 1 },
      { type = "item", name = "ftl-drive", quantity = 1 },
    }
  end

  -- Kills
  if script.active_mods["bobenemies"] then
    grouped_milestones["kills"] = {
      { type = "group", name = "Kills" },
      { type = "kill", name = "small-worm-turret", quantity = 1 },
      { type = "kill", name = "medium-worm-turret", quantity = 1 },
      { type = "kill", name = "big-worm-turret", quantity = 1 },
      { type = "alias", name = "bob-big-explosive-worm-turret", equals = "big-worm-turret", quantity = 1 },
      { type = "alias", name = "bob-big-piercing-worm-turret", equals = "big-worm-turret", quantity = 1 },
      { type = "alias", name = "bob-big-fire-worm-turret", equals = "big-worm-turret", quantity = 1 },
      { type = "alias", name = "bob-big-poison-worm-turret", equals = "big-worm-turret", quantity = 1 },
      { type = "alias", name = "bob-big-electric-worm-turret", equals = "big-worm-turret", quantity = 1 },
      { type = "kill", name = "bob-giant-worm-turret", quantity = 1 },
      { type = "kill", name = "behemoth-worm-turret", quantity = 1 },
      { type = "kill", name = "behemoth-worm-turret", quantity = 1000, next = "x10" },
      { type = "kill", name = "character", quantity = 1, next = "x5" },
    }
  else
    grouped_milestones["kills"] = {
      { type = "group", name = "Kills" },
      { type = "kill", name = "small-worm-turret", quantity = 1 },
      { type = "kill", name = "medium-worm-turret", quantity = 1 },
      { type = "kill", name = "big-worm-turret", quantity = 1 },
      { type = "kill", name = "behemoth-worm-turret", quantity = 1 },
      { type = "kill", name = "behemoth-worm-turret", quantity = 1000, next = "x10" },
      { type = "kill", name = "character", quantity = 1, next = "x5" },
    }
  end

  local milestones = {}
  for group_name, group_milestones in pairs(grouped_milestones) do
    for _, milestone in pairs(group_milestones) do
      table.insert(milestones, milestone)
    end
  end

  return {
    ["Sea Block"] = {
      required_mods = { "SeaBlock", "bobplates", "bobelectronics", "angelsbioprocessing", "angelspetrochem" },
      milestones = milestones,
    },
  }
end

remote.add_interface("SeaBlock", {
  get_unlocks = get_unlocks,
  set_unlock = set_unlock,
  get_starting_items = get_starting_items,
  set_starting_item = set_starting_item,
  set_starting_items = set_starting_items,
  milestones_presets = milestones_presets,
})
