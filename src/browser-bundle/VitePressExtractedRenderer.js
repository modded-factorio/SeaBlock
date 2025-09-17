// VitePress Extracted Browser Bundle Renderer
// This renderer uses the extracted VitePress components without Node.js dependencies

// Buffer polyfill for browser compatibility
import { Buffer } from 'buffer'
if (typeof globalThis.Buffer === 'undefined') {
  globalThis.Buffer = Buffer
}

import { createApp, h, defineComponent, ref, computed, reactive, provide } from 'vue'

// Import directly from our extracted files instead of going through the original package
import DefaultLayout from './vitepress-theme/client/theme-default/Layout.vue'
import VPNav from './vitepress-theme/client/theme-default/components/VPNav.vue'
import VPSidebar from './vitepress-theme/client/theme-default/components/VPSidebar.vue'
import VPContent from './vitepress-theme/client/theme-default/components/VPContent.vue'
import VPFooter from './vitepress-theme/client/theme-default/components/VPFooter.vue'
import VPSkipLink from './vitepress-theme/client/theme-default/components/VPSkipLink.vue'
import VPLocalNav from './vitepress-theme/client/theme-default/components/VPLocalNav.vue'
import VPPage from './vitepress-theme/client/theme-default/components/VPPage.vue'
import VPDoc from './vitepress-theme/client/theme-default/components/VPDoc.vue'
import VPHome from './vitepress-theme/client/theme-default/components/VPHome.vue'

// Import all VitePress functionality from our alias
import {
  Content,
  ClientOnly,
  dataSymbol,
  useData,
  RouterSymbol,
  createRouter,
  initData,
  siteDataRef,
  _escapeHtml,
  defineClientComponent,
  getScrollOffset,
  inBrowser,
  onContentUpdated,
  withBase
} from 'vitepress'

// Import VitePress composables
import { useCopyCode } from './vitepress-theme/client/app/composables/copyCode.js'
import { useCodeGroups } from './vitepress-theme/client/app/composables/codeGroups.js'

// Import VitePress theme styles (including CSS variables)
import './vitepress-theme/client/theme-default/without-fonts.js'

// Import VitePress markdown processing from our browser-compatible version
import { createMarkdownRenderer, markdownToVue } from './markdown.js'

// Import site data
import { siteData } from '../site-data.js'

// Import custom theme components (now safe to import since we're using 'vitepress')
import '@vitepress/theme/custom.css'
import '@vitepress/theme/editor-styles.css'

// VitePress Extracted Browser Bundle Renderer
class VitePressExtractedRenderer {
  constructor(options = {}) {
    this.options = {
      base: '/SeaBlock-wiki/',
      ...options
    }
    this.isInitialized = false
    this.markdownProcessor = null
    this.siteData = siteData
    this.mountedApp = null
  }

  // Initialize the VitePress component renderer
  async init() {
    if (this.isInitialized) return

    // Set up global VitePress environment
    this.setupGlobalVitePressEnvironment()

    this.isInitialized = true
  }

  // Set up global VitePress environment with monkeypatching
  setupGlobalVitePressEnvironment() {
    if (typeof window !== 'undefined') {
      window.__VITEPRESS__ = true
      window.__VP_SITE_DATA__ = this.siteData
      // Add missing VitePress globals
      window.__VP_LOCAL_SEARCH__ = null
      window.__VP_HASH_MAP__ = {}
      window.__ALGOLIA__ = null
      window.__CARBON__ = null
      window.__VUE_PROD_DEVTOOLS__ = false
      window.__VUE_OPTIONS_API__ = true
    }

    // Monkeypatch the siteDataRef that VitePress expects
    if (siteDataRef) {
      siteDataRef.value = this.siteData
      console.log('✅ Monkeypatched siteDataRef with extracted bundle')
    }
  }

  // Process markdown content using VitePress-compatible markdown renderer
  async processMarkdown(markdown) {
    try {
      // Use the new markdownToVue function for full VitePress compatibility
      const result = await markdownToVue(markdown, '', {
        theme: { light: 'github-light', dark: 'github-dark' },
        lineNumbers: true
      })

      console.log('✅ Markdown processed with VitePress markdownToVue function')

      return {
        html: result.html,
        frontmatter: result.frontmatter,
        headers: result.headers,
        title: result.title,
        description: result.description,
        renderFunction: result.renderFunction
      }
    } catch (error) {
      console.error('❌ Error processing markdown with VitePress markdownToVue:', error)
      throw error
    }
  }

  // Parse front matter (basic YAML parsing)
  parseFrontMatter(fmContent) {
    const frontmatter = {}
    const lines = fmContent.split('\n')

    for (const line of lines) {
      const trimmed = line.trim()
      if (!trimmed || trimmed.startsWith('#')) continue

      const colonIndex = trimmed.indexOf(':')
      if (colonIndex === -1) continue

      const key = trimmed.slice(0, colonIndex).trim()
      let value = trimmed.slice(colonIndex + 1).trim()

      // Remove quotes if present
      if (
        (value.startsWith('"') && value.endsWith('"')) ||
        (value.startsWith("'") && value.endsWith("'"))
      ) {
        value = value.slice(1, -1)
      }

      // Convert boolean values
      if (value === 'true') value = true
      else if (value === 'false') value = false
      // Convert numbers
      else if (!isNaN(value) && !isNaN(parseFloat(value))) value = parseFloat(value)

      frontmatter[key] = value
    }

    return frontmatter
  }

