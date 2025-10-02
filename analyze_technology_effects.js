#!/usr/bin/env node

import fs from 'fs'

/**
 * Enhanced script to analyze technology unlock effects with detailed categorization
 * and logic breakdown for each effect type
 */

function analyzeTechnologies() {
  try {
    // Read the technologies JSON file
    const filePath = '/workspaces/SeaBlock/docs/public/data/en-technologies.json'
    const rawData = fs.readFileSync(filePath, 'utf8')
    const technologies = JSON.parse(rawData)

    console.log('Detailed Technology Effect Analysis')
    console.log('==================================\n')

    // Group effects by type for analysis
    const effectsByType = new Map()
    let totalEffects = 0
    let technologiesWithNonRecipeEffects = 0

    // Collect all non-recipe effects
    for (const [techName, techData] of Object.entries(technologies)) {
      if (techData.type === 'technology' && techData.effects && Array.isArray(techData.effects)) {
        const nonRecipeEffects = techData.effects.filter(effect => effect.type !== 'unlock-recipe')

        if (nonRecipeEffects.length > 0) {
          technologiesWithNonRecipeEffects++

          nonRecipeEffects.forEach(effect => {
            totalEffects++

            if (!effectsByType.has(effect.type)) {
              effectsByType.set(effect.type, [])
            }

            effectsByType.get(effect.type).push({
              technology: techName,
              displayName: techData.displayName,
              effect: effect
            })
          })
        }
      }
    }

    // Analyze each effect type in detail
    console.log('EFFECT TYPE ANALYSIS')
    console.log('====================\n')

    for (const [effectType, effects] of effectsByType) {
      console.log(`\n${effectType.toUpperCase()}`)
      console.log('='.repeat(effectType.length))
      console.log(
        `Found ${effects.length} instances across ${new Set(effects.map(e => e.technology)).size} technologies\n`
      )

      // Group by categories/parameters
      const categories = new Map()
      const modifiers = new Set()
      const specialProperties = new Set()

      effects.forEach(({ technology, displayName, effect }) => {
        // Analyze categories
        if (effect.ammo_category) {
          if (!categories.has('ammo_category')) {
            categories.set('ammo_category', new Set())
          }
          categories.get('ammo_category').add(effect.ammo_category)
        }

        if (effect.turret_id) {
          if (!categories.has('turret_id')) {
            categories.set('turret_id', new Set())
          }
          categories.get('turret_id').add(effect.turret_id)
        }

        // Analyze modifiers
        if (effect.modifier !== undefined) {
          modifiers.add(effect.modifier)
        }

        // Collect all other properties
        Object.keys(effect).forEach(key => {
          if (
            key !== 'type' &&
            key !== 'ammo_category' &&
            key !== 'turret_id' &&
            key !== 'modifier'
          ) {
            specialProperties.add(key)
          }
        })
      })

      // Display analysis
      if (categories.size > 0) {
        console.log('Categories:')
        for (const [category, values] of categories) {
          console.log(`  ${category}: ${Array.from(values).join(', ')}`)
        }
        console.log('')
      }

      if (modifiers.size > 0) {
        const sortedModifiers = Array.from(modifiers).sort((a, b) => a - b)
        console.log(`Modifier values: ${sortedModifiers.join(', ')}`)
        console.log(`  Range: ${Math.min(...sortedModifiers)} to ${Math.max(...sortedModifiers)}`)
        console.log('')
      }

      if (specialProperties.size > 0) {
        console.log(`Other properties: ${Array.from(specialProperties).join(', ')}`)
        console.log('')
      }

      // Show sample effects
      console.log('Sample effects:')
      const sampleSize = Math.min(5, effects.length)
      for (let i = 0; i < sampleSize; i++) {
        const { technology, displayName, effect } = effects[i]
        console.log(`  ${technology} (${displayName}):`)
        Object.entries(effect).forEach(([key, value]) => {
          console.log(`    ${key}: ${JSON.stringify(value)}`)
        })
        console.log('')
      }

      if (effects.length > sampleSize) {
        console.log(`  ... and ${effects.length - sampleSize} more`)
      }
    }

    // Summary by effect type
    console.log('\n\nSUMMARY BY EFFECT TYPE')
    console.log('======================\n')

    const sortedEffects = Array.from(effectsByType.entries()).sort(
      (a, b) => b[1].length - a[1].length
    )

    for (const [effectType, effects] of sortedEffects) {
      const uniqueTechs = new Set(effects.map(e => e.technology)).size
      console.log(`${effectType}: ${effects.length} effects across ${uniqueTechs} technologies`)
    }

    console.log(`\nOverall Summary:`)
    console.log(`- Technologies with non-recipe effects: ${technologiesWithNonRecipeEffects}`)
    console.log(`- Total non-recipe effects found: ${totalEffects}`)
    console.log(`- Unique effect types: ${effectsByType.size}`)
  } catch (error) {
    console.error('Error analyzing technologies:', error.message)
    process.exit(1)
  }
}

// Run the analysis
analyzeTechnologies()
