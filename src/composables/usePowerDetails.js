import { computed } from 'vue'
import { useFactorioData } from './useFactorioData.js'

export function usePowerDetails(selectedItem, isEntity) {
  const { getBuildingData } = useFactorioData()

  // Power generation properties
  const hasPowerGeneration = computed(() => {
    // Check if this is a solar panel or other power generating item
    const name = selectedItem.value?.name?.toLowerCase() || ''
    return name.includes('solar') || name.includes('steam-engine') || name.includes('nuclear')
  })

  const powerOutput = computed(() => {
    if (!hasPowerGeneration.value) return null

    const name = selectedItem.value?.name?.toLowerCase() || ''
    if (name.includes('solar')) return '60.0'
    if (name.includes('steam-engine')) return '510.0'
    if (name.includes('nuclear')) return '1000.0'
    return null
  })

  // Electricity consumption properties
  const hasElectricityConsumption = computed(() => {
    if (!selectedItem.value?.name || !isEntity.value) {
      return false
    }

    const buildingData = getBuildingData(selectedItem.value.name)
    return buildingData?.energy_usage && buildingData.energy_usage !== '0kW'
  })

  return {
    hasPowerGeneration,
    powerOutput,
    hasElectricityConsumption
  }
}
