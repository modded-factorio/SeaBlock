-- Compatibility shim for running the 1.1-era SeaBlock/Angel/Bob data stage on
-- Factorio 2.0.  This file is intentionally concentrated in one place so the
-- mechanical API migrations can be audited and eventually removed when the
-- upstream mods carry native 2.0 definitions.
--
-- The pass is idempotent: SeaBlock calls it from data.lua and again from
-- data-final-fixes.lua because Bob and Angel data-updates can introduce new
-- legacy shapes after the first pass has already run.

-- Factorio 2.0 removed the single-result recipe shorthand.  Older SeaBlock and
-- Angel code still creates recipes with `result` / `result_count`, so normalize
-- those into a one-entry `results` array before Factorio validates prototypes.
local function normalize_recipe_result(recipe)
  if not recipe then
    return
  end
  if recipe.results then
    recipe.result = nil
    recipe.result_count = nil
    return
  end
  if not recipe.result then
    recipe.result_count = nil
    return
  end
  recipe.results = {
    {
      type = "item",
      name = recipe.result,
      amount = recipe.result_count or 1,
    },
  }
  recipe.result = nil
  recipe.result_count = nil
end

-- The old `normal` / `expensive` recipe difficulty blocks are gone in 2.0.
-- SeaBlock only needs the normal values for this compatibility target, so copy
-- supported fields from `normal` to the top-level recipe and leave balance
-- cleanup for later gameplay validation.
local function migrate_recipe_difficulty(recipe)
  if not recipe or type(recipe.normal) ~= "table" then
    return
  end
  normalize_recipe_result(recipe.normal)
  for _, key in pairs({
    "allow_as_intermediate",
    "allow_decomposition",
    "allow_intermediates",
    "allow_productivity",
    "always_show_made_in",
    "always_show_products",
    "category",
    "emissions_multiplier",
    "enabled",
    "energy_required",
    "hide_from_player_crafting",
    "hidden",
    "ingredients",
    "main_product",
    "maximum_productivity",
    "overload_multiplier",
    "preserve_products_in_machine_output",
    "requester_paste_multiplier",
    "results",
    "show_amount_in_title",
    "surface_conditions",
  }) do
    if recipe[key] == nil and recipe.normal[key] ~= nil then
      recipe[key] = recipe.normal[key]
    end
  end
end

local function recipe_result_name(recipe)
  if not recipe then
    return nil
  end
  if recipe.main_product and recipe.main_product ~= "" then
    return recipe.main_product
  end
  if recipe.results and #recipe.results == 1 then
    return recipe.results[1].name or recipe.results[1][1]
  end
  if recipe.result then
    return recipe.result
  end
  return recipe_result_name(recipe.normal)
end

local function product_prototype(name)
  if not name then
    return nil
  end
  for _, type_name in pairs({
    "ammo",
    "armor",
    "capsule",
    "fluid",
    "gun",
    "item",
    "item-with-entity-data",
    "module",
    "rail-planner",
    "repair-tool",
    "tool",
  }) do
    if data.raw[type_name] and data.raw[type_name][name] then
      return data.raw[type_name][name]
    end
  end
  return nil
end

local function copy_recipe_icon_from_product(recipe)
  if not recipe or recipe.icon or recipe.icons then
    return
  end
  local result_name = recipe_result_name(recipe)
  local product = product_prototype(result_name)
  if not product then
    return
  end
  if product.icons then
    recipe.icons = util.table.deepcopy(product.icons)
  elseif product.icon then
    recipe.icon = product.icon
    recipe.icon_size = product.icon_size
    recipe.icon_mipmaps = product.icon_mipmaps
  end
  if recipe.main_product == nil then
    recipe.main_product = result_name
  end
end

-- Recipes with multiple generated outputs must have a valid main product in
-- 2.0.  When old code points at a renamed or removed product, choose the first
-- remaining result so the prototype remains loadable.
local function repair_main_product(recipe)
  if not recipe or not recipe.main_product or not recipe.results then
    return
  end
  for _, result in pairs(recipe.results) do
    if (result.name or result[1]) == recipe.main_product then
      return
    end
  end
  local first_result = recipe.results[1]
  recipe.main_product = first_result and (first_result.name or first_result[1]) or nil
end

-- Factorio 2.0 is stricter about energy unit casing.  Angel fluids used `KJ`
-- in a few heat capacities; the engine accepts `kJ`.
local function normalize_fluid_units(fluid)
  if fluid and type(fluid.heat_capacity) == "string" then
    fluid.heat_capacity = string.gsub(fluid.heat_capacity, "KJ", "kJ")
  end
