<template>
  <div class="animated-sprite" :class="spriteClasses" :style="spriteStyle" :title="title">
    <div v-if="isLoading" class="sprite-loading">
      <div class="loading-spinner" />
    </div>
    <div v-else-if="hasError" class="sprite-error">
      <span>?</span>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, onUnmounted } from 'vue'
import { withBase } from 'vitepress'

// Props
const props = defineProps({
  spriteData: {
    type: Object,
    required: true
  },
  size: {
    type: [String, Number],
    default: 64
  },
  title: {
    type: String,
    default: ''
  },
  playAnimation: {
    type: Boolean,
    default: true
  },
  animationSpeed: {
    type: Number,
    default: 1.0
  }
})

// Reactive state
const isLoading = ref(true)
const hasError = ref(false)
const currentFrame = ref(0)
const animationInterval = ref(null)

// Helper function to extract the main animation from Factorio graphics data
const getMainAnimation = graphicsData => {
  if (!graphicsData) return null

  // Check for graphics_set.animation (assembling machines, furnaces, etc.)
  if (graphicsData.graphics_set?.animation) {
    const animation = graphicsData.graphics_set.animation

    // Check for simple layers array
    if (animation.layers && Array.isArray(animation.layers)) {
      const mainLayer = animation.layers.find(
        layer =>
          layer.filename && !layer.draw_as_shadow && !layer.draw_as_glow && !layer.draw_as_light
      )
      if (mainLayer) {
        return {
          filename: mainLayer.filename,
          width: mainLayer.width,
          height: mainLayer.height,
          frame_count: mainLayer.frame_count || 1, // Default to 1 for static entities
          line_length: mainLayer.line_length || 1, // Default to 1 for static entities
          shift: mainLayer.shift || [0, 0],
          scale: mainLayer.scale || 1,
          priority: mainLayer.priority || 'high'
        }
      }
    }

    // Check for direct animation
    if (
      animation.filename &&
      !animation.draw_as_shadow &&
      !animation.draw_as_glow &&
      !animation.draw_as_light
    ) {
      return {
        filename: animation.filename,
        width: animation.width,
        height: animation.height,
        frame_count: animation.frame_count || 1, // Default to 1 for static entities
        line_length: animation.line_length || 1, // Default to 1 for static entities
        shift: animation.shift || [0, 0],
        scale: animation.scale || 1,
        priority: animation.priority || 'high'
      }
    }

    // Check for directional animation
    const directions = ['north', 'east', 'south', 'west']
    for (const direction of directions) {
      // Check for direct filename (bob-void-pump, etc.)
      if (animation[direction]?.filename) {
        return {
          filename: animation[direction].filename,
          width: animation[direction].width,
          height: animation[direction].height,
          frame_count: animation[direction].frame_count || 1,
          line_length: animation[direction].line_length || 1,
          shift: animation[direction].shift || [0, 0],
          scale: animation[direction].scale || 1,
          priority: animation[direction].priority || 'high'
        }
      }

      // Check for layers array
      if (animation[direction]?.layers && Array.isArray(animation[direction].layers)) {
        const mainLayer = animation[direction].layers.find(
          layer =>
            layer.filename && !layer.draw_as_shadow && !layer.draw_as_glow && !layer.draw_as_light
        )
        if (mainLayer) {
          return {
            filename: mainLayer.filename,
            width: mainLayer.width,
            height: mainLayer.height,
            frame_count: mainLayer.frame_count || 1, // Default to 1 for static entities
            line_length: mainLayer.line_length || 1, // Default to 1 for static entities
            shift: mainLayer.shift || [0, 0],
            scale: mainLayer.scale || 1,
            priority: mainLayer.priority || 'high'
            // Note: x/y offsets removed to prevent sprite sheet issues
          }
        }
      }
    }
  }

  // Check for belt_animation_set (transport belts, underground belts, splitters)
  if (graphicsData.belt_animation_set?.animation_set) {
    const animationSet = graphicsData.belt_animation_set.animation_set
    if (animationSet.filename) {
      return {
        filename: animationSet.filename,
        width: animationSet.size || 128,
        height: animationSet.size || 128,
        frame_count: animationSet.frame_count || 16,
        line_length: animationSet.direction_count || 20,
        shift: animationSet.shift || [0, 0],
        scale: animationSet.scale || 0.5,
        priority: animationSet.priority || 'extra-high'
      }
    }
  }

  // Check for direct animation property
  if (graphicsData.animation?.filename) {
    return graphicsData.animation
  }

  // Check for animations (plural) with directional sprites (pump, etc.)
  if (graphicsData.animations) {
    const directions = ['north', 'east', 'south', 'west']
    for (const direction of directions) {
      if (graphicsData.animations[direction]?.filename) {
        return graphicsData.animations[direction]
      }
    }
  }

  // Check for animation.layers (logistic chests, etc.)
  if (graphicsData.animation?.layers && Array.isArray(graphicsData.animation.layers)) {
    const mainLayer = graphicsData.animation.layers.find(
      layer =>
        layer.filename && !layer.draw_as_shadow && !layer.draw_as_glow && !layer.draw_as_light
    )
    if (mainLayer) {
      // For animated entities, if line_length is not specified, calculate it from frame_count
      const frameCount = mainLayer.frame_count || 1
      const lineLength = mainLayer.line_length || frameCount

      return {
        filename: mainLayer.filename,
        width: mainLayer.width,
        height: mainLayer.height,
        frame_count: frameCount,
        line_length: lineLength,
        shift: mainLayer.shift || [0, 0],
        scale: mainLayer.scale || 1,
        priority: mainLayer.priority || 'high'
      }
    }
  }

  // Check for inserter graphics (hand_base_picture, hand_open_picture, hand_closed_picture, platform_picture)
  if (graphicsData.hand_base_picture?.filename) {
    return {
      filename: graphicsData.hand_base_picture.filename,
      width: graphicsData.hand_base_picture.width,
      height: graphicsData.hand_base_picture.height,
      frame_count: 1,
      line_length: 1,
      shift: graphicsData.hand_base_picture.shift || [0, 0],
      scale: graphicsData.hand_base_picture.scale || 1,
      priority: graphicsData.hand_base_picture.priority || 'high'
    }
  }

  if (graphicsData.hand_open_picture?.filename) {
    return {
      filename: graphicsData.hand_open_picture.filename,
      width: graphicsData.hand_open_picture.width,
      height: graphicsData.hand_open_picture.height,
      frame_count: 1,
      line_length: 1,
      shift: graphicsData.hand_open_picture.shift || [0, 0],
      scale: graphicsData.hand_open_picture.scale || 1,
      priority: graphicsData.hand_open_picture.priority || 'high'
    }
  }

  if (graphicsData.hand_closed_picture?.filename) {
    return {
      filename: graphicsData.hand_closed_picture.filename,
      width: graphicsData.hand_closed_picture.width,
      height: graphicsData.hand_closed_picture.height,
      frame_count: 1,
      line_length: 1,
      shift: graphicsData.hand_closed_picture.shift || [0, 0],
      scale: graphicsData.hand_closed_picture.scale || 1,
      priority: graphicsData.hand_closed_picture.priority || 'high'
    }
  }

  if (graphicsData.platform_picture?.sheet?.filename) {
    return {
      filename: graphicsData.platform_picture.sheet.filename,
      width: graphicsData.platform_picture.sheet.width,
      height: graphicsData.platform_picture.sheet.height,
      frame_count: 1,
      line_length: 1,
      shift: graphicsData.platform_picture.sheet.shift || [0, 0],
      scale: graphicsData.platform_picture.sheet.scale || 1,
      priority: graphicsData.platform_picture.sheet.priority || 'high'
    }
  }

  // Check for static picture (chests, poles, lamps, simple machines)
  if (graphicsData.picture?.filename) {
    return {
      filename: graphicsData.picture.filename,
      width: graphicsData.picture.width,
      height: graphicsData.picture.height,
      frame_count: 1,
      line_length: 1,
      shift: graphicsData.picture.shift || [0, 0],
      scale: graphicsData.picture.scale || 1,
      priority: graphicsData.picture.priority || 'high'
    }
  }

  // Check for picture.layers (chests, containers, etc.)
  if (graphicsData.picture?.layers && Array.isArray(graphicsData.picture.layers)) {
    const mainLayer = graphicsData.picture.layers.find(
      layer =>
        layer.filename && !layer.draw_as_shadow && !layer.draw_as_glow && !layer.draw_as_light
    )
    if (mainLayer) {
      return {
        filename: mainLayer.filename,
        width: mainLayer.width,
        height: mainLayer.height,
        frame_count: 1,
        line_length: 1,
        shift: mainLayer.shift || [0, 0],
        scale: mainLayer.scale || 1,
        priority: mainLayer.priority || 'high'
      }
    }
  }

  // Check for pictures.layers (electric poles, etc.)
  if (graphicsData.pictures?.layers && Array.isArray(graphicsData.pictures.layers)) {
    const mainLayer = graphicsData.pictures.layers.find(
      layer =>
        layer.filename && !layer.draw_as_shadow && !layer.draw_as_glow && !layer.draw_as_light
    )
    if (mainLayer) {
      return {
        filename: mainLayer.filename,
        width: mainLayer.width,
        height: mainLayer.height,
        frame_count: 1,
        line_length: mainLayer.direction_count || 1, // Use direction_count for directional sprites
        shift: mainLayer.shift || [0, 0],
        scale: mainLayer.scale || 1,
        priority: mainLayer.priority || 'high'
      }
    }
  }

  // Check for directional pictures (belts, underground belts, pipes, heat-exchanger, etc.)
  if (graphicsData.pictures) {
    const directions = ['north', 'east', 'south', 'west']
    for (const direction of directions) {
      // Check for direct filename (belts, pipes)
      if (graphicsData.pictures[direction]?.filename) {
        return {
          filename: graphicsData.pictures[direction].filename,
          width: graphicsData.pictures[direction].width,
          height: graphicsData.pictures[direction].height,
          frame_count: 1,
          line_length: 1,
          shift: graphicsData.pictures[direction].shift || [0, 0],
          scale: graphicsData.pictures[direction].scale || 1,
          priority: graphicsData.pictures[direction].priority || 'high'
        }
      }

      // Check for structure.layers (heat-exchanger, etc.)
      if (
        graphicsData.pictures[direction]?.structure?.layers &&
        Array.isArray(graphicsData.pictures[direction].structure.layers)
      ) {
        const mainLayer = graphicsData.pictures[direction].structure.layers.find(
          layer =>
            layer.filename && !layer.draw_as_shadow && !layer.draw_as_glow && !layer.draw_as_light
        )
        if (mainLayer) {
          return {
            filename: mainLayer.filename,
            width: mainLayer.width,
            height: mainLayer.height,
            frame_count: 1,
            line_length: 1,
            shift: mainLayer.shift || [0, 0],
            scale: mainLayer.scale || 1,
            priority: mainLayer.priority || 'high'
          }
        }
      }
    }

    // Check for pipe configuration sprites (straight_vertical, corner_up_right, etc.)
    const pipeConfigs = [
      'straight_vertical_single',
      'straight_vertical',
      'straight_horizontal',
      'corner_up_right',
      'corner_up_left',
      'corner_down_right',
      'corner_down_left',
      't_up',
      't_down',
      't_right',
      't_left',
      'cross',
      'ending_up',
      'ending_down',
      'ending_right',
      'ending_left'
    ]

    for (const config of pipeConfigs) {
      if (graphicsData.pictures[config]?.filename) {
        return {
          filename: graphicsData.pictures[config].filename,
          width: graphicsData.pictures[config].width,
          height: graphicsData.pictures[config].height,
          frame_count: 1,
          line_length: 1,
          shift: graphicsData.pictures[config].shift || [0, 0],
          scale: graphicsData.pictures[config].scale || 1,
          priority: graphicsData.pictures[config].priority || 'high'
        }
      }
    }
  }

  // Check for sprites (combinators, etc.)
  if (graphicsData.sprites) {
    const directions = ['north', 'east', 'south', 'west']
    for (const direction of directions) {
      // Check for direct filename (simple sprites)
      if (graphicsData.sprites[direction]?.filename) {
        return {
          filename: graphicsData.sprites[direction].filename,
          width: graphicsData.sprites[direction].width,
          height: graphicsData.sprites[direction].height,
          frame_count: graphicsData.sprites[direction].frame_count || 1,
          line_length: graphicsData.sprites[direction].line_length || 1,
          shift: graphicsData.sprites[direction].shift || [0, 0],
          scale: graphicsData.sprites[direction].scale || 1,
          priority: graphicsData.sprites[direction].priority || 'high'
        }
      }

      // Check for layers array (combinators, etc.)
      if (
        graphicsData.sprites[direction]?.layers &&
        Array.isArray(graphicsData.sprites[direction].layers)
      ) {
        const mainLayer = graphicsData.sprites[direction].layers.find(
          layer =>
            layer.filename && !layer.draw_as_shadow && !layer.draw_as_glow && !layer.draw_as_light
        )
        if (mainLayer) {
          const result = {
            filename: mainLayer.filename,
            width: mainLayer.width,
            height: mainLayer.height,
            frame_count: mainLayer.frame_count || 1,
            line_length: mainLayer.line_length || 1,
            shift: mainLayer.shift || [0, 0],
            scale: mainLayer.scale || 1,
            priority: mainLayer.priority || 'high'
            // Note: For combinators, we don't include x/y offsets as they represent directional variants
            // We only show the north-facing sprite (first direction checked)
          }
          return result
        }
      }
    }
  }

  // Check for connection_sprites (heat-pipe, pipe-to-ground, etc.)
  if (graphicsData.connection_sprites) {
    // Try to get a single connection sprite first
    if (
      graphicsData.connection_sprites.single &&
      Array.isArray(graphicsData.connection_sprites.single) &&
      graphicsData.connection_sprites.single[0]?.filename
    ) {
      return {
        filename: graphicsData.connection_sprites.single[0].filename,
        width: graphicsData.connection_sprites.single[0].width,
        height: graphicsData.connection_sprites.single[0].height,
        frame_count: 1,
        line_length: 1,
        shift: graphicsData.connection_sprites.single[0].shift || [0, 0],
        scale: graphicsData.connection_sprites.single[0].scale || 1,
        priority: graphicsData.connection_sprites.single[0].priority || 'high'
      }
    }

    // Try straight_vertical as fallback
    if (
      graphicsData.connection_sprites.straight_vertical &&
      Array.isArray(graphicsData.connection_sprites.straight_vertical) &&
      graphicsData.connection_sprites.straight_vertical[0]?.filename
    ) {
      return {
        filename: graphicsData.connection_sprites.straight_vertical[0].filename,
        width: graphicsData.connection_sprites.straight_vertical[0].width,
        height: graphicsData.connection_sprites.straight_vertical[0].height,
        frame_count: 1,
        line_length: 1,
        shift: graphicsData.connection_sprites.straight_vertical[0].shift || [0, 0],
        scale: graphicsData.connection_sprites.straight_vertical[0].scale || 1,
        priority: graphicsData.connection_sprites.straight_vertical[0].priority || 'high'
      }
    }
  }

  // Check for horizontal_animation (steam-engine, steam-turbine, etc.)
  if (
    graphicsData.horizontal_animation?.layers &&
    Array.isArray(graphicsData.horizontal_animation.layers)
  ) {
    const mainLayer = graphicsData.horizontal_animation.layers.find(
      layer =>
        layer.filename && !layer.draw_as_shadow && !layer.draw_as_glow && !layer.draw_as_light
    )
    if (mainLayer) {
      return {
        filename: mainLayer.filename,
        width: mainLayer.width,
        height: mainLayer.height,
        frame_count: mainLayer.frame_count,
        line_length: mainLayer.line_length,
        shift: mainLayer.shift || [0, 0],
        scale: mainLayer.scale || 1,
        priority: mainLayer.priority || 'high'
      }
    }
  }

  // Check for vertical_animation (steam-engine, steam-turbine, etc.)
  if (
    graphicsData.vertical_animation?.layers &&
    Array.isArray(graphicsData.vertical_animation.layers)
  ) {
    const mainLayer = graphicsData.vertical_animation.layers.find(
      layer =>
        layer.filename && !layer.draw_as_shadow && !layer.draw_as_glow && !layer.draw_as_light
    )
    if (mainLayer) {
      return {
        filename: mainLayer.filename,
        width: mainLayer.width,
        height: mainLayer.height,
        frame_count: mainLayer.frame_count,
        line_length: mainLayer.line_length,
        shift: mainLayer.shift || [0, 0],
        scale: mainLayer.scale || 1,
        priority: mainLayer.priority || 'high'
      }
    }
  }

  // Check for chargable_graphics (accumulator, etc.)
  if (
    graphicsData.chargable_graphics?.picture?.layers &&
    Array.isArray(graphicsData.chargable_graphics.picture.layers)
  ) {
    const mainLayer = graphicsData.chargable_graphics.picture.layers.find(
      layer =>
        layer.filename && !layer.draw_as_shadow && !layer.draw_as_glow && !layer.draw_as_light
    )
    if (mainLayer) {
      return {
        filename: mainLayer.filename,
        width: mainLayer.width,
        height: mainLayer.height,
        frame_count: 1,
        line_length: 1,
        shift: mainLayer.shift || [0, 0],
        scale: mainLayer.scale || 1,
        priority: mainLayer.priority || 'high'
      }
    }
  }

  return null
}

