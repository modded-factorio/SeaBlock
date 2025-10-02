#!/usr/bin/env node

import fs from 'fs'
import path from 'path'
import { fileURLToPath } from 'url'

import sharp from 'sharp'

const __filename = fileURLToPath(import.meta.url)
const __dirname = path.dirname(__filename)

/**
 * Factorio Data Processor
 *
 * Processes Factorio data dumps and generates locale-specific JSON files
 * for frontend consumption.
 *
 * APPROACH:
 * - Returns original Factorio objects with minimal transformation
 * - Enriches objects with localized names (displayName) and descriptions
 * - Converts icon paths to spritemap references
 * - Adds tooltip data for UI consumption
 * - Uses blacklist approach for buildings to exclude unwanted entity types
 * - Preserves all original Factorio properties and structure
 * - Creates separate graphics path mapping (Factorio paths -> public paths)
 * - Copies graphics files without modifying original data
 *
 * SEMANTIC CHANGES:
 * - Groups: Added 'subgroups' property containing all subgroups for the group
 * - All entities: Added 'displayName' and 'description' properties with localized text
 * - All entities: Added 'icon' property with spritemap reference instead of raw path
 * - All entities: Added 'tooltip' property with structured tooltip data
 * - Buildings: Uses blacklist instead of whitelist for entity type filtering
 * - Graphics: Separate graphics-path-map.json file maps Factorio paths to public paths
 */

class FactorioDataProcessor {
  constructor(dataDumpsPath = './data-dumps') {
    this.dataDumpsPath = dataDumpsPath
    this.outputPath = './docs/public/data'
    this.rawData = null
    this.localeData = {}
    this.spritemap = {}
    this.spritemapIndex = 0
    this.graphicsPathMap = {} // Maps Factorio paths to public paths
  }

  /**
   * Load and parse the raw data dump
   */
  async loadRawData() {
    console.log('Loading raw data dump...')
    const rawDataPath = path.join(this.dataDumpsPath, 'data-raw-dump.json')

    try {
      const rawDataContent = fs.readFileSync(rawDataPath, 'utf8')
      this.rawData = JSON.parse(rawDataContent)
      console.log('✓ Raw data loaded successfully')
    } catch (error) {
      console.error('✗ Failed to load raw data:', error.message)
      throw error
    }
  }

  /**
   * Load all locale files
   */
  async loadLocaleData() {
    console.log('Loading locale data...')

    const localeFiles = [
      'recipe-locale.json',
      'item-locale.json',
      'item-group-locale.json',
      'item-subgroup-locale.json',
      'fluid-locale.json',
      'tile-locale.json',
      'technology-locale.json',
      'entity-locale.json',
      'equipment-locale.json'
    ]

    for (const localeFile of localeFiles) {
      const localePath = path.join(this.dataDumpsPath, localeFile)
      const localeType = localeFile.replace('-locale.json', '')

      try {
        if (fs.existsSync(localePath)) {
          const content = fs.readFileSync(localePath, 'utf8')
          this.localeData[localeType] = JSON.parse(content)
          console.log(`✓ Loaded ${localeFile}`)
        } else {
          console.log(`⚠ ${localeFile} not found, skipping...`)
        }
      } catch (error) {
        console.error(`✗ Failed to load ${localeFile}:`, error.message)
      }
    }
  }

  /**
   * Get localized name for an entity
   */
  getLocalizedName(entityType, entityName, fallback = null) {
    const locale = this.localeData[entityType]
    if (locale && locale.names && locale.names[entityName]) {
      return locale.names[entityName]
    }
    return fallback || entityName
  }

  /**
   * Get localized description for an entity
   */
  getLocalizedDescription(entityType, entityName, fallback = null) {
    const locale = this.localeData[entityType]
    if (locale && locale.descriptions && locale.descriptions[entityName]) {
      return locale.descriptions[entityName]
    }
    return fallback || ''
  }

  /**
   * Add icon to spritemap and return spritemap reference
   */
  addToSpritemap(_iconPath, entityType, entityName) {
    if (!entityType || !entityName) return null

    // Simply look for a file with the same name as the entity in the appropriate directory
    const sourcePath = path.join(this.dataDumpsPath, entityType, `${entityName}.png`)

    // Check if source file exists
    if (!fs.existsSync(sourcePath)) {
      console.warn(`Icon file not found: ${sourcePath}`)
      return null
    }

    // Create spritemap key
    const spritemapKey = `${entityType}-${entityName}`

    // Add to spritemap if not already present
    if (!this.spritemap[spritemapKey]) {
      this.spritemap[spritemapKey] = {
        x: this.spritemapIndex * 64, // Will be updated during spritemap generation
        y: 0,
        width: 64,
        height: 64,
        source: sourcePath
      }
      this.spritemapIndex++
    }

    return spritemapKey
  }

  /**
   * Convert Factorio internal icon path to spritemap reference
   */
  convertIconPath(iconPath, entityType, entityName) {
    if (!entityType || !entityName) return null

    // Add to spritemap and return reference
    const spritemapKey = this.addToSpritemap(iconPath, entityType, entityName)
    return spritemapKey ? `spritemap:${spritemapKey}` : null
  }

  /**
   * Copy graphics file to public directory and return public path
   */
  copyGraphicsFile(graphicsPath, entityType, entityName) {
    if (!graphicsPath) return null

    let sourcePath = null
    let publicPath = null

    // Convert Factorio internal paths to source paths
    if (graphicsPath.startsWith('__base__/graphics/')) {
      sourcePath = path.join(
        this.dataDumpsPath,
        'raw-graphics',
        graphicsPath.replace('__base__/graphics/', '')
      )
      publicPath = `animations/${graphicsPath.replace('__base__/graphics/', '')}`
    } else if (graphicsPath.startsWith('__core__/graphics/')) {
      sourcePath = path.join(
        this.dataDumpsPath,
        'raw-graphics/core',
        graphicsPath.replace('__core__/graphics/', '')
      )
      publicPath = `animations/core/${graphicsPath.replace('__core__/graphics/', '')}`
    } else if (graphicsPath.startsWith('__') && graphicsPath.includes('__/graphics/')) {
      // Handle mod graphics
      const match = graphicsPath.match(/^__(.+?)__\/graphics\/(.+)$/)
      if (match) {
        const modName = match[1]
        const modGraphicsPath = match[2]

        // Try to find the actual mod directory (handle versioned mod names)
        const rawGraphicsDir = path.join(this.dataDumpsPath, 'raw-graphics')
        let actualModDir = modName

        // Check if the exact mod name directory exists
        if (!fs.existsSync(path.join(rawGraphicsDir, modName))) {
          // Look for versioned mod directories (e.g., bobplates_2.0.3)
          try {
            const dirs = fs.readdirSync(rawGraphicsDir, { withFileTypes: true })
            const matchingDir = dirs.find(
              dirent => dirent.isDirectory() && dirent.name.startsWith(modName + '_')
            )
            if (matchingDir) {
              actualModDir = matchingDir.name
            }
          } catch (err) {
            console.warn(`Could not read raw-graphics directory: ${err.message}`)
          }
        }

        sourcePath = path.join(this.dataDumpsPath, 'raw-graphics', actualModDir, modGraphicsPath)
        publicPath = `animations/${modName}/${modGraphicsPath}`
      }
    }

    if (!sourcePath || !publicPath) {
      // Fallback: try to construct path from entity name
      if (entityName) {
        sourcePath = path.join(
          this.dataDumpsPath,
          'raw-graphics/entity',
          entityName,
          `${entityName}.png`
        )
        publicPath = `animations/entity/${entityName}/${entityName}.png`
      } else {
        return null
      }
    }

    // Check if source file exists
    if (!fs.existsSync(sourcePath)) {
      console.warn(`Graphics file not found: ${sourcePath}`)
      return null
    }

    // Create destination directory
    const destPath = path.join(this.outputPath, publicPath)
    const destDir = path.dirname(destPath)
    if (!fs.existsSync(destDir)) {
      fs.mkdirSync(destDir, { recursive: true })
    }

    // Copy file if it doesn't exist
    if (!fs.existsSync(destPath)) {
      fs.copyFileSync(sourcePath, destPath)
    }

    return publicPath
  }