end

local collision_layer_renames = {
  ["ground-tile"] = "ground_tile",
  ["ghost-layer"] = "ghost",
  ["item-layer"] = "item",
  ["object-layer"] = "object",
  ["player-layer"] = "player",
  ["train-layer"] = "train",
  ["water-tile"] = "water_tile",
}

-- Collision masks changed from an array of legacy layer names to a keyed
-- `layers` table.  Preserve `not-colliding-with-itself` as the separate 2.0
-- boolean and translate the renamed base layers.
local function normalize_collision_mask(mask)
  if not mask or mask.layers then
    return mask
  end
  local normalized = { layers = {} }
  for _, layer in pairs(mask) do
    if layer == "not-colliding-with-itself" then
      normalized.not_colliding_with_itself = true
    else
      normalized.layers[collision_layer_renames[layer] or layer] = true
    end
  end
  return normalized
end

local function normalize_prototype_collision_masks(prototype)
  for _, key in pairs({
    "adjacent_tile_collision_mask",
    "center_collision_mask",
    "collision_mask",
    "tile_collision_mask",
  }) do
    prototype[key] = normalize_collision_mask(prototype[key])
  end
end

local function normalize_tile_variants(tile)
  if tile and tile.variants and not tile.variants.transition and not tile.variants.empty_transitions then
    tile.variants.empty_transitions = true
  end
end

-- Tile pollution absorption moved from a scalar field to the general
-- `absorptions_per_second = { pollution = ... }` shape.
local function normalize_pollution_absorption(prototype)
  if prototype and prototype.pollution_absorption_per_second ~= nil then
    prototype.absorptions_per_second = prototype.absorptions_per_second or {}
    prototype.absorptions_per_second.pollution = prototype.pollution_absorption_per_second
    prototype.pollution_absorption_per_second = nil
  end
end

-- Energy-source and entity emissions are now pollutant dictionaries.  These
-- conversions keep old numeric pollution values intact without inventing any
-- non-pollution emissions.
local function normalize_energy_source(energy_source)
  if energy_source and type(energy_source.emissions_per_minute) == "number" then
    energy_source.emissions_per_minute = { pollution = energy_source.emissions_per_minute }
  end
end

local function normalize_emissions(prototype)
  if prototype and type(prototype.emissions_per_second) == "number" then
    prototype.emissions_per_second = { pollution = prototype.emissions_per_second }
  end
end

-- Old peak-based autoplace can no longer be mixed into 2.0 prototypes.  This
-- helper keeps already-converted expressions, removes autoplace that references
-- missing controls, and uses a small constant expression as a load-safe fallback
-- for legacy definitions that still only have `peaks` / probability fields.
local function normalize_autoplace(autoplace)
  if not autoplace then
    return nil
  end
  local function references_missing_control(expression)
    if type(expression) ~= "string" then
      return false
    end
    for control_name in string.gmatch(expression, "control:([%w%-%_]+):") do
      if data.raw["autoplace-control"] and not rawget(data.raw["autoplace-control"], control_name) then
        return true
      end
    end
    return false
  end
  if
    autoplace.control
    and data.raw["autoplace-control"]
    and not rawget(data.raw["autoplace-control"], autoplace.control)
  then
    return nil
  end
  if references_missing_control(autoplace.probability_expression) then
    return nil
  end
  for _, expression in pairs(autoplace.local_expressions or {}) do
    if references_missing_control(expression) then
      return nil
    end
  end
  if autoplace.probability_expression then
    return autoplace
  end
  autoplace.probability_expression = tostring(autoplace.max_probability or autoplace.probability or 0.01)
  autoplace.peaks = nil
  autoplace.max_probability = nil
  autoplace.random_probability_penalty = nil
  autoplace.sharpness = nil
  return autoplace
end

-- Several legacy lists use the compact positional `{name, amount}` product
-- format.  Factorio 2.0 accepts named fields more consistently across recipes,
-- mining results, and generated Bob/Angel helper output, so normalize in place.
local function normalize_product_list(products)
  for _, product in pairs(products or {}) do
    if type(product) == "table" then
      if product.name == nil and product[1] then
        product.name = product[1]
        product[1] = nil
      end
      if product.amount == nil and product[2] then
        product.amount = product[2]
        product[2] = nil
      end
      product.type = product.type or "item"
    end
  end
