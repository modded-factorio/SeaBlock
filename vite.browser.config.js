import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'
import { resolve } from 'path'
import { nodePolyfills } from 'vite-plugin-node-polyfills'

export default defineConfig({
  plugins: [
    vue(),
    nodePolyfills({
      // Only include essential polyfills to minimize bundle size
      include: [
        'path',
        'fs',
        'crypto',
        'util',
        'os',
        'stream',
        'events',
        'url',
        'querystring',
        'buffer',
        'process',
        'assert',
        'constants',
        'string_decoder'
      ],
      // Exclude heavy Node.js modules that aren't needed in browser
      exclude: [
        'fsevents',
        'child_process',
        'worker_threads',
        'module',
        'perf_hooks',
        'v8',
        'dns',
        'http',
        'https',
        'net',
        'tls',
        'zlib',
        'tty',
        'readline'
      ],
      // Enable essential globals
      globals: {
        Buffer: true,
        global: true,
        process: true
      },
      // Enable protocol imports for node: modules
      protocolImports: true
    })
  ],
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
  // Remove ssr.noExternal to avoid bundling Node.js dependencies
  build: {
    lib: {
      entry: resolve(__dirname, 'src/browser-bundle/VitePressComponentRenderer.js'),
      name: 'VitePressComponentRenderer',
      fileName: format => `vitepress-component-renderer.${format}.js`,
      formats: ['es']
    },
    rollupOptions: {
      // Externalize VitePress imports so they can be loaded dynamically at runtime
      external: [
        'vitepress/dist/client/theme-default/Layout.vue',
        'vitepress/dist/client/theme-default/components/VPNav.vue',
        'vitepress/dist/client/theme-default/components/VPSidebar.vue',
        'vitepress/dist/client/theme-default/components/VPContent.vue',
        'vitepress/dist/client/theme-default/components/VPFooter.vue',
        'vitepress/dist/client/app/data.js',
        'vitepress/dist/client/app/router.js',
        'vitepress/dist/client/shared.js'
      ]
    },
    outDir: 'assets/js',
    emptyOutDir: false
  },
  resolve: {
    conditions: ['browser', 'module', 'import'],
    dedupe: ['vitepress'],
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
      '@internal/*': resolve(__dirname, 'node_modules/vitepress/dist/client/app/internal/*'),
      // Force VitePress to use client-side modules only
      vitepress$: resolve(__dirname, 'node_modules/vitepress/dist/client/index.js')
    }
  }
})