  /**
   * Convert Factorio internal graphics path to public path and populate mapping
   */
  convertGraphicsPath(graphicsPath, entityType, entityName) {
    if (!graphicsPath) return null

    // Check if we already have this path mapped
    if (this.graphicsPathMap[graphicsPath]) {
      return this.graphicsPathMap[graphicsPath]
    }

    // Convert and copy the file
    const publicPath = this.copyGraphicsFile(graphicsPath, entityType, entityName)

    // Store the mapping
    if (publicPath) {
      this.graphicsPathMap[graphicsPath] = publicPath
    }

    return publicPath
  }

  /**
   * Recursively collect graphics paths from an object to populate the mapping
   */
  collectGraphicsPaths(obj) {
    if (typeof obj !== 'object' || obj === null) {
      return
    }

    if (Array.isArray(obj)) {
      obj.forEach(item => this.collectGraphicsPaths(item))
      return
    }

    // Collect filename paths
    if (obj.filename && typeof obj.filename === 'string') {
      this.convertGraphicsPath(obj.filename, 'entity', '')
    }

    // Recursively process all properties
    Object.keys(obj).forEach(key => {
      this.collectGraphicsPaths(obj[key])
    })
  }

  /**
   * Process groups and subgroups data
   * Returns original Factorio objects enriched with localized names and subgroups
   */
  processGroups() {
    console.log('Processing groups and subgroups...')
    const groups = this.rawData['item-group'] || {}
    const subgroups = this.rawData['item-subgroup'] || {}
    const processedGroups = {}

    // Process groups - return original objects with enrichment
    for (const [groupName, groupData] of Object.entries(groups)) {
      if (groupData.hidden) continue

      const localizedName = this.getLocalizedName('item-group', groupName)

      // Return original group data with enrichment
      processedGroups[groupName] = {
        ...groupData,
        displayName: localizedName,
        icon: this.convertIconPath(groupData.icon, 'item-group', groupName),
        subgroups: []
      }
    }

    // Process subgroups and assign to groups
    for (const [subgroupName, subgroupData] of Object.entries(subgroups)) {
      if (subgroupData.hidden) continue

      const parentGroup = subgroupData.group
      if (parentGroup && processedGroups[parentGroup]) {
        const localizedName = this.getLocalizedName('item-subgroup', subgroupName)

        const subgroupInfo = {
          ...subgroupData,
          displayName: localizedName
        }

        processedGroups[parentGroup].subgroups.push(subgroupInfo)
      }
    }

    // Sort subgroups within each group
    for (const group of Object.values(processedGroups)) {
      group.subgroups.sort((a, b) => a.order.localeCompare(b.order))
    }

    return processedGroups
  }

  /**
   * Process ingredients for recipes
   */
  processIngredients(ingredients) {
    if (!ingredients) return []

    if (Array.isArray(ingredients)) {
      return ingredients.map(ingredient => ({
        name: ingredient.name,
        type: ingredient.type,
        amount: ingredient.amount,
        displayName: this.getLocalizedName(ingredient.type, ingredient.name)
      }))
    }

    return []
  }

  /**
   * Process results for recipes
   */
  processResults(results) {
    if (!results) return []

    if (Array.isArray(results)) {
      return results.map(result => ({
        name: result.name,
        type: result.type,
        amount: result.amount,
        probability: result.probability,
        displayName: this.getLocalizedName(result.type, result.name)
      }))
    }

    return []
  }

  /**
   * Process technology effects
   */
  processTechnologyEffects(effects) {
    if (!effects || !Array.isArray(effects)) return []

    return effects.map(effect => ({
      type: effect.type,
      recipe: effect.recipe,
      modifier: effect.modifier,
      ammoCategory: effect.ammo_category,
      targetType: effect.target_type,
      targetValue: effect.target_value
    }))
  }

  /**
   * Process technology icons
   */
  processTechnologyIcons(techData, techName) {
    // Handle both simple icon format and complex icons array format
    if (techData.icons && Array.isArray(techData.icons)) {
      // Complex icons array format
      return techData.icons.map(icon => ({
        icon: this.convertIconPath(icon.icon, 'technology', techName),
        iconSize: icon.icon_size,
        scale: icon.scale,
        shift: icon.shift
      }))
    } else if (techData.icon) {
      // Simple icon format
      return [
        {
          icon: this.convertIconPath(techData.icon, 'technology', techName),
          iconSize: techData.icon_size,
          scale: null,
          shift: null
        }
      ]
    }

    return []
  }

  /**
   * Generate tooltip for recipes
   */
  generateRecipeTooltip(recipeData, displayName, description, recipeName) {
    const tooltip = {
      title: displayName,
      description,
      icon: this.convertIconPath(recipeData.icon, 'recipe', recipeName),
      details: []
    }

    if (recipeData.energy_required) {
      tooltip.details.push(`Crafting time: ${recipeData.energy_required}s`)
    }

    if (recipeData.ingredients && Array.isArray(recipeData.ingredients)) {
      const ingredients = recipeData.ingredients
        .map(ing => `${ing.amount} ${this.getLocalizedName(ing.type, ing.name)}`)
        .join(', ')
      tooltip.details.push(`Ingredients: ${ingredients}`)
    }

    if (recipeData.results && Array.isArray(recipeData.results)) {
      const results = recipeData.results
        .map(result => `${result.amount} ${this.getLocalizedName(result.type, result.name)}`)
        .join(', ')
      tooltip.details.push(`Results: ${results}`)
    }

    return tooltip
  }

