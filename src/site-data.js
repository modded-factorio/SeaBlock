// Site data for VitePress browser renderer
// Now imports from the shared config-data.js file

import { configData } from '/docs/.vitepress/config-data.js'

// Add browser-specific fields
export const siteData = {
  ...configData,
  lang: 'en-US',
  head: [],
  locales: {}
}

export default siteData
