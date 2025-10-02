<template>
  <div class="factorio-sprite-container" :style="containerStyle">
    <!-- All animations use canvas -->
    <canvas
      ref="spriteCanvas"
      :width="canvasWidth"
      :height="canvasHeight"
      class="factorio-sprite-canvas"
    />
    <!-- Pause/Play Button Overlay -->
    <div class="animation-controls">
      <button
        class="pause-play-button"
        :class="{ paused: isPaused }"
        :title="isPaused ? 'Play animation' : 'Pause animation'"
        @click="togglePause"
      >
        <span v-if="isPaused" class="play-icon">▶</span>
        <span v-else class="pause-icon">⏸</span>
      </button>
    </div>
  </div>
</template>

<script>
import { ref, computed, onMounted, onUnmounted, watch, nextTick } from 'vue'
import { withBase } from 'vitepress/client'

import { createFactorioAnimationEngine } from '../../../src/index.js'

export default {
  name: 'FactorioSprite',
  props: {
    spriteData: {
      type: Object,
      required: true
    },
    size: {
      type: Number,
      default: 128
    },
    playAnimation: {
      type: Boolean,
      default: true
    },
    // New props for enhanced animation support
    direction: {
      type: [Number, String],
      default: 0
    },
    activity: {
      type: Number,
      default: 1.0
    },
    workingState: {
      type: String,
      default: 'idle'
    },
    recipeTint: {
      type: Object,
      default: null
    },
    segmentKind: {
      type: String,
      default: 'straight'
    },
    cornerKind: {
      type: String,
      default: null
    },
    useHiRes: {
      type: Boolean,
      default: false
    },
    variationIndex: {
      type: Number,
      default: 0
    },
    isPaused: {
      type: Boolean,
      default: false
    }
  },
  emits: ['toggle-pause'],
  setup(props, { emit }) {
    const spriteCanvas = ref(null)
    const animationId = ref(null)
    const _currentFrame = ref(0)
    const hasError = ref(false)

    // Performance optimization variables
    const lastFrameTime = ref(0)
    const targetFPS = 60
    const frameInterval = 1000 / targetFPS
    const lastRenderTime = ref(0)
    const isDirty = ref(true)
    const lastAnimationData = ref(null)

    // Performance monitoring
    const fpsStartTime = ref(0)
    const currentFPS = ref(0)
    const performanceStats = ref({
      frameCount: 0,
      renderTime: 0,
      skippedFrames: 0
    })

    // Load graphics path mapping
    const graphicsPathMap = ref({})

    // Load the graphics path mapping on mount
    onMounted(async () => {
      try {
        const response = await fetch(withBase('/data/graphics-path-map.json'))
        if (response.ok) {
          graphicsPathMap.value = await response.json()
        }
      } catch (error) {
        console.warn('Failed to load graphics path mapping:', error)
      }
    })

    // Create animation engine instance
    const animationEngine = ref(null)

    // Create the animation engine when graphics path mapping is loaded
    const createEngine = () => {
      animationEngine.value = createFactorioAnimationEngine({
        loadImage: filename => {
          const img = new Image()
          // Convert Factorio path to public path using the mapping
          const publicPath = graphicsPathMap.value[filename] || filename
          img.src = withBase(`/data/${publicPath}`)
          return img
        },
        applyDOMChanges: _mutation => {
          // Handle DOM mutations for style changes
        },
        canvas: null, // Will be set when canvas is available
        devicePixelRatio: window.devicePixelRatio || 2,
        graphicsPathMap: graphicsPathMap.value
      })
    }

    // Watch for graphics path mapping changes and recreate engine
    watch(
      graphicsPathMap,
      () => {
        if (Object.keys(graphicsPathMap.value).length > 0) {
          createEngine()
        }
      },
      { deep: true }
    )

    // Set canvas reference when available
    watch(spriteCanvas, canvas => {
      if (canvas && animationEngine.value) {
        animationEngine.value.canvas = canvas
      }
    })

    // Just forward spriteData directly
    const animationData = computed(() => {
      return props.spriteData
    })

    // Watch for animation data errors
    watch(animationData, newData => {
      if (!newData && props.spriteData) {
        hasError.value = true
      }
    })

    // Calculate minimum canvas dimensions based on animation data
    const _canvasDimensions = computed(() => {
      if (!animationData.value) {
        return { width: 64, height: 64 } // Default fallback
      }

      let minWidth = 16
      let minHeight = 16

      const selection_box = animationData.value.selection_box
      if (selection_box) {
        const entityWidth = (1 + selection_box[1][0] - selection_box[0][0]) * 32
        const entityHeight = (1 + selection_box[1][1] - selection_box[0][1]) * 32
        minWidth = Math.max(minWidth, entityWidth)
        minHeight = Math.max(minHeight, entityHeight)
      }

      return { width: minWidth, height: minHeight }
    })

    // Container style - use full width and height of parent with minimal padding
    const containerStyle = computed(() => ({
      width: '100%',
      height: '100%',
      display: 'flex',
      justifyContent: 'center',
      alignItems: 'center',
      overflow: 'hidden',
      padding: '0',
      margin: '0'
    }))

    // Canvas dimensions - fit container width with configurable pixel size
    const canvasWidth = computed(() => {
      if (!spriteCanvas.value?.parentElement) {
        return props.size * 2 // Fallback
      }

      const parentWidth = spriteCanvas.value.parentElement.clientWidth
      const pixelScale = 2 // Scale factor: 1 = native, 2 = 2x smaller pixels, 0.5 = 2x larger pixels
      return Math.round(parentWidth * pixelScale)
    })

    const canvasHeight = computed(() => {
      if (!spriteCanvas.value?.parentElement) {
        return props.size * 2 // Fallback
      }

      const parentWidth = spriteCanvas.value.parentElement.clientWidth
      const parentHeight = spriteCanvas.value.parentElement.clientHeight
      const pixelScale = 2 // Scale factor: 1 = native, 2 = 2x smaller pixels, 0.5 = 2x larger pixels

      // Calculate height to maintain the container's aspect ratio
      const containerAspectRatio = parentWidth / parentHeight
      return Math.round((parentWidth / containerAspectRatio) * pixelScale)
    })

    // Sprite classes
    const spriteClasses = computed(() => ({
      'sprite-error': hasError.value
    }))

    // Canvas rendering with performance optimizations
    const renderCanvas = async () => {
      if (!spriteCanvas.value || !animationData.value) {
        return
      }

      const currentTime = performance.now()
      const renderStartTime = performance.now()

      // Frame rate limiting - only render if enough time has passed
      if (currentTime - lastRenderTime.value < frameInterval) {
        performanceStats.value.skippedFrames++
        return
      }

      // Skip rendering if nothing has changed (dirty checking)
      if (!isDirty.value && lastAnimationData.value === JSON.stringify(animationData.value)) {
        performanceStats.value.skippedFrames++
        return
      }

      const canvas = spriteCanvas.value
      const ctx = canvas.getContext('2d')

      // Save context state for better performance
      ctx.save()

      // Set up proper scaling for the animation
      const scale = props.size / 128 // Scale from 128px base to desired size
      ctx.scale(scale, scale)

      // Clear canvas efficiently
      ctx.clearRect(0, 0, canvas.width, canvas.height)

      // Use the unified render method from the animation engine
      try {
        if (!animationEngine.value) {
          console.warn('Animation engine not ready')
          return
        }

        await animationEngine.value.render(ctx, animationData.value, {
          ...props,
          time: _currentFrame.value / 60, // Frame-based timing at 60 FPS
          frame: _currentFrame.value, // Pass frame number for sprite sheet animations
          animationSpeedMultiplier: 1.0 // Use normal speed
        })

        // Update performance tracking
        const renderEndTime = performance.now()
        const renderTime = renderEndTime - renderStartTime

        performanceStats.value.frameCount++
        performanceStats.value.renderTime = renderTime
        lastRenderTime.value = currentTime
        isDirty.value = false
        lastAnimationData.value = JSON.stringify(animationData.value)

        // Calculate FPS every 60 frames
        if (performanceStats.value.frameCount % 60 === 0) {
          const elapsed = currentTime - fpsStartTime.value
          if (elapsed > 0) {
            currentFPS.value = Math.round((60 * 1000) / elapsed)
            fpsStartTime.value = currentTime
          }
        }
      } catch (error) {
        console.error('Canvas render error:', error)
      } finally {
        // Restore context state
        ctx.restore()
      }
    }

    // Animation loop with frame rate limiting
    const animate = async (currentTime = performance.now()) => {
      if (props.playAnimation && animationData.value && !props.isPaused) {
        // Frame rate limiting - only advance frame if enough time has passed
        if (currentTime - lastFrameTime.value >= frameInterval) {
          _currentFrame.value++
          lastFrameTime.value = currentTime
          isDirty.value = true // Mark as dirty when frame advances
        }

        await renderCanvas()
        animationId.value = requestAnimationFrame(animate)
      }
    }

    // Toggle pause/play
    const togglePause = () => {
      emit('toggle-pause')
    }

    // Start/stop animation
    const startAnimation = () => {
      if (props.playAnimation && animationData.value && !props.isPaused) {
        stopAnimation()
        animationId.value = requestAnimationFrame(animate)
      }
    }

    const stopAnimation = () => {
      if (animationId.value) {
        cancelAnimationFrame(animationId.value)
        animationId.value = null
      }
    }

    // Watch for changes
    watch([animationData], () => {
      nextTick(() => {
        // Always render first frame when data changes, even if paused
        _currentFrame.value = 1
        isDirty.value = true // Mark as dirty when data changes
        renderCanvas()
        // Start animation if not paused
        if (!props.isPaused) {
          startAnimation()
        }
      })
    })

    // Watch for spriteData changes (when switching items)
    watch(
      () => props.spriteData,
      () => {
        nextTick(() => {
          // Always render first frame when sprite data changes
          _currentFrame.value = 1
          isDirty.value = true // Mark as dirty when sprite data changes
          renderCanvas()
          // Start animation if not paused
          if (!props.isPaused) {
            startAnimation()
          }
        })
      }
    )

    // Watch for pause state changes
    watch(
      () => props.isPaused,
      isPaused => {
        if (isPaused) {
          // Pause animation but keep current frame
          stopAnimation()
          renderCanvas()
        } else {
          // Resume animation
          startAnimation()
        }
      }
    )

    // Watch for container size changes
    watch(containerStyle, () => {
      nextTick(() => {
        isDirty.value = true // Mark as dirty when container size changes
        renderCanvas()
      })
    })

    watch(
      () => props.playAnimation,
      newVal => {
        if (newVal) {
          startAnimation()
        } else {
          stopAnimation()
        }
      }
    )

    // Resize observer for responsive canvas
    let resizeObserver = null

    // Lifecycle
    onMounted(() => {
      nextTick(() => {
        // Initialize performance tracking
        lastFrameTime.value = performance.now()
        lastRenderTime.value = performance.now()
        fpsStartTime.value = performance.now()

        // Always render first frame when mounted
        _currentFrame.value = 1
        isDirty.value = true
        renderCanvas()
        // Start animation only if not paused
        if (!props.isPaused) {
          startAnimation()
        }

        // Set up resize observer for responsive canvas
        if (spriteCanvas.value?.parentElement) {
          resizeObserver = new ResizeObserver(() => {
            nextTick(() => {
              isDirty.value = true // Mark as dirty when resized
              renderCanvas()
            })
          })
          resizeObserver.observe(spriteCanvas.value.parentElement)
        }
      })
    })

    onUnmounted(() => {
      stopAnimation()
      if (resizeObserver) {
        resizeObserver.disconnect()
      }
    })

    return {
      spriteCanvas,
      animationData,
      containerStyle,
      canvasWidth,
      canvasHeight,
      spriteClasses,
      hasError,
      togglePause,
      // Performance monitoring (for debugging)
      currentFPS,
      performanceStats
    }
  }
}
</script>

