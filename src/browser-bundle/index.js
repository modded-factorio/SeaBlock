// VitePress Browser Bundle
// This module provides VitePress rendering capabilities in the browser using the actual VitePress renderer

// Export the VitePress component renderer (uses actual Vue components)
export { VitePressComponentRenderer } from './VitePressComponentRenderer.js'

// Export VitePress symbols
export { dataSymbol } from 'vitepress/dist/client/app/data.js'
export { RouterSymbol } from 'vitepress/dist/client/app/router.js'

// Global export for browser usage
if (typeof window !== 'undefined') {
  // Import and expose the VitePress browser renderer
  // Import and expose the VitePress component renderer
  import('./VitePressComponentRenderer.js').then(module => {
    window.VitePressComponentRenderer = module.VitePressComponentRenderer
  })

  // Import and expose VitePress symbols for iframe usage
  Promise.all([
    import('vitepress/dist/client/app/data.js'),
    import('vitepress/dist/client/app/router.js')
  ]).then(([{ dataSymbol, useData }, { RouterSymbol }]) => {
    window.VitePress = window.VitePress || {}
    window.VitePress.dataSymbol = dataSymbol
    window.VitePress.useData = useData
    window.VitePress.RouterSymbol = RouterSymbol
  })
}
