#!/usr/bin/env node

import fs from 'fs'
import path from 'path'

/**
 * Script to parse technologies JSON and output all technology unlock effects
 * that aren't recipe unlocks
 */

function parseTechnologies() {
  try {
    // Read the technologies JSON file
    const filePath = '/workspaces/SeaBlock/docs/public/data/en-technologies.json'
    const rawData = fs.readFileSync(filePath, 'utf8')
    const technologies = JSON.parse(rawData)

    console.log('Technology Unlock Effects (Non-Recipe):')
    console.log('=====================================\n')

    let totalEffects = 0
    let technologiesWithNonRecipeEffects = 0

    // Iterate through all technologies
    for (const [techName, techData] of Object.entries(technologies)) {
      if (techData.type === 'technology' && techData.effects && Array.isArray(techData.effects)) {
        const nonRecipeEffects = techData.effects.filter(effect => effect.type !== 'unlock-recipe')

        if (nonRecipeEffects.length > 0) {
          technologiesWithNonRecipeEffects++
          console.log(`Technology: ${techName}`)
          console.log(`Display Name: ${techData.displayName || 'N/A'}`)
          console.log(`Effects:`)

          nonRecipeEffects.forEach((effect, index) => {
            totalEffects++
            console.log(`  ${index + 1}. Type: ${effect.type}`)

            // Display all properties of the effect
            Object.entries(effect).forEach(([key, value]) => {
              if (key !== 'type') {
                console.log(`     ${key}: ${JSON.stringify(value)}`)
              }
            })
          })
          console.log('') // Empty line for readability
        }
      }
    }

    console.log(`\nSummary:`)
    console.log(`- Technologies with non-recipe effects: ${technologiesWithNonRecipeEffects}`)
    console.log(`- Total non-recipe effects found: ${totalEffects}`)
  } catch (error) {
    console.error('Error parsing technologies:', error.message)
    process.exit(1)
  }
}

// Run the script
parseTechnologies()