end

local function normalize_minable(prototype)
  if prototype and prototype.minable then
    normalize_product_list(prototype.minable.results)
  end
end

-- Module effect bonuses changed from `{ bonus = n }` to plain numeric values.
-- Bob's module chain still emits the old wrapper for some generated modules.
local function normalize_module_effects(module)
  for _, key in pairs({ "consumption", "pollution", "productivity", "quality", "speed" }) do
    if module.effect and type(module.effect[key]) == "table" and module.effect[key].bonus ~= nil then
      module.effect[key] = module.effect[key].bonus
    end
  end
end

-- Technology definitions are now stricter about complete units and science
-- pack ingredient format.  This fills harmless defaults and converts named
-- ingredient records back to the tuple format Factorio expects here.
local function normalize_technology_unit(technology)
  if technology.unit and technology.unit.time == nil then
    technology.unit.time = 30
  end
  if technology.unit and technology.unit.count == nil and technology.unit.count_formula == nil then
    technology.unit.count = 1
  end
  for index, ingredient in pairs((technology.unit and technology.unit.ingredients) or {}) do
    if type(ingredient) == "table" and ingredient.name then
      technology.unit.ingredients[index] = { ingredient.name, ingredient.amount or 1 }
    end
  end
  if technology.upgrade ~= nil and type(technology.upgrade) ~= "boolean" then
    technology.upgrade = true
  end
end

-- Fluid box pipe connections changed shape in 2.0.  Older prototypes may omit
-- a direction, use `type` where 2.0 expects `flow_direction`, or place pipe
-- endpoints exactly on the collision-box edge.  Infer/rename/clamp just enough
-- for validation while keeping the original connection layout recognizable.
local function infer_pipe_direction(position)
  local x = position and position[1] or 0
  local y = position and position[2] or 0
  if math.abs(x) > math.abs(y) then
    return x < 0 and defines.direction.west or defines.direction.east
  end
  return y < 0 and defines.direction.north or defines.direction.south
end

local function clamp(value, min_value, max_value)
  return math.min(math.max(value, min_value), max_value)
end

local function clamp_pipe_position(connection, prototype)
  local box = prototype and (prototype.collision_box or prototype.selection_box)
  if not box then
    return
  end
  local left_top = box[1]
  local right_bottom = box[2]
  if not left_top or not right_bottom then
    return
  end
  local function clamp_position(position)
    position[1] = clamp(position[1], left_top[1] + 0.1, right_bottom[1] - 0.1)
    position[2] = clamp(position[2], left_top[2] + 0.1, right_bottom[2] - 0.1)
  end
  if connection.position then
    clamp_position(connection.position)
  end
  for _, position in pairs(connection.positions or {}) do
    clamp_position(position)
  end
end

local function normalize_pipe_connection(connection, prototype)
  if type(connection) ~= "table" then
    return
  end
  if connection.direction == nil then
    connection.direction = infer_pipe_direction(connection.position)
  end
  clamp_pipe_position(connection, prototype)
  if connection.type and connection.flow_direction == nil then
    connection.flow_direction = connection.type
    connection.type = nil
  end
  if prototype and prototype.type == "storage-tank" then
    connection.flow_direction = nil
  end
end

local function normalize_fluid_box(fluid_box, prototype)
  if type(fluid_box) == "table" and fluid_box.volume == nil and fluid_box.pipe_connections then
    fluid_box.volume = 100
  end
  for _, connection in pairs(type(fluid_box) == "table" and fluid_box.pipe_connections or {}) do
    normalize_pipe_connection(connection, prototype)
  end
end

local function normalize_entity_fluid_boxes(prototype)
  if not prototype then
    return
  end
  normalize_fluid_box(prototype.fluid_box, prototype)
  normalize_fluid_box(prototype.input_fluid_box, prototype)
  normalize_fluid_box(prototype.output_fluid_box, prototype)
  if type(prototype.fluid_boxes) == "table" and prototype.fluid_boxes.off_when_no_fluid_recipe ~= nil then
    prototype.fluid_boxes_off_when_no_fluid_recipe = prototype.fluid_boxes.off_when_no_fluid_recipe
    prototype.fluid_boxes.off_when_no_fluid_recipe = nil
  end
  for _, fluid_box in pairs(prototype.fluid_boxes or {}) do
    normalize_fluid_box(fluid_box, prototype)
  end
