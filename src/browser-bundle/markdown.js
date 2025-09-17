// Browser-compatible VitePress markdown processing functions
// Extracted and adapted from VitePress source code

import MarkdownIt from 'markdown-it'
import markdownItAnchor from 'markdown-it-anchor'
import markdownItToc from 'markdown-it-table-of-contents'
import markdownItEmoji from 'markdown-it-emoji'
import markdownItTaskLists from 'markdown-it-task-lists'
import markdownItContainer from 'markdown-it-container'
import markdownItGithubAlerts from 'markdown-it-github-alerts'
import markdownItMathjax3 from 'markdown-it-mathjax3'
import markdownItCjkFriendly from 'markdown-it-cjk-friendly'
import { sfcPlugin } from '@mdit-vue/plugin-sfc'
import { frontmatterPlugin } from '@mdit-vue/plugin-frontmatter'
import { headersPlugin } from '@mdit-vue/plugin-headers'
import { tocPlugin } from '@mdit-vue/plugin-toc'
import { componentPlugin } from '@mdit-vue/plugin-component'
import { titlePlugin } from '@mdit-vue/plugin-title'
import { resolveTitleFromToken, slugify as defaultSlugify } from '@mdit-vue/shared'
import { createHighlighterCore } from 'shiki/core'
import { createOnigurumaEngine } from 'shiki/engine/oniguruma'
import * as Vue from 'vue'
import { h, defineComponent, ref, reactive, computed, watch, onMounted, onUnmounted } from 'vue'
import { compile } from '@vue/compiler-dom'
// Import only the languages we need for Factorio wiki
import javascript from '@shikijs/langs/javascript'
import lua from '@shikijs/langs/lua'
import markdown from '@shikijs/langs/markdown'
import json from '@shikijs/langs/json'
import yaml from '@shikijs/langs/yaml'
import html from '@shikijs/langs/html'
import css from '@shikijs/langs/css'
import bash from '@shikijs/langs/bash'
import diff from '@shikijs/langs/diff'
import ini from '@shikijs/langs/ini'
// Import only the themes we need
import githubDark from '@shikijs/themes/github-dark'
import githubLight from '@shikijs/themes/github-light'

// Simple LRU cache implementation for performance optimization
class LRUCache {
  constructor(maxSize = 100) {
    this.maxSize = maxSize
    this.cache = new Map()
  }

  get(key) {
    if (this.cache.has(key)) {
      const value = this.cache.get(key)
      // Move to end (most recently used)
      this.cache.delete(key)
      this.cache.set(key, value)
      return value
    }
    return null
  }

  set(key, value) {
    if (this.cache.has(key)) {
      this.cache.delete(key)
    } else if (this.cache.size >= this.maxSize) {
      // Remove least recently used (first item)
      const firstKey = this.cache.keys().next().value
      this.cache.delete(firstKey)
    }
    this.cache.set(key, value)
  }

  clear() {
    this.cache.clear()
  }
}

// Global cache for compiled markdown results
const markdownCache = new LRUCache(100)

// Simple hash function for cache keys
async function hashString(str) {
  const encoder = new TextEncoder()
  const data = encoder.encode(str)
  const hashBuffer = await crypto.subtle.digest('SHA-256', data)
  const hashArray = Array.from(new Uint8Array(hashBuffer))
  return hashArray.map(b => b.toString(16).padStart(2, '0')).join('')
}

// Inject GitHub Alerts CSS if not already present
async function injectGitHubAlertsCSS() {
  // Check if CSS is already injected
  if (document.getElementById('github-alerts-css')) {
    return
  }

  try {
    // Import CSS from the plugin
    const baseCSS = await import('markdown-it-github-alerts/styles/github-base.css?inline')
    const colorsCSS = await import(
      'markdown-it-github-alerts/styles/github-colors-light.css?inline'
    )

    const style = document.createElement('style')
    style.id = 'github-alerts-css'
    style.textContent = baseCSS.default + colorsCSS.default
    document.head.appendChild(style)
  } catch (error) {
    console.warn('Failed to load GitHub Alerts CSS:', error)
    // Fallback: inject basic styles
    const style = document.createElement('style')
    style.id = 'github-alerts-css'
    style.textContent = `
      .markdown-alert {
        padding: 0.5rem 1rem;
        margin-bottom: 16px;
        color: inherit;
        border-left: .25em solid #888;
      }
      .markdown-alert .markdown-alert-title {
        display: flex;
        font-weight: 500;
        align-items: center;
        line-height: 1;
      }
      .markdown-alert .markdown-alert-title .octicon {
        margin-right: 0.5rem;
        display: inline-block;
        overflow: visible !important;
        vertical-align: text-bottom;
        fill: currentColor;
      }
    `
    document.head.appendChild(style)
  }
}

