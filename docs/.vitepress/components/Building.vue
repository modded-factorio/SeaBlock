<template>
  <div
    class="building-card"
    :class="buildingClasses"
  >
    <div class="building-header">
      <div class="building-icon-container">
        <AnimatedSprite
          v-if="(showAnimatedSprite || variant === 'animated') && buildingData?.sprite"
          :sprite-data="buildingData.sprite"
          :size="iconSize"
          class="building-animated-sprite"
          :title="buildingData.displayName"
          :play-animation="true"
        />
        <SpriteIcon
          v-else-if="buildingData?.icon"
          :sprite-key="buildingData.icon.replace('spritemap:', '')"
          :size="iconSize"
          class="building-icon"
          :title="buildingData.displayName"
        />
        <div
          v-else
          class="building-icon-placeholder"
        >
          <span>?</span>
        </div>
      </div>
      <div class="building-info">
        <h3 class="building-name">
          {{ buildingData?.displayName || buildingId }}
        </h3>
        <p
          v-if="buildingData?.type"
          class="building-type"
        >
          {{ formatBuildingType(buildingData.type) }}
        </p>
      </div>
    </div>

    <div
      v-if="buildingData"
      class="building-stats"
    >
      <div
        v-if="buildingData.maxHealth"
        class="stat-item"
      >
        <span class="stat-label">Health:</span>
        <span class="stat-value">{{ buildingData.maxHealth }}</span>
      </div>

      <div
        v-if="buildingData.minable?.mining_time"
        class="stat-item"
      >
        <span class="stat-label">Mining time:</span>
        <span class="stat-value">{{ buildingData.minable.mining_time }}s</span>
      </div>

      <div
        v-if="buildingData.flags && buildingData.flags.length > 0"
        class="stat-item"
      >
        <span class="stat-label">Flags:</span>
        <span class="stat-value">{{ buildingData.flags.join(', ') }}</span>
      </div>
    </div>

    <div
      v-if="showTooltip"
      class="building-tooltip"
    >
      <Tooltip
        :item-id="buildingId"
        category="buildings"
      >
        <button class="tooltip-trigger-button">
          View Details
        </button>
      </Tooltip>
    </div>

    <div
      v-if="isLoading"
      class="building-loading"
    >
      <div class="loading-spinner" />
      <span>Loading...</span>
    </div>

    <div
      v-if="hasError"
      class="building-error"
    >
      <span>Failed to load building data</span>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { withBase } from 'vitepress'

import SpriteIcon from './SpriteIcon.vue'
import AnimatedSprite from './AnimatedSprite.vue'
import Tooltip from './Tooltip.vue'

// Props
const props = defineProps({
  buildingId: {
    type: String,
    required: true
  },
  iconSize: {
    type: [String, Number],
    default: 48
  },
  showTooltip: {
    type: Boolean,
    default: true
  },
  variant: {
    type: String,
    default: 'default', // 'default', 'compact', 'detailed', 'sprite-focused', 'animated'
    validator: value =>
      ['default', 'compact', 'detailed', 'sprite-focused', 'animated'].includes(value)
  },
  showAnimatedSprite: {
    type: Boolean,
    default: false
  }
})

// Reactive state
const buildingData = ref(null)
const isLoading = ref(true)
const hasError = ref(false)

// Computed properties
const buildingClasses = computed(() => ({
  [`building-${props.variant}`]: true,
  'building-loading': isLoading.value,
  'building-error': hasError.value
}))

// Global building cache
let buildingCache = null
let buildingCachePromise = null