end

local function normalize_offshore_pump(prototype)
  if prototype and prototype.type == "offshore-pump" then
    prototype.energy_source = prototype.energy_source or { type = "void" }
    prototype.energy_usage = prototype.energy_usage or "60kW"
    prototype.fluid_source_offset = prototype.fluid_source_offset or { 0, -1 }
  end
end

local item_like_types

-- `next_upgrade` may not point at an entity that the player cannot actually
-- place.  Hiding recipes/items during SeaBlock cleanup can leave old upgrade
-- chains dangling, so drop unsafe links after all item hiding has run.
local function entity_has_visible_place_item(entity_name)
  for _, type_name in pairs(item_like_types) do
    for _, item in pairs(data.raw[type_name] or {}) do
      if item.place_result == entity_name and not item.hidden then
        return true
      end
    end
  end
  return false
end

local function normalize_next_upgrade(prototype)
  if prototype.next_upgrade and not entity_has_visible_place_item(prototype.next_upgrade) then
    prototype.next_upgrade = nil
  end
end

item_like_types = {
  "ammo",
  "armor",
  "blueprint",
  "capsule",
  "copy-paste-tool",
  "deconstruction-item",
  "gun",
  "item",
  "item-with-entity-data",
  "item-with-inventory",
  "item-with-label",
  "item-with-tags",
  "module",
  "rail-planner",
  "repair-tool",
  "selection-tool",
  "spidertron-remote",
  "tool",
  "upgrade-item",
}

-- In 2.0, item-like prototypes use the `hidden` boolean rather than a `hidden`
-- entry in `flags`.  Move that flag to the supported field and keep unrelated
-- flags unchanged.
local function migrate_hidden_item_flags(prototype)
  if not prototype or not prototype.flags then
    return
  end
  local flags = {}
  for _, flag in pairs(prototype.flags) do
    if flag == "hidden" then
      prototype.hidden = true
    else
      table.insert(flags, flag)
    end
  end
  prototype.flags = #flags > 0 and flags or nil
end

-- Landfill-style item placement masks use the new keyed collision mask format.
-- This mirrors normalize_collision_mask for the nested `place_as_tile` field.
local function migrate_place_as_tile_condition(prototype)
  local place_as_tile = prototype and prototype.place_as_tile
  if not place_as_tile or not place_as_tile.condition or place_as_tile.condition.layers then
    return
  end
  local layers = {}
  for _, layer in pairs(place_as_tile.condition) do
    if layer == "water-tile" then
      layer = "water_tile"
    elseif layer == "ground-tile" then
      layer = "ground_tile"
    end
    layers[layer] = true
  end
  place_as_tile.condition = { layers = layers }
end

-- Always use rawget for existence checks.  This file installs a Bob-name
-- redirect metatable later; existence checks must answer "is there a real
-- prototype with this exact name?" so missing references can still be pruned.
local function prototype_exists(type_name, name)
  if type(name) ~= "string" then
    return false
  end
  if type_name == "item" then
    for _, item_type in pairs(item_like_types) do
      if data.raw[item_type] and rawget(data.raw[item_type], name) then
        return true
      end
    end
    return false
  end
  return data.raw[type_name] and rawget(data.raw[type_name], name) ~= nil
end