// Browser-compatible createMarkdownRenderer
export async function createMarkdownRenderer(
  srcDir = '',
  options = {},
  base = '/',
  logger = console
) {
  const theme = options.theme ?? { light: 'github-light', dark: 'github-dark' }
  const codeCopyButtonTitle = options.codeCopyButtonTitle || 'Copy Code'
  const hasSingleTheme = typeof theme === 'string' || 'name' in theme

  // Create markdown-it instance with VitePress-like configuration
  // Using the captured constructor reference to avoid closure issues
  const md = new MarkdownIt({
    html: true,
    linkify: true,
    typographer: true,
    breaks: true,
    ...options
  })

  // Configure linkify
  md.linkify.set({ fuzzyLink: false })

  // Initialize syntax highlighter with fine-grained bundles for Factorio wiki
  let highlighter = null
  try {
    highlighter = await createHighlighterCore({
      themes: [githubLight, githubDark],
      langs: [
        javascript,
        lua, // Factorio modding
        markdown,
        json,
        yaml,
        html,
        css,
        bash, // Command examples
        diff, // Code changes
        ini // Factorio config files
      ],
      engine: createOnigurumaEngine(import('shiki/wasm'))
    })
  } catch (error) {
    logger.warn('Failed to initialize syntax highlighter:', error)
  }

  // Apply VitePress-like plugins
  if (options.preConfig) {
    options.preConfig(md)
  }

  // Use container plugin for custom blocks
  md.use(markdownItContainer, 'tip')
  md.use(markdownItContainer, 'warning')
  md.use(markdownItContainer, 'danger')
  md.use(markdownItContainer, 'details')
  md.use(markdownItContainer, 'alert')

  // Use GitHub Alerts plugin for modern alert syntax
  md.use(markdownItGithubAlerts)

  // Inject GitHub Alerts CSS
  await injectGitHubAlertsCSS()

  // Use MathJax3 plugin for math support
  md.use(markdownItMathjax3)

  // Use CJK-friendly plugin for better CJK language support
  md.use(markdownItCjkFriendly)

  // Use mdit-vue plugins (VitePress approach)
  const slugify = options.anchor?.slugify ?? defaultSlugify

  // Use component plugin for Vue components
  md.use(componentPlugin, { ...options.component })

  // Use frontmatter plugin for YAML front matter parsing
  md.use(frontmatterPlugin, { ...options.frontmatter })

  // Use headers plugin for header extraction
  if (options.headers !== false) {
    md.use(headersPlugin, {
      level: [2, 3, 4, 5, 6],
      slugify,
      ...(typeof options.headers === 'boolean' ? undefined : options.headers)
    })
  }

  // Use SFC plugin for Vue component extraction (like VitePress)
  md.use(sfcPlugin, {
    customBlocks: ['docs', 'i18n', 'api', 'demo', 'example'],
    ...options.sfc
  })

  // Use title plugin for title extraction
  md.use(titlePlugin)

  // Use TOC plugin
  md.use(tocPlugin, {
    slugify,
    ...options.toc,
    format: s => {
      const title = s.replaceAll('&amp;', '&') // encoded twice because of restoreEntities
      return options.toc?.format?.(title) ?? title
    }
  })

  // Use anchor plugin with VitePress-style configuration
  md.use(markdownItAnchor, {
    slugify,
    getTokensText: tokens => {
      return tokens
        .filter(t => !['html_inline', 'emoji'].includes(t.type))
        .map(t => t.content)
        .join('')
    },
    permalink: (slug, _, state, idx) => {
      const title =
        state.tokens[idx + 1]?.children
          ?.filter(token => ['text', 'code_inline'].includes(token.type))
          .reduce((acc, t) => acc + t.content, '')
          .trim() || ''

      const linkTokens = [
        Object.assign(new state.Token('text', '', 0), { content: ' ' }),
        Object.assign(new state.Token('link_open', 'a', 1), {
          attrs: [
            ['class', 'header-anchor'],
            ['href', `#${slug}`],
            ['aria-label', `Permalink to "${title}"`]
          ]
        }),
        Object.assign(new state.Token('html_inline', '', 0), {
          content: '&#8203;',
          meta: { isPermalinkSymbol: true }
        }),
        new state.Token('link_close', 'a', -1)
      ]

      state.tokens[idx + 1].children?.push(...linkTokens)
    },
    ...options.anchor
  })

  // Use emoji plugin
  md.use(markdownItEmoji, { ...options.emoji })

  // Use task lists plugin
  md.use(markdownItTaskLists)

  // Configure syntax highlighting
  if (highlighter) {
    // Define the languages we support for Factorio wiki
    const supportedLanguages = [
      'javascript',
      'lua',
      'markdown',
      'json',
      'yaml',
      'html',
      'css',
      'bash',
      'diff',
      'ini'
    ]

    md.set({
      highlight: (str, lang) => {
        if (!lang || !supportedLanguages.includes(lang)) {
          return ''
        }
        try {
          return highlighter.codeToHtml(str, {
            lang,
            theme: hasSingleTheme ? theme : theme.light
          })
        } catch (error) {
          logger.warn(`Failed to highlight code block with language "${lang}":`, error)
          return ''
        }
      }
    })
  }

  // Custom table renderer for accessibility
  md.renderer.rules.table_open = function (tokens, idx, options, env, self) {
    return '<table tabindex="0">\n'
  }

  // Custom image renderer for optimization and lazy loading
  md.renderer.rules.image = function (tokens, idx, options, env, self) {
    const token = tokens[idx]
    const src = token.attrGet('src')
    const alt = token.attrGet('alt') || ''
    const title = token.attrGet('title')

    // Add lazy loading and optimization attributes
    let attrs = `src="${src}" alt="${alt}" loading="lazy"`
    if (title) attrs += ` title="${title}"`

    // Add responsive image support
    attrs += ' style="max-width: 100%; height: auto;"'

    return `<img ${attrs}>`
  }

  // Custom link renderer for external link handling
  md.renderer.rules.link_open = function (tokens, idx, options, env, self) {
    const token = tokens[idx]
    const href = token.attrGet('href')

    // Check if it's an external link
    const isExternal = href && (href.startsWith('http://') || href.startsWith('https://'))

    if (isExternal) {
      // Add target="_blank" and rel="noopener noreferrer" for external links
      token.attrSet('target', '_blank')
      token.attrSet('rel', 'noopener noreferrer')
    }

    return self.renderToken(tokens, idx, options)
  }

  // Note: Removed custom HTML block renderer override
  // The SFC plugin handles Vue blocks directly during parsing

  // Custom container renderers for VitePress-like styling
  md.renderer.rules.container_tip_open = function (tokens, idx, options, env, self) {
    const token = tokens[idx]
    const title = token.info.trim().split(' ').slice(1).join(' ') || 'Tip'
    return `<div class="custom-block tip">\n<p class="custom-block-title">${title}</p>\n`
  }
  md.renderer.rules.container_tip_close = function (tokens, idx, options, env, self) {
    return '</div>\n'
  }
  md.renderer.rules.container_warning_open = function (tokens, idx, options, env, self) {
    const token = tokens[idx]
    const title = token.info.trim().split(' ').slice(1).join(' ') || 'Warning'
    return `<div class="custom-block warning">\n<p class="custom-block-title">${title}</p>\n`
  }
  md.renderer.rules.container_warning_close = function (tokens, idx, options, env, self) {
    return '</div>\n'
  }
  md.renderer.rules.container_danger_open = function (tokens, idx, options, env, self) {
    const token = tokens[idx]
    const title = token.info.trim().split(' ').slice(1).join(' ') || 'Danger'
    return `<div class="custom-block danger">\n<p class="custom-block-title">${title}</p>\n`
  }
  md.renderer.rules.container_danger_close = function (tokens, idx, options, env, self) {
    return '</div>\n'
  }
  md.renderer.rules.container_details_open = function (tokens, idx, options, env, self) {
    const token = tokens[idx]
    const title = token.info.trim().split(' ').slice(1).join(' ') || 'Details'
    return `<details class="custom-block details">\n<summary>${title}</summary>\n`
  }
  md.renderer.rules.container_details_close = function (tokens, idx, options, env, self) {
    return '</details>\n'
  }

  return md
}

