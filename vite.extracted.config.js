import { resolve } from 'path'

import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'

export default defineConfig({
  plugins: [vue()],
  define: {
    global: 'globalThis',
    __VUE_OPTIONS_API__: JSON.stringify(true),
    __VUE_PROD_DEVTOOLS__: JSON.stringify(false),
    __VP_HASH_MAP__: '{}',
    __ASSETS_DIR__: '"/assets"',
    Buffer: 'Buffer'
  },
  server: {
    headers: {
      'Cross-Origin-Embedder-Policy': 'require-corp',
      'Cross-Origin-Opener-Policy': 'same-origin'
    }
  },
  build: {
    outDir: 'docs/public/assets',
    emptyOutDir: false,
    minify: true,
    rollupOptions: {
      input: {
        'vitepress-extracted-renderer': resolve(
          __dirname,
          'src/browser-bundle/VitePressExtractedRenderer.js'
        )
      },
      output: {
        entryFileNames: 'vitepress-extracted-renderer.js',
        chunkFileNames: 'vitepress-extracted-renderer.js',
        assetFileNames: '[name].[ext]',
        manualChunks: () => 'vitepress-extracted-renderer'
      },
      treeshake: true,
      external: [],
      plugins: []
    }
  },
  resolve: {
    conditions: ['browser', 'module', 'import'],
    mainFields: ['browser', 'module', 'main'],
    alias: {
      '@': resolve(__dirname, 'src'),
      '@siteData': resolve(__dirname, 'src/site-data.js'),
      '@localSearchIndex': resolve(__dirname, 'src/browser-bundle/mocks/local-search-index.js'),
      // Use our extracted VitePress theme instead of the original package
      '@theme': resolve(__dirname, 'src/browser-bundle/vitepress-theme/client/theme-default'),
      '@theme/*': resolve(__dirname, 'src/browser-bundle/vitepress-theme/client/theme-default/*'),
      '@core': resolve(__dirname, 'src/browser-bundle/vitepress-theme/client'),
      '@core/*': resolve(__dirname, 'src/browser-bundle/vitepress-theme/client/*'),
      '@app': resolve(__dirname, 'src/browser-bundle/vitepress-theme/client/app'),
      '@app/*': resolve(__dirname, 'src/browser-bundle/vitepress-theme/client/app/*'),
      '@shared': resolve(__dirname, 'src/browser-bundle/vitepress-theme/client'),
      '@shared/*': resolve(__dirname, 'src/browser-bundle/vitepress-theme/client/*'),
      '@internal': resolve(__dirname, 'src/browser-bundle/vitepress-theme/client/app'),
      '@internal/*': resolve(__dirname, 'src/browser-bundle/vitepress-theme/client/app/*'),
      // Custom alias for VitePress imports - resolves to our common exports
      vitepress: resolve(__dirname, 'src/browser-bundle/vitepress-theme/client/index.js'),
      // Alias for .vitepress directory to access config and theme
      '@vitepress': resolve(__dirname, 'docs/.vitepress'),
      // Buffer polyfill for browser compatibility
      buffer: 'buffer'
    }
  },
  optimizeDeps: {
    include: [
      'vue',
      'markdown-it',
      'markdown-it-anchor',
      'markdown-it-table-of-contents',
      'markdown-it-emoji',
      'markdown-it-task-lists',
      'markdown-it-container',
      'buffer'
    ]
  }
})