-- Bob's 2.0 development branch renamed many 1.1 prototypes.  Some gained a
-- `bob-` prefix, while common base concepts such as modules and circuits were
-- collapsed or mapped onto base-game names.  This table captures the nontrivial
-- cases that a simple prefix fallback cannot infer.
local bob_2_0_name_renames = {
  item = {
    ["empty-barrel"] = "barrel",
    ["speed-module-4"] = "speed-module-3",
    ["speed-module-5"] = "bob-speed-module-4",
    ["speed-module-6"] = "bob-speed-module-4",
    ["speed-module-7"] = "bob-speed-module-5",
    ["speed-module-8"] = "bob-speed-module-5",
    ["effectivity-module"] = "efficiency-module",
    ["effectivity-module-2"] = "efficiency-module-2",
    ["effectivity-module-3"] = "efficiency-module-3",
    ["effectivity-module-4"] = "efficiency-module-3",
    ["effectivity-module-5"] = "bob-efficiency-module-4",
    ["effectivity-module-6"] = "bob-efficiency-module-4",
    ["effectivity-module-7"] = "bob-efficiency-module-5",
    ["effectivity-module-8"] = "bob-efficiency-module-5",
    ["effectivity-processor"] = "bob-efficiency-processor",
    ["effectivity-processor-2"] = "bob-efficiency-processor-2",
    ["effectivity-processor-3"] = "bob-efficiency-processor-3",
    ["productivity-module-4"] = "productivity-module-3",
    ["productivity-module-5"] = "bob-productivity-module-4",
    ["productivity-module-6"] = "bob-productivity-module-4",
    ["productivity-module-7"] = "bob-productivity-module-5",
    ["productivity-module-8"] = "bob-productivity-module-5",
  },
  recipe = {
    ["empty-barrel"] = "barrel",
    ["speed-module-4"] = "speed-module-3",
    ["speed-module-5"] = "bob-speed-module-4",
    ["speed-module-6"] = "bob-speed-module-4",
    ["speed-module-7"] = "bob-speed-module-5",
    ["speed-module-8"] = "bob-speed-module-5",
    ["effectivity-module"] = "efficiency-module",
    ["effectivity-module-2"] = "efficiency-module-2",
    ["effectivity-module-3"] = "efficiency-module-3",
    ["effectivity-module-4"] = "efficiency-module-3",
    ["effectivity-module-5"] = "bob-efficiency-module-4",
    ["effectivity-module-6"] = "bob-efficiency-module-4",
    ["effectivity-module-7"] = "bob-efficiency-module-5",
    ["effectivity-module-8"] = "bob-efficiency-module-5",
    ["effectivity-processor"] = "bob-efficiency-processor",
    ["effectivity-processor-2"] = "bob-efficiency-processor-2",
    ["effectivity-processor-3"] = "bob-efficiency-processor-3",
    ["productivity-module-4"] = "productivity-module-3",
    ["productivity-module-5"] = "bob-productivity-module-4",
    ["productivity-module-6"] = "bob-productivity-module-4",
    ["productivity-module-7"] = "bob-productivity-module-5",
    ["productivity-module-8"] = "bob-productivity-module-5",
  },
  technology = {
    ["advanced-electronics"] = "advanced-circuit",
    ["advanced-electronics-2"] = "processing-unit",
    ["advanced-electronics-3"] = "bob-advanced-processing-unit",
    ["speed-module-4"] = "speed-module-3",
    ["speed-module-5"] = "bob-speed-module-4",
    ["speed-module-6"] = "bob-speed-module-4",
    ["speed-module-7"] = "bob-speed-module-5",
    ["speed-module-8"] = "bob-speed-module-5",
    ["effectivity-module"] = "efficiency-module",
    ["effectivity-module-2"] = "efficiency-module-2",
    ["effectivity-module-3"] = "efficiency-module-3",
    ["effectivity-module-4"] = "efficiency-module-3",
    ["effectivity-module-5"] = "bob-efficiency-module-4",
    ["effectivity-module-6"] = "bob-efficiency-module-4",
    ["effectivity-module-7"] = "bob-efficiency-module-5",
    ["effectivity-module-8"] = "bob-efficiency-module-5",
    ["productivity-module-4"] = "productivity-module-3",
    ["productivity-module-5"] = "bob-productivity-module-4",
    ["productivity-module-6"] = "bob-productivity-module-4",
    ["productivity-module-7"] = "bob-productivity-module-5",
    ["productivity-module-8"] = "bob-productivity-module-5",
  },
}

local function resolve_bob_2_0_name(type_name, name)
  if type(name) ~= "string" or prototype_exists(type_name, name) then
    return name
  end
  local renamed_name = bob_2_0_name_renames[type_name] and bob_2_0_name_renames[type_name][name]
  if renamed_name and prototype_exists(type_name, renamed_name) then
    return renamed_name
  end
  local prefixed_name = "bob-" .. name
  if prototype_exists(type_name, prefixed_name) then
    return prefixed_name
  end
  return name
end

-- Products can be items or fluids, and SeaBlock's old references do not always
-- know which kind they are.  Try both namespaces before leaving the name alone;
-- unresolved names are handled by the later recipe/technology pruning pass.
local function product_name_exists(name)
  return prototype_exists("item", name) or prototype_exists("fluid", name)
end

local function resolve_product_name(name)
  if type(name) ~= "string" or product_name_exists(name) then
    return name
  end
  local renamed_item = resolve_bob_2_0_name("item", name)
  if renamed_item ~= name then
    return renamed_item
  end
  local renamed_fluid = resolve_bob_2_0_name("fluid", name)
  if renamed_fluid ~= name then
    return renamed_fluid
  end
  local prefixed_name = "bob-" .. name
  if product_name_exists(prefixed_name) then
    return prefixed_name
  end
  return name
