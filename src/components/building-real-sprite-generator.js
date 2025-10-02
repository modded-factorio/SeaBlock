#!/usr/bin/env node

/**
 * Building Real GIF Generator
 *
 * This script uses node-canvas to generate actual animated GIF files with real Factorio sprites,
 * demonstrating proper sprite loading and rendering in animated format.
 */

import fs from 'fs'
import path from 'path'
import GIFEncoder from 'gifencoder'
import { createCanvas, loadImage } from 'canvas'

import { createFactorioAnimationEngine } from './FactorioAnimationEngine.js'

console.log('🎬 Building Real GIF Generator')
console.log('================================')
console.log('Usage: node building-real-sprite-generator.js [options]')
console.log('')
console.log('Options:')
console.log('  --building <name>     Specific building name (processes all if not specified)')
console.log('  --duration <seconds>  Animation duration in seconds (default: 3)')
console.log('  --fps <number>        Frames per second (default: 60)')
console.log('  --help               Show this help message')
console.log('')
console.log('Examples:')
console.log('  node building-real-sprite-generator.js')
console.log('  node building-real-sprite-generator.js --building assembling-machine-1')
console.log(
  '  node building-real-sprite-generator.js --building assembling-machine-1 --duration 5 --fps 30'
)
console.log('  node building-real-sprite-generator.js --duration 2 --fps 120')
console.log('  node building-real-sprite-generator.js --help')
console.log('')

// Mock performance object for Node.js environment
if (typeof performance === 'undefined') {
  globalThis.performance = {
    now: () => Date.now()
  }
}

// Real image loader using node-canvas
function createRealImageLoader(graphicsPathMap) {
  return async filename => {
    // Convert Factorio path to public path using the mapping
    const publicPath = graphicsPathMap[filename] || filename
    const fullPath = `/workspaces/SeaBlock/docs/public/data/${publicPath}`
    //console.log(`📁 Loading image: ${filename} -> ${publicPath}`)

    try {
      // Try to load the actual image file
      if (fs.existsSync(fullPath)) {
        const image = await loadImage(fullPath)
        //console.log(`✅ Image loaded: ${filename} (${image.width}x${image.height})`)
        return image // Store the actual image object
      } else {
        console.log(`⚠️  File not found: ${fullPath}, using placeholder`)
        return createPlaceholderImage(filename)
      }
    } catch (error) {
      console.log(`⚠️  Error loading ${filename}: ${error.message}, using placeholder`)
      return createPlaceholderImage(filename)
    }
  }
}

// Create a placeholder image when real files aren't available
function createPlaceholderImage(filename) {
  const canvas = createCanvas(64, 64)
  const ctx = canvas.getContext('2d')

  // Create a colored rectangle as placeholder
  const colors = ['#ff6b6b', '#4ecdc4', '#45b7d1', '#96ceb4', '#feca57', '#ff9ff3']
  const color = colors[Math.floor(Math.random() * colors.length)]

  ctx.fillStyle = color
  ctx.fillRect(0, 0, 64, 64)

  // Add text
  ctx.fillStyle = '#ffffff'
  ctx.font = '10px Arial'
  ctx.textAlign = 'center'
  ctx.fillText('DEMO', 32, 30)
  ctx.fillText('SPRITE', 32, 45)

  return {
    width: 64,
    height: 64,
    naturalWidth: 64,
    naturalHeight: 64,
    complete: true,
    src: filename,
    onload: null,
    onerror: null,
    canvas: canvas // Store the canvas for drawing
  }
}

// DOM changes tracker
function createDOMChangesTracker() {
  const changes = []
  let changeCount = 0

  return {
    apply: mutation => {
      changes.push(mutation)
      changeCount++
      console.log(`🎨 DOM change #${changeCount}: ${mutation.type}`)
    },
    getChanges: () => changes,
    getChangeCount: () => changeCount,
    clear: () => {
      changes.length = 0
      changeCount = 0
    }
  }
}