  /**
   * Generate tooltip for items
   */
  generateItemTooltip(itemData, displayName, description, itemName) {
    const tooltip = {
      title: displayName,
      description,
      icon: this.convertIconPath(itemData.icon, 'item', itemName),
      details: []
    }

    if (itemData.stack_size) {
      tooltip.details.push(`Stack size: ${itemData.stack_size}`)
    }

    if (itemData.fuel_value) {
      tooltip.details.push(`Fuel value: ${itemData.fuel_value}`)
    }

    if (itemData.place_as_equipment_result) {
      tooltip.details.push(
        `Equipment: ${this.getLocalizedName('equipment', itemData.place_as_equipment_result)}`
      )
    }

    return tooltip
  }

  /**
   * Generate tooltip for fluids
   */
  generateFluidTooltip(fluidData, displayName, description, fluidName) {
    const tooltip = {
      title: displayName,
      description,
      icon: this.convertIconPath(fluidData.icon, 'fluid', fluidName),
      details: []
    }

    if (fluidData.default_temperature !== undefined) {
      tooltip.details.push(`Default temperature: ${fluidData.default_temperature}°C`)
    }

    if (fluidData.max_temperature !== undefined) {
      tooltip.details.push(`Max temperature: ${fluidData.max_temperature}°C`)
    }

    return tooltip
  }

  /**
   * Generate tooltip for tiles
   */
  generateTileTooltip(tileData, displayName, description, tileName) {
    const tooltip = {
      title: displayName,
      description,
      icon: this.convertIconPath(tileData.icon, 'tile', tileName),
      details: []
    }

    if (tileData.layer !== undefined) {
      tooltip.details.push(`Layer: ${tileData.layer}`)
    }

    if (tileData.layer_group) {
      tooltip.details.push(`Layer group: ${tileData.layer_group}`)
    }

    return tooltip
  }

  /**
   * Generate tooltip for technologies
   */
  generateTechnologyTooltip(techData, displayName, description, techName) {
    const processedIcons = this.processTechnologyIcons(techData, techName)
    const tooltip = {
      title: displayName,
      description,
      icon: processedIcons.length > 0 ? processedIcons[0].icon : null,
      details: []
    }

    if (techData.prerequisites && techData.prerequisites.length > 0) {
      const prereqs = techData.prerequisites
        .map(prereq => this.getLocalizedName('technology', prereq))
        .join(', ')
      tooltip.details.push(`Prerequisites: ${prereqs}`)
    }

    if (techData.unit) {
      tooltip.details.push(`Research cost: ${techData.unit.count} ${techData.unit.time}s`)
    }

    if (techData.effects && techData.effects.length > 0) {
      const effects = techData.effects
        .map(effect => {
          if (effect.type === 'unlock-recipe') {
            return `Unlocks: ${this.getLocalizedName('recipe', effect.recipe)}`
          }
          return `${effect.type}: ${effect.modifier || effect.target_value}`
        })
        .join(', ')
      tooltip.details.push(`Effects: ${effects}`)
    }

    return tooltip
  }

  /**
   * Generate tooltip for buildings
   */
  generateBuildingTooltip(buildingData, displayName, description, buildingName) {
    const tooltip = {
      title: displayName,
      description,
      icon: this.convertIconPath(buildingData.icon, 'entity', buildingName),
      details: []
    }

    if (buildingData.max_health) {
      tooltip.details.push(`Health: ${buildingData.max_health}`)
    }

    if (buildingData.minable && buildingData.minable.mining_time) {
      tooltip.details.push(`Mining time: ${buildingData.minable.mining_time}s`)
    }

    if (buildingData.flags && buildingData.flags.length > 0) {
      tooltip.details.push(`Flags: ${buildingData.flags.join(', ')}`)
    }

    return tooltip
  }

  /**
   * Create output directory
   */
  createOutputDirectory() {
    if (!fs.existsSync(this.outputPath)) {
      fs.mkdirSync(this.outputPath, { recursive: true })
      console.log(`✓ Created output directory: ${this.outputPath}`)
    }

    // Create subdirectories for different asset types
    const subdirs = ['icons', 'sprites', 'animations']
    subdirs.forEach(subdir => {
      const subdirPath = path.join(this.outputPath, subdir)
      if (!fs.existsSync(subdirPath)) {
        fs.mkdirSync(subdirPath, { recursive: true })
      }
    })
  }

