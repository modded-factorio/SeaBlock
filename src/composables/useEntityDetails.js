import { computed } from 'vue'

export function useEntityDetails(selectedItem) {
  // Entity detection
  const isEntity = computed(() => {
    if (!selectedItem.value?.types) {
      return false
    }

    // Check if it's ONLY non-entity types (fewer non-entities to check)
    const nonEntityTypes = ['item', 'fluid', 'recipe', 'technology', 'tile']
    const hasOnlyNonEntityTypes = selectedItem.value.types.every(type =>
      nonEntityTypes.includes(type)
    )
    return !hasOnlyNonEntityTypes
  })

  const itemTypeLabel = computed(() => {
    if (!selectedItem.value?.types) {
      return 'Unknown'
    }

    const { types } = selectedItem.value
    const displayTypes = []

    // Priority order for display - check each type in order
    if (types.includes('recipe')) displayTypes.push('Recipe')
    if (types.includes('item')) displayTypes.push('Item')
    if (types.includes('entity')) displayTypes.push('Entity')
    if (types.includes('tile')) displayTypes.push('Tile')
    if (types.includes('fluid')) displayTypes.push('Fluid')
    if (types.includes('technology')) displayTypes.push('Technology')

    // If it's an entity (not in the non-entity list) and not already added
    const nonEntityTypes = ['item', 'fluid', 'recipe', 'technology', 'tile']
    const hasOnlyNonEntityTypes = types.every(type => nonEntityTypes.includes(type))
    if (!hasOnlyNonEntityTypes && !displayTypes.includes('Entity')) {
      displayTypes.push('Entity')
    }

    // If no types found, add any remaining types
    if (displayTypes.length === 0) {
      types.forEach(type => {
        const capitalized = type.charAt(0).toUpperCase() + type.slice(1)
        if (!displayTypes.includes(capitalized)) {
          displayTypes.push(capitalized)
        }
      })
    }

    // Return joined types or 'Unknown'
    return displayTypes.length > 0 ? displayTypes.join('/') : 'Unknown'
  })

  const entitySpriteData = computed(() => {
    if (!isEntity.value || !selectedItem.value) {
      return null
    }

    console.log('selectedItem.value', selectedItem.value)

    // Try to get sprite data from entity data
    if (selectedItem.value.entity) {
      return selectedItem.value.entity
    }

    return null
  })

  return {
    isEntity,
    itemTypeLabel,
    entitySpriteData
  }
}