// Real canvas implementation using node-canvas
function createRealCanvas(width = 256, height = 256) {
  const canvas = createCanvas(width, height)
  const ctx = canvas.getContext('2d')

  return {
    canvas,
    ctx,
    width,
    height,
    getContext: () => ctx
  }
}

// Animation frame generator with real sprite rendering
class RealSpriteFrameGenerator {
  constructor(engine, canvas, domChanges) {
    this.engine = engine
    this.canvas = canvas
    this.domChanges = domChanges
    this.frames = []
    this.isGenerating = false
    this.loadedImages = new Map()
    this.processedData = null
    this.animationType = null
  }

  async generateFrames(buildingName, graphicsData, duration = 5, fps = 60) {
    console.log(`\n🎬 Generating ${duration}s animation for: ${buildingName}`)

    this.isGenerating = true
    this.frames = []

    try {
      // Detect animation type
      const animationType = this.engine.detectAnimationType(graphicsData)
      console.log(`   Animation Type: ${animationType}`)
      // Store for later re-rendering
      this.processedData = graphicsData
      this.animationType = animationType

      // Generate frames for the specified duration and FPS
      const totalFrames = duration * fps

      console.log(`   Generating ${totalFrames} frames at ${fps} FPS...`)

      for (let frame = 0; frame < totalFrames; frame++) {
        const time = frame / fps

        // Store frame data
        this.frames.push({
          frame,
          time,
          timestamp: Date.now(),
          canvas: {
            width: this.canvas.width,
            height: this.canvas.height
          }
        })

        // Progress indicator (less verbose)
        if (frame % (totalFrames / 5) === 0) {
          const progress = Math.round((frame / totalFrames) * 100)
          console.log(`   📊 Progress: ${progress}%`)
        }
      }

      console.log(`✅ Generated ${this.frames.length} frames for ${buildingName}`)
      return this.frames
    } catch (error) {
      console.error(`❌ Error generating frames for ${buildingName}:`, error.message)
      return []
    } finally {
      this.isGenerating = false
    }
  }

  async renderFrame(ctx, processedData, animationType, time, frame) {
    try {
      // Clear the canvas before rendering each frame
      ctx.clearRect(0, 0, this.canvas.width, this.canvas.height)

      // Set background color
      ctx.fillStyle = '#f8f9fa'
      ctx.fillRect(0, 0, this.canvas.width, this.canvas.height)
      // Use FactorioAnimationEngine for all rendering
      await this.engine.render(ctx, processedData, {
        direction: 0,
        activity: 1.0,
        workingState: 'idle',
        time: time,
        frame: frame,
        // Scale up animation speed for faster GIF generation
        animationSpeedMultiplier: 60.0
      })
    } catch (error) {
      console.error(`   ❌ Render error at frame ${frame}:`, error.message)
    }
  }

  // Save individual frame as PNG
  async saveFrame(buildingName, frameIndex, frame) {
    const outputDir = `/workspaces/SeaBlock/docs/public/generated-gifs/${buildingName}`
    if (!fs.existsSync(outputDir)) {
      fs.mkdirSync(outputDir, { recursive: true })
    }

    const filename = `${buildingName}-frame-${frameIndex.toString().padStart(3, '0')}.png`
    const filepath = path.join(outputDir, filename)

    const buffer = this.canvas.canvas.toBuffer('image/png')
    fs.writeFileSync(filepath, buffer)

    return filepath
  }

  // Save all frames as individual PNG files