  /**
   * Procedural approach: Collect and route all entities appropriately
   * Groups are handled separately (item-group, item-subgroup)
   */
  collectAndRouteEntities() {
    console.log('Collecting and routing entities procedurally...')

    // Define blacklist of types that should NOT be processed as buildings
    const buildingBlacklist = new Set([
      // Handled by specific processors
      'item',
      'fluid',
      'technology',
      'recipe',
      'tile',
      'item-group',
      'item-subgroup', // Handled separately

      // Item subtypes (handled by items processor)
      'module',
      'equipment',
      'gun',
      'ammo',
      'armor',
      'tool',
      'capsule',
      'blueprint',
      'blueprint-book',
      'deconstruction-item',
      'repair-tool',
      'spidertron-remote',
      'upgrade-item',
      'item-with-entity-data',

      // Decorative/utility entities
      'corpse',
      'explosion',
      'fire',
      'smoke',
      'particle',
      'optimized-particle',
      'optimized-decorative',
      'trivial-smoke',
      'ambient-sound',
      'utility-sounds',
      'utility-sprites',
      'font',
      'sprite',
      'noise-expression',
      'noise-function',
      'autoplace-control',
      'collision-layer',
      'damage-type',
      'impact-category',
      'fuel-category',
      'ammo-category',
      'module-category',
      'recipe-category',
      'resource-category',
      'equipment-category',
      'deliver-category',
      'surface-property',
      'trigger-target-type',
      'quality',
      'map-gen-presets',
      'map-settings',
      'utility-constants',
      'mouse-cursor',
      'gui-style',
      'shortcut',
      'custom-input',
      'tips-and-tricks-item',
      'tips-and-tricks-item-category',
      'tutorial',
      'achievement',
      'build-entity-achievement',
      'kill-achievement',
      'produce-achievement',
      'produce-per-hour-achievement',
      'research-achievement',
      'research-with-science-pack-achievement',
      'construct-with-robots-achievement',
      'deconstruct-with-robots-achievement',
      'deliver-by-robots-achievement',
      'dont-build-entity-achievement',
      'dont-craft-manually-achievement',
      'dont-kill-manually-achievement',
      'dont-use-entity-in-energy-production-achievement',
      'use-entity-in-energy-production-achievement',
      'player-damaged-achievement',
      'deplete-resource-achievement',
      'destroy-cliff-achievement',
      'shoot-achievement',
      'group-attack-achievement',
      'train-path-achievement',
      'combat-robot-count-achievement',
      'complete-objective-achievement',
      'deliver-impact-combination',

      // Planning/editor tools (not buildings)
      'rail-planner',
      'copy-paste-tool',
      'selection-tool',

      'procession-layer-inheritance-group',
      'highlight-box',
      // Ghost entities
      'entity-ghost',
      'tile-ghost',
      'equipment-ghost',

      // Controllers and special entities
      'character-corpse',
      'editor-controller',
      'god-controller',
      'spectator-controller',
      'remote-controller',
      'spidertron-remote',

      // Special effects and visuals
      'beam',
      'arrow',
      'sticker',

      // Spidertron parts
      'spider-vehicle',
      'spider-unit',
      'spider-leg',

      // Temporary entities
      'temporary-container',
      'proxy-container',
      'item-request-proxy',
      'item-entity',
      'linked-container',
      'linked-belt',

      // Rail remnants
      'rail-remnants',

      // Special equipment
      'equipment-grid',
      'equipment-category',

      // Virtual signals and streams (not buildings)
      'virtual-signal',
      'stream',

      'speech-bubble',
      'artillery-projectile',
      'poison-cloud',
      // Additional blacklisted entity types
      'particle-source',
      'projectile',
      'tile-effect',
      'rocket-silo-rocket-shadow',
      'rocket-silo-rocket',
      'airborne-pollutant',
      'smoke-with-trigger',
      'solar-panel-equipment',
      'generator-equipment',
      'battery-equipment',
      'energy-shield-equipment',
      'night-vision-equipment',
      'movement-bonus-equipment',
      'belt-immunity-equipment',
      'active-defense-equipment',
      'roboport-equipment',
      'burner-usage',
      'procession',
      'deconstructible-tile-proxy',
      'delayed-active-trigger',

      //Potentially useful stuff
      'asteroid-chunk',
      'planet',
      'space-location'
    ])

    const processedData = {
      items: {},
      recipes: {},
      fluids: {},
      tiles: {},
      technologies: {},
      buildings: {}
    }

    // Process items (including item subtypes)
    const itemTypes = [
      'item',
      'module',
      'equipment',
      'gun',
      'ammo',
      'armor',
      'tool',
      'capsule',
      'blueprint',
      'blueprint-book',
      'deconstruction-item',
      'repair-tool',
      'spidertron-remote',
      'upgrade-item',
      'item-with-entity-data',
      'rail-planner',
      'solar-panel-equipment',
      'generator-equipment',
      'battery-equipment',
      'energy-shield-equipment',
      'night-vision-equipment',
      'movement-bonus-equipment',
      'belt-immunity-equipment',
      'active-defense-equipment',
      'roboport-equipment'
    ]
    Object.entries(this.rawData).forEach(([categoryKey, categoryData]) => {
      if (typeof categoryData !== 'object' || categoryData === null) return
      Object.entries(categoryData).forEach(([entityKey, entityData]) => {
        if (typeof entityData !== 'object' || entityData === null || !entityData.type) return
        if (itemTypes.includes(entityData.type)) {
          const processedItem = this.processEntityAsItem(entityData, entityKey, entityData.type)
          if (processedItem) {
            processedData.items[entityKey] = processedItem
          }
        }
      })
    })

    // Process recipes
    Object.entries(this.rawData).forEach(([categoryKey, categoryData]) => {
      if (typeof categoryData !== 'object' || categoryData === null) return
      Object.entries(categoryData).forEach(([entityKey, entityData]) => {
        if (typeof entityData !== 'object' || entityData === null || !entityData.type) return
        if (entityData.type === 'recipe') {
          const processedRecipe = this.processEntityAsRecipe(entityData, entityKey)
          if (processedRecipe) {
            processedData.recipes[entityKey] = processedRecipe
          }
        }
      })
    })

    // Process fluids
    Object.entries(this.rawData).forEach(([categoryKey, categoryData]) => {
      if (typeof categoryData !== 'object' || categoryData === null) return
      Object.entries(categoryData).forEach(([entityKey, entityData]) => {
        if (typeof entityData !== 'object' || entityData === null || !entityData.type) return
        if (entityData.type === 'fluid') {
          const processedFluid = this.processEntityAsFluid(entityData, entityKey)
          if (processedFluid) {
            processedData.fluids[entityKey] = processedFluid
          }
        }
      })
    })

    // Process tiles
    Object.entries(this.rawData).forEach(([categoryKey, categoryData]) => {
      if (typeof categoryData !== 'object' || categoryData === null) return
      Object.entries(categoryData).forEach(([entityKey, entityData]) => {
        if (typeof entityData !== 'object' || entityData === null || !entityData.type) return
        if (entityData.type === 'tile') {
          const processedTile = this.processEntityAsTile(entityData, entityKey)
          if (processedTile) {
            processedData.tiles[entityKey] = processedTile
          }
        }
      })
    })

    // Process technologies
    Object.entries(this.rawData).forEach(([categoryKey, categoryData]) => {
      if (typeof categoryData !== 'object' || categoryData === null) return
      Object.entries(categoryData).forEach(([entityKey, entityData]) => {
        if (typeof entityData !== 'object' || entityData === null || !entityData.type) return
        if (entityData.type === 'technology') {
          const processedTech = this.processEntityAsTechnology(entityData, entityKey)
          if (processedTech) {
            processedData.technologies[entityKey] = processedTech
          }
        }
      })
    })

    // Process buildings (everything not blacklisted)
    Object.entries(this.rawData).forEach(([categoryKey, categoryData]) => {
      if (typeof categoryData !== 'object' || categoryData === null) return
      Object.entries(categoryData).forEach(([entityKey, entityData]) => {
        if (typeof entityData !== 'object' || entityData === null || !entityData.type) return
        if (!buildingBlacklist.has(entityData.type)) {
          const processedBuilding = this.processEntityAsBuilding(
            entityData,
            entityKey,
            entityData.type
          )
          if (processedBuilding) {
            processedData.buildings[entityKey] = processedBuilding
          }
        }
      })
    })

    return processedData
  }

  /**
   * Process a single entity as an item
   */
  processEntityAsItem(entityData, entityName, entityType) {
    const localizedName = this.getLocalizedName(entityType, entityName)
    const localizedDescription = this.getLocalizedDescription(entityType, entityName)

    return {
      ...entityData,
      displayName: localizedName,
      description: localizedDescription,
      icon: this.convertIconPath(`${entityType}/${entityName}.png`, 'item', entityName),
      tooltip: this.generateItemTooltip(entityData, localizedName, localizedDescription, entityName)
    }
  }

  /**
   * Process a single entity as a recipe
   */
  processEntityAsRecipe(entityData, entityName) {
    const localizedName = this.getLocalizedName('recipe', entityName)
    const localizedDescription = this.getLocalizedDescription('recipe', entityName)

    return {
      ...entityData,
      displayName: localizedName,
      description: localizedDescription,
      icon: this.convertIconPath(`recipe/${entityName}.png`, 'recipe', entityName),
      tooltip: this.generateRecipeTooltip(
        entityData,
        localizedName,
        localizedDescription,
        entityName
      )
    }
  }

