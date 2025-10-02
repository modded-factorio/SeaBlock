import { computed } from 'vue'

import { useFactorioData } from './useFactorioData'

export function useRecipeDetails(selectedItem, recipesData, buildingsData) {
  const { getUnlockTechnologies, getItemData, getTechnologyData } = useFactorioData()

  // Cache used-in-recipes calls - now using unified object data
  const usedInRecipes = computed(() => {
    if (!selectedItem.value?.usageRecipes) {
      return []
    }
    return selectedItem.value.usageRecipes.map(recipeName => ({
      name: recipeName,
      displayName: recipeName, // Will be resolved by unified object
      type: 'recipe'
    }))
  })

  // Cache unlock technologies calls - now using unified object data
  const unlockTechnologies = computed(() => {
    return getUnlockTechnologies(selectedItem.value.name)
  })

  // Cache made in buildings calls
  const madeInBuildings = computed(() => {
    if (!buildingsData.value) {
      return []
    }

    // Use the recipe category, or default to "crafting" if not specified
    const recipeCategory = selectedItem.value?.recipe?.category || 'crafting'
    const compatibleBuildings = []

    // Find all buildings that can craft this recipe category
    for (const [buildingName, buildingData] of Object.entries(buildingsData.value)) {
      if (
        buildingData.crafting_categories &&
        buildingData.crafting_categories.includes(recipeCategory)
      ) {
        compatibleBuildings.push({
          name: buildingName,
          displayName: buildingData.displayName || buildingName
        })
      }
    }

    return compatibleBuildings
  })

  // Helper functions for technology display
  const getTechnologyLevel = techName => {
    try {
      const techData = getTechnologyData(techName)
      return techData?.level || 1
    } catch (error) {
      console.warn('Failed to get technology level:', error)
      return 1
    }
  }

  const getTechnologySciencePacks = techName => {
    try {
      const techData = getTechnologyData(techName)
      if (!techData?.unit?.ingredients) return []

      return techData.unit.ingredients.map(ingredient => {
        // Handle both object format {name: string, amount: number} and array format [name, amount]
        let ingredientName
        if (Array.isArray(ingredient)) {
          ingredientName = ingredient[0]
        } else if (ingredient.name) {
          ingredientName = ingredient.name
        } else {
          console.warn('Ingredient format not recognized:', ingredient)
          return {
            name: 'unknown',
            displayName: 'Unknown'
          }
        }

        if (!ingredientName) {
          console.warn('Ingredient name is missing:', ingredient)
          return {
            name: 'unknown',
            displayName: 'Unknown'
          }
        }

        try {
          // Try to get as item first
          const itemData = getItemData(ingredientName)
          return {
            name: ingredientName,
            displayName: itemData?.displayName || ingredientName
          }
        } catch (itemError) {
          // If not found as item, try as recipe
          try {
            const { getRecipeData } = useFactorioData()
            const recipeData = getRecipeData(ingredientName)
            return {
              name: ingredientName,
              displayName: recipeData?.displayName || ingredientName
            }
          } catch (recipeError) {
            console.warn(
              `Failed to get data for ingredient '${ingredientName}' as both item and recipe:`,
              itemError,
              recipeError
            )
            return {
              name: ingredientName,
              displayName: ingredientName
            }
          }
        }
      })
    } catch (error) {
      console.warn('Failed to get technology science packs:', error)
      return []
    }
  }

  return {
    usedInRecipes,
    unlockTechnologies,
    madeInBuildings,
    getTechnologyLevel,
    getTechnologySciencePacks
  }
}
