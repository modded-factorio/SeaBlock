import { useFactorioRenderingMapping } from '../composables/useFactorioRenderingMapping'
/**
 * Factorio Animation Engine
 *
 * A testable, framework-agnostic animation engine for Factorio-style sprites.
 * Can be used in both browser and Node.js environments with appropriate mocks.
 */

function unWrapLayer(layer) {
  //sheets are for varations either rotated or not
  let sheet = null
  if (layer.sheets) {
    sheet = layer.sheets[0]
  } else if (layer.sheet) {
    sheet = layer.sheet
  } else if (layer.north) {
    return layer.north
  } else {
    if (layer.filenames) {
      return { ...layer, filename: layer.filenames[0] }
    }
    return layer
  }

  if (sheet.variation_count && sheet.filenames) {
    return { ...sheet, filename: sheet.filenames[0] }
  } else {
    return {
      ...sheet,
      height: sheet.height / sheet.variation_count,
      width: sheet.width / sheet.frame_count,
      frame_count: 0,
      line_length: 0
    }
  }
}
// Animation run modes
const RUN_MODES = {
  FORWARD: 'forward',
  BACKWARD: 'backward',
  PING_PONG: 'forward-then-backward',
  RANDOM: 'random'
}

// Core animation utilities
function drawCheckerboardBackground(ctx, width, height, squareSize = 16) {
  // Save current state
  ctx.save()

  // Clear canvas
  ctx.clearRect(0, 0, width, height)

  // Set up checkerboard pattern - matching Factorio's dark theme
  const lightGray = '#2a2a2a'
  const darkGray = '#1a1a1a'

  // Draw checkerboard pattern
  for (let x = 0; x < width; x += squareSize) {
    for (let y = 0; y < height; y += squareSize) {
      const isEven = (x / squareSize + y / squareSize) % 2 === 0
      ctx.fillStyle = isEven ? lightGray : darkGray
      ctx.fillRect(x, y, squareSize, squareSize)
    }
  }

  // Restore state
  ctx.restore()
}

function computeFrameIndex({
  t,
  animationSpeed,
  frameCount,
  runMode = RUN_MODES.FORWARD,
  frameSequence = null
}) {
  if (frameSequence && Array.isArray(frameSequence)) {
    // Use custom frame sequence
    const sequenceIndex = Math.floor(t * animationSpeed) % frameSequence.length
    return frameSequence[sequenceIndex] - 1 // Convert to 0-based
  }

  const totalFrames = frameCount
  const frameTime = 1 / animationSpeed

  switch (runMode) {
    case RUN_MODES.FORWARD:
      return Math.floor(t * animationSpeed) % totalFrames

    case RUN_MODES.BACKWARD:
      return totalFrames - 1 - (Math.floor(t * animationSpeed) % totalFrames)

    case RUN_MODES.PING_PONG: {
      const cycleTime = totalFrames * frameTime
      const cycleProgress = (t % cycleTime) / cycleTime
      if (cycleProgress < 0.5) {
        return Math.floor(cycleProgress * 2 * totalFrames)
      } else {
        return totalFrames - 1 - Math.floor((cycleProgress - 0.5) * 2 * totalFrames)
      }
    }

    case RUN_MODES.RANDOM:
      return Math.floor(Math.random() * totalFrames)

    default:
      return Math.floor(t * animationSpeed) % totalFrames
  }
}

function resolveLayer(layer, useHiRes = null, devicePixelRatio = 2) {
  const shouldUseHiRes = useHiRes !== null ? useHiRes : devicePixelRatio >= 2
  return shouldUseHiRes && layer.hr_version ? layer.hr_version : layer
}

function getHiResScale(layer, useHiRes = null, devicePixelRatio = 2) {
  const shouldUseHiRes = useHiRes !== null ? useHiRes : devicePixelRatio >= 2
  if (shouldUseHiRes && layer.hr_version) {
    // Hi-res assets are typically 2x scale
    return 0.5
  }
  return 1
}