// Extract the main animation data from the complete graphics data
const animationData = computed(() => {
  return getMainAnimation(props.spriteData)
})

// Computed properties
const spriteSize = computed(() => {
  const size = typeof props.size === 'string' ? parseInt(props.size) : props.size
  return Math.max(32, Math.min(256, size)) // Clamp between 32 and 256
})

const spriteClasses = computed(() => ({
  'sprite-loading': isLoading.value,
  'sprite-error': hasError.value,
  'sprite-animated':
    props.playAnimation && (animationData.value?.frame_count || animationData.value?.frameCount) > 1
}))

// Base sprite properties that don't change during animation
const baseSpriteStyle = computed(() => {
  if (!animationData.value || hasError.value) {
    return {}
  }

  // Handle both Factorio naming (frame_count, line_length) and camelCase naming (frameCount, lineLength)
  const frameCount = animationData.value.frame_count || animationData.value.frameCount || 1
  const lineLength = animationData.value.line_length || animationData.value.lineLength || 8
  const width = animationData.value.width || 64
  const height = animationData.value.height || 64
  const scale = animationData.value.scale || 1

  // Calculate display scale based on the requested size
  const displayScale = spriteSize.value / width
  const frameWidth = width
  const frameHeight = height
  const framesPerRow = lineLength
  const totalFrames = frameCount

  // Calculate background size based on sprite sheet dimensions
  // Since we removed x/y offsets, we always use the standard sprite sheet width
  const actualSpriteSheetWidth = frameWidth * framesPerRow
  const backgroundSize = `${actualSpriteSheetWidth * displayScale}px auto`

  return {
    width: `${frameWidth * displayScale}px`,
    height: `${frameHeight * displayScale}px`,
    backgroundImage: `url(${withBase(`/data/${animationData.value.filename}`)})`,
    backgroundSize: backgroundSize,
    backgroundRepeat: 'no-repeat',
    transform: `scale(${scale})`,
    transformOrigin: 'center',
    // Store calculation values for frame positioning
    _frameWidth: frameWidth,
    _frameHeight: frameHeight,
    _framesPerRow: framesPerRow,
    _totalFrames: totalFrames,
    _displayScale: displayScale
  }
})

