import { computed } from 'vue'

import { useFactorioData } from './useFactorioData.js'

export function useBuildingStats(selectedItem, isEntity) {
  const { getBuildingData } = useFactorioData()

  // Building statistics
  const buildingStats = computed(() => {
    if (!selectedItem.value?.name || !isEntity.value) {
      return {}
    }

    // Get the building data to access real stats
    const buildingData = getBuildingData(selectedItem.value.name)
    if (!buildingData) {
      return {}
    }

    const {
      crafting_speed,
      max_health,
      energy_source,
      module_slots,
      resistances,
      energy_usage,
      allowed_effects
    } = buildingData

    // Parse energy usage string with Factorio energy mechanics
    // Min consumption is 3.33% (1/30th) of the energy usage
    // Max consumption is energy usage + min consumption
    let parsedEnergyUsage = null
    if (energy_usage && typeof energy_usage === 'string') {
      const match = energy_usage.match(/(\d+(?:\.\d+)?)/)
      if (match) {
        const baseConsumption = parseFloat(match[1])
        const minConsumption = baseConsumption / 30 // 3.33% of energy usage
        const maxConsumption = baseConsumption + minConsumption

        parsedEnergyUsage = {
          min: minConsumption,
          max: maxConsumption
        }
      }
    }

    return {
      craftingSpeed: crafting_speed,
      baseHealth: max_health,
      pollution: energy_source?.emissions_per_minute?.pollution,
      moduleSlots: module_slots,
      resistances,
      energyUsage: parsedEnergyUsage,
      allowedEffects: allowed_effects,
      // Building/Entity-specific properties
      distributionEfficiency: buildingData.distribution_efficiency,
      radarCoverageDistance: buildingData.radar_coverage_distance,
      storageSize: buildingData.storage_size,
      cargoHatchCount: buildingData.cargo_hatch_count
    }
  })

  return {
    buildingStats
  }
}
