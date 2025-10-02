// Global spritemap cache for SpriteIcon components
let spritemapCache = null
let spritemapCachePromise = null

export async function loadSpritemapData(withBase) {
  if (spritemapCache) {
    return spritemapCache
  }

  if (spritemapCachePromise) {
    return spritemapCachePromise
  }

  spritemapCachePromise = fetch(withBase('/data/spritemap.json'))
    .then(response => {
      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`)
      }
      return response.json()
    })
    .then(data => {
      spritemapCache = data
      return spritemapCache
    })
    .catch(error => {
      console.error('Failed to load spritemap data:', error)
      spritemapCachePromise = null
      return null
    })

  return spritemapCachePromise
}
