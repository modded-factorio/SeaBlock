`# Vite Dependencies & Node.js Polyfills Guide

## Problem Analysis

The main issue you're facing is that VitePress has two distinct entry points:

1. **`/dist/node/index.js`** - Server-side code with Node.js imports (fs, path, crypto, etc.)
2. **`/dist/client/index.js`** - Browser-compatible client-side code

When Vite tries to bundle VitePress for the browser, it encounters Node.js modules that don't have browser equivalents, causing build failures.

## Root Cause

The error occurs because:

- VitePress's Node.js entry point imports modules like `node:path`, `node:fs`, `node:crypto`
- These modules are externalized by Vite for browser compatibility
- But there's no browser bundle available to externalize to
- The build fails with "Module has been externalized for browser compatibility"

## Solutions

### Solution 1: Use Client-Side VitePress Only (Recommended)

**Strategy**: Force Vite to use only the client-side VitePress modules and provide polyfills for essential Node.js modules.

**Implementation**:

```javascript
// vite.browser.config.js
import { nodePolyfills } from 'vite-plugin-node-polyfills'

export default defineConfig({
  plugins: [
    vue(),
    nodePolyfills({
      // Only include essential polyfills
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
      // Exclude heavy modules
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
      globals: { Buffer: true, global: true, process: true },
      protocolImports: true
    })
  ],
  resolve: {
    // Force browser-first resolution
    conditions: ['browser', 'module', 'import'],
    mainFields: ['browser', 'module', 'main'],
    alias: {
      // Ensure we use client-side modules
      vitepress$: resolve(__dirname, 'node_modules/vitepress/dist/client/index.js')
    }
  }
})
```

### Solution 2: Create a Dedicated Browser Bundle

**Strategy**: Create a separate Vite project specifically for bundling a browser-compatible version of VitePress.

**Implementation**:

1. Create a new Vite project in a subdirectory
2. Configure it to bundle only the client-side VitePress modules
3. Use this as a dependency in your main project

```bash
# Create browser bundle project
mkdir vitepress-browser-bundle
cd vitepress-browser-bundle
npm init -y
npm install vite @vitejs/plugin-vue vue vitepress
```

### Solution 3: Externalize and Load Dynamically

**Strategy**: Externalize VitePress components and load them dynamically at runtime.

**Implementation**:

```javascript
// vite.config.js
export default defineConfig({
  build: {
    rollupOptions: {
      external: [
        'vitepress/dist/client/theme-default/Layout.vue',
        'vitepress/dist/client/theme-default/components/VPNav.vue'
        // ... other components
      ],
      output: {
        globals: {
          'vitepress/dist/client/theme-default/Layout.vue': 'VitePressLayout'
          // ... other globals
        }
      }
    }
  }
})
```

## Bundle Size Optimization Strategies

### 1. Tree Shaking

```javascript
// vite.config.js
export default defineConfig({
  build: {
    rollupOptions: {
      treeshake: {
        moduleSideEffects: false,
        propertyReadSideEffects: false,
        tryCatchDeoptimization: false
      }
    }
  }
})
```

### 2. Code Splitting

```javascript
// vite.config.js
export default defineConfig({
  build: {
    rollupOptions: {
      output: {
        manualChunks: {
          'vitepress-core': ['vitepress/dist/client'],
          'vue-components': ['vue'],
          markdown: ['markdown-it', 'markdown-it-anchor']
        }
      }
    }
  }
})
```

### 3. Polyfill Optimization

```javascript
// Only include polyfills you actually need
nodePolyfills({
  include: ['path', 'fs', 'crypto', 'util', 'buffer', 'process'],
  exclude: [
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
  ]
})
```

### 4. Dependency Analysis

```bash
# Analyze bundle size
npm install --save-dev rollup-plugin-visualizer
```

```javascript
// vite.config.js
import { visualizer } from 'rollup-plugin-visualizer'

export default defineConfig({
  plugins: [
    visualizer({
      filename: 'dist/stats.html',
      open: true,
      gzipSize: true,
      brotliSize: true
    })
  ]
})
```

## Recommended Approach

For your SeaBlock Wiki project, I recommend **Solution 1** with the following optimizations:

1. **Use the optimized Vite configuration** (`vite.browser.config.optimized.js`)
2. **Implement selective polyfills** - only include what you actually need
3. **Externalize VitePress components** - load them dynamically
4. **Use code splitting** - separate core functionality from UI components
5. **Monitor bundle size** - use bundle analysis tools

## Testing the Solution

```bash
# Test the optimized build
npm run build:browser -- --config vite.browser.config.optimized.js

# Analyze bundle size
npx vite-bundle-analyzer assets/js
```

## Key Takeaways

1. **VitePress has separate Node.js and browser entry points** - always use the client-side version for browser builds
2. **Node.js polyfills add significant bundle size** - only include what you need
3. **Externalization can reduce bundle size** - but requires runtime loading
4. **Bundle analysis is essential** - monitor what's actually being included
5. **Tree shaking works best with ES modules** - ensure your dependencies support it

## Next Steps

1. Test the optimized configuration
2. Analyze the bundle size with the visualizer
3. Implement code splitting for better performance
4. Consider creating a dedicated browser bundle if needed
5. Monitor and optimize based on actual usage patterns
