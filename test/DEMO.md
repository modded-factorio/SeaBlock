# VitePress Browser Editor Demo

This directory contains demo files and scripts to test the VitePress-compatible browser-based editor.

## Quick Start

```bash
# Build and serve the demo
npm run demo
```

This will:

1. Build the browser bundle if needed
2. Start a demo server on port 8080
3. Display helpful information about available demo pages

## Demo Pages

### Main Demo

- **URL**: http://localhost:8080/demo-vitepress-editor.html
- **Features**: Comprehensive demo with VitePress features, custom containers, and detailed explanations

### Test Editor

- **URL**: http://localhost:8080/test-editor.html
- **Features**: Simple test interface for the editor widget

## Available Scripts

```bash
# Main demo script (recommended)
npm run demo

# Simple Python server (alternative)
npm run demo:simple

# Build browser bundle only
npm run build:browser
```

## Features to Test

### VitePress-Compatible Processing

- ✅ Frontmatter handling
- ✅ Custom containers (`::: tip`, `::: warning`, `::: details`)
- ✅ Code blocks with syntax highlighting
- ✅ Tables, lists, and other markdown elements

### Editor Features

- ✅ Real-time preview
- ✅ Split-pane interface
- ✅ Copy to GitHub functionality
- ✅ Theme switching (light/dark)
- ✅ Fullscreen preview
- ✅ Resizable panes

### Browser Bundle

- ✅ Standalone JavaScript module
- ✅ Vue 3 component architecture
- ✅ VitePress-compatible styling
- ✅ No external dependencies (except Vue)

## Sample Markdown

Try this VitePress-compatible markdown in the editor:

````markdown
---
title: SeaBlock Wiki Guide
description: A comprehensive guide to the SeaBlock mod
---

# Welcome to SeaBlock Wiki

This is a **comprehensive guide** to the SeaBlock mod for Factorio.

## Getting Started

::: tip Pro Tip
SeaBlock is a challenging modpack that transforms Factorio into a resource management puzzle!
:::

### Key Features

- **Complex resource chains** - Everything starts from water and air
- **Advanced automation** - Requires sophisticated factory design
- **Long-term progression** - Hundreds of hours of gameplay

::: warning Important
SeaBlock is significantly more complex than vanilla Factorio. Be prepared for a steep learning curve!
:::

### Code Example

```javascript
// Example automation script
const resourceFlow = calculateOptimalFlow()
console.log('Optimal flow:', resourceFlow)
```
````

::: details Advanced Configuration
For advanced users, you can configure custom resource ratios:

```yaml
resource_ratios:
  iron: 1.0
  copper: 0.8
  steel: 0.3
```

:::

> **Note**: This is just the beginning of your SeaBlock journey!

[Learn more about SeaBlock](https://github.com/SeaBlockCommunity/SeaBlock)

```

## Architecture

The browser editor uses a **VitePress-compatible markdown processing pipeline**:

1. **Markdown Input** - User types markdown in the left pane
2. **VitePress Processing** - Markdown is processed through VitePress-compatible pipeline
3. **Vue Rendering** - Processed content is rendered using Vue components
4. **Live Preview** - Right pane shows exactly how it will look on the VitePress site

This approach ensures that what you see in the editor preview matches exactly what will be rendered on the live VitePress site.
```
