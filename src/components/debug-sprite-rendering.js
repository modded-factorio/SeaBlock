#!/usr/bin/env node

/**
 * Debug Sprite Rendering
 *
 * Simple test to debug why sprites aren't rendering
 */

import { createCanvas, loadImage } from 'canvas'
import fs from 'fs'

console.log('🔍 Debug Sprite Rendering')
console.log('========================\n')

async function debugSpriteRendering() {
  // Create a simple canvas
  const canvas = createCanvas(256, 256)
  const ctx = canvas.getContext('2d')

  // Set background
  ctx.fillStyle = '#f0f0f0'
  ctx.fillRect(0, 0, 256, 256)

  console.log('📁 Testing image loading...')

  // Try to load a real Factorio sprite
  const spritePath =
    '/workspaces/SeaBlock/docs/public/data/animations/entity/assembling-machine-1/assembling-machine-1.png'

  if (fs.existsSync(spritePath)) {
    console.log(`✅ File exists: ${spritePath}`)

    try {
      const image = await loadImage(spritePath)
      console.log(`✅ Image loaded: ${image.width}x${image.height}`)

      // Try to draw the image
      console.log('🎨 Drawing image to canvas...')
      ctx.drawImage(image, 50, 50, 128, 128)

      // Add some text
      ctx.fillStyle = '#000000'
      ctx.font = '16px Arial'
      ctx.fillText('Real Factorio Sprite', 10, 30)

      // Save the result
      const outputPath = '/workspaces/SeaBlock/docs/public/generated-gifs/debug-sprite.png'
      const buffer = canvas.toBuffer('image/png')
      fs.writeFileSync(outputPath, buffer)

      console.log(`✅ Debug image saved: ${outputPath}`)
      console.log(`📊 Image size: ${buffer.length} bytes`)
    } catch (error) {
      console.error(`❌ Error loading image: ${error.message}`)
    }
  } else {
    console.log(`❌ File not found: ${spritePath}`)

    // Create a test image instead
    console.log('🎨 Creating test image...')
    ctx.fillStyle = '#ff6b6b'
    ctx.fillRect(50, 50, 128, 128)

    ctx.fillStyle = '#ffffff'
    ctx.font = '16px Arial'
    ctx.fillText('Test Image', 60, 120)

    // Save the result
    const outputPath = '/workspaces/SeaBlock/docs/public/generated-gifs/debug-test.png'
    const buffer = canvas.toBuffer('image/png')
    fs.writeFileSync(outputPath, buffer)

    console.log(`✅ Test image saved: ${outputPath}`)
  }
}

debugSpriteRendering().catch(console.error)
