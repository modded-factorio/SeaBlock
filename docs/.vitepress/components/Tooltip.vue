<template>
  <ClientOnly>
    <span
      class="tooltip-trigger"
      tabindex="0"
      role="button"
      :aria-describedby="tooltipId"
      @mouseenter="showTooltip"
      @mouseleave="hideTooltip"
      @click="togglePin"
      @focus="showTooltip"
      @blur="hideTooltip"
    >
      <slot />
      <Teleport to="body">
        <div
          v-if="isVisible"
          :id="tooltipId"
          class="tooltip"
          :class="tooltipClasses"
          :style="tooltipStyle"
          role="tooltip"
          :aria-hidden="!isVisible"
          :data-debug="`visible: ${isVisible}, data: ${!!tooltipData}`"
        >
          <div class="tooltip-content">
            <div v-if="isLoading" class="tooltip-loading">Loading...</div>
            <template v-else>
              <div class="tooltip-header">
                <SpriteIcon
                  v-if="tooltipData?.icon"
                  :sprite-key="tooltipData.icon.replace('spritemap:', '')"
                  :size="36"
                  class="tooltip-icon"
                />
                <div
                  v-if="tooltipData?.title"
                  class="tooltip-title"
                  :class="{ 'tooltip-error': hasError }"
                >
                  {{ tooltipData.title }}
                </div>
                <button
                  class="tooltip-pin-button"
                  :title="isPinned ? 'Unpin tooltip' : 'Pin tooltip'"
                  :aria-label="isPinned ? 'Unpin tooltip' : 'Pin tooltip'"
                  @click.stop="togglePin"
                >
                  <svg
                    v-if="isPinned"
                    width="12"
                    height="12"
                    viewBox="0 0 24 24"
                    fill="currentColor"
                  >
                    <path d="M16,12V4H17V2H7V4H8V12L6,14V16H11.2V22H12.8V16H18V14L16,12Z" />
                  </svg>
                  <svg v-else width="12" height="12" viewBox="0 0 24 24" fill="currentColor">
                    <path
                      d="M16,12V4H17V2H7V4H8V12L6,14V16H11.2V22H12.8V16H18V14L16,12Z"
                      opacity="0.5"
                    />
                  </svg>
                </button>
              </div>
              <div
                v-if="tooltipData?.description"
                class="tooltip-description"
                :class="{ 'tooltip-error': hasError }"
              >
                {{ tooltipData.description }}
              </div>
              <div v-if="tooltipData?.details?.length" class="tooltip-details">
                <div
                  v-for="(detail, index) in tooltipData.details"
                  :key="index"
                  class="tooltip-detail"
                >
                  {{ detail }}
                </div>
              </div>
            </template>
          </div>
          <div class="tooltip-arrow" />
        </div>
      </Teleport>
    </span>
    <template #fallback>
      <slot />
    </template>
  </ClientOnly>
</template>

<script setup>
import { ref, computed, onMounted, onUnmounted, nextTick } from 'vue'
import { withBase } from 'vitepress'

import SpriteIcon from './SpriteIcon.vue'

// Props
const props = defineProps({
  itemId: {
    type: String,
    required: true
  },
  category: {
    type: String,
    default: 'items', // 'items', 'recipes', 'fluids', 'buildings', etc.
    validator: value =>
      ['items', 'recipes', 'fluids', 'buildings', 'technologies', 'tiles'].includes(value)
  },
  position: {
    type: String,
    default: 'top',
    validator: value => ['top', 'bottom', 'left', 'right'].includes(value)
  },
  delay: {
    type: Number,
    default: 300
  }
})

// Reactive state
const isVisible = ref(false)
const isPinned = ref(false)
const tooltipData = ref(null)
const tooltipStyle = ref({})
const showTimeout = ref(null)
const hideTimeout = ref(null)
const isLoading = ref(false)
const hasError = ref(false)

// Generate unique tooltip ID
const tooltipId = computed(
  () => `tooltip-${props.itemId}-${Math.random().toString(36).substr(2, 9)}`
)

// Tooltip classes
const tooltipClasses = computed(() => ({
  [`tooltip-${props.position}`]: true,
  'tooltip-visible': isVisible.value,
  'tooltip-pinned': isPinned.value
}))

// Global tooltip cache
let tooltipCache = null
let tooltipCachePromise = null

