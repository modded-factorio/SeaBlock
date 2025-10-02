/**
 * Composable for creating unified objects from different Factorio data types
 * This provides a consistent interface for recipes, technologies, items, buildings, etc.
 */

export function useUnifiedObjects() {
  /**
   * Create a unified object from recipe data
   */
  function createRecipeObject(recipe, itemsData, technologiesData, buildingsData = null) {
    if (!recipe) return null

    // Determine types based on results
    const types = ['recipe']
    let entityData = null

    if (recipe.results && recipe.results.length > 0) {
      for (const result of recipe.results) {
        if (result.type === 'item' && !types.includes('item')) {
          types.push('item')

          // Check if this item can be placed as an entity
          if (buildingsData && buildingsData[result.name]) {
            entityData = buildingsData[result.name]
            if (!types.includes('entity')) {
              types.push('entity')
            }
          }
        } else if (result.type === 'fluid' && !types.includes('fluid')) {
          types.push('fluid')
        } else if (result.type === 'entity' && !types.includes('entity')) {
          types.push('entity')
        }
      }
    }

    return {
      // Core properties
      id: recipe.name,
      name: recipe.name,
      displayName: recipe.displayName,
      description: recipe.description,
      types,

      // Organization
      group: recipe.group,
      subgroup: recipe.subgroup,
      order: recipe.order,
      category: recipe.category,

      // Recipe-specific data
      recipe: {
        ...recipe,
        ingredients: recipe.ingredients || [],
        results: recipe.results || [],
        energy_required: recipe.energy_required,
        enabled: recipe.enabled,
        category: recipe.category
      },

      // Entity data (if this recipe produces a placeable entity)
      entity: entityData,

      // Computed properties
      primaryResult: recipe.results?.[0] || null,
      isEnabled: recipe.enabled !== false,
      unlockTechnologies: getUnlockTechnologies(recipe, technologiesData),

      // Metadata
      source: 'recipe',
      lastUpdated: Date.now()
    }
  }

  /**
   * Create a unified object from technology data
   */
  function createTechnologyObject(technology, _recipesData, _itemsData) {
    if (!technology) return null

    return {
      // Core properties
      id: technology.name,
      name: technology.name,
      displayName: technology.displayName,
      description: technology.description,
      types: ['technology'],

      // Organization
      group: 'technologies',
      subgroup: 'technologies',
      order: technology.order || technology.name,

      // Technology-specific data
      technology: {
        ...technology,
        prerequisites: technology.prerequisites || [],
        effects: technology.effects || [],
        unit: technology.unit,
        maxLevel: technology.maxLevel,
        upgrade: technology.upgrade
      },

      // Metadata
      source: 'technology',
      lastUpdated: Date.now()
    }
  }

  /**
   * Create a unified object from item data
   */
  function createItemObject(item, recipesData) {
    if (!item) return null

    return {
      // Core properties
      id: item.name,
      name: item.name,
      displayName: item.displayName,
      description: item.description,
      types: ['item'],

      // Icon and visual
      icon: item.icon?.replace('spritemap:', '') || '',
      icon_size: item.icon_size,

      // Organization
      group: item.group,
      subgroup: item.subgroup,
      order: item.order,

      // Item-specific data
      item: {
        ...item,
        stack_size: item.stack_size,
        fuel_value: item.fuel_value,
        tooltip: item.tooltip
      },

      // Computed properties
      craftingRecipes: getCraftingRecipes(item.name, recipesData),
      usageRecipes: getUsageRecipes(item.name, recipesData),

      // Metadata
      source: 'item',
      lastUpdated: Date.now()
    }
  }

  /**
   * Create a unified object from fluid data
   */
  function createFluidObject(fluid, recipesData) {
    if (!fluid) return null

    return {
      // Core properties
      id: fluid.name,
      name: fluid.name,
      displayName: fluid.displayName,
      description: fluid.description,
      types: ['fluid'],

      // Icon and visual
      icon: fluid.icon?.replace('spritemap:', '') || '',
      icon_size: fluid.icon_size,
      base_color: fluid.base_color,
      flow_color: fluid.flow_color,

      // Organization
      group: 'fluids',
      subgroup: fluid.subgroup || 'fluids',
      order: fluid.order || fluid.name,

      // Fluid-specific data
      fluid: {
        ...fluid,
        default_temperature: fluid.default_temperature,
        max_temperature: fluid.max_temperature,
        auto_barrel: fluid.auto_barrel
      },

      // Computed properties
      craftingRecipes: getCraftingRecipes(fluid.name, recipesData),
      usageRecipes: getUsageRecipes(fluid.name, recipesData),

      // Metadata
      source: 'fluid',
      lastUpdated: Date.now()
    }
  }

  /**
   * Create a unified object from tile data
   */
  function createTileObject(tile, _recipesData) {
    if (!tile) return null

    return {
      // Core properties
      id: tile.name,
      name: tile.name,
      displayName: tile.displayName,
      description: tile.description,
      types: ['tile'],

      // Icon and visual
      icon: tile.icon?.replace('spritemap:', '') || '',
      icon_size: tile.icon_size,

      // Organization
      group: 'tiles',
      subgroup: tile.subgroup || 'tiles',
      order: tile.order || tile.name,

      // Tile-specific data
      tile: { ...tile },

      // Metadata
      source: 'tile',
      lastUpdated: Date.now()
    }
  }

  // Icon methods removed - icons are now handled directly in the data

  // Helper functions for relationships
  function getUnlockTechnologies(recipe, technologiesData) {
    if (!recipe || !technologiesData) return []

    const unlockTechnologies = []
    for (const [techName, techData] of Object.entries(technologiesData)) {
      if (techData.effects && techData.effects.length > 0) {
        for (const effect of techData.effects) {
          if (effect.type === 'unlock-recipe' && effect.recipe === recipe.name) {
            unlockTechnologies.push(techName)
            break
          }
        }
      }
    }
    return unlockTechnologies
  }

  function _getUnlockedRecipes(technology, recipesData) {
    if (!technology || !technology.effects || !recipesData) return []

    const unlockedRecipes = []
    for (const effect of technology.effects) {
      if (effect.type === 'unlock-recipe' && recipesData[effect.recipe]) {
        unlockedRecipes.push(effect.recipe)
      }
    }
    return unlockedRecipes
  }

  function getCraftingRecipes(itemName, recipesData) {
    if (!itemName || !recipesData) return []

    const craftingRecipes = []
    for (const [recipeName, recipeData] of Object.entries(recipesData)) {
      if (recipeData.results) {
        for (const result of recipeData.results) {
          if (result.name === itemName) {
            craftingRecipes.push(recipeName)
            break
          }
        }
      }
    }
    return craftingRecipes
  }

  function getUsageRecipes(itemName, recipesData) {
    if (!itemName || !recipesData) return []

    const usageRecipes = []
    for (const [recipeName, recipeData] of Object.entries(recipesData)) {
      if (recipeData.ingredients) {
        for (const ingredient of recipeData.ingredients) {
          if (ingredient.name === itemName) {
            usageRecipes.push(recipeName)
            break
          }
        }
      }
    }
    return usageRecipes
  }

  /**
   * Create a unified object by fetching all data by key
   * This is the new unified approach that fetches all related data
   */
  function createUnifiedObjectByKey(key, dataSources) {
    if (!key || !dataSources) return []

    const { recipesData, itemsData, buildingsData, fluidsData, tilesData } = dataSources

    // Start with the base data for this key
    const item = itemsData?.[key]
    const fluid = fluidsData?.[key]
    const entity = buildingsData?.[key]
    const recipe = recipesData?.[key]
    const tile = tilesData?.[key]
    /*
    const recipe = { ...recipesData?.[key] }

    if (true) {
      const mainProductName = recipe.main_product || recipe.results?.[0]?.name
      const recipeMainProduct = itemsData?.[mainProductName] || fluidsData?.[mainProductName]
      //Factoriopedia is using the subgroup of the main product for recipes
      if (recipeMainProduct && recipe.main_product === '') {
        //recipe.original_subgroup = recipe.subgroup
        //recipe.subgroup = recipeMainProduct?.subgroup
      }
      //recipe.order = recipeMainProduct?.order
    }
    */

    const objects = []
    //There are valid shapes for unified objects: (recipe/)item/entity, recipe/fluid, and recipe/tile
    let recipeUsed = false
    let entityUsed = false
    let tileUsed = false
    //Start by trying to make recipe/fluid (if incompatible return the fluid)
    if (fluid) {
      const unifiedObject = {
        types: ['fluid'],
        source: 'fluid',
        fluid
      }
      objects.push(unifiedObject)
      if (recipe) {
        //Check if the recipe is compatible with the fluid
        if (
          recipe.main_product === key ||
          (recipe.results?.length === 1 && recipe.results?.[0]?.name === key)
        ) {
          unifiedObject.recipe = recipe
          unifiedObject.types.push('recipe')
          recipeUsed = true
        }
      }
    }

    //Then try to make recipe/item/entity
    if (item) {
      const unifiedObject = {
        types: ['item'],
        source: 'item',
        item
      }
      objects.push(unifiedObject)
      if (!recipeUsed && recipe) {
        //Check if the recipe is compatible with the item
        if (
          recipe.main_product === key ||
          (recipe.results?.length === 1 && recipe.results?.[0]?.name === key)
        ) {
          unifiedObject.recipe = recipe
          unifiedObject.types.push('recipe')
          recipeUsed = true
        }
      }
      if (entity) {
        //Check if the entity is compatible with the item
        if (
          item.place_result === key ||
          entity?.minable?.results?.every(item => item.name === key)
        ) {
          unifiedObject.entity = entity
          unifiedObject.types.push('entity')
          entityUsed = true
        }
      }
      //Check if the tile is compatible with the item
      if (item.place_as_tile) {
        const tileName = item.place_as_tile.result
        unifiedObject.tile = tilesData[tileName]
        unifiedObject.types.push('tile')
        if (tileName === key) {
          tileUsed = true
        }
      }
    }

    // Handle tiles - they can combine with items
    if (tile && !tileUsed) {
      // check if it would've been part of an item
      const placeAsTileItem = Object.values(itemsData).filter(
        item => item.place_as_tile && item.place_as_tile.result === key
      )
      if (placeAsTileItem.length === 0 && tile.next_direction) {
        // walk the tile data until and end or we cycle back to the original tile
        let currentTile = tile
        while (currentTile.next_direction && currentTile.next_direction !== tile.name) {
          currentTile = tilesData[currentTile.next_direction]
          const otherTilePlaceAsTileItem = Object.values(itemsData).filter(
            item => item.place_as_tile && item.place_as_tile.result === currentTile.name
          )
          if (otherTilePlaceAsTileItem.length > 0) {
            return createUnifiedObjectByKey(currentTile.name, dataSources)
          }
        }
      }

      if (placeAsTileItem.length === 0) {
        const unifiedObject = {
          types: ['tile'],
          source: 'tile',
          tile
        }
        objects.push(unifiedObject)
      }
    }

    if (entity && !entityUsed) {
      const unifiedObject = {
        types: ['entity'],
        source: 'entity',
        entity
      }
      objects.push(unifiedObject)
    }

    if (recipe && !recipeUsed) {
      const unifiedObject = {
        types: ['recipe'],
        source: 'recipe',
        recipe
      }
      objects.push(unifiedObject)
    }

    // Update all objects with the necessary properties using the correct hierarchy
    objects.forEach(object => {
      // Core properties with hierarchy: recipe > item > entity > fluid > tile
      object.id =
        object.recipe?.name ||
        object.item?.name ||
        object.entity?.name ||
        object.fluid?.name ||
        object.tile?.name ||
        key
      object.name =
        object.recipe?.name ||
        object.item?.name ||
        object.entity?.name ||
        object.fluid?.name ||
        object.tile?.name ||
        key
      object.displayName =
        object.recipe?.displayName ||
        object.item?.displayName ||
        object.entity?.displayName ||
        object.fluid?.displayName ||
        object.tile?.displayName ||
        key
      object.description =
        object.recipe?.description ||
        object.item?.description ||
        object.entity?.description ||
        object.fluid?.description ||
        object.tile?.description
      // Organization properties with hierarchy
      object.subgroup =
        object.item?.subgroup ||
        object.fluid?.subgroup ||
        object.recipe?.subgroup ||
        object.entity?.subgroup ||
        object.tile?.subgroup ||
        (object.entity && !object.recipe && !object.item && !object.fluid && !object.tile
          ? 'entities'
          : null)
      object.order =
        object.item?.order ||
        object.fluid?.order ||
        object.recipe?.order ||
        object.entity?.order ||
        object.tile?.order ||
        key

      // Visual properties
      object.icon =
        object.recipe?.icon ||
        object.item?.icon ||
        object.entity?.icon ||
        object.fluid?.icon ||
        object.tile?.icon ||
        ''
      object.icon_size =
        object.recipe?.icon_size ||
        object.item?.icon_size ||
        object.entity?.icon_size ||
        object.fluid?.icon_size ||
        object.tile?.icon_size

      object.factoriopedia_alternative =
        object.recipe?.factoriopedia_alternative ||
        object.item?.factoriopedia_alternative ||
        object.entity?.factoriopedia_alternative ||
        object.fluid?.factoriopedia_alternative ||
        object.tile?.factoriopedia_alternative

      // Metadata
      object.lastUpdated = Date.now()
    })

    return objects
  }
  /**
   * Create a unified object from any data type (legacy method)
   */
  function createUnifiedObject(_data, _dataType, _additionalData = {}) {
    throw new Error('createUnifiedObject is deprecated')
  }

  /**
   * Get display properties for any unified object
   */
  function getDisplayProperties(unifiedObject) {
    if (!unifiedObject) return {}

    return {
      id: unifiedObject.id,
      name: unifiedObject.name,
      displayName: unifiedObject.displayName,
      description: unifiedObject.description,
      types: unifiedObject.types,
      icon: unifiedObject.icon,
      group: unifiedObject.group,
      subgroup: unifiedObject.subgroup,
      order: unifiedObject.order
    }
  }

  /**
   * Check if two unified objects are the same
   */
  function isSameObject(obj1, obj2) {
    if (!obj1 || !obj2) return false
    return obj1.id === obj2.id && JSON.stringify(obj1.types) === JSON.stringify(obj2.types)
  }

  /**
   * Check if a unified object has a specific type
   */
  function hasType(unifiedObject, type) {
    if (!unifiedObject || !unifiedObject.types) return false
    return unifiedObject.types.includes(type)
  }

  /**
   * Get the primary type (first type in the array)
   */
  function getPrimaryType(unifiedObject) {
    if (!unifiedObject || !unifiedObject.types || unifiedObject.types.length === 0) return null
    return unifiedObject.types[0]
  }

  return {
    createRecipeObject,
    createTechnologyObject,
    createItemObject,
    createFluidObject,
    createTileObject,
    createUnifiedObject,
    createUnifiedObjectByKey,
    getDisplayProperties,
    isSameObject,
    hasType,
    getPrimaryType
  }
}