end

local function normalize_named_entry(entry, default_type)
  if type(entry) ~= "table" then
    return
  end
  local type_name = entry.type or default_type or "item"
  local key = entry.name and "name" or 1
  local name = entry[key]
  if type_name == "item" then
    entry[key] = resolve_bob_2_0_name("item", name)
  elseif type_name == "fluid" then
    entry[key] = resolve_bob_2_0_name("fluid", name)
  elseif type_name == "recipe" then
    entry[key] = resolve_bob_2_0_name("recipe", name)
  end
end

local function normalize_recipe_references(recipe)
  if not recipe then
    return
  end
  for _, ingredient in pairs(recipe.ingredients or {}) do
    normalize_named_entry(ingredient, "item")
  end
  for _, result in pairs(recipe.results or {}) do
    normalize_named_entry(result, result.type or "item")
  end
  recipe.main_product = resolve_product_name(recipe.main_product)
  normalize_recipe_references(recipe.normal)
  normalize_recipe_references(recipe.expensive)
end

-- Recipe categories were renamed along with Bob's electronics machines.  When
-- a category is gone, prefer the explicit known replacement before trying the
-- generic Bob prefix resolver.
local recipe_category_renames = {
  ["electronics-machine"] = "electronics",
  ["electronics-machine-with-fluid"] = "electronics-with-fluid",
}

local function normalize_recipe_category(recipe)
  if not recipe or not recipe.category then
    return
  end
  if prototype_exists("recipe-category", recipe.category) then
    return
  end
  local renamed_category = recipe_category_renames[recipe.category]
  if renamed_category and prototype_exists("recipe-category", renamed_category) then
    recipe.category = renamed_category
    return
  end
  recipe.category = resolve_bob_2_0_name("recipe-category", recipe.category)
end

local function normalize_recipe_category_name(category)
  if prototype_exists("recipe-category", category) then
    return category
  end
  local renamed_category = recipe_category_renames[category]
  if renamed_category and prototype_exists("recipe-category", renamed_category) then
    return renamed_category
  end
  return resolve_bob_2_0_name("recipe-category", category)
end

local function normalize_crafting_categories(prototype)
  if prototype.crafting_category then
    prototype.crafting_category = normalize_recipe_category_name(prototype.crafting_category)
  end
  for index, category in pairs(prototype.crafting_categories or {}) do
    prototype.crafting_categories[index] = normalize_recipe_category_name(category)
  end
end

-- Planet map-gen settings are validated against actual prototype autoplace
-- definitions in 2.0.  SeaBlock intentionally removes most vanilla autoplace,
-- so remove stale map-gen references to prototypes or controls that no longer
-- have matching definitions.
local function prototype_has_autoplace(name)
  for _, prototypes in pairs(data.raw) do
    local prototype = rawget(prototypes, name)
    if prototype and prototype.autoplace then
      return true
    end
  end
  return false
end

local function normalize_map_gen_settings(map_gen_settings)
  if not map_gen_settings then
    return
  end
  for control_name in pairs(map_gen_settings.autoplace_controls or {}) do
    if data.raw["autoplace-control"] and not rawget(data.raw["autoplace-control"], control_name) then
      map_gen_settings.autoplace_controls[control_name] = nil
    end
  end
  for _, setting_group in pairs(map_gen_settings.autoplace_settings or {}) do
    for prototype_name in pairs(setting_group.settings or {}) do
      if not prototype_has_autoplace(prototype_name) then
        setting_group.settings[prototype_name] = nil
      end
    end
  end
end

local function normalize_minable_references(prototype)
  for _, product in pairs((prototype.minable and prototype.minable.results) or {}) do
    normalize_named_entry(product, product.type or "item")
  end
end

