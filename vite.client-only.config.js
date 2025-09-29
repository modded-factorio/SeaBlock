import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'
import { resolve } from 'path'

export default defineConfig({
  plugins: [vue()],
  define: {
    global: 'globalThis',
    'process.env': '{}',
    'process.platform': '"browser"',
    'process.version': '"18.0.0"',
    'process.versions': '{"node":"18.0.0"}',
    'process.browser': 'true',
    'process.argv': '[]',
    'process.pid': '1',
    'process.title': '"browser"',
    'process.arch': '"x64"',
    'process.env.PROD': 'false'
  },
  server: {
    headers: {
      'Cross-Origin-Embedder-Policy': 'require-corp',
      'Cross-Origin-Opener-Policy': 'same-origin'
    }
  },
  build: {
    lib: {
      entry: resolve(__dirname, 'src/browser-bundle/VitePressClientOnly.js'),
      name: 'VitePressClientRenderer',
      fileName: format => `vitepress-client-renderer.${format}.js`,
      formats: ['es', 'umd']
    },
    rollupOptions: {
      // Externalize Vue to reduce bundle size
      external: ['vue'],
      output: {
        globals: {
          vue: 'Vue'
        }
      }
    },
    outDir: 'assets/js',
    emptyOutDir: false
  },
  resolve: {
    conditions: ['browser', 'module', 'import'],
    mainFields: ['browser', 'module', 'main'],
    alias: {
      '@': resolve(__dirname, 'src'),
      '@siteData': resolve(__dirname, 'src/site-data.js'),
      '@localSearchIndex': resolve(__dirname, 'src/browser-bundle/mocks/local-search-index.js'),
      '@theme': resolve(__dirname, 'node_modules/vitepress/dist/client/theme-default'),
      '@theme/*': resolve(__dirname, 'node_modules/vitepress/dist/client/theme-default/*'),
      '@core': resolve(__dirname, 'node_modules/vitepress/dist/client'),
      '@core/*': resolve(__dirname, 'node_modules/vitepress/dist/client/*'),
      '@app': resolve(__dirname, 'node_modules/vitepress/dist/client/app'),
      '@app/*': resolve(__dirname, 'node_modules/vitepress/dist/client/app/*'),
      '@shared': resolve(__dirname, 'node_modules/vitepress/dist/shared'),
      '@shared/*': resolve(__dirname, 'node_modules/vitepress/dist/shared/*'),
      '@internal': resolve(__dirname, 'node_modules/vitepress/dist/client/app/internal'),
      '@internal/*': resolve(__dirname, 'node_modules/vitepress/dist/client/app/internal/*')
    }
  },
  optimizeDeps: {
    // Include Vue and markdown-it for optimization
    include: [
      'vue',
      'markdown-it',
      'markdown-it-anchor',
      'markdown-it-table-of-contents',
      'markdown-it-emoji',
      'markdown-it-task-lists',
      'markdown-it-container'
    ]
  }
})