// Browser-compatible markdownToVue function (VitePress-style)
export async function markdownToVue(src, file = '', options = {}) {
  // Create cache key based on content and options
  const contentHash = await hashString(src)
  const cacheKey = `${file}:${src.length}:${contentHash}`

  // Check cache first
  const cached = markdownCache.get(cacheKey)
  if (cached) {
    return cached
  }

  // Create markdown renderer
  const md = await createMarkdownRenderer('', options)

  // Reset environment before render (VitePress approach)
  const env = {
    path: file,
    relativePath: file,
    includes: []
  }

  // Render markdown to HTML - frontmatter is now processed by the plugin
  console.log('🔍 [markdownToVue] Rendering markdown to HTML with frontmatter plugin...')
  const html = md.render(src, env)
  console.log('🔍 [markdownToVue] HTML rendered, length:', html.length)

  // Extract data from environment (set by plugins)
  const { frontmatter = {}, headers = [], links = [], sfcBlocks, title = '' } = env

  // Create comprehensive PageData structure (VitePress-style)
  const pageData = {
    title: inferTitle(md, frontmatter, title),
    titleTemplate: frontmatter.titleTemplate,
    description: inferDescription(frontmatter),
    frontmatter,
    headers,
    relativePath: file,
    filePath: file
  }

  // Create Vue component for mixed content (HTML + Vue components)
  console.log('🔍 [markdownToVue] Creating Vue component for mixed content...')
  const component = createMixedContentComponent(html, pageData, sfcBlocks)
  console.log('🔍 [markdownToVue] Vue component created')

  const result = {
    renderFunction: component,
    pageData,
    frontmatter,
    headers,
    title: pageData.title,
    description: pageData.description,
    html,
    deadLinks: [] // Could implement dead link detection later
  }

  // Cache the result
  markdownCache.set(cacheKey, result)

  return result
}

