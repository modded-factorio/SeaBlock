/**
 * Composable for loading and managing Factorio data from JSON files
 * This handles all the data loading logic that was previously in Factoriopedia.vue
 * Uses singleton pattern to ensure data is shared across all components
 */

import { ref } from 'vue'
import { withBase } from 'vitepress'

import { useUnifiedObjects } from './useUnifiedObjects.js'

// Singleton instance - shared across all components
let factorioDataInstance = null

function createFactorioDataInstance() {
  // Reactive data refs
  const itemsData = ref(null)
  const recipesData = ref(null)
  const tooltipsData = ref(null)
  const groupsData = ref(null)
  const technologiesData = ref(null)
  const fluidsData = ref(null)
  const buildingsData = ref(null)
  const tilesData = ref(null)

  // Loading state
  const isLoading = ref(false)
  const loadingError = ref(null)

  /**
   * Load items data from JSON
   */
  async function loadItemsData() {
    try {
      const response = await fetch(withBase('/data/en-items.json'))
      if (!response.ok) throw new Error(`HTTP error! status: ${response.status}`)
      const rawData = await response.json()

      // Filter out hidden items
      const filteredData = {}
      for (const [key, item] of Object.entries(rawData)) {
        if (!item.hidden) {
          filteredData[key] = item
        }
      }

      itemsData.value = filteredData
      console.log(
        `✓ Loaded items data (${Object.keys(filteredData).length} items, ${Object.keys(rawData).length - Object.keys(filteredData).length} hidden)`
      )
    } catch (error) {
      console.error('Failed to load items data:', error)
      throw error
    }
  }

  /**
   * Load recipes data from JSON
   */
  async function loadRecipesData() {
    try {
      const response = await fetch(withBase('/data/en-recipes.json'))
      if (!response.ok) throw new Error(`HTTP error! status: ${response.status}`)
      const rawData = await response.json()

      // Filter out hidden recipes
      const filteredData = {}
      for (const [key, recipe] of Object.entries(rawData)) {
        if (!recipe.hidden) {
          filteredData[key] = recipe
        }
      }

      recipesData.value = filteredData
      console.log(
        `✓ Loaded recipes data (${Object.keys(filteredData).length} recipes, ${Object.keys(rawData).length - Object.keys(filteredData).length} hidden)`
      )
    } catch (error) {
      console.error('Failed to load recipes data:', error)
      throw error
    }
  }

  /**
   * Load tooltips data from JSON
   */
  async function loadTooltipsData() {
    try {
      const response = await fetch(withBase('/data/en-tooltips.json'))
      if (!response.ok) throw new Error(`HTTP error! status: ${response.status}`)
      tooltipsData.value = await response.json()
      console.log('✓ Loaded tooltips data')
    } catch (error) {
      console.error('Failed to load tooltips data:', error)
      throw error
    }
  }

  /**
   * Load groups data from JSON
   */
  async function loadGroupsData() {
    try {
      const response = await fetch(withBase('/data/en-groups.json'))
      if (!response.ok) throw new Error(`HTTP error! status: ${response.status}`)
      groupsData.value = await response.json()
      console.log('✓ Loaded groups data')
    } catch (error) {
      console.error('Failed to load groups data:', error)
      throw error
    }
  }

  /**
   * Load technologies data from JSON
   */
  async function loadTechnologiesData() {
    try {
      const response = await fetch(withBase('/data/en-technologies.json'))
      if (!response.ok) throw new Error(`HTTP error! status: ${response.status}`)
      const rawData = await response.json()

      // Filter out hidden technologies
      const filteredData = {}
      for (const [key, technology] of Object.entries(rawData)) {
        if (!technology.hidden) {
          filteredData[key] = technology
        }
      }

      technologiesData.value = filteredData
      console.log(
        `✓ Loaded technologies data (${Object.keys(filteredData).length} technologies, ${Object.keys(rawData).length - Object.keys(filteredData).length} hidden)`
      )
    } catch (error) {
      console.error('Failed to load technologies data:', error)
      throw error
    }
  }

  /**
   * Load fluids data from JSON
   */
  async function loadFluidsData() {
    try {
      const response = await fetch(withBase('/data/en-fluids.json'))
      if (!response.ok) throw new Error(`HTTP error! status: ${response.status}`)
      const rawData = await response.json()

      // Filter out hidden fluids
      const filteredData = {}
      for (const [key, fluid] of Object.entries(rawData)) {
        if (!fluid.hidden) {
          filteredData[key] = fluid
        }
      }

      fluidsData.value = filteredData
      console.log(
        `✓ Loaded fluids data (${Object.keys(filteredData).length} fluids, ${Object.keys(rawData).length - Object.keys(filteredData).length} hidden)`
      )
    } catch (error) {
      console.error('Failed to load fluids data:', error)
      throw error
    }
  }

  /**
   * Load buildings data from JSON
   */
  async function loadBuildingsData() {
    try {
      const response = await fetch(withBase('/data/en-buildings.json'))
      if (!response.ok) throw new Error(`HTTP error! status: ${response.status}`)
      const rawData = await response.json()

      buildingsData.value = rawData
      console.log(`✓ Loaded buildings data (${Object.keys(rawData).length} buildings)`)
    } catch (error) {
      console.error('Failed to load buildings data:', error)
      throw error
    }
  }

  /**
   * Load tiles data from JSON
   */
  async function loadTilesData() {
    try {
      const response = await fetch(withBase('/data/en-tiles.json'))
      if (!response.ok) throw new Error(`HTTP error! status: ${response.status}`)
      const rawData = await response.json()

      // Filter out hidden tiles
      const filteredData = {}
      for (const [key, tile] of Object.entries(rawData)) {
        if (!tile.hidden) {
          filteredData[key] = tile
        }
      }

      tilesData.value = filteredData
      console.log(
        `✓ Loaded tiles data (${Object.keys(filteredData).length} tiles, ${Object.keys(rawData).length - Object.keys(filteredData).length} hidden)`
      )
    } catch (error) {
      console.error('Failed to load tiles data:', error)
      throw error
    }
  }

  /**
   * Load all data files in parallel
   */
  async function loadAllData() {
    isLoading.value = true
    loadingError.value = null

    try {
      await Promise.all([
        loadItemsData(),
        loadRecipesData(),
        loadTooltipsData(),
        loadGroupsData(),
        loadTechnologiesData(),
        loadFluidsData(),
        loadBuildingsData(),
        loadTilesData()
      ])
      console.log('✓ All Factorio data loaded successfully')
    } catch (error) {
      loadingError.value = error
      console.error('Failed to load Factorio data:', error)
      throw error
    } finally {
      isLoading.value = false
    }
  }

  /**
   * Check if all data is loaded
   */
  function isDataLoaded() {
    return (
      itemsData.value &&
      recipesData.value &&
      tooltipsData.value &&
      groupsData.value &&
      technologiesData.value &&
      fluidsData.value &&
      buildingsData.value &&
      tilesData.value
    )
  }

  /**
   * Get a specific item by name
   */
  function getItemData(itemName) {
    if (!itemName) {
      throw new Error('Item name is required')
    }
    if (isLoading.value) {
      throw new Error('Data is still loading')
    }
    if (!itemsData.value) {
      throw new Error('Items data is not available')
    }
    const item = itemsData.value[itemName]
    if (!item) {
      throw new Error(`Item '${itemName}' not found`)
    }
    return item
  }

  /**
   * Get a specific recipe by name
   */
  function getRecipeData(recipeName) {
    if (!recipeName) {
      throw new Error('Recipe name is required')
    }
    if (isLoading.value) {
      throw new Error('Data is still loading')
    }
    if (!recipesData.value) {
      throw new Error('Recipes data is not available')
    }
    const recipe = recipesData.value[recipeName]
    if (!recipe) {
      throw new Error(`Recipe '${recipeName}' not found`)
    }
    return recipe
  }

  /**
   * Get a specific technology by name
   */
  function getTechnologyData(technologyName) {
    if (!technologyName) {
      throw new Error('Technology name is required')
    }
    if (isLoading.value) {
      throw new Error('Data is still loading')
    }
    if (!technologiesData.value) {
      throw new Error('Technologies data is not available')
    }
    const technology = technologiesData.value[technologyName]
    if (!technology) {
      throw new Error(`Technology '${technologyName}' not found`)
    }
    return technology
  }

  /**
   * Get a specific fluid by name
   */
  function getFluidData(fluidName) {
    if (!fluidName) {
      throw new Error('Fluid name is required')
    }
    if (isLoading.value) {
      throw new Error('Data is still loading')
    }
    if (!fluidsData.value) {
      throw new Error('Fluids data is not available')
    }
    const fluid = fluidsData.value[fluidName]
    if (!fluid) {
      throw new Error(`Fluid '${fluidName}' not found`)
    }
    return fluid
  }

  /**
   * Get a specific building by name
   */
  function getBuildingData(buildingName) {
    if (!buildingName) {
      throw new Error('Building name is required')
    }
    if (isLoading.value) {
      throw new Error('Data is still loading')
    }
    if (!buildingsData.value) {
      throw new Error('Buildings data is not available')
    }
    const building = buildingsData.value[buildingName]
    if (!building) {
      throw new Error(`Building '${buildingName}' not found`)
    }
    return building
  }

  /**
   * Get a specific tile by name
   */
  function getTileData(tileName) {
    if (!tileName) {
      throw new Error('Tile name is required')
    }
    if (isLoading.value) {
      throw new Error('Data is still loading')
    }
    if (!tilesData.value) {
      throw new Error('Tiles data is not available')
    }
    const tile = tilesData.value[tileName]
    if (!tile) {
      throw new Error(`Tile '${tileName}' not found`)
    }
    return tile
  }

  /**
   * Get a specific group by name
   */
  function getGroupData(groupName) {
    if (!groupName) {
      throw new Error('Group name is required')
    }
    if (isLoading.value) {
      throw new Error('Data is still loading')
    }
    if (!groupsData.value) {
      throw new Error('Groups data is not available')
    }
    const group = groupsData.value[groupName]
    if (!group) {
      throw new Error(`Group '${groupName}' not found`)
    }
    return group
  }

  /**
   * Get tooltip data for a specific item
   */
  function getTooltipData(itemName) {
    if (!itemName) {
      throw new Error('Item name is required')
    }
    if (isLoading.value) {
      throw new Error('Data is still loading')
    }
    if (!tooltipsData.value) {
      throw new Error('Tooltips data is not available')
    }
    const tooltip = tooltipsData.value[itemName]
    if (!tooltip) {
      throw new Error(`Tooltip for '${itemName}' not found`)
    }
    return tooltip
  }

  /**
   * Find all recipes that produce a specific item
   */
  function findRecipesByResult(itemName) {
    if (!recipesData.value || !itemName) return []

    const recipes = []
    for (const [_recipeName, recipeData] of Object.entries(recipesData.value)) {
      if (recipeData.results) {
        for (const result of recipeData.results) {
          if (result.name === itemName) {
            recipes.push(recipeData)
            break
          }
        }
      }
    }
    return recipes
  }

  /**
   * Find all recipes that use a specific item as ingredient
   */
  function findRecipesByIngredient(itemName) {
    if (!recipesData.value || !itemName) return []

    const recipes = []
    for (const [_recipeName, recipeData] of Object.entries(recipesData.value)) {
      if (recipeData.ingredients) {
        for (const ingredient of recipeData.ingredients) {
          if (ingredient.name === itemName) {
            recipes.push(recipeData)
            break
          }
        }
      }
    }
    return recipes
  }

  /**
   * Get all technologies that unlock a specific recipe
   */
  function getUnlockTechnologies(recipeName) {
    if (!technologiesData.value || !recipeName) return []

    const unlockTechnologies = []
    for (const [techName, techData] of Object.entries(technologiesData.value)) {
      if (techData.effects && techData.effects.length > 0) {
        for (const effect of techData.effects) {
          if (effect.type === 'unlock-recipe' && effect.recipe === recipeName) {
            unlockTechnologies.push(techName)
            break
          }
        }
      }
    }
    return unlockTechnologies
  }

  /**
   * Get all recipes unlocked by a specific technology
   */
  function getUnlockedRecipes(technologyName) {
    if (!technologiesData.value || !technologyName) return []

    const techData = technologiesData.value[technologyName]
    if (!techData || !techData.effects) return []

    const unlockedRecipes = []
    for (const effect of techData.effects) {
      if (effect.type === 'unlock-recipe') {
        unlockedRecipes.push(effect.recipe)
      }
    }
    return unlockedRecipes
  }

  // These methods have been removed - use unified objects instead
  // All display names, icons, and data are now available through unified objects

  // getUsedInRecipes and getRecipeDisplayName removed - use unified objects instead

  // getObjectIcon removed - use unified objects for icon data

  /**
   * Pre-compute the entire category structure for all data types using unified objects
   */
  function precomputeCategoryStructure() {
    if (!groupsData.value || !recipesData.value || !itemsData.value) return {}

    const structure = {}
    const { createUnifiedObjectByKey, createTechnologyObject } = useUnifiedObjects()

    // Data sources for unified object creation
    const dataSources = {
      recipesData: recipesData.value,
      itemsData: itemsData.value,
      technologiesData: technologiesData.value,
      buildingsData: buildingsData.value,
      fluidsData: fluidsData.value,
      tilesData: tilesData.value
    }

    let allItems = []

    // Get all distinct keys from all data sources
    const allKeys = new Set([
      ...Object.keys(itemsData.value || {}),
      ...Object.keys(buildingsData.value || {}),
      ...Object.keys(fluidsData.value || {}),
      ...Object.keys(recipesData.value || {}),
      ...Object.keys(tilesData.value || {})
    ])

    // Process each key to get all possible unified objects
    allKeys.forEach(key => {
      const unifiedObjects = createUnifiedObjectByKey(key, dataSources)
      if (unifiedObjects && unifiedObjects.length > 0) {
        allItems.push(...unifiedObjects)
      }
    })

    // Filter out items that have a factoriopedia alternative
    allItems = allItems.filter(item => !item.factoriopedia_alternative)

    // Process technologies separately (they can't be merged by key)
    if (technologiesData.value) {
      Object.entries(technologiesData.value).forEach(([_techName, techData]) => {
        const unifiedObject = createTechnologyObject(techData, recipesData.value, itemsData.value)
        if (unifiedObject) {
          allItems.push(unifiedObject)
        }
      })
    }

    // Group items by subgroup
    const itemGroups = {}
    allItems.forEach(item => {
      const subgroup = item.subgroup || 'uncategorized'

      if (!itemGroups[subgroup]) {
        itemGroups[subgroup] = []
      }

      itemGroups[subgroup].push(item)
    })

    // Sort items within each subgroup
    Object.keys(itemGroups).forEach(subgroup => {
      itemGroups[subgroup].sort((a, b) => {
        if (a.order && b.order) {
          return a.order.localeCompare(b.order)
        } else if (a.order) {
          return -1
        } else if (b.order) {
          return 1
        } else {
          return a.displayName?.localeCompare(b.displayName)
        }
      })
    })

    // Create structure for each category
    const categories = Object.values(groupsData.value)
      .map(group => ({
        key: group.name,
        name: group.displayName,
        icon: group.icon?.replace('spritemap:', '') || null,
        order: group.order
      }))
      .sort((a, b) => {
        // Sort by order first, then by name
        const orderCompare = a.order.localeCompare(b.order)
        return orderCompare !== 0 ? orderCompare : a.name.localeCompare(b.name)
      })

    // Build category structure
    categories.forEach(category => {
      const group = groupsData.value[category.key]
      const subgroupOrder = {}
      group.subgroups.forEach(sub => {
        subgroupOrder[sub.name] = sub.order
      })

      // Get subgroups that have items
      const subgroups = group.subgroups
        .map(sub => ({
          name: sub.name,
          displayName: sub.displayName,
          order: sub.order,
          recipes: itemGroups[sub.name] || []
        }))
        .filter(sub => sub.recipes.length > 0)
        .sort((a, b) => {
          // Sort by order first, then by name
          const orderCompare = a.order.localeCompare(b.order)
          return orderCompare !== 0 ? orderCompare : a.name.localeCompare(b.name)
        })

      // Only add category if it has items
      if (subgroups.length > 0) {
        structure[category.key] = {
          key: category.key,
          name: category.name,
          icon: category.icon,
          order: category.order,
          subgroups
        }
      }
    })

    // Create "all" category - include all items
    const allSubgroups = Object.keys(itemGroups)
      .map(subgroupName => ({
        name: subgroupName,
        displayName: subgroupName,
        order: 'zzz', // Put at end
        recipes: itemGroups[subgroupName]
      }))
      .filter(sub => sub.recipes.length > 0)
      .sort((a, b) => a.name.localeCompare(b.name))

    structure['all'] = {
      key: 'all',
      name: 'All Items',
      icon: 'item-iron-plate', // Use a common item icon to represent "all"
      order: 'a',
      subgroups: allSubgroups
    }

    // Create special categories for synthetic groups
    const syntheticGroups = ['technologies', 'entities']

    syntheticGroups.forEach(groupName => {
      const groupItems = allItems.filter(item => item.group === groupName)
      if (groupItems.length > 0) {
        structure[groupName] = {
          key: groupName,
          name: groupName.charAt(0).toUpperCase() + groupName.slice(1),
          icon:
            groupName === 'technologies'
              ? 'technology-automation-science-pack'
              : 'entity-assembling-machine-1',
          order: 'zzz', // Put synthetic groups last
          subgroups: [
            {
              name: groupName,
              displayName: groupName.charAt(0).toUpperCase() + groupName.slice(1),
              order: 'a',
              recipes: groupItems
            }
          ]
        }
      }
    })
    //window.structure = structure
    return structure
  }

  /**
   * Get alternative recipes that produce a specific item
   */
  function getAlternativeRecipes(itemName) {
    if (!itemName || !recipesData.value) return []

    const recipes = []
    Object.values(recipesData.value).forEach(recipe => {
      if (recipe.results?.some(result => result.name === itemName)) {
        recipes.push(recipe)
      }
    })
    return recipes
  }

  /**
   * Create a unified object for selection based on type and name
   * This now uses the new unified approach that fetches all data by key
   */
  function createUnifiedSelectionObject(type, name, _data = null) {
    const { createUnifiedObjectByKey, createTechnologyObject } = useUnifiedObjects()

    // Handle technologies specially since they can't be merged by key
    if (type === 'technology') {
      const techData = technologiesData.value?.[name]
      if (techData) {
        return createTechnologyObject(techData, recipesData.value, itemsData.value)
      }
      return null
    }

    // Use the new unified approach - fetch all data by key for other types
    const dataSources = {
      recipesData: recipesData.value,
      itemsData: itemsData.value,
      technologiesData: technologiesData.value,
      buildingsData: buildingsData.value,
      fluidsData: fluidsData.value,
      tilesData: tilesData.value
    }

    const objects = createUnifiedObjectByKey(name, dataSources)
    return objects.find(object => object.types.includes(type))
  }

  return {
    // Data refs
    itemsData,
    recipesData,
    tooltipsData,
    groupsData,
    technologiesData,
    fluidsData,
    buildingsData,
    tilesData,

    // Loading state
    isLoading,
    loadingError,

    // Loading functions
    loadAllData,
    loadItemsData,
    loadRecipesData,
    loadTooltipsData,
    loadGroupsData,
    loadTechnologiesData,
    loadFluidsData,
    loadBuildingsData,
    loadTilesData,

    // Utility functions
    isDataLoaded,
    getItemData,
    getRecipeData,
    getTechnologyData,
    getFluidData,
    getBuildingData,
    getTileData,
    getGroupData,
    getTooltipData,
    findRecipesByResult,
    findRecipesByIngredient,
    getUnlockTechnologies,
    getUnlockedRecipes,
    precomputeCategoryStructure,
    getAlternativeRecipes,
    createUnifiedSelectionObject
  }
}

export function useFactorioData() {
  // Return singleton instance
  if (!factorioDataInstance) {
    factorioDataInstance = createFactorioDataInstance()
  }
  return factorioDataInstance
}
