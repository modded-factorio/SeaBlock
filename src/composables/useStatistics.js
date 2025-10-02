import { computed } from 'vue'

// Stub functions to derive properties from selectedItem
function getPrimaryResultStackSize(selectedItem) {
  // TODO: Implement logic to derive primary result stack size
  return null
}

function getEntityPollution(selectedItem) {
  // TODO: Implement logic to derive entity pollution
  return null
}

function getEntityAllowedEffects(selectedItem) {
  // TODO: Implement logic to derive entity allowed effects
  return null
}

function getPrimaryResultTooltipDetails(selectedItem) {
  // TODO: Implement logic to derive primary result tooltip details
  return null
}

export function useStatistics(selectedItem) {
  const statisticsData = computed(() => {
    return generateStatistics(selectedItem.value)
  })

  return {
    statisticsData
  }
}

export function generateStatistics(selectedItem) {
  if (!selectedItem) return []

  const stats = []

  // Derive properties from selectedItem
  // eslint-disable-next-line unused-imports/no-unused-vars
  const { entity, item, tile, recipe, fluid, technology } = selectedItem
  const primaryResultStackSize = getPrimaryResultStackSize(selectedItem) || {}
  const entityPollution = getEntityPollution(selectedItem) | {}
  const entityAllowedEffects = getEntityAllowedEffects(selectedItem) || {}
  const primaryResultTooltipDetails = getPrimaryResultTooltipDetails(selectedItem) || {}

  // Helper function to test value and call function if truthy
  const addStat = (value, statFunction) => {
    if (value) {
      const result = statFunction(value, selectedItem)
      if (result) {
        stats.push(result)
      }
    }
  }
  // Basic properties
  addStat(primaryResultStackSize, value => ({
    label: 'Stack size',
    value
  }))

  addStat(selectedItem.energyRequired, value => ({
    label: 'Crafting time',
    value: `${value}s`,
    icon: 'utility-time'
  }))

  addStat(entity?.crafting_speed, value => ({
    label: 'Crafting speed',
    value,
    icon: 'utility-speed'
  }))

  addStat(item?.item?.stack_size, value => ({
    label: 'Stack size',
    value,
    icon: 'utility-stack'
  }))

  addStat(entity?.max_health, value => ({
    label: 'Base health',
    value,
    icon: 'utility-heart'
  }))

  addStat(entityPollution, value => ({
    label: 'Pollution',
    value: `${value}/m`,
    icon: 'utility-fire'
  }))

  addStat(entity?.module_slots, value => ({
    label: 'Module slots',
    value,
    icon: 'utility-module'
  }))

  addStat(entityAllowedEffects, value => ({
    label: 'Allowed effects',
    value: value.join ? value.join(', ') : ''
  }))

  addStat(entity?.distribution_effectivity, value => ({
    label: 'Distribution efficiency',
    value,
    icon: 'utility-beacon'
  }))

  addStat(entity?.max_distance_of_nearby_sector_revealed, value => ({
    label: 'Exploration coverage distance',
    value,
    icon: 'utility-radar'
  }))

  addStat(entity?.max_distance_of_sector_revealed, value => ({
    label: 'Exploration coverage distance',
    value,
    icon: 'utility-radar'
  }))

  addStat(entity?.storage_size, value => ({
    label: 'Storage size',
    value,
    icon: 'utility-storage'
  }))

  addStat(entity?.cargo_hatch_count, value => ({
    label: 'Cargo hatch count',
    value,
    icon: 'utility-cargo'
  }))

  // Resistances with children
  addStat(entity?.resistances, value => ({
    label: 'Resistances',
    children: value.map(resistance => ({
      label: resistance.type,
      value: `${resistance.percent}%`
    }))
  }))

  // Mining properties
  addStat(item?.item?.mining_speed, value => ({
    label: 'Mining speed',
    value,
    icon: 'utility-mining'
  }))

  addStat(item?.item?.mining_area, value => ({
    label: 'Mining area',
    value
  }))

  // Pumping properties
  addStat(item?.item?.pumping_speed, value => ({
    label: 'Pumping speed',
    value,
    icon: 'utility-pump'
  }))

  // Rocket properties
  addStat(item?.item?.rocket_capacity, value => ({
    label: 'Rocket capacity',
    value,
    icon: 'utility-rocket'
  }))

  // Repair properties
  addStat(item?.item?.repair_speed, value => ({
    label: 'Repair speed',
    value,
    icon: 'utility-repair'
  }))

  addStat(item?.item?.durability, value => ({
    label: 'Durability',
    value
  }))

  // Storage properties
  addStat(item?.item?.storage_volume, value => ({
    label: 'Storage volume',
    value,
    icon: 'utility-storage'
  }))

  // Rotation properties
  addStat(item?.item?.rotation_speed, value => ({
    label: 'Rotation speed',
    value,
    icon: 'utility-rotation'
  }))

  addStat(
    item?.item?.can_filter_items !== undefined ? item.value.can_filter_items : null,
    value => ({
      label: 'Can filter items',
      value: value ? 'Yes' : 'No'
    })
  )

  // Wire properties
  addStat(item?.item?.wire_reach, value => ({
    label: 'Wire reach',
    value,
    icon: 'utility-wire'
  }))

  addStat(item?.item?.supply_area, value => ({
    label: 'Supply area',
    value
  }))

  // Range properties
  addStat(item?.item?.minimum_range, value => ({
    label: 'Minimum range',
    value,
    icon: 'utility-range'
  }))

  addStat(item?.item?.range, value => ({
    label: 'Range',
    value
  }))

  addStat(item?.item?.shooting_speed, value => ({
    label: 'Shooting speed',
    value
  }))

  // Equipment properties (shortcuts)
  addStat(
    item?.item?.inventory_size_bonus || selectedItem?.equipment?.inventory_size_bonus,
    value => ({
      label: 'Inventory size bonus',
      value
    })
  )

  addStat(item?.item?.movement_bonus || selectedItem?.equipment?.movement_bonus, value => ({
    label: 'Movement bonus',
    value
  }))

  // Construction properties
  addStat(item?.item?.construction_area, value => ({
    label: 'Construction area',
    value
  }))

  addStat(item?.item?.robot_limit, value => ({
    label: 'Robot limit',
    value
  }))

  // Shield properties (shortcuts)
  addStat(item?.item?.shield_hitpoints || selectedItem?.equipment?.shield_hitpoints, value => ({
    label: 'Shield hitpoints',
    value,
    icon: 'utility-shield'
  }))

  addStat(item?.item?.recharge_speed || selectedItem?.equipment?.recharge_speed, value => ({
    label: 'Recharge speed',
    value
  }))

  // Coverage properties
  addStat(item?.item?.continuous_coverage_distance, value => ({
    label: 'Continuous coverage distance',
    value
  }))

  addStat(item?.item?.exploration_coverage_distance, value => ({
    label: 'Exploration coverage distance',
    value
  }))

  // Magazine properties
  addStat(item?.item?.magazine_size, value => ({
    label: 'Magazine size',
    value
  }))

  addStat(item?.item?.range_modifier, value => ({
    label: 'Range modifier',
    value
  }))

  // Temperature properties (shortcuts)
  addStat(item?.item?.min_temperature || selectedItem?.fluid?.min_temperature, value => ({
    label: 'Min temperature',
    value: `${value}°C`
  }))

  addStat(item?.item?.max_temperature || selectedItem?.fluid?.max_temperature, value => ({
    label: 'Max temperature',
    value: `${value}°C`
  }))

  addStat(selectedItem?.fluid?.default_temperature, value => ({
    label: 'Default temperature',
    value: `${value}°C`
  }))

  addStat(item?.item?.heat_capacity, value => ({
    label: 'Heat capacity',
    value
  }))

  // Speed and healing
  addStat(item?.item?.speed, value => ({
    label: 'Speed',
    value
  }))

  addStat(item?.item?.healing, value => ({
    label: 'Healing',
    value
  }))

  // Tooltip details
  addStat(primaryResultTooltipDetails.value, value => ({
    label: 'Details',
    children: value.map(detail => ({
      label: detail,
      value: ''
    }))
  }))

  return stats
}