  // Create VitePress page component using extracted components
  createVitePressPageComponent(isDark = false) {
    return defineComponent({
      name: 'VitePressPage',
      props: {
        isDark: Boolean
      },
      setup(props) {
        const components = [
          h(VPSkipLink),
          h(VPNav),
          h(VPLocalNav),
          h(VPSidebar),
          h(
            VPContent,
            { id: 'VPContent' },
            {
              default: () => h(Content)
            }
          ),
          h(VPFooter)
        ]

        return () =>
          h(
            DefaultLayout,
            {
              class: props.isDark ? 'dark' : ''
            },
            {
              default: () => components
            }
          )
      }
    })
  }

  // Create VitePress data using the extracted initData function
  createVitePressData(router, isDark = false) {
    const data = initData(router.route)

    if (isDark !== undefined) {
      data.isDark.value = isDark
    }

    return data
  }

  // Create a mock router for useRouter monkeypatching
  createMockRouter() {
    // Create a mock route object that initData expects
    const mockRoute = reactive({
      path: '/',
      component: null,
      data: {
        relativePath: '/',
        title: 'VitePress Preview',
        description: 'Preview of VitePress content',
        headers: [],
        frontmatter: {},
        lastUpdated: new Date().toISOString(),
        params: {},
        isNotFound: false // Explicitly set to false to prevent 404
      }
    })

    // Create mock router object
    const mockRouter = {
      route: mockRoute,
      go: () => Promise.resolve(),
      onBeforeRouteChange: null,
      onAfterRouteChange: null,
      onBeforePageLoad: null,
      onAfterPageLoad: null
    }

    return mockRouter
  }

  createVitePressRouter(renderFunction) {
    // Just use the mock router directly - it's simpler and more reliable
    const mockRouter = this.createMockRouter()

    // Use the render function directly as the route component

    console.log('✅ Render function:', renderFunction)

    mockRouter.route.component = renderFunction

    console.log('✅ Router created with mock router (no real router interference)')
    return mockRouter
  }

  // Mount VitePress page to the actual DOM mount point with monkeypatching
  async mountVitePressPage(container, props = {}) {
    if (!this.isInitialized) {
      await this.init()
    }

    const {
      html: processedContent,
      renderFunction,
      frontmatter,
      headers,
      title,
      description
    } = await this.processMarkdown(props.markdown)

    // Create router with the render function
    const router = this.createVitePressRouter(renderFunction)
    const vitePressData = this.createVitePressData(router, props.isDark)

    // Update the route data directly (this will automatically update all computed properties)
    Object.assign(router.route.data, {
      content: processedContent,
      title: title || 'VitePress Preview',
      description: description || 'Preview of VitePress content',
      frontmatter: frontmatter,
      headers: headers,
      isNotFound: false,
      relativePath: 'index.md',
      filePath: 'index.md'
    })

    // Create the VitePress page component for the layout
    const VitePressPageComponent = this.createVitePressPageComponent(props.isDark)

    const VitePressApp = defineComponent({
      name: 'VitePressApp',
      setup() {
        console.log('✅ VitePressApp setup function called')

        // Use extracted useData
        const { site, lang, dir } = useData()
        console.log('✅ Using extracted useData successfully')

        // Setup VitePress composables
        useCopyCode() // Enable copy-to-clipboard on code blocks
        useCodeGroups() // Enable code group tabs functionality
        console.log('✅ VitePress composables initialized')

        // Render the VitePress page component (which includes all the layout)
        return () =>
          h(VitePressPageComponent, {
            content: '', // Don't pass content here - router component handles it
            isDark: props.isDark
          })
      }
    })

    const app = createApp(VitePressApp)

    // Provide the symbols at the app level for proper injection
    app.provide(RouterSymbol, router)
    app.provide(dataSymbol, vitePressData)

    console.log('✅ Provided RouterSymbol at app level:', RouterSymbol.toString())
    console.log('✅ Provided dataSymbol at app level:', dataSymbol.toString())

    // Also provide the symbols globally for components that might access them directly
    if (typeof window !== 'undefined') {
      window.__VITEPRESS_ROUTER__ = router
      window.__VITEPRESS_DATA__ = vitePressData
      console.log('✅ Provided VitePress symbols globally with extracted bundle')
    }

    // Install global components from extracted VitePress
    app.component('Content', Content)
    app.component('ClientOnly', ClientOnly)
    console.log('✅ Installed extracted VitePress global components')

    // Expose $frontmatter & $params
    Object.defineProperties(app.config.globalProperties, {
      $frontmatter: {
        get() {
          return vitePressData.frontmatter.value
        }
      },
      $params: {
        get() {
          return vitePressData.params.value
        }
      }
    })

    app.mount(container)
    this.mountedApp = app

    //html element class dark if props.isDark
    document.documentElement.classList.toggle('dark', props.isDark)

    console.log('✅ VitePress app mounted with extracted bundle')
    return app
  }

  // Extract CSS from the mounted app
  extractComponentCSS() {
    const allStyles = []

    // Get all style sheets from the document
    for (const sheet of document.styleSheets) {
      try {
        for (const rule of sheet.cssRules) {
          allStyles.push(rule.cssText)
        }
      } catch (e) {
        // Skip cross-origin stylesheets
      }
    }

    return allStyles.join('\n')
  }

  // Generate VitePress CSS
  async generateVitePressCSS(isDark = false) {
    // Extract CSS from the current document stylesheets
    const componentCSS = this.extractComponentCSS()

    // Combine with base VitePress styles
    return `
      /* Extracted Component CSS */
      ${componentCSS}
    `
  }

  // Clean up mounted app
  cleanup() {
    if (this.mountedApp) {
      this.mountedApp.unmount()
      this.mountedApp = null
    }
  }
}

// Export for both module and browser environments
export { VitePressExtractedRenderer }

// Browser global export
if (typeof window !== 'undefined') {
  window.VitePressExtractedRenderer = VitePressExtractedRenderer
}