  // Create animated GIF from frames
  async createGIF(buildingName, duration = 3, fps = 60) {
    console.log(`   🎬 Creating animated GIF for ${buildingName}...`)

    const outputDir = `/workspaces/SeaBlock/docs/public/generated-gifs`
    const gifPath = path.join(outputDir, `${buildingName}.gif`)

    // Calculate frame delay from FPS
    const frameDelay = 1000 / fps // Convert FPS to milliseconds per frame

    // Create GIF encoder
    const encoder = new GIFEncoder(this.canvas.width, this.canvas.height)
    encoder.start()
    encoder.setRepeat(0) // 0 = repeat forever
    encoder.setDelay(frameDelay) // Dynamic delay based on FPS parameter
    encoder.setQuality(10) // 1-20, lower is better quality

    // Add each frame to the GIF
    for (let i = 0; i < this.frames.length; i++) {
      const frame = this.frames[i]

      // Re-render the frame
      this.canvas.ctx.clearRect(0, 0, this.canvas.width, this.canvas.height)
      this.canvas.ctx.fillStyle = '#f8f9fa'
      this.canvas.ctx.fillRect(0, 0, this.canvas.width, this.canvas.height)

      // Re-render the sprites for this frame using the engine
      if (this.processedData) {
        await this.renderFrame(
          this.canvas.ctx,
          this.processedData,
          this.animationType,
          frame.time,
          i
        )
      } else {
        // Fallback to test rectangle
        this.canvas.ctx.fillStyle = '#ff6b6b'
        this.canvas.ctx.fillRect(200, 200, 100, 100) // Original size, centered
      }

      // Add frame info
      this.canvas.ctx.fillStyle = 'rgba(0, 0, 0, 0.7)'
      this.canvas.ctx.fillRect(0, this.canvas.height - 30, this.canvas.width, 30)
      this.canvas.ctx.fillStyle = '#ffffff'
      this.canvas.ctx.font = '14px Arial'
      this.canvas.ctx.fillText(
        `${buildingName} - Frame ${i} (${frame.time.toFixed(1)}s)`,
        10,
        this.canvas.height - 10
      )

      // Add frame to GIF
      encoder.addFrame(this.canvas.ctx)

      if (i % 15 === 0) {
        console.log(`     🎬 GIF progress: ${i}/${this.frames.length} frames`)
      }
    }

    // Finish the GIF
    encoder.finish()

    // Save the GIF
    const buffer = encoder.out.getData()
    fs.writeFileSync(gifPath, buffer)

    console.log(`   ✅ Created GIF: ${gifPath} (${buffer.length} bytes)`)
    return gifPath
  }

  // Generate building summary
  generateBuildingSummary(buildingName, graphicsData, animationType, processedData, frames) {
    const summary = {
      buildingName,
      graphicsStructure: Object.keys(graphicsData).join(', '),
      animationType,
      methodology: this.getMethodologyDescription(animationType, processedData),
      frameCount: frames.length,
      layers: this.getLayerInfo(processedData),
      dimensions: this.getDimensions(processedData),
      features: this.getFeatureList(processedData)
    }

    return summary
  }

  getMethodologyDescription(animationType, processedData) {
    switch (animationType) {
      case 'layered-sprite':
        return `Multi-layer sprite rendering with ${processedData.directions?.north?.layers?.length || 0} layers`
      case 'simple-sprite':
        return 'Single sprite rendering'
      case 'belt-animation-set':
        return 'Transport belt animation with indices and frozen patches'
      case 'sprite-sheet':
        return 'Sprite sheet animation with frame sequencing'
      default:
        return 'Unknown animation type'
    }
  }

  getLayerInfo(processedData) {
    if (processedData.directions?.north?.layers) {
      return processedData.directions.north.layers.map((layer, i) => ({
        index: i,
        filename: layer.filename,
        type: layer.type || 'sprite',
        width: layer.width,
        height: layer.height,
        frameCount: layer.frameCount || 1
      }))
    }
    return []
  }

  getDimensions(processedData) {
    if (processedData.directions?.north?.layers) {
      const layers = processedData.directions.north.layers
      const maxWidth = Math.max(...layers.map(l => (l.width || 0) + (l.x || 0)))
      const maxHeight = Math.max(...layers.map(l => (l.height || 0) + (l.y || 0)))
      return { width: maxWidth, height: maxHeight }
    }
    return { width: 0, height: 0 }
  }

  getFeatureList(processedData) {
    const features = []
    if (processedData.directions?.north?.layers) {
      const layers = processedData.directions.north.layers
      if (layers.some(l => l.drawAsShadow)) features.push('shadows')
      if (layers.some(l => l.drawAsGlow)) features.push('glow effects')
      if (layers.some(l => l.drawAsLight)) features.push('light effects')
      if (layers.some(l => l.tint)) features.push('tinting')
      if (layers.some(l => l.frameCount > 1)) features.push('animation')
    }
    return features
  }
}