// Normalize shifts to canvas scale
function normalizeShift(shift, layerWidth, pixelsPerTile = 32) {
  if (!shift || !Array.isArray(shift)) return [0, 0]

  const [shiftX, shiftY] = shift
  // Convert from tile-space to pixel-space
  const shiftPixelsX = (shiftX * layerWidth) / pixelsPerTile
  const shiftPixelsY = (shiftY * layerWidth) / pixelsPerTile

  return [shiftPixelsX, shiftPixelsY]
}

// Calculate shadow position relative to main sprite
function calculateShadowPosition(layer, allLayers) {
  // For shadows, position relative to main sprite
  if (layer.type === 'shadow' || layer.draw_as_shadow) {
    // Find the main sprite layer to get its position
    const mainSpriteLayer = allLayers.find(l => l.type !== 'shadow' && !l.draw_as_shadow)

    if (mainSpriteLayer) {
      const mainSpriteX = mainSpriteLayer.x || 0
      const mainSpriteY = mainSpriteLayer.y || 0
      const mainSpriteHeight = mainSpriteLayer.height || 0
      const mainSpriteWidth = mainSpriteLayer.width || 0
      const shadowHeight = layer.height || 0
      const shadowWidth = layer.width || 0

      // Apply shift values (convert from tiles to pixels: 1 tile = 32 pixels)
      const shiftX = layer.shift && layer.shift[0] ? layer.shift[0] * 32 : 0
      const shiftY = layer.shift && layer.shift[1] ? layer.shift[1] * 32 : 0

      const position = {
        x: mainSpriteX + (mainSpriteWidth - shadowWidth) + shiftX,
        y: mainSpriteY + (mainSpriteHeight - shadowHeight) / 2 + shiftY
      }

      return position
    }
  }

  // For non-shadows, use normal positioning
  const shiftX = layer.shift && layer.shift[0] ? layer.shift[0] * 32 : 0
  const shiftY = layer.shift && layer.shift[1] ? layer.shift[1] * 32 : 0

  const position = {
    x: (layer.x || 0) + shiftX,
    y: (layer.y || 0) + shiftY
  }

  return position
}

// Apply layer rotation and scale
function applyLayerTransform(ctx, layer, layerWidth) {
  if (layer.rotate !== undefined) {
    const radians = (layer.rotate * Math.PI) / 180
    ctx.rotate(radians)
  }

  if (layer.scale !== undefined && layer.scale !== 1) {
    ctx.scale(layer.scale, layer.scale)
  }

  // Apply normalized shift
  if (layer.shift) {
    const [shiftX, shiftY] = normalizeShift(layer.shift, layerWidth)
    ctx.translate(shiftX, shiftY)
  }
}

function applyTintAndBlend(ctx, layer, tint = null) {
  ctx.save()

  // Apply blend mode for glow/light effects
  if (layer.draw_as_glow || layer.draw_as_light) {
    ctx.globalCompositeOperation = 'lighter'
  }

  // Apply tinting
  if (layer.tint || tint) {
    const tintColor = tint || layer.tint
    if (tintColor && typeof tintColor === 'object') {
      const { a = 1 } = tintColor
      ctx.globalAlpha *= a
      // For multiply blend, we'd need to draw to offscreen canvas and composite
      // For now, we'll use a simpler approach with globalAlpha
    }
  }

  return ctx
}

function resetBlendMode(ctx) {
  ctx.globalCompositeOperation = 'source-over'
  ctx.globalAlpha = 1
  ctx.restore()
}

// Factorio blend mode implementations
const FACTORIO_BLEND_MODES = {
  normal: 'source-over',
  additive: 'lighter',
  'additive-soft': 'screen',
  multiplicative: 'multiply',
  'multiplicative-with-alpha': 'multiply',
  overwrite: 'source-atop'
}

