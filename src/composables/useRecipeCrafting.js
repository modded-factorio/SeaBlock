import { computed } from 'vue'
import { useFactorioData } from './useFactorioData.js'

export function useRecipeCrafting(selectedItem, recipesData, isEntity) {
  const { getBuildingData } = useFactorioData()

  // Cache can craft recipes calls
  const canCraftRecipes = computed(() => {
    if (!selectedItem.value?.name || !recipesData.value || !isEntity.value) {
      return []
    }

    // Get the building data to access crafting_categories
    const buildingData = getBuildingData(selectedItem.value.name)
    if (!buildingData?.crafting_categories) {
      return []
    }

    // Get all crafting categories this building can handle
    const craftingCategories = buildingData.crafting_categories

    // Find all recipes that can be crafted in any of these categories
    const craftableRecipes = []
    for (const [recipeName, recipeData] of Object.entries(recipesData.value)) {
      if (craftingCategories.includes(recipeData.category)) {
        craftableRecipes.push({
          name: recipeName,
          displayName: recipeData.displayName
        })
      }
    }

    return craftableRecipes
  })

  return {
    canCraftRecipes
  }
}