  /**
   * Process a single entity as a fluid
   */
  processEntityAsFluid(entityData, entityName) {
    const localizedName = this.getLocalizedName('fluid', entityName)
    const localizedDescription = this.getLocalizedDescription('fluid', entityName)

    return {
      ...entityData,
      displayName: localizedName,
      description: localizedDescription,
      icon: this.convertIconPath(`fluid/${entityName}.png`, 'fluid', entityName),
      tooltip: this.generateFluidTooltip(
        entityData,
        localizedName,
        localizedDescription,
        entityName
      )
    }
  }

  /**
   * Process a single entity as a tile
   */
  processEntityAsTile(entityData, entityName) {
    const localizedName = this.getLocalizedName('tile', entityName)
    const localizedDescription = this.getLocalizedDescription('tile', entityName)

    return {
      ...entityData,
      displayName: localizedName,
      description: localizedDescription,
      icon: this.convertIconPath(`tile/${entityName}.png`, 'tile', entityName),
      tooltip: this.generateTileTooltip(entityData, localizedName, localizedDescription, entityName)
    }
  }

  /**
   * Process a single entity as a technology
   */
  processEntityAsTechnology(entityData, entityName) {
    const localizedName = this.getLocalizedName('technology', entityName)
    const localizedDescription = this.getLocalizedDescription('technology', entityName)

    return {
      ...entityData,
      displayName: localizedName,
      description: localizedDescription,
      icons: this.convertIconPath(`technology/${entityName}.png`, 'technology', entityName),
      effects: entityData.effects || [],
      tooltip: this.generateTechnologyTooltip(
        entityData,
        localizedName,
        localizedDescription,
        entityName
      )
    }
  }

  /**
   * Process a single entity as a building
   */
  processEntityAsBuilding(entityData, entityName, entityType) {
    const localizedName = this.getLocalizedName(entityType, entityName)
    const localizedDescription = this.getLocalizedDescription(entityType, entityName)

    const processedBuilding = {
      ...entityData,
      displayName: localizedName,
      description: localizedDescription,
      icon: this.convertIconPath(`entity/${entityName}.png`, 'entity', entityName),
      tooltip: this.generateBuildingTooltip(
        entityData,
        localizedName,
        localizedDescription,
        entityName
      )
    }

    // Collect graphics paths for this building
    this.collectGraphicsPaths(processedBuilding)

    return processedBuilding
  }

  /**
   * Write processed data to files
   */
  async writeProcessedData() {
    console.log('Writing processed data...')
    this.createOutputDirectory()

    // Use the new procedural approach for all entities except groups
    const proceduralData = this.collectAndRouteEntities()

    const dataTypes = {
      groups: this.processGroups(), // Groups handled separately as requested
      ...proceduralData
    }

    for (const [dataType, data] of Object.entries(dataTypes)) {
      const outputFile = path.join(this.outputPath, `en-${dataType}.json`)
      fs.writeFileSync(outputFile, JSON.stringify(data, null, 2))
      console.log(`✓ Written ${Object.keys(data).length} ${dataType} to ${outputFile}`)
    }

    // Generate tooltips file
    const tooltips = this.generateTooltipsFile(dataTypes)
    const tooltipsFile = path.join(this.outputPath, 'en-tooltips.json')
    fs.writeFileSync(tooltipsFile, JSON.stringify(tooltips, null, 2))
    console.log(`✓ Written tooltips to ${tooltipsFile}`)

    // Write graphics path mapping
    const graphicsPathFile = path.join(this.outputPath, 'graphics-path-map.json')
    fs.writeFileSync(graphicsPathFile, JSON.stringify(this.graphicsPathMap, null, 2))
    console.log(`✓ Written graphics path mapping to ${graphicsPathFile}`)

    // Add utility icons to spritemap
    this.addUtilityIcons()

    // Generate spritemap
    await this.generateSpritemap()
    console.log(`✓ Generated spritemap with ${Object.keys(this.spritemap).length} icons`)

    // Copy all entity graphics
    await this.copyAllEntityGraphics()
    console.log(`✓ Copied all entity graphics`)
  }

  /**
   * Generate consolidated tooltips file
   */
  generateTooltipsFile(dataTypes) {
    const tooltips = {}

    for (const [dataType, data] of Object.entries(dataTypes)) {
      tooltips[dataType] = {}
      for (const [itemName, itemData] of Object.entries(data)) {
        if (itemData.tooltip) {
          tooltips[dataType][itemName] = itemData.tooltip
        }
      }
    }

    return tooltips
  }

  /**
   * Generate fallback icon for utility icons
   */
  async generateFallbackIcon(spritemapKey, iconSize) {
    try {
      // Extract icon type from spritemap key
      const iconType = spritemapKey.replace('utility-', '')

      // Create a simple colored icon based on the type
      let backgroundColor = { r: 100, g: 100, b: 100, alpha: 255 } // Default gray

      // Set specific colors for different icon types
      if (
        iconType.includes('time') ||
        iconType.includes('clock') ||
        iconType.includes('duration')
      ) {
        backgroundColor = { r: 255, g: 165, b: 0, alpha: 255 } // Orange
      } else if (
        iconType.includes('electricity') ||
        iconType.includes('power') ||
        iconType.includes('energy') ||
        iconType.includes('lightning')
      ) {
        backgroundColor = { r: 255, g: 255, b: 0, alpha: 255 } // Yellow
      } else if (
        iconType.includes('science') ||
        iconType.includes('research') ||
        iconType.includes('lab') ||
        iconType.includes('flask')
      ) {
        backgroundColor = { r: 0, g: 0, b: 255, alpha: 255 } // Blue
      } else if (
        iconType.includes('production') ||
        iconType.includes('crafting') ||
        iconType.includes('factory') ||
        iconType.includes('assembly')
      ) {
        backgroundColor = { r: 255, g: 0, b: 0, alpha: 255 } // Red
      } else if (
        iconType.includes('transport') ||
        iconType.includes('logistics') ||
        iconType.includes('belt') ||
        iconType.includes('inserter')
      ) {
        backgroundColor = { r: 0, g: 255, b: 0, alpha: 255 } // Green
      } else if (
        iconType.includes('resource') ||
        iconType.includes('material') ||
        iconType.includes('ore') ||
        iconType.includes('mining')
      ) {
        backgroundColor = { r: 139, g: 69, b: 19, alpha: 255 } // Brown
      } else if (
        iconType.includes('status') ||
        iconType.includes('state') ||
        iconType.includes('active') ||
        iconType.includes('inactive')
      ) {
        backgroundColor = { r: 128, g: 0, b: 128, alpha: 255 } // Purple
      } else if (
        iconType.includes('direction') ||
        iconType.includes('movement') ||
        iconType.includes('arrow') ||
        iconType.includes('pointer')
      ) {
        backgroundColor = { r: 0, g: 128, b: 128, alpha: 255 } // Teal
      } else if (
        iconType.includes('quality') ||
        iconType.includes('efficiency') ||
        iconType.includes('speed') ||
        iconType.includes('performance')
      ) {
        backgroundColor = { r: 255, g: 192, b: 203, alpha: 255 } // Pink
      } else if (
        iconType.includes('environment') ||
        iconType.includes('nature') ||
        iconType.includes('tree') ||
        iconType.includes('water')
      ) {
        backgroundColor = { r: 0, g: 128, b: 0, alpha: 255 } // Dark green
      } else if (
        iconType.includes('technology') ||
        iconType.includes('innovation') ||
        iconType.includes('upgrade') ||
        iconType.includes('module')
      ) {
        backgroundColor = { r: 75, g: 0, b: 130, alpha: 255 } // Indigo
      }

      // Create a simple icon with background color and text
      const icon = sharp({
        create: {
          width: iconSize,
          height: iconSize,
          channels: 4,
          background: backgroundColor
        }
      })

      // Add a border
      const borderedIcon = icon.extend({
        top: 2,
        bottom: 2,
        left: 2,
        right: 2,
        background: { r: 0, g: 0, b: 0, alpha: 255 }
      })

      return await borderedIcon.png().toBuffer()
    } catch (error) {
      console.warn(`Failed to generate fallback icon for ${spritemapKey}:`, error.message)
      return null
    }
  }