// Note: Custom front matter parsing removed - now using @mdit-vue/plugin-frontmatter

// Helper function to extract headers from HTML
function extractHeaders(html) {
  const headers = []
  const headerRegex = /<h([1-6])[^>]*id="([^"]*)"[^>]*>(.*?)<\/h[1-6]>/g
  let match

  while ((match = headerRegex.exec(html)) !== null) {
    headers.push({
      level: parseInt(match[1]),
      id: match[2],
      title: match[3].replace(/<[^>]*>/g, '').trim()
    })
  }

  return headers
}

// Helper function to infer title (VitePress-style)
function inferTitle(md, frontmatter, title) {
  if (typeof frontmatter.title === 'string') {
    const titleToken = md.parseInline(frontmatter.title, {})[0]
    if (titleToken) {
      return resolveTitleFromToken(titleToken, {
        shouldAllowHtml: false,
        shouldEscapeText: false
      })
    }
  }
  return title
}

// Helper function to infer description (VitePress-style)
function inferDescription(frontmatter) {
  const { description, head } = frontmatter

  if (description !== undefined) {
    return description
  }

  return (head && getHeadMetaContent(head, 'description')) || ''
}

// Helper function to get head meta content
function getHeadMetaContent(head, name) {
  if (!head || !head.length) {
    return undefined
  }

  const meta = head.find(([tag, attrs = {}]) => {
    return tag === 'meta' && attrs.name === name && attrs.content
  })

  return meta && meta[1].content
}