// Custom blend mode functions for Factorio-specific blending
function applyFactorioBlendMode(ctx, layer, backgroundCanvas, activeCanvas) {
  const blendMode = layer.blend_mode || 'normal'

  // For simple blend modes, use native canvas operations
  if (FACTORIO_BLEND_MODES[blendMode]) {
    ctx.globalCompositeOperation = FACTORIO_BLEND_MODES[blendMode]
    return
  }

  // For complex blend modes, we need custom implementation
  switch (blendMode) {
    case 'additive':
      // Result = Active_RGB + Background_RGB
      ctx.globalCompositeOperation = 'lighter'
      break

    case 'additive-soft':
      // Result = Active_RGB * (1 - Background_RGB) + Background_RGB
      // This is similar to screen blend mode
      ctx.globalCompositeOperation = 'screen'
      break

    case 'multiplicative':
      // Result = Active_RGB * Background_RGB
      ctx.globalCompositeOperation = 'multiply'
      break

    case 'multiplicative-with-alpha':
      // Result = Active_RGB * Background_RGB * Active_Alpha + Background_RGB * (1 - Active_Alpha)
      // This requires custom implementation with offscreen canvas
      return applyMultiplicativeWithAlpha(ctx, layer, backgroundCanvas, activeCanvas)

    case 'overwrite':
      // Result = Active_RGBA or Background_RGBA
      ctx.globalCompositeOperation = 'source-atop'
      break

    default:
      ctx.globalCompositeOperation = 'source-over'
  }
}

// Custom implementation for multiplicative-with-alpha blend mode
function applyMultiplicativeWithAlpha(ctx, layer, backgroundCanvas, activeCanvas) {
  if (!backgroundCanvas || !activeCanvas) {
    // Fallback to regular multiply if we don't have the canvases
    ctx.globalCompositeOperation = 'multiply'
    return
  }

  // Create a temporary canvas for the blend operation
  const tempCanvas = document.createElement('canvas')
  tempCanvas.width = ctx.canvas.width
  tempCanvas.height = ctx.canvas.height
  const tempCtx = tempCanvas.getContext('2d')

  // Get image data from both canvases
  const backgroundData = backgroundCanvas
    .getContext('2d')
    .getImageData(0, 0, backgroundCanvas.width, backgroundCanvas.height)
  const activeData = activeCanvas
    .getContext('2d')
    .getImageData(0, 0, activeCanvas.width, activeCanvas.height)

  // Create result image data
  const resultData = tempCtx.createImageData(tempCanvas.width, tempCanvas.height)

  // Apply the multiplicative-with-alpha formula
  for (let i = 0; i < backgroundData.data.length; i += 4) {
    const bgR = backgroundData.data[i]
    const bgG = backgroundData.data[i + 1]
    const bgB = backgroundData.data[i + 2]
    const bgA = backgroundData.data[i + 3]

    const activeR = activeData.data[i]
    const activeG = activeData.data[i + 1]
    const activeB = activeData.data[i + 2]
    const activeA = activeData.data[i + 3] / 255 // Normalize alpha

    // Result = Active_RGB * Background_RGB * Active_Alpha + Background_RGB * (1 - Active_Alpha)
    resultData.data[i] = Math.min(255, (activeR * bgR * activeA + bgR * (1 - activeA)) / 255)
    resultData.data[i + 1] = Math.min(255, (activeG * bgG * activeA + bgG * (1 - activeA)) / 255)
    resultData.data[i + 2] = Math.min(255, (activeB * bgB * activeA + bgB * (1 - activeA)) / 255)
    resultData.data[i + 3] = Math.max(bgA, activeA * 255)
  }

  // Put the result back on the canvas
  tempCtx.putImageData(resultData, 0, 0)
  ctx.drawImage(tempCanvas, 0, 0)
}

