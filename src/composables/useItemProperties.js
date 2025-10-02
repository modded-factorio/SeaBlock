import { computed } from 'vue'
import { useFactorioData } from './useFactorioData.js'

export function useItemProperties(selectedItem) {
  const { getItemData } = useFactorioData()

  const itemProperties = computed(() => {
    if (!selectedItem.value || !selectedItem.value.name) {
      return {}
    }

    const itemData = getItemData(selectedItem.value.name)
    if (!itemData) {
      return {}
    }

    return {
      // Item-specific properties
      stack_size: itemData.stack_size,
      description: itemData.description,
      rocket_launch_products: itemData.rocket_launch_products,
      durability: itemData.durability,
      magazine_size: itemData.magazine_size,
      range_modifier: itemData.range_modifier,
      min_temperature: itemData.min_temperature,
      max_temperature: itemData.max_temperature,
      heat_capacity: itemData.heat_capacity,
      speed: itemData.speed,
      healing: itemData.healing,
      // Mining properties
      mining_speed: itemData.mining_speed,
      mining_area: itemData.mining_area,
      // Pumping properties
      pumping_speed: itemData.pumping_speed,
      // Rocket properties
      rocket_capacity: itemData.rocket_capacity,
      // Repair properties
      repair_speed: itemData.repair_speed,
      // Storage properties
      storage_volume: itemData.storage_volume,
      // Rotation properties
      rotation_speed: itemData.rotation_speed,
      // Filter properties
      can_filter_items: itemData.can_filter_items,
      // Wire properties
      wire_reach: itemData.wire_reach,
      // Supply properties
      supply_area: itemData.supply_area,
      // Range properties
      minimum_range: itemData.minimum_range,
      range: itemData.range,
      shooting_speed: itemData.shooting_speed,
      // Inventory properties
      inventory_size_bonus: itemData.inventory_size_bonus,
      movement_bonus: itemData.movement_bonus,
      // Construction properties
      construction_area: itemData.construction_area,
      robot_limit: itemData.robot_limit,
      // Shield properties
      shield_hitpoints: itemData.shield_hitpoints,
      recharge_speed: itemData.recharge_speed,
      // Coverage properties
      continuous_coverage_distance: itemData.continuous_coverage_distance,
      exploration_coverage_distance: itemData.exploration_coverage_distance
    }
  })

  return {
    itemProperties
  }
}