  /**
   * Add utility icons to spritemap
   */
  addUtilityIcons() {
    console.log('Adding utility icons to spritemap...')

    // Use actual Factorio virtual signal icons
    const utilityIcons = [
      // Time and duration icons
      { key: 'time', signal: 'signal-clock', description: 'Time/Duration icon' },
      { key: 'clock', signal: 'signal-clock', description: 'Clock icon' },
      { key: 'hourglass', signal: 'signal-hourglass', description: 'Hourglass icon' },

      // Electricity and power icons
      { key: 'electricity', signal: 'signal-lightning', description: 'Electricity icon' },
      { key: 'power', signal: 'signal-lightning', description: 'Power icon' },
      { key: 'energy', signal: 'signal-lightning', description: 'Energy icon' },
      { key: 'lightning', signal: 'signal-lightning', description: 'Lightning bolt icon' },
      { key: 'battery', signal: 'signal-battery-full', description: 'Battery icon' },

      // Science and research icons
      { key: 'science', signal: 'signal-science-pack', description: 'Science icon' },
      { key: 'research', signal: 'signal-science-pack', description: 'Research icon' },
      { key: 'lab', signal: 'signal-science-pack', description: 'Lab icon' },
      { key: 'flask', signal: 'signal-science-pack', description: 'Flask icon' },

      // Production and crafting icons
      { key: 'production', signal: 'signal-star', description: 'Production icon' },
      { key: 'crafting', signal: 'signal-star', description: 'Crafting icon' },
      { key: 'factory', signal: 'signal-star', description: 'Factory icon' },
      { key: 'assembly', signal: 'signal-star', description: 'Assembly icon' },

      // Transport and logistics icons
      { key: 'transport', signal: 'signal-recycle', description: 'Transport icon' },
      { key: 'logistics', signal: 'signal-recycle', description: 'Logistics icon' },
      { key: 'belt', signal: 'signal-recycle', description: 'Belt icon' },
      { key: 'inserter', signal: 'signal-recycle', description: 'Inserter icon' },

      // Resource and material icons
      { key: 'resource', signal: 'signal-mining', description: 'Resource icon' },
      { key: 'material', signal: 'signal-mining', description: 'Material icon' },
      { key: 'ore', signal: 'signal-mining', description: 'Ore icon' },
      { key: 'mining', signal: 'signal-mining', description: 'Mining icon' },

      // Status and state icons
      { key: 'status', signal: 'signal-info', description: 'Status icon' },
      { key: 'state', signal: 'signal-info', description: 'State icon' },
      { key: 'active', signal: 'signal-check', description: 'Active icon' },
      { key: 'inactive', signal: 'signal-deny', description: 'Inactive icon' },

      // Direction and movement icons
      { key: 'direction', signal: 'signal-right-arrow', description: 'Direction icon' },
      { key: 'movement', signal: 'signal-right-arrow', description: 'Movement icon' },
      { key: 'arrow', signal: 'signal-right-arrow', description: 'Arrow icon' },
      { key: 'pointer', signal: 'signal-right-arrow', description: 'Pointer icon' },

      // Quality and efficiency icons
      { key: 'quality', signal: 'signal-star', description: 'Quality icon' },
      { key: 'efficiency', signal: 'signal-star', description: 'Efficiency icon' },
      { key: 'speed', signal: 'signal-speed', description: 'Speed icon' },
      { key: 'performance', signal: 'signal-speed', description: 'Performance icon' },

      // Environment and nature icons
      { key: 'environment', signal: 'signal-sun', description: 'Environment icon' },
      { key: 'nature', signal: 'signal-sun', description: 'Nature icon' },
      { key: 'tree', signal: 'signal-sun', description: 'Tree icon' },
      { key: 'water', signal: 'signal-liquid', description: 'Water icon' },

      // Technology and innovation icons
      { key: 'technology', signal: 'signal-science-pack', description: 'Technology icon' },
      { key: 'innovation', signal: 'signal-science-pack', description: 'Innovation icon' },
      { key: 'upgrade', signal: 'signal-science-pack', description: 'Upgrade icon' },
      { key: 'module', signal: 'signal-science-pack', description: 'Module icon' },

      // Additional useful icons
      { key: 'fuel', signal: 'signal-fuel', description: 'Fuel icon' },
      { key: 'damage', signal: 'signal-damage', description: 'Damage icon' },
      { key: 'fire', signal: 'signal-fire', description: 'Fire icon' },
      { key: 'explosion', signal: 'signal-explosion', description: 'Explosion icon' },
      { key: 'radioactivity', signal: 'signal-radioactivity', description: 'Radioactivity icon' },
      { key: 'weapon', signal: 'signal-weapon', description: 'Weapon icon' },
      { key: 'alarm', signal: 'signal-alarm', description: 'Alarm icon' },
      { key: 'alert', signal: 'signal-alert', description: 'Alert icon' },
      { key: 'check', signal: 'signal-check', description: 'Check icon' },
      { key: 'deny', signal: 'signal-deny', description: 'Deny icon' },
      { key: 'input', signal: 'signal-input', description: 'Input icon' },
      { key: 'output', signal: 'signal-output', description: 'Output icon' },
      { key: 'lock', signal: 'signal-lock', description: 'Lock icon' },
      { key: 'unlock', signal: 'signal-unlock', description: 'Unlock icon' },
      { key: 'info', signal: 'signal-info', description: 'Info icon' },
      { key: 'unknown', signal: 'signal-unknown', description: 'Unknown icon' },
      { key: 'ghost', signal: 'signal-ghost', description: 'Ghost icon' },
      { key: 'heart', signal: 'signal-heart', description: 'Heart icon' },
      { key: 'moon', signal: 'signal-moon', description: 'Moon icon' },
      { key: 'sun', signal: 'signal-sun', description: 'Sun icon' },
      { key: 'snowflake', signal: 'signal-snowflake', description: 'Snowflake icon' },
      { key: 'star', signal: 'signal-star', description: 'Star icon' },
      { key: 'white-flag', signal: 'signal-white-flag', description: 'White flag icon' },
      { key: 'skull', signal: 'signal-skull', description: 'Skull icon' },
      { key: 'map-marker', signal: 'signal-map-marker', description: 'Map marker icon' },
      { key: 'trash', signal: 'signal-trash-bin', description: 'Trash icon' },
      { key: 'recycle', signal: 'signal-recycle', description: 'Recycle icon' }
    ]

    for (const icon of utilityIcons) {
      const spritemapKey = `utility-${icon.key}`

      // Add to spritemap if not already present
      if (!this.spritemap[spritemapKey]) {
        this.spritemap[spritemapKey] = {
          x: this.spritemapIndex * 64, // Will be updated during spritemap generation
          y: 0,
          width: 64,
          height: 64,
          source: path.join(this.dataDumpsPath, 'virtual-signal', `${icon.signal}.png`),
          description: icon.description
        }
        this.spritemapIndex++
      }
    }

    console.log(`✓ Added ${utilityIcons.length} utility icons to spritemap`)
  }