<style scoped>
.factorio-sprite-container {
  position: relative;
  overflow: hidden;
  padding: 0;
  margin: 0;
  box-sizing: border-box;
}

.sprite-animated {
  animation-timing-function: linear;
}

.factorio-sprite-canvas {
  display: block;
  width: 100%;
  height: 100%;
  object-fit: contain;
  image-rendering: pixelated;
  image-rendering: -moz-crisp-edges;
  image-rendering: crisp-edges;
  padding: 0;
  margin: 0;
  border: none;
  outline: none;
}

.sprite-error {
  background-color: #ff6b6b;
  border: 2px dashed #ff5252;
}

/* Animation Controls */
.animation-controls {
  position: absolute;
  top: 8px;
  right: 8px;
  z-index: 10;
}

.pause-play-button {
  width: 32px;
  height: 32px;
  border: none;
  border-radius: 4px;
  background: rgba(0, 0, 0, 0.7);
  color: white;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 14px;
  transition: all 0.2s ease;
  backdrop-filter: blur(4px);
}

.pause-play-button:hover {
  background: rgba(0, 0, 0, 0.8);
  transform: scale(1.1);
}

.pause-play-button.paused {
  background: rgba(0, 100, 0, 0.7);
}

.pause-play-button.paused:hover {
  background: rgba(0, 100, 0, 0.8);
}

.play-icon,
.pause-icon {
  display: block;
  line-height: 1;
}

.play-icon {
  margin-left: 2px; /* Slight offset to center the play triangle */
}
</style>
