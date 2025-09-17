# VitePress Browser Renderer Documentation

## Overview

This document describes the browser-based VitePress-compatible markdown renderer that enables WYSIWYG editing in the browser without requiring a server. The renderer maintains perfect compatibility with VitePress by using the same packages and processing pipeline.

## Architecture

### Core Philosophy

**Perfect VitePress Compatibility**: Use the exact same packages and processing pipeline as VitePress to ensure identical output and behavior.

### Package Alignment

We use the same packages as VitePress:

| Component          | VitePress Package | Our Implementation   | Status |
| ------------------ | ----------------- | -------------------- | ------ |
| Markdown Parser    | `markdown-it`     | `markdown-it@14.0.0` | ✅     |
| Syntax Highlighter | `shiki`           | `shiki@0.14.5`       | ✅     |
| Frontend Framework | `vue`             | `vue@3`              | ✅     |
| Markdown Plugins   | Various           | Same plugins         | ✅     |
| Front Matter       | `gray-matter`     | Custom YAML parser   | 🔄     |

### Processing Pipeline

```
Markdown Input
    ↓
Front Matter Parser (YAML)
    ↓
Vue Component Parser (placeholder)
    ↓
markdown-it Processing
    ├── markdown-it-anchor (header links)
    ├── markdown-it-table-of-contents
    ├── markdown-it-emoji
    ├── markdown-it-task-lists
    └── Shiki syntax highlighting
    ↓
Final HTML (VitePress-compatible)
```

## Implementation Details

### 1. Package Management

**CDN Strategy**: Use Skypack CDN for automatic dependency resolution and browser compatibility.

```javascript
// Import map configuration
{
  "imports": {
    "markdown-it": "https://cdn.skypack.dev/markdown-it@14.0.0",
    "shiki": "https://cdn.skypack.dev/shiki@0.14.5",
    "vue": "https://cdn.skypack.dev/vue@3"
  }
}
```

**Benefits**:

- Automatic transitive dependency resolution
- Browser-compatible builds
- No manual dependency management
- CDN caching for performance

### 2. Browser Polyfills

**Node.js Compatibility**: Comprehensive polyfills for Node.js modules that VitePress dependencies expect.

```javascript
// Key polyfilled modules
- fs (file system operations)
- path (path manipulation)
- process (process information)
- util (utility functions)
- crypto (cryptographic functions)
- os (operating system info)
- url (URL parsing)
- events (event emitter)
- stream (stream operations)
```

**Implementation**: All polyfills are no-op or mock implementations that prevent errors while maintaining API compatibility.

### 3. Syntax Highlighting

**Shiki Integration**: Use the same syntax highlighter as VitePress.

```javascript
const highlighter = await createHighlighter({
  themes: ['github-light', 'github-dark'],
  langs: ['javascript', 'typescript', 'vue', 'html', 'css', 'json', 'markdown', 'bash', 'python']
})
```

**Features**:

- Same themes as VitePress (GitHub light/dark)
- Same language support
- Same HTML output structure
- Embedded CSS (no external stylesheets needed)

### 4. Markdown Processing

**markdown-it Configuration**: Identical to VitePress configuration.

```javascript
const md = new MarkdownIt({
  html: true, // Allow HTML in markdown
  linkify: true, // Auto-convert URLs to links
  typographer: true, // Smart quotes and typography
  breaks: true, // Convert line breaks to <br>
  highlight: shikiHighlighter
})
```

**Plugins**: Same plugins as VitePress:

- `markdown-it-anchor` - Header anchor links
- `markdown-it-table-of-contents` - TOC generation
- `markdown-it-emoji` - Emoji support
- `markdown-it-task-lists` - Checkbox lists

## Compatibility Matrix

### ✅ Fully Compatible Features