  /**
   * Generate spritemap from collected icons
   */
  async generateSpritemap() {
    if (Object.keys(this.spritemap).length === 0) {
      console.log('No icons to generate spritemap')
      return
    }

    console.log(`Generating spritemap with ${Object.keys(this.spritemap).length} icons...`)

    // Calculate spritemap dimensions
    const iconsPerRow = Math.ceil(Math.sqrt(Object.keys(this.spritemap).length))
    const iconSize = 64 // Standard Factorio icon size
    const spritemapWidth = iconsPerRow * iconSize
    const spritemapHeight = Math.ceil(Object.keys(this.spritemap).length / iconsPerRow) * iconSize

    console.log(
      `Spritemap dimensions: ${spritemapWidth}x${spritemapHeight} (${iconsPerRow} icons per row)`
    )

    // Create a blank canvas for the spritemap
    const spritemapCanvas = sharp({
      create: {
        width: spritemapWidth,
        height: spritemapHeight,
        channels: 4,
        background: { r: 0, g: 0, b: 0, alpha: 0 } // Transparent background
      }
    })

    // Prepare composite operations for all icons
    const compositeOperations = []
    const updatedSpritemap = {}

    let iconIndex = 0
    for (const [spritemapKey, spriteData] of Object.entries(this.spritemap)) {
      const row = Math.floor(iconIndex / iconsPerRow)
      const col = iconIndex % iconsPerRow
      const x = col * iconSize
      const y = row * iconSize

      // Update spritemap coordinates
      updatedSpritemap[spritemapKey] = {
        x,
        y,
        width: iconSize,
        height: iconSize,
        source: spriteData.source
      }

      // Check if source file exists and add to composite operations
      if (spriteData.source && fs.existsSync(spriteData.source)) {
        try {
          // Get image metadata to determine how to process it
          const imageMetadata = await sharp(spriteData.source).metadata()
          const { width, height } = imageMetadata

          let iconBuffer

          // Determine if this is a multi-icon file or single icon
          if (width > iconSize || height > iconSize || width !== height) {
            // Multi-icon file or non-square image - extract height x height from top-left
            const extractSize = Math.min(height, width)
            iconBuffer = await sharp(spriteData.source)
              .extract({ left: 0, top: 0, width: extractSize, height: extractSize })
              .resize(iconSize, iconSize, {
                fit: 'contain',
                background: { r: 0, g: 0, b: 0, alpha: 0 }
              })
              .png()
              .toBuffer()
          } else {
            // Single icon file - use the full image
            iconBuffer = await sharp(spriteData.source)
              .resize(iconSize, iconSize, {
                fit: 'contain',
                background: { r: 0, g: 0, b: 0, alpha: 0 }
              })
              .png()
              .toBuffer()
          }

          compositeOperations.push({
            input: iconBuffer,
            left: x,
            top: y
          })
        } catch (error) {
          console.warn(`Failed to process icon ${spriteData.source}:`, error.message)
        }
      } else if (spriteData.source) {
        console.warn(`Icon file not found: ${spriteData.source}`)
      } else {
        // Generate fallback icon for utility icons
        const fallbackIcon = await this.generateFallbackIcon(spritemapKey, iconSize)
        if (fallbackIcon) {
          compositeOperations.push({
            input: fallbackIcon,
            left: x,
            top: y
          })
        }
      }

      iconIndex++
    }

    // Create the final spritemap image
    try {
      const spritemapBuffer = await spritemapCanvas.composite(compositeOperations).png().toBuffer()

      // Write spritemap image file
      const spritemapImageFile = path.join(this.outputPath, 'spritemap.png')
      fs.writeFileSync(spritemapImageFile, spritemapBuffer)
      console.log(`✓ Generated spritemap image: ${spritemapImageFile}`)

      // Create spritemap JSON file with updated coordinates
      const spritemapFile = path.join(this.outputPath, 'spritemap.json')
      const spritemapData = {
        image: 'spritemap.png',
        width: spritemapWidth,
        height: spritemapHeight,
        iconsPerRow,
        iconSize,
        sprites: updatedSpritemap
      }
      fs.writeFileSync(spritemapFile, JSON.stringify(spritemapData, null, 2))
      console.log(`✓ Written spritemap data: ${spritemapFile}`)
    } catch (error) {
      console.error('Failed to generate spritemap image:', error.message)
      // Fallback: just create the JSON file
      const spritemapFile = path.join(this.outputPath, 'spritemap.json')
      fs.writeFileSync(spritemapFile, JSON.stringify(this.spritemap, null, 2))
      console.log(`✓ Written spritemap JSON (fallback): ${spritemapFile}`)
    }
  }

  /**
   * Copy all entity graphics from raw-graphics to public directory
   */
  async copyAllEntityGraphics() {
    const sourceDir = path.join(this.dataDumpsPath, 'raw-graphics')
    const destDir = path.join(this.outputPath, 'animations')

    // Copy base game entity graphics
    const baseEntityDir = path.join(sourceDir, 'entity')
    if (fs.existsSync(baseEntityDir)) {
      await this.copyDirectoryRecursive(baseEntityDir, path.join(destDir, 'entity'))
    }

    // Copy mod entity graphics
    const modDirs = fs
      .readdirSync(sourceDir, { withFileTypes: true })
      .filter(
        dirent =>
          dirent.isDirectory() &&
          dirent.name !== 'entity' &&
          dirent.name !== 'icons' &&
          dirent.name !== 'technology'
      )
      .map(dirent => dirent.name)

    for (const modName of modDirs) {
      const modEntityDir = path.join(sourceDir, modName, 'entity')
      if (fs.existsSync(modEntityDir)) {
        await this.copyDirectoryRecursive(modEntityDir, path.join(destDir, modName, 'entity'))
      }
    }
  }