// Apply animation speed to all layers recursively
function applyAnimationSpeedToLayers(layers, globalAnimationSpeed = 1) {
  if (!Array.isArray(layers)) return layers

  return layers.map(layer => {
    const unwrappedLayer = unWrapLayer(layer)

    // If this layer has nested layers, apply speed to them first
    if (unwrappedLayer?.layers) {
      const processedNestedLayers = applyAnimationSpeedToLayers(
        unwrappedLayer.layers,
        globalAnimationSpeed
      )
      return {
        ...unwrappedLayer,
        layers: processedNestedLayers
      }
    }

    // Apply animation speed to this layer
    const layerAnimationSpeed = unwrappedLayer.animation_speed || globalAnimationSpeed
    return {
      ...unwrappedLayer,
      animation_speed: layerAnimationSpeed
    }
  })
}

// Stripes support for multi-atlas animations
function loadImageSource(layer) {
  if (layer.stripes && Array.isArray(layer.stripes)) {
    // Calculate total dimensions from stripes
    let totalWidth = 0
    let totalHeight = 0
    let maxFramesPerRow = 0

    for (const stripe of layer.stripes) {
      const stripeWidth = stripe.width_in_frames * (layer.width || 64)
      const stripeHeight = stripe.height_in_frames * (layer.height || 64)
      totalWidth = Math.max(totalWidth, stripeWidth)
      totalHeight += stripeHeight
      maxFramesPerRow = Math.max(maxFramesPerRow, stripe.width_in_frames)
    }

    return {
      type: 'stripes',
      totalWidth,
      totalHeight,
      maxFramesPerRow,
      stripes: layer.stripes.map(stripe => ({
        filename: stripe.filename,
        widthInFrames: stripe.width_in_frames,
        heightInFrames: stripe.height_in_frames,
        x: stripe.x || 0,
        y: stripe.y || 0,
        frameWidth: layer.width || 64,
        frameHeight: layer.height || 64
      }))
    }
  }

  // Single image source
  return {
    type: 'single',
    filename: layer.filename,
    width: layer.width,
    height: layer.height
  }
}

function getStripeFrameInfo(stripes, frameIndex, frameWidth, frameHeight) {
  let _currentY = 0

  for (const stripe of stripes) {
    const stripeFrames = stripe.widthInFrames * stripe.heightInFrames
    if (frameIndex < stripeFrames) {
      const frameInStripe = frameIndex
      const frameX = (frameInStripe % stripe.widthInFrames) * frameWidth
      const frameY = Math.floor(frameInStripe / stripe.widthInFrames) * frameHeight

      return {
        filename: stripe.filename,
        x: stripe.x + frameX,
        y: stripe.y + frameY,
        width: frameWidth,
        height: frameHeight
      }
    }

    frameIndex -= stripeFrames
    _currentY += stripe.heightInFrames * frameHeight
  }

  // Fallback to first stripe
  return {
    filename: stripes[0].filename,
    x: stripes[0].x,
    y: stripes[0].y,
    width: frameWidth,
    height: frameHeight
  }
}

// Handle sprite variations
function getVariationFrameOffset(variationIndex, variationCount, framesPerVariation) {
  if (variationCount <= 1) return 0
  const clampedIndex = Math.max(0, Math.min(variationIndex, variationCount - 1))
  return clampedIndex * framesPerVariation
}

// Select variation based on props or random
function selectVariation(variationCount, variationIndex = null) {
  if (variationCount <= 1) return 0
  if (variationIndex !== null) {
    return Math.max(0, Math.min(variationIndex, variationCount - 1))
  }
  return Math.floor(Math.random() * variationCount)
}

// Enhanced error handling and fallbacks
function safeImageLoad(src, fallbackSrc = null, imageLoader) {
  return new Promise((resolve, reject) => {
    const img = imageLoader()

    img.onload = () => resolve(img)
    img.onerror = () => {
      if (fallbackSrc) {
        console.warn(`Failed to load image ${src}, trying fallback ${fallbackSrc}`)
        const fallbackImg = imageLoader()
        fallbackImg.onload = () => resolve(fallbackImg)
        fallbackImg.onerror = () => {
          console.error(`Failed to load both primary and fallback images: ${src}, ${fallbackSrc}`)
          reject(new Error(`Image load failed: ${src}`))
        }
        fallbackImg.src = fallbackSrc
      } else {
        console.error(`Failed to load image: ${src}`)
        reject(new Error(`Image load failed: ${src}`))
      }
    }

    img.src = src
  })
}