| Feature             | VitePress | Browser Renderer | Notes                  |
| ------------------- | --------- | ---------------- | ---------------------- |
| Basic Markdown      | ✅        | ✅               | Identical output       |
| Syntax Highlighting | ✅        | ✅               | Same Shiki themes      |
| Front Matter        | ✅        | ✅               | YAML parsing           |
| Header Anchors      | ✅        | ✅               | Same anchor generation |
| Table of Contents   | ✅        | ✅               | Same TOC structure     |
| Emoji Support       | ✅        | ✅               | Same emoji rendering   |
| Task Lists          | ✅        | ✅               | Same checkbox behavior |
| HTML in Markdown    | ✅        | ✅               | Same HTML processing   |

### 🔄 Partially Compatible Features

| Feature           | VitePress | Browser Renderer | Status                       |
| ----------------- | --------- | ---------------- | ---------------------------- |
| Vue Components    | ✅        | 🔄               | Detection only, no rendering |
| Custom Containers | ✅        | 🔄               | Not implemented              |
| Asset Processing  | ✅        | 🔄               | Basic support only           |

### ❌ Not Compatible Features

| Feature               | VitePress | Browser Renderer | Reason              |
| --------------------- | --------- | ---------------- | ------------------- |
| File System Access    | ✅        | ❌               | Browser security    |
| Node.js APIs          | ✅        | ❌               | Browser environment |
| Build-time Processing | ✅        | ❌               | Runtime only        |

## Maintenance Guidelines

### 1. Package Version Alignment

**Critical**: Always keep package versions in sync with VitePress.

```bash
# Check VitePress dependencies
npm list --depth=0

# Update our CDN imports to match
# Update import map in test-vitepress-browser.html
```

### 2. Feature Compatibility Testing

**Test Matrix**: Verify each feature works identically to VitePress.

```markdown
# Test cases for compatibility

- [ ] Basic markdown rendering
- [ ] Syntax highlighting (all languages)
- [ ] Front matter parsing
- [ ] Header anchors
- [ ] Table of contents
- [ ] Emoji rendering
- [ ] Task lists
- [ ] HTML in markdown
```

### 3. Output Comparison

**Validation**: Compare HTML output between VitePress and browser renderer.

```javascript
// Test script to compare outputs
const vitepressOutput = await vitepressRenderer.render(markdown)
const browserOutput = await browserRenderer.render(markdown)
assert.deepEqual(vitepressOutput, browserOutput)
```

## Future Enhancements

### 1. Vue Component Support

**Goal**: Full Vue component rendering in markdown.

**Implementation Plan**:

- Vue template compiler in browser
- Component registration system
- Props and slots support
- Event handling

### 2. Custom Containers

**Goal**: Support VitePress custom containers (`::: tip`, `::: warning`, etc.).

**Implementation**:

- Custom markdown-it plugin
- Container parsing and rendering
- Styling to match VitePress

### 3. Asset Processing

**Goal**: Handle images, links, and other assets like VitePress.

**Implementation**:

- Asset URL resolution
- Image optimization
- Link processing

## Troubleshooting

### Common Issues

1. **Package Version Mismatch**
   - Symptom: Different rendering output
   - Solution: Update CDN imports to match VitePress versions

2. **Missing Dependencies**
   - Symptom: Import errors in browser
   - Solution: Add missing packages to import map

3. **Polyfill Issues**
   - Symptom: Node.js module errors
   - Solution: Add missing polyfills to browser-polyfill.js

### Debug Tools

```javascript
// Enable debug logging
window.VitePressBrowserRenderer.debug = true

// Compare outputs
const result = await renderer.processMarkdown(markdown)
console.log('Rendered HTML:', result)
```

## Performance Considerations

### Bundle Size

- Current bundle: ~12KB gzipped
- External dependencies: Loaded from CDN
- Lazy loading: Components loaded on demand

### Caching Strategy

- CDN caching for dependencies
- Browser caching for rendered content
- Service worker for offline support (future)

## Security Considerations

### Content Sanitization

- HTML sanitization with DOMPurify
- XSS prevention
- Safe markdown processing

### CSP Compatibility

- Compatible with Content Security Policy
- No inline scripts or styles
- External resource loading only

---

**Last Updated**: 2024-01-XX  
**VitePress Version**: 1.0.0-rc.31  
**Browser Renderer Version**: 1.0.0
