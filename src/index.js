/**
 * Main entry point for SeaBlock JavaScript modules
 * Exports all composables and components for easy importing
 *
 * This file provides a centralized import point while avoiding
 * naming collisions by only exporting specific named exports.
 */

// Composables - only export the main composable functions
export { useFactorioData } from './composables/useFactorioData.js'
export { useRecipeDetails } from './composables/useRecipeDetails.js'
export { useItemDetails } from './composables/useItemDetails.js'
export { useItemProperties } from './composables/useItemProperties.js'
export { useBuildingStats } from './composables/useBuildingStats.js'
export { useEntityDetails } from './composables/useEntityDetails.js'
export { usePowerDetails } from './composables/usePowerDetails.js'
export { useRecipeCrafting } from './composables/useRecipeCrafting.js'
export { useUnifiedObjects } from './composables/useUnifiedObjects.js'

// Components - only export the main functions we need
export { createFactorioAnimationEngine } from './components/FactorioAnimationEngine.js'
export { loadSpritemapData } from './components/spriteCache.js'
