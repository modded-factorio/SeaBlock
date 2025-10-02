# Factorio Animation Engine

A testable, framework-agnostic animation engine for Factorio-style sprites that can be used in both browser and Node.js environments.

## Features

- **Direction System**: Support for 4/8/16 directions with proper frame offset calculation
- **Run Modes**: Forward, backward, ping-pong, and random animation modes
- **Frame Sequences**: Custom frame ordering and timing
- **Stripes Support**: Multi-atlas animation support
- **Hi-Res Assets**: Automatic hr_version asset selection
- **Tinting & Blend Modes**: Comprehensive tinting and blend mode support
- **Speed Coupling**: Animation speed tied to activity and perceived performance
- **Belt Animation Sets**: Complete TransportBeltAnimationSet support
- **Working Visualisations**: Crafting machine working state support
- **Inserter Transforms**: Arm rotation, extension, and shadow support
- **Variation Selection**: SpriteVariations with variation selection
- **Error Handling**: Robust error handling with fallbacks

## Installation

```bash
npm install
```

## Usage

### Browser Environment

```javascript
import { createFactorioAnimationEngine } from './FactorioAnimationEngine.js'

const engine = createFactorioAnimationEngine({
  loadImage: filename => {
    const img = new Image()
    img.src = `/data/${filename}`
    return img
  },
  applyDOMChanges: mutation => {
    // Handle DOM mutations for style changes
    const element = document.querySelector(mutation.selector)
    if (element) {
      Object.assign(element.style, mutation.styles)
    }
  },
  canvas: document.getElementById('animation-canvas'),
  devicePixelRatio: window.devicePixelRatio || 2
})

// Process animation data
const animationData = engine.processAnimationData(graphicsData, {
  direction: 'north',
  workingState: 'working',
  activity: 1.5
})

// Render to canvas
const ctx = canvas.getContext('2d')
engine.renderLayeredSprite(ctx, animationData, props)
```

### Node.js Testing Environment

```javascript
import { createFactorioAnimationEngine } from './FactorioAnimationEngine.js'

// Mock implementations for testing
const mockImage = () => ({
  onload: null,
  onerror: null,
  src: '',
  width: 64,
  height: 64
})

const mockCanvas = {
  getContext: () => ({
    save: () => {},
    restore: () => {},
    scale: () => {},
    translate: () => {},
    rotate: () => {},
    drawImage: () => {},
    globalAlpha: 1,
    globalCompositeOperation: 'source-over'
  })
}

const engine = createFactorioAnimationEngine({
  loadImage: filename => {
    const img = new Image()
    img.src = `/data/${filename}`
    return img
  },
  applyDOMChanges: mutation => console.log('DOM change:', mutation),
  canvas: mockCanvas,
  devicePixelRatio: 2
})

// Test direction normalization
console.log(engine.normalizeDirection('north', 4)) // 0

// Test frame calculation
const frameIndex = engine.computeFrameIndex({
  t: 1.0,
  animationSpeed: 2.0,
  frameCount: 8,
  runMode: engine.RUN_MODES.FORWARD
})
console.log('Frame index:', frameIndex) // 2
```

## API Reference

### Factory Function

```javascript
createFactorioAnimationEngine({
  loadImage: Function, // Function to load images (filename) => Image object
  applyDOMChanges: Function, // Function to apply DOM changes
  canvas: Canvas, // Canvas element for rendering
  devicePixelRatio: Number // Device pixel ratio (default: 2)
})
```

### Core Methods

#### `normalizeDirection(direction, directionsCount)`

Normalizes direction input to a number between 0 and directionsCount-1.

#### `computeFrameIndex({ t, animationSpeed, frameCount, runMode, frameSequence })`

Calculates the current frame index based on time and animation parameters.

#### `detectAnimationType(graphicsData)`

Detects the animation type from graphics data.

#### `processAnimationData(graphicsData, size, props)`

Processes graphics data into animation data structure.

### Rendering Methods

#### `renderSpriteSheet(ctx, data, props)`

Renders a sprite sheet animation to canvas.

#### `renderLayeredSprite(ctx, data, props)`

Renders a layered sprite animation to canvas.

#### `renderBeltAnimationSet(ctx, data, props)`

Renders a belt animation set to canvas.

### Utility Methods

#### `loadImageSource(layer)`

Loads image source data, handling both single images and stripes.

#### `getStripeFrameInfo(stripes, frameIndex, frameWidth, frameHeight)`

Calculates frame information for stripe-based animations.

#### `selectVariation(variationCount, variationIndex)`

Selects a variation index for sprite variations.

#### `validateAnimationData(data)`

Validates animation data structure.

## Testing

Run the test suite:

```bash
node run-tests.js
```

Run the comprehensive test suite:

```bash
node FactorioAnimationEngine.test.js
```

The test suite includes:

- **Realistic Mocking**: Canvas operations are tracked and logged
- **DOM Changes**: Style and class changes are simulated and verified
- **Image Loading**: Simulates loading from `/public/data` folder
- **Performance Testing**: Frame calculation performance benchmarks
- **Integration Testing**: Complete animation data processing

## Examples

### Basic Animation

```javascript
const graphicsData = {
  picture: {
    filename: 'test.png',
    width: 64,
    height: 64
  }
}

const animationData = engine.processAnimationData(graphicsData, {})
```

### Layered Animation

```javascript
const graphicsData = {
  graphics_set: {
    animation: {
      layers: [
        {
          filename: 'base.png',
          width: 64,
          height: 64,
          frame_count: 8,
          line_length: 4
        }
      ]
    }
  }
}

const animationData = engine.processAnimationData(graphicsData, {
  direction: 'north',
  workingState: 'working'
})
```

### Belt Animation

```javascript
const graphicsData = {
  belt_animation_set: {
    animation_set: {
      filename: 'belt.png',
      width: 64,
      height: 64,
      frame_count: 16,
      line_length: 8,
      direction_count: 32
    },
    north_index: 1,
    south_index: 2,
    east_index: 3,
    west_index: 4
  }
}

const animationData = engine.processAnimationData(graphicsData, {
  direction: 'north',
  segmentKind: 'straight'
})
```

## Performance

The engine is optimized for performance with:

- Efficient frame calculation algorithms
- Lazy loading of images
- Hardware-accelerated canvas rendering
- Memory management for animation frames

## Error Handling

The engine includes comprehensive error handling:

- Safe image loading with fallbacks
- Data validation with warnings
- Graceful degradation for missing assets
- Console warnings for debugging

## License

MIT License - see LICENSE file for details.
