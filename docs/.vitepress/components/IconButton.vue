<template>
  <div
    class="icon-button"
    :class="{
      selected: isSelected,
      clickable: clickable,
      'empty-cell': isEmpty
    }"
    :title="resolvedTitle"
    @click="handleClick"
  >
    <SpriteIcon
      v-if="!isEmpty && resolvedSpriteKey"
      :sprite-key="resolvedSpriteKey"
      :size="size"
      :title="resolvedTitle"
    />
    <span v-if="label" class="icon-label">{{ label }}</span>
  </div>
</template>

<script setup>
import { computed } from 'vue'

import SpriteIcon from './SpriteIcon.vue'
import { useFactorioData } from '../../../src/index.js'

// Use the data composable
const {
  getObjectIcon,
  getItemData,
  getRecipeData,
  getTechnologyData,
  getFluidData,
  getBuildingData
} = useFactorioData()

// Props
const props = defineProps({
  spriteKey: {
    type: String,
    default: ''
  },
  type: {
    type: String,
    default: ''
  },
  name: {
    type: String,
    default: ''
  },
  size: {
    type: [String, Number],
    default: 32
  },
  isSelected: {
    type: Boolean,
    default: false
  },
  clickable: {
    type: Boolean,
    default: true
  },
  isEmpty: {
    type: Boolean,
    default: false
  },
  title: {
    type: String,
    default: ''
  },
  label: {
    type: String,
    default: ''
  }
})

// Emits
const emit = defineEmits(['click'])

// Computed properties
const resolvedSpriteKey = computed(() => {
  // If spriteKey is provided directly, use it
  if (props.spriteKey) {
    return props.spriteKey
  }

  // Otherwise, resolve from type and name
  if (props.type && props.name) {
    return `${props.type}-${props.name}`
  }
  return ''
})

const resolvedTitle = computed(() => {
  // If title is provided directly, use it
  if (props.title) {
    return props.title
  }

  // Otherwise, resolve from type and name
  if (props.type && props.name) {
    try {
      switch (props.type) {
        case 'item':
          return getItemData(props.name)?.displayName || props.name
        case 'recipe':
          return getRecipeData(props.name)?.displayName || props.name
        case 'technology':
          return getTechnologyData(props.name)?.displayName || props.name
        case 'fluid':
          return getFluidData(props.name)?.displayName || props.name
        case 'building':
          return getBuildingData(props.name)?.displayName || props.name
        default:
          return props.name
      }
    } catch (error) {
      console.warn(`Failed to get title for ${props.type}:${props.name}:`, error.message)
      return props.name
    }
  }

  return ''
})

// Methods
function handleClick() {
  if (props.clickable && !props.isEmpty) {
    emit('click')
  }
}
</script>

<style scoped>
.icon-button {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  width: v-bind(size + 'px');
  height: v-bind(size + 'px');
  min-width: v-bind(size + 'px');
  min-height: v-bind(size + 'px');
  max-width: v-bind(size + 'px');
  max-height: v-bind(size + 'px');
  border: 1px solid var(--vp-c-border);
  border-radius: 4px;
  background: var(--vp-c-bg);
  transition: all 0.2s ease;
  position: relative;
  flex-shrink: 0;
}

.icon-button.clickable {
  cursor: pointer;
}

.icon-button.clickable:hover {
  background: var(--vp-c-bg-soft-hover);
  border-color: var(--vp-c-brand-1);
  transform: translateY(-1px);
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

.icon-button.selected {
  background: var(--vp-c-brand-soft);
  border-color: var(--vp-c-brand-1);
  box-shadow: 0 0 0 2px var(--vp-c-brand-1);
}

.icon-button.empty-cell {
  background: transparent;
  border: none;
  cursor: default;
}

.icon-button.empty-cell:hover {
  background: transparent;
  border: none;
  transform: none;
  box-shadow: none;
}

.icon-label {
  font-size: 0.75rem;
  color: var(--vp-c-text-3);
  margin-top: 4px;
  text-align: center;
  line-height: 1.2;
  max-width: 100%;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.icon-button.selected .icon-label {
  color: var(--vp-c-brand-1);
  font-weight: 500;
}

/* Dark mode adjustments */
.dark .icon-button {
  background: var(--vp-c-bg);
  border-color: var(--vp-c-border);
}

.dark .icon-button.clickable:hover {
  background: var(--vp-c-bg-soft-hover);
  border-color: var(--vp-c-brand-1);
}

.dark .icon-button.selected {
  background: var(--vp-c-brand-soft);
  border-color: var(--vp-c-brand-1);
}
</style>
