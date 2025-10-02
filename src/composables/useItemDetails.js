import { computed } from 'vue'
import { useFactorioData } from './useFactorioData.js'

export function useItemDetails(selectedItem) {
  const { getItemData } = useFactorioData()

  // Computed properties to cache repeated getItemData calls
  const primaryResultItem = computed(() => {
    if (!selectedItem.value?.results?.[0]?.name) {
      return null
    }
    try {
      return getItemData(selectedItem.value.results[0].name)
    } catch (error) {
      console.warn('Failed to get item data:', error)
      return null
    }
  })

  const primaryResultStackSize = computed(() => {
    return primaryResultItem.value?.stack_size
  })

  const primaryResultTooltipDetails = computed(() => {
    return primaryResultItem.value?.tooltip?.details
  })

  return {
    primaryResultItem,
    primaryResultStackSize,
    primaryResultTooltipDetails
  }
}