// Helper function to create Vue component for mixed content (HTML + Vue components)
function createMixedContentComponent(html, pageData, sfcBlocks = {}) {
  console.log('🔍 [Mixed Content Component] Creating Vue component for mixed content...')

  // Create a complete SFC string and compile it
  try {
    // Build the complete SFC string
    const sfcParts = []

    // Inject page data and add script blocks (VitePress-style)
    const pageDataCode = `\nexport const __pageData = JSON.parse(${JSON.stringify(
      JSON.stringify(pageData)
    )})`

    // Add script blocks with page data injection
    if (sfcBlocks.scripts?.length > 0) {
      const allScriptContent = sfcBlocks.scripts
        .map(scriptBlock => scriptBlock.contentStripped)
        .filter(content => content.trim())
        .join('\n\n')

      const hasScriptSetup = sfcBlocks.scripts.some(scriptBlock =>
        scriptBlock.tagOpen?.includes('setup')
      )

      if (hasScriptSetup) {
        sfcParts.push(`<script setup>
${pageDataCode}
${allScriptContent}
</script>`)
      } else {
        sfcParts.push(`<script>
${pageDataCode}
${allScriptContent}
export default {name:${JSON.stringify(pageData.relativePath)}}
</script>`)
      }
    } else {
      // No existing script, create one with page data
      sfcParts.push(`<script>
${pageDataCode}
export default {name:${JSON.stringify(pageData.relativePath)}}
</script>`)
    }

    // Add template (wrap HTML in template tags)
    sfcParts.push(`<template>
${html}
</template>`)

    // Add style blocks
    if (sfcBlocks.styles?.length > 0) {
      sfcBlocks.styles.forEach(styleBlock => {
        sfcParts.push(`<style${styleBlock.tagOpen?.includes('scoped') ? ' scoped' : ''}>
${styleBlock.content}
</style>`)
      })
    }

    // Join all parts to create complete SFC
    const completeSFC = sfcParts.join('\n\n')
    console.log('🔍 [SFC Compilation] Complete SFC length:', completeSFC.length)

    // Compile the template content (use template blocks if available, otherwise wrap html in a root element)
    let templateContent = html
    if (sfcBlocks.templates?.length > 0) {
      // Extract content from template blocks (without the <template> tags)
      templateContent = sfcBlocks.templates
        .map(templateBlock => templateBlock.contentStripped)
        .filter(content => content.trim())
        .join('\n\n')
    } else if (html.trim()) {
      // Wrap HTML content in a single root element for Vue compilation
      templateContent = `<div class="markdown-content">${html}</div>`
    }

    console.log('🔍 [Template Compilation] Template content:', templateContent)
    console.log('🔍 [Template Compilation] SFC blocks templates:', sfcBlocks.templates)
    console.log('🔍 [Template Compilation] HTML content:', html)
    console.log('🔍 [Template Compilation] All SFC blocks:', sfcBlocks)

    const compileResult = compile(templateContent)
    console.log('🔍 [Template Compilation] Compile result:', compileResult)
    console.log('🔍 [Template Compilation] Compile errors:', compileResult.errors)

    // Extract the render function from the compiled code
    // The compiled code needs Vue runtime functions to be available
    const compiledTemplate = new Function(
      'Vue',
      'h',
      'ref',
      'reactive',
      'computed',
      'watch',
      'onMounted',
      'onUnmounted',
      compileResult.code
    )(Vue, h, ref, reactive, computed, watch, onMounted, onUnmounted)
    console.log('🔍 [Template Compilation] Compiled template function:', compiledTemplate)
    console.log(
      '🔍 [Template Compilation] Compiled template function type:',
      typeof compiledTemplate
    )
    console.log(
      '🔍 [Template Compilation] Compiled template function toString:',
      compiledTemplate.toString()
    )

    // Handle regular script blocks (not setup) - merge with component options
    const componentOptions = {
      name: 'MarkdownPageComponent'
    }

    if (sfcBlocks.scripts?.length > 0) {
      const regularScripts = sfcBlocks.scripts.filter(
        scriptBlock => !scriptBlock.tagOpen?.includes('setup')
      )

      if (regularScripts.length > 0) {
        const regularScriptContent = regularScripts
          .map(scriptBlock => scriptBlock.contentStripped)
          .filter(content => content.trim())
          .join('\n\n')

        try {
          // Check if script contains import statements
          if (regularScriptContent.includes('import ')) {
            console.warn(
              '⚠️ [Regular Script] Import statements not supported in regular script blocks'
            )
            // Skip execution if contains imports
          } else {
            const scriptFunction = new Function(
              'Vue',
              'ref',
              'reactive',
              'computed',
              'watch',
              'onMounted',
              'onUnmounted',
              'h',
              `
              ${regularScriptContent}
              return typeof module !== 'undefined' && module.exports ? module.exports : {}
              `
            )

            const scriptResult = scriptFunction(
              Vue,
              ref,
              reactive,
              computed,
              watch,
              onMounted,
              onUnmounted,
              h
            )

            // Merge script result with component options
            Object.assign(componentOptions, scriptResult)
          }
        } catch (error) {
          console.error('❌ [Regular Script] Execution failed:', error)
        }
      }
    }

    // Create a component that uses the compiled template and includes the script logic
    const component = defineComponent({
      ...componentOptions,
      setup(props, ctx) {
        // Only handle script setup blocks in setup function
        if (sfcBlocks.scripts?.length > 0) {
          const setupScripts = sfcBlocks.scripts.filter(scriptBlock =>
            scriptBlock.tagOpen?.includes('setup')
          )

          if (setupScripts.length > 0) {
            const setupScriptContent = setupScripts
              .map(scriptBlock => scriptBlock.contentStripped)
              .filter(content => content.trim())
              .join('\n\n')

            // Check if script contains import statements
            if (setupScriptContent.includes('import ')) {
              console.warn(
                '⚠️ [Script Setup] Import statements not supported in setup script blocks'
              )
              return {}
            } else {
              const ids = collectTopLevelIds(setupScriptContent)
              const returnStmt = ids.length ? `\n;return { ${ids.join(', ')} }` : '\n;return {}'
              const body = setupScriptContent + returnStmt

              const fn = new Function(
                'Vue',
                'ref',
                'reactive',
                'computed',
                'watch',
                'onMounted',
                'onUnmounted',
                'h',
                'props',
                'emit',
                'slots',
                'attrs',
                'expose',
                body
              )

              try {
                return fn(
                  Vue,
                  ref,
                  reactive,
                  computed,
                  watch,
                  onMounted,
                  onUnmounted,
                  h,
                  props,
                  ctx.emit,
                  ctx.slots,
                  ctx.attrs,
                  ctx.expose
                )
              } catch (e) {
                console.error('❌ [Script Setup] failed:', e)
                return {}
              }
            }
          }
        }

        return {}
      }
    })

    // Set the render function after component creation
    component.render = function () {
      console.log('🔍 [Render] Component instance:', this)
      console.log('🔍 [Render] Setup data:', this.$setup)
      const result = compiledTemplate(this)
      console.log('🔍 [Render] Compiled template result:', result)
      return result
    }

    return component
  } catch (error) {
    console.error('❌ [SFC Compilation] Failed to compile complete SFC:', error)

    // Fallback: create a simple component with innerHTML
    return defineComponent({
      name: 'MarkdownPageComponentFallback',
      render() {
        return h('div', {
          class: 'vp-doc',
          innerHTML: html
        })
      }
    })
  }
}
function collectTopLevelIds(code) {
  const ids = new Set()
  // vars
  for (const m of code.matchAll(/\b(?:const|let|var)\s+([A-Za-z_$][\w$]*)/g)) {
    ids.add(m[1])
  }
  // functions
  for (const m of code.matchAll(/\bfunction\s+([A-Za-z_$][\w$]*)/g)) {
    ids.add(m[1])
  }
  // classes
  for (const m of code.matchAll(/\bclass\s+([A-Za-z_$][\w$]*)/g)) {
    ids.add(m[1])
  }
  return Array.from(ids)
}

// Export cache management functions
export function clearMarkdownCache() {
  markdownCache.clear()
}

export function getCacheStats() {
  return {
    size: markdownCache.cache.size,
    maxSize: markdownCache.maxSize
  }
}
