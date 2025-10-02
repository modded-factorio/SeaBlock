import { readFileSync, readdirSync, statSync } from 'fs'
import { resolve, basename } from 'path'

import { defineConfig } from 'vitepress'

import { configData } from './config-data.js'

// Clone the imported config data to avoid mutations
const modifiedConfigData = { ...configData }
modifiedConfigData.themeConfig = { ...configData.themeConfig }

// ---------- Helpers ----------
function safeStat(p) {
  try {
    return statSync(p)
  } catch {
    return null
  }
}

function toTitleCase(s) {
  return s
    .replace(/[-_]+/g, ' ')
    .replace(/\s+/g, ' ')
    .trim()
    .replace(/\b\w/g, c => c.toUpperCase())
}

function getMarkdownTitle(absFilePath, fallback) {
  try {
    const raw = readFileSync(absFilePath, 'utf-8')

    // Try YAML frontmatter `title:`
    const fmMatch = raw.match(/^---\s*[\s\S]*?^---/m)
    if (fmMatch) {
      const titleMatch =
        fmMatch[0].match(/^\s*title\s*:\s*(.+)\s*$/im) ||
        fmMatch[0].match(/^\s*title\s*:\s*["']([^"']+)["']\s*$/im)
      if (titleMatch) {
        return titleMatch[1].replace(/^["']|["']$/g, '').trim()
      }
    }

    // Fallback: first H1
    const h1Match = raw.match(/^\s*#\s+(.+?)\s*$/m)
    if (h1Match) return h1Match[1].trim()

    // Last resort: filename
    return fallback
  } catch {
    return fallback
  }
}

const docsRoot = resolve(process.cwd(), 'docs')

/**
 * Build sidebar for a given directory.
 * Rules:
 * - Files: index.md / README.md first, then the rest (alpha).
 * - Directories:
 *   - If the recursive result yields exactly one page item, roll it into a shared "Child Pages" group.
 *   - Otherwise, keep a normal subgroup with its own title.
 * - Each item's text is SSR-derived from the page title.
 */
function buildSidebar(dir, basePath = '') {
  const entries = readdirSync(dir, { withFileTypes: true })

  const files = []
  const dirs = []

  for (const entry of entries) {
    if (entry.isFile() && entry.name.toLowerCase().endsWith('.md')) files.push(entry.name)
    else if (entry.isDirectory()) dirs.push(entry.name)
  }

  // Sort files with index.md/README.md first, then alpha
  const indexNames = new Set(['index.md', 'readme.md'])
  const sortedFiles = files.sort((a, b) => {
    const ai = indexNames.has(a.toLowerCase()) ? -1 : 0
    const bi = indexNames.has(b.toLowerCase()) ? -1 : 0
    if (ai !== bi) return ai - bi
    return a.localeCompare(b, undefined, { numeric: true, sensitivity: 'base' })
  })

  const sidebar = []
  const rolledUpChildPages = []

  // Add file pages
  for (const file of sortedFiles) {
    const relPath = basePath ? `${basePath}/${file}` : file
    const link = `/${relPath.replace(/\\/g, '/').replace(/\/+/g, '/')}`.replace(/\.md$/i, '')
    const absFile = resolve(dir, file)
    const text = getMarkdownTitle(absFile, file.replace(/\.md$/i, ''))
    sidebar.push({ text, link })
  }

  // Handle subdirectories
  for (const sub of dirs.sort((a, b) =>
    a.localeCompare(b, undefined, { numeric: true, sensitivity: 'base' })
  )) {
    const subDir = resolve(dir, sub)
    const subRel = basePath ? `${basePath}/${sub}` : sub

    const children = buildSidebar(subDir, subRel)

    // Determine if this subgroup resolves to a single *page* item (not another group)
    const flattenableSingle =
      children.length === 1 &&
      'link' in children[0] && // single direct page
      typeof children[0].link === 'string'

    if (flattenableSingle) {
      // Roll into the shared "Child Pages" group
      rolledUpChildPages.push(children[0])
    } else if (children.length > 0) {
      // Title for the subgroup: prefer the subfolder's index.md title, else folder name
      const indexMd = resolve(subDir, 'index.md')
      const readmeMd = resolve(subDir, 'README.md')
      const titleSource =
        (safeStat(indexMd)?.isFile() && indexMd) ||
        (safeStat(readmeMd)?.isFile() && readmeMd) ||
        null
      const groupTitle = titleSource
        ? getMarkdownTitle(titleSource, toTitleCase(sub))
        : toTitleCase(sub)
      sidebar.push({ text: groupTitle, items: children })
    }
  }

  if (rolledUpChildPages.length) {
    // Keep "/" index of current folder first within this group too, if present
    const sorted = rolledUpChildPages.sort((a, b) =>
      a.text.localeCompare(b.text, undefined, { numeric: true, sensitivity: 'base' })
    )
    sidebar.push({
      text: 'Child Pages',
      items: sorted
    })
  }

  return sidebar
}

// ---------- Build sidebar based on nav ----------
const sidebarConfig = {}

if (modifiedConfigData.themeConfig?.nav) {
  modifiedConfigData.themeConfig.nav.forEach(navItem => {
    if (navItem?.link) {
      const navPath = navItem.link.replace(/^\/+|\/+$/g, '')
      const folderPath = resolve(docsRoot, navPath)
      if (safeStat(folderPath)?.isDirectory()) {
        sidebarConfig[`/${navPath}/`] = buildSidebar(folderPath, navPath)
      }
    }
  })
}

modifiedConfigData.themeConfig.sidebar = sidebarConfig

export default defineConfig({
  ...modifiedConfigData,
  transformPageData(pageData) {
    try {
      const markdownPath = resolve(process.cwd(), 'docs', pageData.relativePath)
      const rawMarkdown = readFileSync(markdownPath, 'utf-8')

      // Encode the raw markdown content as base64
      const encoded = Buffer.from(rawMarkdown, 'utf-8').toString('base64')

      // Attach comprehensive markdown data to the pageData for editor consumption
      pageData.frontmatter.__encodedMarkdown = encoded
      pageData.frontmatter.__markdownLength = rawMarkdown.length
      pageData.frontmatter.__markdownHash = Buffer.from(rawMarkdown).toString('base64').slice(0, 16)

      // Add metadata for editor
      pageData.frontmatter.__editorData = {
        hasContent: rawMarkdown.trim().length > 0,
        contentLength: rawMarkdown.length,
        hasFrontmatter: rawMarkdown.startsWith('---'),
        lastModified: new Date().toISOString(),
        pagePath: pageData.relativePath
      }

      // Also provide SSR title here as a safety net (VitePress may set `title` later)
      if (!pageData.title || typeof pageData.title !== 'string') {
        const fallbackFile = resolve(process.cwd(), 'docs', pageData.relativePath)
        const fallbackName = basename(fallbackFile).replace(/\.md$/i, '')
        pageData.title = getMarkdownTitle(fallbackFile, fallbackName)
      }

      console.log(`📝 Injected markdown for ${pageData.relativePath} (${rawMarkdown.length} chars)`)
    } catch (error) {
      console.log(`⚠️ Could not read markdown file for ${pageData.relativePath}:`, error?.message)
    }

    return pageData
  }
})