// Get safe dimensions with fallbacks
function getSafeDimensions(layer, defaultSize = 64) {
  const width = layer.width || layer.width_in_frames || defaultSize
  const height = layer.height || layer.height_in_frames || defaultSize

  if (width <= 0 || height <= 0) {
    console.warn(
      `Invalid dimensions for layer: ${width}x${height}, using fallback ${defaultSize}x${defaultSize}`
    )
    return { width: defaultSize, height: defaultSize }
  }

  return { width, height }
}

// Validate animation data
function validateAnimationData(data) {
  if (!data) {
    console.error('Animation data is null or undefined')
    return false
  }

  if (!data.filename && !data.stripes) {
    console.error('Animation data missing filename and stripes')
    return false
  }

  if (data.frame_count && data.frame_count <= 0) {
    console.warn(`Invalid frame count: ${data.frame_count}, using fallback`)
    data.frame_count = 1
  }

  return true
}

// Image cache to avoid reloading images on every frame
const imageCache = new Map()

// Environment-agnostic image loading
function createImageLoader(loadImage, graphicsPathMap = {}) {
  return filename => {
    // Convert Factorio path to public path using the mapping
    const publicPath = graphicsPathMap[filename] || filename

    // Check cache first (use original filename as cache key)
    if (imageCache.has(filename)) {
      return Promise.resolve(imageCache.get(filename))
    }

    // Create image using the provided loader with the mapped path
    const img = loadImage(publicPath)

    // If it's already a loaded image (Node.js environment), cache and return
    if (img && img.complete) {
      imageCache.set(filename, img)
      return Promise.resolve(img)
    }

    // For browser environment, handle async loading
    return new Promise((resolve, reject) => {
      if (img.onload && img.onerror) {
        img.onload = () => {
          imageCache.set(filename, img)
          resolve(img)
        }
        img.onerror = () => {
          console.error(`Failed to load image: ${filename}`)
          reject(new Error(`Image load failed: ${filename}`))
        }
      } else {
        // Already loaded
        imageCache.set(filename, img)
        resolve(img)
      }
    })
  }
}