  /**
   * Recursively copy directory contents
   */
  async copyDirectoryRecursive(source, dest) {
    if (!fs.existsSync(dest)) {
      fs.mkdirSync(dest, { recursive: true })
    }

    const entries = fs.readdirSync(source, { withFileTypes: true })

    for (const entry of entries) {
      const sourcePath = path.join(source, entry.name)
      const destPath = path.join(dest, entry.name)

      if (entry.isDirectory()) {
        await this.copyDirectoryRecursive(sourcePath, destPath)
      } else if (entry.isFile() && entry.name.endsWith('.png')) {
        // Only copy PNG files
        if (!fs.existsSync(destPath)) {
          fs.copyFileSync(sourcePath, destPath)
        }
      }
    }
  }

  /**
   * Lint check for raw-graphics paths in output files
   */
  async lintCheckRawGraphics() {
    console.log('Running lint check for raw-graphics paths...')

    const outputFiles = [
      'docs/public/data/en-buildings.json',
      'docs/public/data/en-items.json',
      'docs/public/data/en-recipes.json',
      'docs/public/data/en-fluids.json',
      'docs/public/data/en-tiles.json',
      'docs/public/data/en-technologies.json'
    ]

    let hasErrors = false

    for (const filePath of outputFiles) {
      if (fs.existsSync(filePath)) {
        const content = fs.readFileSync(filePath, 'utf8')
        const rawGraphicsMatches = content.match(/raw-graphics/g)

        if (rawGraphicsMatches) {
          console.error(
            `✗ Found ${rawGraphicsMatches.length} raw-graphics references in ${filePath}`
          )
          hasErrors = true

          // Find and report specific lines with raw-graphics
          const lines = content.split('\n')
          lines.forEach((line, index) => {
            if (line.includes('raw-graphics')) {
              console.error(`  Line ${index + 1}: ${line.trim()}`)
            }
          })
        } else {
          console.log(`✓ No raw-graphics references found in ${filePath}`)
        }
      }
    }

    if (hasErrors) {
      console.error('✗ Lint check failed: Found raw-graphics paths in output files')
      console.error('  All graphics paths should be converted to animations/ format')
      process.exit(1)
    } else {
      console.log('✓ Lint check passed: No raw-graphics paths found in output files')
    }
  }

  /**
   * Lint check for entity types not handled in buildings.json
   */
  async lintCheckEntityTypes() {
    console.log('\n🔍 Analyzing entity types not handled in buildings.json...')

    if (!this.rawData) {
      console.log('⚠️  No raw data loaded, skipping entity type analysis')
      return
    }

    // Get all entities from raw data
    const allEntities = []
    for (const key of Object.keys(this.rawData)) {
      const data = this.rawData[key]
      if (data && typeof data === 'object') {
        // Check if this is a direct entity (has type property)
        if (data.type) {
          allEntities.push(key)
        }
        // Check if this is a nested entity structure (entity name as key)
        else {
          for (const entityName of Object.keys(data)) {
            const entity = data[entityName]
            if (entity && typeof entity === 'object' && entity.type) {
              allEntities.push(entityName)
            }
          }
        }
      }
    }

    // Remove duplicates and sort
    const uniqueEntities = [...new Set(allEntities)].sort()

    // Get entities currently in buildings.json
    let buildingsEntities = []
    if (fs.existsSync('docs/public/data/en-buildings.json')) {
      const buildingsData = JSON.parse(
        fs.readFileSync('docs/public/data/en-buildings.json', 'utf8')
      )
      buildingsEntities = Object.keys(buildingsData)
    }

    // Group entities by type
    const entityTypes = {}
    const unhandledEntities = []

    for (const entityName of uniqueEntities) {
      // Find the entity data in the raw data structure
      let entity = null
      for (const key of Object.keys(this.rawData)) {
        const data = this.rawData[key]
        if (data && typeof data === 'object') {
          if (data.type && key === entityName) {
            entity = data
            break
          } else if (data[entityName] && data[entityName].type) {
            entity = data[entityName]
            break
          }
        }
      }

      if (!entity) continue

      const entityType = entity.type

      if (!entityTypes[entityType]) {
        entityTypes[entityType] = { total: 0, handled: 0, unhandled: [] }
      }

      entityTypes[entityType].total++

      if (buildingsEntities.includes(entityName)) {
        entityTypes[entityType].handled++
      } else {
        entityTypes[entityType].unhandled.push(entityName)
        unhandledEntities.push({ name: entityName, type: entityType })
      }
    }

    // Sort entity types by unhandled count
    const sortedTypes = Object.entries(entityTypes)
      .filter(([type, data]) => data.unhandled.length > 0)
      .sort((a, b) => b[1].unhandled.length - a[1].unhandled.length)

    console.log(`\n📊 Entity Type Analysis:`)
    console.log(`Total entities: ${uniqueEntities.length}`)
    console.log(`Handled in buildings.json: ${buildingsEntities.length}`)
    console.log(`Unhandled: ${unhandledEntities.length}`)

    console.log(`\n📋 Unhandled Entity Types (by count):`)
    for (const [type, data] of sortedTypes) {
      const percentage = ((data.handled / data.total) * 100).toFixed(1)
      console.log(
        `  ${type}: ${data.unhandled.length}/${data.total} unhandled (${percentage}% handled)`
      )

      // Show first few examples
      const examples = data.unhandled.slice(0, 3)
      if (examples.length > 0) {
        console.log(`    Examples: ${examples.join(', ')}${data.unhandled.length > 3 ? '...' : ''}`)
      }
    }

    // Show some specific unhandled entities that might be important
    const importantTypes = [
      'combinator',
      'inserter',
      'transport-belt',
      'underground-belt',
      'splitter',
      'pump',
      'pipe-to-ground'
    ]
    console.log(`\n🎯 Important Unhandled Entities:`)
    for (const type of importantTypes) {
      const matching = unhandledEntities.filter(e => e.type === type)
      if (matching.length > 0) {
        console.log(`  ${type}: ${matching.map(e => e.name).join(', ')}`)
      }
    }
  }

  /**
   * Main processing function
   */
  async process() {
    try {
      console.log('Starting Factorio data processing...')

      await this.loadRawData()
      await this.loadLocaleData()
      await this.writeProcessedData()
      await this.lintCheckRawGraphics()
      await this.lintCheckEntityTypes()

      console.log('✓ Data processing completed successfully!')
    } catch (error) {
      console.error('✗ Data processing failed:', error.message)
      process.exit(1)
    }
  }
}

// Run the processor if this script is executed directly
if (import.meta.url === `file://${process.argv[1]}`) {
  const processor = new FactorioDataProcessor()
  processor.process()
}

export default FactorioDataProcessor