// Frame position that changes during animation
const framePosition = computed(() => {
  if (!baseSpriteStyle.value._totalFrames) {
    return { x: 0, y: 0 }
  }

  const frameIndex = Math.min(currentFrame.value, baseSpriteStyle.value._totalFrames - 1)
  const frameX =
    (frameIndex % baseSpriteStyle.value._framesPerRow) * baseSpriteStyle.value._frameWidth
  const frameY =
    Math.floor(frameIndex / baseSpriteStyle.value._framesPerRow) *
    baseSpriteStyle.value._frameHeight

  return {
    x: frameX * baseSpriteStyle.value._displayScale,
    y: frameY * baseSpriteStyle.value._displayScale
  }
})

// Final sprite style combining base properties with frame position
const spriteStyle = computed(() => {
  if (!baseSpriteStyle.value.width) {
    return {}
  }

  return {
    ...baseSpriteStyle.value,
    backgroundPosition: `-${framePosition.value.x}px -${framePosition.value.y}px`
  }
})

// Animation logic
function startAnimation() {
  if (!props.playAnimation || !animationData.value) {
    return
  }

  const frameCount = animationData.value.frame_count || animationData.value.frameCount || 1
  if (frameCount <= 1) {
    return
  }

  const frameRate = 60 / props.animationSpeed // frames per second
  const frameInterval = 1000 / frameRate

  animationInterval.value = setInterval(() => {
    currentFrame.value = (currentFrame.value + 1) % frameCount
  }, frameInterval)
}