// Main factory function
export function createFactorioAnimationEngine({
  loadImage,
  applyDOMChanges: _applyDOMChanges,
  canvas: _canvas,
  devicePixelRatio = 2,
  graphicsPathMap = {}
}) {
  const imageLoader = createImageLoader(loadImage, graphicsPathMap)

  return {
    // Store imageLoader as a property for internal use
    imageLoader,
    // Core utilities
    computeFrameIndex,
    resolveLayer,
    getHiResScale,
    normalizeShift,
    applyLayerTransform,
    applyTintAndBlend,
    resetBlendMode,
    applyFactorioBlendMode,
    FACTORIO_BLEND_MODES,
    applyAnimationSpeedToLayers,

    async renderLayeredSprite(ctx, layers, props = {}) {
      // Draw checkerboard background to show transparency
      drawCheckerboardBackground(ctx, ctx.canvas.width, ctx.canvas.height)

      // Apply animation speed to all layers recursively
      const globalAnimationSpeed = props.animation_speed || 1
      const processedLayers = applyAnimationSpeedToLayers(layers, globalAnimationSpeed)

      // Recursively flatten layers in depth-first order
      // This processes nested layer structures recursively by going deep into each branch before moving to the next
      const flattenLayers = layers => {
        const result = []

        const processLayer = layer => {
          const unwrappedLayer = unWrapLayer(layer)
          if (unwrappedLayer?.layers) {
            // If this layer has nested layers, recursively process them
            unwrappedLayer.layers.forEach(processLayer)
          } else {
            // If this is a leaf layer, add it to the result
            result.push(unwrappedLayer)
          }
        }

        layers.forEach(processLayer)
        return result
      }
      const sortedLayers = flattenLayers(processedLayers)
      //console.log(sortedLayers)
      for (let i = 0; i < sortedLayers.length; i++) {
        const layer = sortedLayers[i]

        // Save current context state
        ctx.save()
        ctx.imageSmoothingEnabled = true
        // Apply layer-specific transformations
        if (layer.filename) {
          const imageData = await this.imageLoader(layer.filename)

          // Set opacity for shadow layers
          if (layer.draw_as_shadow) {
            ctx.globalAlpha = layer.opacity || 0.5

            // Shadows in Factorio data already have their shift values built-in
            // No additional transformation needed
          } else if (layer.type === 'glow' || layer.draw_as_glow) {
            ctx.globalAlpha = layer.opacity || 0.8
          } else {
            ctx.globalAlpha = layer.opacity || 1.0
          }

          // Apply Factorio blend mode
          applyFactorioBlendMode(ctx, layer)
          // Draw the actual image if available
          if (imageData) {
            // Calculate which frame to draw using layer's animation speed
            const baseFrame = props.frame || 0
            const layerAnimationSpeed = layer.animation_speed || 1
            const adjustedFrame = Math.floor(baseFrame * layerAnimationSpeed)
            const currentFrame = adjustedFrame % (layer.frame_count || layer.repeat_count || 1)
            const framesPerRow = layer.line_length || layer.frame_count || 1 // || layer.frame_count
            const frameX = (currentFrame % framesPerRow) * layer.width
            const finalRow = layer.frame_count / layer.line_length || 1
            let frameY =
              (Math.floor(currentFrame / framesPerRow) % finalRow) *
              (layer.height || imageData.height)

            if (layer.y) {
              frameY = layer.y
            }

            // Draw the specific frame from the sprite sheet
            // Apply Factorio shift values (convert from tiles to pixels: 1 tile = 32 pixels)
            const shiftX = layer.shift && layer.shift[0] ? layer.shift[0] * 32 : 0
            const shiftY = layer.shift && layer.shift[1] ? layer.shift[1] * 32 : 0

            // Calculate destination position - center on canvas with scale
            const canvasWidth = ctx.canvas.width
            const canvasHeight = ctx.canvas.height
            const scale = layer.scale || 1.0
            const scaledWidth = layer.width * scale
            const scaledHeight = layer.height * scale

            // Calculate pixel shift: shiftTiles * 32 * scale
            const pixelShiftX = shiftX
            const pixelShiftY = shiftY

            const destX = (canvasWidth - scaledWidth) / 2 + pixelShiftX
            const destY = (canvasHeight - scaledHeight) / 2 + pixelShiftY

            //console.log(destX, destY, layer.width, layer.height)
            ctx.drawImage(
              imageData,
              frameX,
              frameY, // Source position in sprite sheet
              layer.width,
              layer.height, // Source size
              destX,
              destY, // Destination position
              scaledWidth,
              scaledHeight // Destination size (scaled)
            )
          }

          // Restore context state
          ctx.restore()
        }
      }
    },
    // Utility functions
    loadImage: imageLoader,
    loadImageSource,
    getStripeFrameInfo,
    getVariationFrameOffset,
    selectVariation,
    safeImageLoad,
    getSafeDimensions,
    validateAnimationData,

    // Unified render method
    async render(ctx, animationData, props = {}) {
      if (!animationData) {
        console.warn('No animation data provided to render')
        return
      }
      const { getRenderingMethod } = useFactorioRenderingMapping()

      const renderingMethod = getRenderingMethod(animationData)

      if (renderingMethod) {
        await this.renderLayeredSprite(ctx, renderingMethod, props)
        return
      }
      console.warn(`Unknown animation type: ${animationData.type}`)
    }
  }
}

// Default export for Node.js compatibility
export default createFactorioAnimationEngine