// Main GIF generation function
async function generateRealBuildingGIFs(targetBuilding = null, duration = 3, fps = 60) {
  console.log('🔧 Setting up real GIF generation environment...')

  // Load buildings data and graphics path mapping first
  console.log('📖 Loading buildings data...')
  const buildingsPath = '/workspaces/SeaBlock/docs/public/data/en-buildings.json'
  const graphicsPathMapPath = '/workspaces/SeaBlock/docs/public/data/graphics-path-map.json'

  if (!fs.existsSync(buildingsPath)) {
    console.error(`❌ Buildings file not found: ${buildingsPath}`)
    process.exit(1)
  }

  if (!fs.existsSync(graphicsPathMapPath)) {
    console.error(`❌ Graphics path mapping file not found: ${graphicsPathMapPath}`)
    process.exit(1)
  }

  const buildingsData = JSON.parse(fs.readFileSync(buildingsPath, 'utf8'))
  const graphicsPathMap = JSON.parse(fs.readFileSync(graphicsPathMapPath, 'utf8'))
  const buildingNames = Object.keys(buildingsData)

  console.log(`📊 Found ${buildingNames.length} buildings to render\n`)

  // Now create the imageLoader with the graphics path mapping
  const imageLoader = createRealImageLoader(graphicsPathMap)
  const domChanges = createDOMChangesTracker()
  const canvas = createRealCanvas(256, 256) // 4x larger canvas (256 * 4 = 1024)

  const engine = createFactorioAnimationEngine({
    loadImage: imageLoader,
    applyDOMChanges: domChanges.apply,
    canvas: canvas,
    devicePixelRatio: 2,
    graphicsPathMap: graphicsPathMap
  })

  console.log('✅ Real sprite generation environment ready\n')

  // Create output directory
  const outputDir = '/workspaces/SeaBlock/docs/public/generated-gifs'
  if (!fs.existsSync(outputDir)) {
    fs.mkdirSync(outputDir, { recursive: true })
    console.log(`📁 Created output directory: ${outputDir}`)
  }

  // Initialize frame generator
  const frameGenerator = new RealSpriteFrameGenerator(engine, canvas, domChanges)

  // Determine which buildings to process
  let buildingsToRender
  if (targetBuilding) {
    if (buildingsData[targetBuilding]) {
      buildingsToRender = [targetBuilding]
      console.log(`🎯 Processing single building: ${targetBuilding}`)
    } else {
      console.log(`❌ Building '${targetBuilding}' not found in data`)
      console.log(`Available buildings: ${buildingNames.slice(0, 10).join(', ')}...`)
      return []
    }
  } else {
    buildingsToRender = buildingNames
    console.log(`🎬 Processing all ${buildingsToRender.length} buildings`)
  }

  console.log(`🎯 Rendering ${buildingsToRender.length} buildings with real sprites...\n`)

  const results = []

  for (const buildingName of buildingsToRender) {
    console.log(`\n🏗️  Processing building: ${buildingName}`)
    const buildingData = buildingsData[buildingName]

    try {
      console.log(`   📊 Graphics structure: ${Object.keys(buildingData).join(', ')}`)

      // Generate animation frames - pass the original building data (imageLoader handles path conversion)
      const frames = await frameGenerator.generateFrames(buildingName, buildingData, duration, fps)

      if (frames.length > 0) {
        // Create animated GIF
        const gifPath = await frameGenerator.createGIF(buildingName, duration, fps)

        // Generate building summary
        const summary = frameGenerator.generateBuildingSummary(
          buildingName,
          buildingData,
          frameGenerator.animationType,
          frameGenerator.processedData,
          frames
        )

        // Display building summary
        console.log(`\n   📋 Building Summary:`)
        console.log(`      🏗️  Name: ${summary.buildingName}`)
        console.log(`      🎬 Type: ${summary.animationType}`)
        console.log(`      🔧 Method: ${summary.methodology}`)
        console.log(`      📐 Dimensions: ${summary.dimensions.width}x${summary.dimensions.height}`)
        console.log(`      🎭 Layers: ${summary.layers.length}`)
        if (summary.features.length > 0) {
          console.log(`      ✨ Features: ${summary.features.join(', ')}`)
        }
        console.log(`      🌞 Shadows: Factorio shift values (tiles→pixels: ×32)`)
        console.log(`      🎞️  Frames: ${summary.frameCount} (3s @ 10fps)`)
        console.log(`      📁 Output: ${gifPath}`)

        results.push({
          buildingName,
          success: true,
          frameCount: frames.length,
          gifPath: gifPath,
          summary
        })
      } else {
        console.log(`   ❌ No frames generated for ${buildingName}`)
        results.push({
          buildingName,
          success: false,
          error: 'No frames generated'
        })
      }
    } catch (error) {
      console.error(`   ❌ Error processing ${buildingName}:`, error.message)
      results.push({
        buildingName,
        success: false,
        error: error.message
      })
    }
  }

  // Generate summary report
  console.log('\n📊 Real Sprite Generation Summary')
  console.log('==================================')

  const successful = results.filter(r => r.success)
  const failed = results.filter(r => !r.success)

  console.log(`Total Buildings Processed: ${results.length}`)
  console.log(`Successfully Generated: ${successful.length}`)
  console.log(`Failed: ${failed.length}`)
  console.log(`Success Rate: ${((successful.length / results.length) * 100).toFixed(1)}%`)

  if (successful.length > 0) {
    console.log('\n✅ Successfully Generated GIFs:')
    successful.forEach(result => {
      console.log(`  - ${result.buildingName}: ${result.frameCount} frames → ${result.gifPath}`)
    })
  }

  if (failed.length > 0) {
    console.log('\n❌ Failed to Generate:')
    failed.forEach(result => {
      console.log(`  - ${result.buildingName}: ${result.error}`)
    })
  }

  console.log(`\n📁 Output directory: ${outputDir}`)
  console.log('\n🎉 Real building GIF generation completed!')

  return results
}