function stopAnimation() {
  if (animationInterval.value) {
    clearInterval(animationInterval.value)
    animationInterval.value = null
  }
}

// Lifecycle
onMounted(() => {
  if (!animationData.value) {
    isLoading.value = false
    hasError.value = true
    return
  }

  // Simulate loading time for the sprite image
  const img = new Image()
  img.onload = () => {
    isLoading.value = false
    startAnimation()
  }
  img.onerror = () => {
    isLoading.value = false
    hasError.value = true
  }
  img.src = withBase(`/data/${animationData.value.filename}`)
})

onUnmounted(() => {
  stopAnimation()
})

// Watch for changes in animation props
import { watch } from 'vue'
watch(
  () => props.playAnimation,
  newValue => {
    if (newValue) {
      startAnimation()
    } else {
      stopAnimation()
    }
  }
)

watch(
  () => props.animationSpeed,
  () => {
    if (props.playAnimation) {
      stopAnimation()
      startAnimation()
    }
  }
)
</script>

<style scoped>
.animated-sprite {
  display: inline-block;
  position: relative;
  background-repeat: no-repeat;
  image-rendering: pixelated;
  image-rendering: -moz-crisp-edges;
  image-rendering: crisp-edges;
}

.sprite-loading {
  display: flex;
  align-items: center;
  justify-content: center;
  background: var(--vp-c-bg-soft);
  border: 2px solid var(--vp-c-border);
  border-radius: 4px;
}

.loading-spinner {
  width: 16px;
  height: 16px;
  border: 2px solid var(--vp-c-border);
  border-top: 2px solid var(--vp-c-brand-1);
  border-radius: 50%;
  animation: spin 1s linear infinite;
}

.sprite-error {
  display: flex;
  align-items: center;
  justify-content: center;
  background: var(--vp-c-danger-soft);
  border: 2px dashed var(--vp-c-danger-1);
  border-radius: 4px;
  color: var(--vp-c-danger-1);
  font-size: 24px;
  font-weight: bold;
}

.sprite-animated {
  animation: none; /* We handle animation via JavaScript */
}

@keyframes spin {
  0% {
    transform: rotate(0deg);
  }
  100% {
    transform: rotate(360deg);
  }
}

/* Dark mode adjustments */
.dark .sprite-loading {
  background: var(--vp-c-bg-soft);
  border-color: var(--vp-c-border);
}

.dark .sprite-error {
  background: var(--vp-c-danger-soft);
  border-color: var(--vp-c-danger-2);
  color: var(--vp-c-danger-2);
}
</style>