// Load tooltip data with caching
async function loadTooltipData() {
  if (tooltipCache) {
    return tooltipCache
  }

  if (tooltipCachePromise) {
    return tooltipCachePromise
  }

  tooltipCachePromise = fetch(withBase('/data/en-tooltips.json'))
    .then(response => {
      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`)
      }
      return response.json()
    })
    .then(data => {
      tooltipCache = data
      return tooltipCache
    })
    .catch(error => {
      console.error('Failed to load tooltip data:', error)
      tooltipCachePromise = null
      return null
    })

  return tooltipCachePromise
}

// Get tooltip data for specific item
async function getTooltipData() {
  const data = await loadTooltipData()
  if (!data || !data[props.category]) {
    return null
  }
  return data[props.category][props.itemId] || null
}

// Position tooltip relative to trigger element
function positionTooltip() {
  nextTick(() => {
    const trigger = document.querySelector(`[aria-describedby="${tooltipId.value}"]`)
    const tooltip = document.getElementById(tooltipId.value)

    console.log('Positioning tooltip:', { trigger, tooltip, tooltipId: tooltipId.value })

    if (!trigger || !tooltip) {
      console.log('Missing trigger or tooltip element')
      return
    }

    const triggerRect = trigger.getBoundingClientRect()
    const tooltipRect = tooltip.getBoundingClientRect()
    const viewport = {
      width: window.innerWidth,
      height: window.innerHeight
    }

    let top = 0
    let left = 0

    switch (props.position) {
      case 'top':
        top = triggerRect.top - tooltipRect.height - 8
        left = triggerRect.left + (triggerRect.width - tooltipRect.width) / 2
        break
      case 'bottom':
        top = triggerRect.bottom + 8
        left = triggerRect.left + (triggerRect.width - tooltipRect.width) / 2
        break
      case 'left':
        top = triggerRect.top + (triggerRect.height - tooltipRect.height) / 2
        left = triggerRect.left - tooltipRect.width - 8
        break
      case 'right':
        top = triggerRect.top + (triggerRect.height - tooltipRect.height) / 2
        left = triggerRect.right + 8
        break
    }

    // Keep tooltip within viewport
    if (left < 8) left = 8
    if (left + tooltipRect.width > viewport.width - 8) {
      left = viewport.width - tooltipRect.width - 8
    }
    if (top < 8) top = 8
    if (top + tooltipRect.height > viewport.height - 8) {
      top = viewport.height - tooltipRect.height - 8
    }

    tooltipStyle.value = {
      position: 'fixed',
      top: `${top}px`,
      left: `${left}px`,
      zIndex: 9999
    }
  })
}

// Toggle pin state
function togglePin() {
  isPinned.value = !isPinned.value
  if (isPinned.value) {
    // Clear any hide timeout when pinning
    if (hideTimeout.value) {
      clearTimeout(hideTimeout.value)
      hideTimeout.value = null
    }
  }
}

// Show tooltip
async function showTooltip() {
  console.log('showTooltip called for', props.itemId, props.category)
  if (showTimeout.value) {
    clearTimeout(showTimeout.value)
  }
  if (hideTimeout.value) {
    clearTimeout(hideTimeout.value)
    hideTimeout.value = null
  }

  showTimeout.value = setTimeout(async () => {
    console.log('Loading tooltip data for', props.itemId, props.category)
    isLoading.value = true
    hasError.value = false

    try {
      const data = await getTooltipData()
      console.log('Tooltip data loaded:', data)

      if (data) {
        tooltipData.value = data
        isVisible.value = true
        console.log('Setting tooltip visible, positioning...')
        positionTooltip()
      } else {
        // Show fallback message when no data is found
        tooltipData.value = {
          title: props.itemId,
          description: `No tooltip data available for ${props.category}`,
          details: []
        }
        isVisible.value = true
        console.log('No tooltip data found, showing fallback')
        positionTooltip()
      }
    } catch (error) {
      console.error('Error loading tooltip data:', error)
      hasError.value = true
      tooltipData.value = {
        title: 'Error',
        description: 'Failed to load tooltip data',
        details: []
      }
      isVisible.value = true
      positionTooltip()
    } finally {
      isLoading.value = false
    }
  }, props.delay)
}

// Hide tooltip
function hideTooltip() {
  if (showTimeout.value) {
    clearTimeout(showTimeout.value)
    showTimeout.value = null
  }
  if (hideTimeout.value) {
    clearTimeout(hideTimeout.value)
  }

  // Don't hide if pinned
  if (isPinned.value) {
    return
  }

  hideTimeout.value = setTimeout(() => {
    isVisible.value = false
    tooltipData.value = null
    isLoading.value = false
    hasError.value = false
    isPinned.value = false // Reset pin state when hiding
  }, 100)
}

// Handle window resize
function handleResize() {
  if (isVisible.value) {
    positionTooltip()
  }
}

// Handle escape key
function handleKeydown(event) {
  if (event.key === 'Escape' && isVisible.value) {
    hideTooltip()
  }
}

// Lifecycle
onMounted(() => {
  window.addEventListener('resize', handleResize)
  document.addEventListener('keydown', handleKeydown)
})

onUnmounted(() => {
  if (showTimeout.value) {
    clearTimeout(showTimeout.value)
  }
  if (hideTimeout.value) {
    clearTimeout(hideTimeout.value)
  }
  window.removeEventListener('resize', handleResize)
  document.removeEventListener('keydown', handleKeydown)
})
</script>

<style scoped>
.tooltip-trigger {
  display: inline;
  cursor: help;
  border-bottom: 1px dotted currentColor;
  text-decoration: none;
}

.tooltip-trigger:focus {
  outline: 2px solid var(--vp-c-brand-1);
  outline-offset: 2px;
  border-radius: 2px;
}

.tooltip {
  position: fixed;
  background: var(--vp-c-bg-soft);
  border: 1px solid var(--vp-c-border);
  border-radius: 6px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
  max-width: 300px;
  z-index: 9999;
  opacity: 0;
  transform: translateY(-4px);
  transition:
    opacity 0.2s ease,
    transform 0.2s ease;
  pointer-events: none;
}

.tooltip-visible {
  opacity: 1;
  transform: translateY(0);
}

.tooltip-pinned {
  border-color: var(--vp-c-brand-1);
  box-shadow:
    0 4px 12px rgba(0, 0, 0, 0.15),
    0 0 0 1px var(--vp-c-brand-1);
}

.tooltip-pinned .tooltip-pin-button {
  color: var(--vp-c-brand-1);
}

.tooltip-content {
  padding: 8px 12px;
}

.tooltip-header {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-bottom: 4px;
}

.tooltip-icon {
  flex-shrink: 0;
}

.tooltip-title {
  font-weight: 600;
  font-size: 14px;
  color: var(--vp-c-text-1);
  margin: 0;
  flex: 1;
}

.tooltip-pin-button {
  background: none;
  border: none;
  padding: 2px;
  cursor: pointer;
  color: var(--vp-c-text-3);
  border-radius: 2px;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.2s ease;
  flex-shrink: 0;
}

.tooltip-pin-button:hover {
  background: var(--vp-c-bg-soft);
  color: var(--vp-c-text-2);
}

.tooltip-pin-button:focus {
  outline: 2px solid var(--vp-c-brand-1);
  outline-offset: 1px;
}

.tooltip-description {
  font-size: 13px;
  color: var(--vp-c-text-2);
  margin-bottom: 6px;
  line-height: 1.4;
}

.tooltip-details {
  font-size: 12px;
  color: var(--vp-c-text-3);
}

.tooltip-detail {
  margin-bottom: 2px;
  line-height: 1.3;
}

.tooltip-detail:last-child {
  margin-bottom: 0;
}

.tooltip-arrow {
  position: absolute;
  width: 0;
  height: 0;
  border: 6px solid transparent;
}

.tooltip-top .tooltip-arrow {
  bottom: -6px;
  left: 50%;
  transform: translateX(-50%);
  border-top-color: var(--vp-c-border);
}

.tooltip-bottom .tooltip-arrow {
  top: -6px;
  left: 50%;
  transform: translateX(-50%);
  border-bottom-color: var(--vp-c-border);
}

.tooltip-left .tooltip-arrow {
  right: -6px;
  top: 50%;
  transform: translateY(-50%);
  border-left-color: var(--vp-c-border);
}

.tooltip-right .tooltip-arrow {
  left: -6px;
  top: 50%;
  transform: translateY(-50%);
  border-right-color: var(--vp-c-border);
}

/* Dark mode adjustments */
.dark .tooltip {
  background: var(--vp-c-bg-soft);
  border-color: var(--vp-c-border);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.3);
}

.dark .tooltip-pinned {
  border-color: var(--vp-c-brand-2);
  box-shadow:
    0 4px 12px rgba(0, 0, 0, 0.3),
    0 0 0 1px var(--vp-c-brand-2);
}

.dark .tooltip-pinned .tooltip-pin-button {
  color: var(--vp-c-brand-2);
}

.dark .tooltip-title {
  color: var(--vp-c-text-1);
}

.dark .tooltip-description {
  color: var(--vp-c-text-2);
}

.dark .tooltip-details {
  color: var(--vp-c-text-3);
}

.tooltip-loading {
  font-size: 13px;
  color: var(--vp-c-text-2);
  font-style: italic;
}

.tooltip-error {
  color: var(--vp-c-danger-1) !important;
}

.dark .tooltip-error {
  color: var(--vp-c-danger-2) !important;
}
</style>