-- Technologies often reference old Bob names in prerequisites, science packs,
-- and unlock effects.  Rename what exists, remove unlocks for recipes that are
-- gone, and deduplicate science packs after multiple old names collapse to one
-- modern prototype.
local function normalize_technology_references(technology)
  if technology.prerequisites then
    local deduplicated_prerequisites = {}
    local seen_prerequisites = {}
    for _, prerequisite in pairs(technology.prerequisites) do
      prerequisite = resolve_bob_2_0_name("technology", prerequisite)
      if prototype_exists("technology", prerequisite) and not seen_prerequisites[prerequisite] then
        table.insert(deduplicated_prerequisites, prerequisite)
        seen_prerequisites[prerequisite] = true
      end
    end
    technology.prerequisites = deduplicated_prerequisites
  end
  for _, ingredient in pairs((technology.unit and technology.unit.ingredients) or {}) do
    if type(ingredient) == "table" then
      ingredient[1] = resolve_bob_2_0_name("item", ingredient[1])
    end
  end
  if technology.unit and technology.unit.ingredients then
    local deduplicated_ingredients = {}
    local ingredient_index = {}
    for _, ingredient in pairs(technology.unit.ingredients) do
      if type(ingredient) ~= "table" then
        table.insert(deduplicated_ingredients, ingredient)
      else
        local name = ingredient[1]
        if name and ingredient_index[name] then
          local existing = ingredient_index[name]
          existing[2] = math.max(existing[2] or 1, ingredient[2] or 1)
        else
          table.insert(deduplicated_ingredients, ingredient)
          if name then
            ingredient_index[name] = ingredient
          end
        end
      end
    end
    technology.unit.ingredients = deduplicated_ingredients
  end
  if technology.effects then
    local normalized_effects = {}
    for _, effect in pairs(technology.effects) do
      if effect.type == "unlock-recipe" then
        effect.recipe = resolve_bob_2_0_name("recipe", effect.recipe)
      end
      if effect.type ~= "unlock-recipe" or prototype_exists("recipe", effect.recipe) then
        table.insert(normalized_effects, effect)
      end
    end
    technology.effects = normalized_effects
  end
  for _, effect in pairs(technology.effects or {}) do
    if effect.type == "unlock-recipe" then
      effect.recipe = resolve_bob_2_0_name("recipe", effect.recipe)
    end
  end
end

-- Research triggers are stricter in 2.0.  If a trigger points at an entity that
-- is not present in this reduced SeaBlock dependency set, remove it and add a
-- tiny fallback unit so the technology remains valid and can be revisited later.
local function entity_prototype_exists(name)
  for _, type_name in pairs({
    "fish",
    "resource",
    "simple-entity",
    "tree",
    "unit-spawner",
  }) do
    if data.raw[type_name] and rawget(data.raw[type_name], name) then
      return true
    end
  end
  return false
end

local function normalize_research_trigger(technology)
  if
    technology.research_trigger
    and technology.research_trigger.type == "mine-entity"
    and not entity_prototype_exists(technology.research_trigger.entity)
  then
    technology.research_trigger = nil
  end
  if not technology.unit and not technology.research_trigger then
    technology.unit = {
      count = 1,
      ingredients = { { "automation-science-pack", 1 } },
      time = 1,
    }
  end
end

-- Bob 2.0 plus SeaBlock startup tech cleanup can create a two-node prerequisite
-- cycle between electronics and automation science.  Break that exact cycle so
-- Factorio can build the technology graph.
local function remove_technology_prerequisite(technology_name, prerequisite_name)
  local technology = data.raw.technology and data.raw.technology[technology_name]
  if not technology or not technology.prerequisites then
    return
  end
  local prerequisites = {}
  for _, prerequisite in pairs(technology.prerequisites) do
    if prerequisite ~= prerequisite_name then
      table.insert(prerequisites, prerequisite)
    end
  end
  technology.prerequisites = prerequisites
end

-- SeaBlock still uses a `starting_area_moisture` map-gen knob in its terrain
-- expressions.  Base 2.0 no longer provides that control, so recreate a minimal
-- hidden terrain control and register it on planets before map-gen validation.
local function ensure_starting_area_moisture_control()
  if data.raw["autoplace-control"] and not data.raw["autoplace-control"]["starting_area_moisture"] then
    data:extend({
      {
        type = "autoplace-control",
        name = "starting_area_moisture",
        category = "terrain",
        order = "z",
        richness = false,
      },
    })
  end
  for _, planet in pairs(data.raw.planet or {}) do
    if planet.map_gen_settings and planet.map_gen_settings.autoplace_controls then
      planet.map_gen_settings.autoplace_controls["starting_area_moisture"] =
        planet.map_gen_settings.autoplace_controls["starting_area_moisture"] or {}
    end
  end
end