// Load building data with caching
async function loadBuildingData() {
  if (buildingCache) {
    return buildingCache
  }

  if (buildingCachePromise) {
    return buildingCachePromise
  }

  buildingCachePromise = fetch(withBase('/data/en-buildings.json'))
    .then(response => {
      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`)
      }
      return response.json()
    })
    .then(data => {
      buildingCache = data
      return buildingCache
    })
    .catch(error => {
      console.error('Failed to load building data:', error)
      buildingCachePromise = null
      return null
    })

  return buildingCachePromise
}

// Format building type for display
function formatBuildingType(type) {
  return type
    .split('-')
    .map(word => word.charAt(0).toUpperCase() + word.slice(1))
    .join(' ')
}

// Load building data on mount
onMounted(async () => {
  try {
    isLoading.value = true
    hasError.value = false

    const allBuildings = await loadBuildingData()
    if (allBuildings && allBuildings[props.buildingId]) {
      buildingData.value = allBuildings[props.buildingId]
    } else {
      hasError.value = true
    }
  } catch (error) {
    console.error('Error loading building data:', error)
    hasError.value = true
  } finally {
    isLoading.value = false
  }
})
</script>

<style scoped>
.building-card {
  border: 1px solid var(--vp-c-border);
  border-radius: 8px;
  padding: 16px;
  background: var(--vp-c-bg);
  transition: all 0.2s ease;
  position: relative;
}

.building-card:hover {
  border-color: var(--vp-c-brand-1);
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

.building-header {
  display: flex;
  align-items: center;
  gap: 12px;
  margin-bottom: 12px;
}

.building-icon-container {
  flex-shrink: 0;
  display: flex;
  align-items: center;
  justify-content: center;
  background: var(--vp-c-bg-soft);
  border: 2px solid var(--vp-c-border);
  border-radius: 8px;
  padding: 8px;
  transition: all 0.2s ease;
}

.building-icon-container:hover {
  border-color: var(--vp-c-brand-1);
  background: var(--vp-c-bg);
  transform: scale(1.05);
}

.building-icon {
  display: block;
}

.building-animated-sprite {
  display: block;
}

.building-icon-placeholder {
  width: 48px;
  height: 48px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: var(--vp-c-bg-soft);
  border: 2px dashed var(--vp-c-border);
  border-radius: 8px;
  color: var(--vp-c-text-3);
  font-size: 24px;
  font-weight: bold;
}

.building-info {
  flex: 1;
  min-width: 0;
}

.building-name {
  margin: 0 0 4px 0;
  font-size: 16px;
  font-weight: 600;
  color: var(--vp-c-text-1);
  line-height: 1.2;
}

.building-type {
  margin: 0;
  font-size: 12px;
  color: var(--vp-c-text-3);
  text-transform: uppercase;
  letter-spacing: 0.5px;
}

.building-stats {
  display: flex;
  flex-direction: column;
  gap: 6px;
  margin-bottom: 12px;
}

.stat-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  font-size: 13px;
}

.stat-label {
  color: var(--vp-c-text-2);
  font-weight: 500;
}

.stat-value {
  color: var(--vp-c-text-1);
  font-weight: 600;
}

.building-tooltip {
  display: flex;
  justify-content: center;
}

.tooltip-trigger-button {
  background: var(--vp-c-brand-1);
  color: white;
  border: none;
  padding: 6px 12px;
  border-radius: 4px;
  font-size: 12px;
  font-weight: 500;
  cursor: pointer;
  transition: background-color 0.2s ease;
}

.tooltip-trigger-button:hover {
  background: var(--vp-c-brand-2);
}

.building-loading {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
  padding: 20px;
  color: var(--vp-c-text-3);
  font-size: 14px;
}

.loading-spinner {
  width: 16px;
  height: 16px;
  border: 2px solid var(--vp-c-border);
  border-top: 2px solid var(--vp-c-brand-1);
  border-radius: 50%;
  animation: spin 1s linear infinite;
}

.building-error {
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 20px;
  color: var(--vp-c-danger-1);
  font-size: 14px;
  background: var(--vp-c-danger-soft);
  border-radius: 4px;
}

/* Variants */
.building-compact {
  padding: 12px;
}

.building-compact .building-header {
  margin-bottom: 8px;
}

.building-compact .building-name {
  font-size: 14px;
}

.building-compact .building-stats {
  margin-bottom: 8px;
}

.building-compact .stat-item {
  font-size: 12px;
}

.building-detailed {
  padding: 20px;
}

.building-detailed .building-name {
  font-size: 18px;
}

.building-detailed .building-stats {
  gap: 8px;
}

.building-detailed .stat-item {
  font-size: 14px;
  padding: 4px 0;
}

.building-sprite-focused {
  text-align: center;
  padding: 20px;
}

.building-sprite-focused .building-header {
  flex-direction: column;
  gap: 16px;
  margin-bottom: 16px;
}

.building-sprite-focused .building-icon-container {
  margin: 0 auto;
  padding: 16px;
  border-width: 3px;
}

.building-sprite-focused .building-icon {
  transform: scale(1.2);
}

.building-sprite-focused .building-name {
  font-size: 18px;
  margin-bottom: 8px;
}

.building-sprite-focused .building-type {
  font-size: 14px;
  margin-bottom: 0;
}

.building-animated {
  text-align: center;
  padding: 24px;
}

.building-animated .building-header {
  flex-direction: column;
  gap: 20px;
  margin-bottom: 20px;
}

.building-animated .building-icon-container {
  margin: 0 auto;
  padding: 20px;
  border-width: 3px;
  background: var(--vp-c-bg);
}

.building-animated .building-animated-sprite {
  transform: scale(1.5);
}

.building-animated .building-name {
  font-size: 20px;
  margin-bottom: 8px;
}

.building-animated .building-type {
  font-size: 16px;
  margin-bottom: 0;
}

/* Dark mode adjustments */
.dark .building-card {
  background: var(--vp-c-bg-soft);
}

.dark .building-card:hover {
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.3);
}

@keyframes spin {
  0% {
    transform: rotate(0deg);
  }
  100% {
    transform: rotate(360deg);
  }
}
</style>