// Parse command line arguments
function parseArguments() {
  const args = process.argv.slice(2)
  const options = {
    building: null,
    duration: 3,
    fps: 60,
    help: false
  }

  for (let i = 0; i < args.length; i++) {
    const arg = args[i]

    switch (arg) {
      case '--help':
      case '-h':
        options.help = true
        break
      case '--building':
      case '-b':
        options.building = args[++i]
        break
      case '--duration':
      case '-d':
        options.duration = parseFloat(args[++i])
        if (isNaN(options.duration) || options.duration <= 0) {
          console.error('❌ Invalid duration. Must be a positive number.')
          process.exit(1)
        }
        break
      case '--fps':
      case '-f':
        options.fps = parseInt(args[++i])
        if (isNaN(options.fps) || options.fps <= 0) {
          console.error('❌ Invalid FPS. Must be a positive integer.')
          process.exit(1)
        }
        break
      default:
        if (arg.startsWith('--')) {
          console.error(`❌ Unknown option: ${arg}`)
          console.log('Use --help for usage information.')
          process.exit(1)
        } else {
          console.error(`❌ Unknown argument: ${arg}`)
          console.log('Use --help for usage information.')
          process.exit(1)
        }
    }
  }

  return options
}

// Parse arguments
const options = parseArguments()

// Show help and exit
if (options.help) {
  process.exit(0)
}

// Display configuration
if (options.building) {
  console.log(`🎯 Target building specified: ${options.building}`)
} else {
  console.log('🎬 No target building specified, processing all buildings')
}

console.log(`⏱️  Duration: ${options.duration}s`)
console.log(`🎬 FPS: ${options.fps}`)
console.log('')

// Run the real GIF generation
generateRealBuildingGIFs(options.building, options.duration, options.fps).catch(console.error)
