import { defineConfig } from 'vitepress'
import { configData } from './config-data.js'
import { readFileSync } from 'fs'
import { resolve } from 'path'

export default defineConfig({
  ...configData,
  transformPageData(pageData) {
    try {
      // Try to read the raw markdown file directly
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

      console.log(
        `📝 Injected markdown content for ${pageData.relativePath} (${rawMarkdown.length} chars)`
      )
    } catch (error) {
      console.log(`⚠️ Could not read markdown file for ${pageData.relativePath}:`, error.message)
    }

    return pageData
  }
})
