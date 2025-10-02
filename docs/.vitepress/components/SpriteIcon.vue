<template>
  <span
    class="sprite-icon"
    :class="iconClasses"
    :style="iconStyle"
    :title="title"
    :aria-label="ariaLabel"
  >
    <span v-if="!spriteData" class="sprite-icon-fallback">
      {{ fallbackText }}
    </span>
  </span>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { withBase } from 'vitepress'

import { loadSpritemapData } from '../../../src/index.js'

// Props
const props = defineProps({
  spriteKey: {
    type: String,
    required: true
  },
  size: {
    type: [String, Number],
    default: 32
  },
  title: {
    type: String,
    default: ''
  },
  ariaLabel: {
    type: String,
    default: ''
  },
  fallbackText: {
    type: String,
    default: '?'
  },
  color: {
    type: String,
    default: null
  }
})

// Reactive state
const spritemapData = ref(null)
const isLoading = ref(true)
const hasError = ref(false)

// Computed properties
const iconSize = computed(() => {
  const size = typeof props.size === 'string' ? parseInt(props.size) : props.size
  return Math.max(16, Math.min(128, size)) // Clamp between 16 and 128
})

const iconClasses = computed(() => ({
  'sprite-icon-loading': isLoading.value,
  'sprite-icon-error': hasError.value
}))

const spriteData = computed(() => {
  if (!spritemapData.value || !spritemapData.value.sprites) {
    return null
  }
  const sprite = spritemapData.value.sprites[props.spriteKey]
  if (!sprite) {
    console.warn(`Sprite not found: ${props.spriteKey}`)
  }
  return sprite || null
})

const iconStyle = computed(() => {
  if (!spriteData.value || !spritemapData.value) {
    return {}
  }

  const scale = iconSize.value / spritemapData.value.iconSize
  const scaledWidth = spriteData.value.width * scale
  const scaledHeight = spriteData.value.height * scale

  const style = {
    width: `${scaledWidth}px !important`,
    height: `${scaledHeight}px !important`,
    backgroundImage: `url(${withBase(`/data/${spritemapData.value.image}`)}) !important`,
    backgroundPosition: `-${spriteData.value.x * scale}px -${spriteData.value.y * scale}px !important`,
    backgroundSize: `${spritemapData.value.width * scale}px ${spritemapData.value.height * scale}px !important`,
    backgroundRepeat: 'no-repeat !important'
  }

  // Add color if color prop is provided
  if (props.color) {
    // Use CSS mask approach: set background color and use sprite as mask
    const baseUrl = withBase(`/data/${spritemapData.value.image}`)
    const scale = iconSize.value / spritemapData.value.iconSize
    const scaledWidth = spriteData.value.width * scale
    const scaledHeight = spriteData.value.height * scale
    const scaledSheetWidth = spritemapData.value.width * scale
    const scaledSheetHeight = spritemapData.value.height * scale
    const scaledX = spriteData.value.x * scale
    const scaledY = spriteData.value.y * scale

    // Override the background image with solid color and mask
    style.background = `${props.color} !important` // Use the provided color
    style.backgroundImage = 'none !important'
    style.webkitMask = `url(${baseUrl}) no-repeat !important`
    style.webkitMaskPosition = `-${scaledX}px -${scaledY}px !important`
    style.webkitMaskSize = `${scaledSheetWidth}px ${scaledSheetHeight}px !important`
    style.mask = `url(${baseUrl}) no-repeat !important`
    style.maskPosition = `-${scaledX}px -${scaledY}px !important`
    style.maskSize = `${scaledSheetWidth}px ${scaledSheetHeight}px !important`
  }

  // console.log(`SpriteIcon style for ${props.spriteKey}:`, style)
  return style
})

// Load spritemap data on mount
onMounted(async () => {
  try {
    isLoading.value = true
    hasError.value = false
    spritemapData.value = await loadSpritemapData(withBase)

    if (!spritemapData.value) {
      hasError.value = true
      console.error('Failed to load spritemap data')
    } else {
    }
  } catch (error) {
    console.error('Error loading spritemap data:', error)
    hasError.value = true
  } finally {
    isLoading.value = false
  }
})
</script>

<style scoped>
.sprite-icon {
  display: inline-block;
  vertical-align: middle;
  position: relative;
  flex-shrink: 0;
  /* Ensure inline styles override any conflicting CSS */
  width: auto !important;
  height: auto !important;
}

.sprite-icon-fallback {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 100%;
  height: 100%;
  background: var(--vp-c-bg-soft);
  border: 1px solid var(--vp-c-border);
  border-radius: 2px;
  font-size: 12px;
  font-weight: bold;
  color: var(--vp-c-text-3);
  text-align: center;
}

.sprite-icon-loading .sprite-icon-fallback::after {
  content: '';
  width: 12px;
  height: 12px;
  border: 2px solid var(--vp-c-border);
  border-top: 2px solid var(--vp-c-brand-1);
  border-radius: 50%;
  animation: spin 1s linear infinite;
}

.sprite-icon-error .sprite-icon-fallback {
  background: var(--vp-c-danger-soft);
  border-color: var(--vp-c-danger-1);
  color: var(--vp-c-danger-1);
}

/* Size variants removed - using inline styles instead */

/* Dark mode adjustments */
.dark .sprite-icon-fallback {
  background: var(--vp-c-bg-soft);
  border-color: var(--vp-c-border);
  color: var(--vp-c-text-3);
}

.dark .sprite-icon-error .sprite-icon-fallback {
  background: var(--vp-c-danger-soft);
  border-color: var(--vp-c-danger-2);
  color: var(--vp-c-danger-2);
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
