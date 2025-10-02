import fs from 'fs'
import path from 'path'
import { fileURLToPath } from 'url'

const __filename = fileURLToPath(import.meta.url)
const __dirname = path.dirname(__filename)

// Load the data dump
const dataDumpPath = path.join(__dirname, '..', 'data-dumps', 'data-raw-dump.json')
console.log(`📁 Loading data from: ${dataDumpPath}`)

try {
  const rawData = JSON.parse(fs.readFileSync(dataDumpPath, 'utf8'))

  console.log('\n📊 Entity types found in data-raw-dump.json:')
  console.log('='.repeat(50))

  const entityTypeCounts = {}
  const itemsOutsideItemCategory = []
  const itemSubtypes = []
  let totalEntities = 0

  // Drill down one level to analyze actual entities
  Object.keys(rawData).forEach(categoryKey => {
    const category = rawData[categoryKey]
    if (typeof category === 'object' && category !== null) {
      Object.keys(category).forEach(entityKey => {
        const entity = category[entityKey]
        if (typeof entity === 'object' && entity !== null && entity.type) {
          const entityType = entity.type
          entityTypeCounts[entityType] = (entityTypeCounts[entityType] || 0) + 1
          totalEntities++

          // Check for items outside the main 'item' category
          if (entityType === 'item' && categoryKey !== 'item') {
            itemsOutsideItemCategory.push({
              category: categoryKey,
              entityKey: entityKey,
              entity: entity
            })
          }

          // Check for item subtypes (entities that should be treated as items)
          if (
            categoryKey !== 'item' &&
            entity.type &&
            (entity.type === 'module' ||
              entity.type === 'equipment' ||
              entity.type === 'gun' ||
              entity.type === 'ammo' ||
              entity.type === 'armor' ||
              entity.type === 'tool' ||
              entity.type === 'capsule' ||
              entity.type === 'upgrade-item' ||
              entity.type === 'deconstruction-item' ||
              entity.type === 'blueprint' ||
              entity.type === 'blueprint-book' ||
              entity.type === 'repair-tool' ||
              entity.type === 'spidertron-remote' ||
              entity.type === 'item-with-entity-data')
          ) {
            itemSubtypes.push({
              category: categoryKey,
              entityKey: entityKey,
              type: entity.type,
              entity: entity
            })
          }
        }
      })
    }
  })

  console.log(`Total entities found: ${totalEntities}`)
  console.log(`Unique entity types: ${Object.keys(entityTypeCounts).length}\n`)

  // Sort by count (descending) then by name
  const sortedTypes = Object.entries(entityTypeCounts).sort(
    (a, b) => b[1] - a[1] || a[0].localeCompare(b[0])
  )

  sortedTypes.forEach(([type, count], index) => {
    console.log(`${(index + 1).toString().padStart(3)}. ${type}: ${count} entities`)
  })

  console.log('\n📈 Summary:')
  console.log(`   Total entities: ${totalEntities}`)
  console.log(`   Unique types: ${Object.keys(entityTypeCounts).length}`)

  // Check for items outside the main 'item' category
  if (itemsOutsideItemCategory.length > 0) {
    console.log(
      `\n⚠️  Found ${itemsOutsideItemCategory.length} items outside the main 'item' category:`
    )
    itemsOutsideItemCategory.forEach((item, index) => {
      console.log(`   ${index + 1}. ${item.category}.${item.entityKey} (type: ${item.entity.type})`)
    })
  } else {
    console.log('\n✅ All items are properly categorized under the main "item" category')
  }

  // Check for item subtypes that should be included in item processing
  if (itemSubtypes.length > 0) {
    console.log(`\n🔍 Found ${itemSubtypes.length} item subtypes outside the main 'item' category:`)

    // Group by type
    const subtypesByType = {}
    itemSubtypes.forEach(item => {
      if (!subtypesByType[item.type]) {
        subtypesByType[item.type] = []
      }
      subtypesByType[item.type].push(item)
    })

    Object.keys(subtypesByType)
      .sort()
      .forEach(type => {
        const items = subtypesByType[type]
        console.log(`\n   📦 ${type} (${items.length} entities):`)
        items.forEach((item, index) => {
          console.log(`      ${index + 1}. ${item.category}.${item.entityKey}`)
        })
      })
  } else {
    console.log('\n✅ No item subtypes found outside the main categories')
  }

  // Show top 10 most common types
  console.log('\n🏆 Top 10 most common entity types:')
  sortedTypes.slice(0, 10).forEach(([type, count], index) => {
    console.log(`   ${index + 1}. ${type}: ${count}`)
  })
} catch (error) {
  console.error('❌ Error reading data dump:', error.message)
}