-- Lab inputs are validated against the science packs used by technologies.  The
-- Angel/Bob tech tree can introduce packs after labs are declared, so union all
-- visible science packs into each lab to keep startup validation load-safe.
local function normalize_lab_inputs()
  local science_packs = {}
  for _, technology in pairs(data.raw.technology or {}) do
    for _, ingredient in pairs((technology.unit and technology.unit.ingredients) or {}) do
      local name = type(ingredient) == "table" and (ingredient.name or ingredient[1])
      if name and prototype_exists("item", name) then
        science_packs[name] = true
      end
    end
  end
  for _, lab in pairs(data.raw.lab or {}) do
    lab.inputs = lab.inputs or {}
    local existing_inputs = {}
    for _, input in pairs(lab.inputs) do
      existing_inputs[input] = true
    end
    for science_pack in pairs(science_packs) do
      if not existing_inputs[science_pack] then
        table.insert(lab.inputs, science_pack)
      end
    end
  end
end

-- Run all mechanical 2.0 normalizations.  The order matters: name and recipe
-- cleanup happens before tech cleanup, hidden/upgrade cleanup happens after
-- item/entity passes, and map-gen cleanup runs after autoplace normalization.
local function run_factorio_2_0_compat()
  ensure_starting_area_moisture_control()

  for _, recipe in pairs(data.raw.recipe or {}) do
    migrate_recipe_difficulty(recipe)
    normalize_recipe_result(recipe)
    normalize_recipe_references(recipe)
    normalize_recipe_category(recipe)
    copy_recipe_icon_from_product(recipe)
    repair_main_product(recipe)
  end

  for _, fluid in pairs(data.raw.fluid or {}) do
    normalize_fluid_units(fluid)
  end

  for _, prototypes in pairs(data.raw) do
    for _, prototype in pairs(prototypes) do
      migrate_hidden_item_flags(prototype)
      normalize_prototype_collision_masks(prototype)
      normalize_pollution_absorption(prototype)
      normalize_emissions(prototype)
      normalize_energy_source(prototype.energy_source)
      normalize_entity_fluid_boxes(prototype)
      normalize_offshore_pump(prototype)
      prototype.autoplace = normalize_autoplace(prototype.autoplace)
      normalize_minable(prototype)
      normalize_minable_references(prototype)
      normalize_crafting_categories(prototype)
      normalize_next_upgrade(prototype)
    end
  end

  for _, tile in pairs(data.raw.tile or {}) do
    normalize_tile_variants(tile)
  end

  for _, module in pairs(data.raw.module or {}) do
    normalize_module_effects(module)
  end

  for _, technology in pairs(data.raw.technology or {}) do
    normalize_research_trigger(technology)
    normalize_technology_unit(technology)
    normalize_technology_references(technology)
  end
  remove_technology_prerequisite("electronics", "automation-science-pack")
  remove_technology_prerequisite("automation-science-pack", "electronics")
  normalize_lab_inputs()

  for _, planet in pairs(data.raw.planet or {}) do
    normalize_map_gen_settings(planet.map_gen_settings)
  end

  for _, type_name in pairs(item_like_types) do
    for _, prototype in pairs(data.raw[type_name] or {}) do
      migrate_hidden_item_flags(prototype)
      migrate_place_as_tile_condition(prototype)
    end
  end

  -- Bob's 2.0 ports prefixed many prototype names with "bob-". SeaBlock and
  -- Angel's data-updates still contain direct lookups using the 1.1 names.
  -- Redirect lookups without adding mismatched alias keys that Factorio would
  -- reject during final prototype validation.  This is a compatibility crutch
  -- for data-updates code only; real prototype names remain the Bob 2.0 names.
  for _, prototypes in pairs(data.raw) do
    local metatable = getmetatable(prototypes) or {}
    if not metatable.__seablock_bob_name_redirect then
      local existing_index = metatable.__index
      metatable.__index = function(table, key)
        local prefixed = rawget(table, "bob-" .. key)
        if prefixed then
          return prefixed
        end
        if type(existing_index) == "function" then
          return existing_index(table, key)
        elseif type(existing_index) == "table" then
          return existing_index[key]
        end
      end
      metatable.__seablock_bob_name_redirect = true
      setmetatable(prototypes, metatable)
    end
  end
end

-- Expose the pass so late data-final-fixes from SeaBlock or Angel's Refining
-- can rerun it after they have generated or mutated additional prototypes.
seablock.factorio_2_0_compat = run_factorio_2_0_compat
run_factorio_2_0_compat()
