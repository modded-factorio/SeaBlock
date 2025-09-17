// exports in this file are exposed to themes and md files via 'vitepress'
// so the user can do `import { useRoute, useData } from 'vitepress'`
// composables
export { dataSymbol, useData, initData, siteDataRef } from './app/data'
export { useRoute, useRouter, RouterSymbol, createRouter } from './app/router'
// utilities
export {
  _escapeHtml,
  defineClientComponent,
  getScrollOffset,
  inBrowser,
  onContentUpdated,
  withBase
} from './app/utils'
// components
export { Content } from './app/components/Content'
export { ClientOnly } from './app/components/ClientOnly'
// markdown processing
export { createMarkdownRenderer, markdownToVue } from '../../markdown.js'

// Config utilities (stubs for browser compatibility)
export const defineConfig = config => config
