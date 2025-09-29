# Implementation Plan: VitePress Browser-Based WYSIWYG Wiki

## Project Summary

We're building a **SeaBlock Wiki** that solves the core problem: **GitHub's markdown preview doesn't match the actual site rendering**. Our solution uses VitePress (Vue + Vite) compiled to run in the browser for true WYSIWYG editing.

## Core Requirements
- ✅ **Wiki-style editing** - True WYSIWYG experience
- ✅ **No hosting charges** - Free GitHub Pages hosting
- ✅ **Exact preview** - What you see is what you get
- ✅ **GitHub Pages compatible** - Standard static site deployment

## Architecture Overview

### 1. **Dual SSG Approach**
```
Node.js VitePress (Production) ←→ Browser VitePress (Editing)
     ↓                                    ↓
GitHub Pages Deployment              Live WYSIWYG Preview
```

### 2. **Implementation Flow**
1. **Node.js VitePress** - Generates static site for GitHub Pages
2. **Browser Bundle** - VitePress compiled to JavaScript module
3. **Edit Widget** - Textbox + live preview + navigation testing
4. **Copy-Paste Workflow** - Export markdown → GitHub editor → Deploy

## Technical Stack

### Production (GitHub Pages)
- **VitePress** - Vue-based SSG
- **Markdown** - Content format
- **GitHub Actions** - Automated deployment
- **GitHub Pages** - Free hosting

### Browser Editing
- **VitePress Browser Bundle** - Compiled VitePress for client-side
- **Vue 3** - Component framework
- **Vite** - Build tool (compiled to browser bundle)
- **Live Preview** - Real-time rendering

## Key Features

### WYSIWYG Editor
- **Split-pane interface** - Markdown source + live preview
- **Real-time rendering** - Uses actual VitePress renderer
- **Navigation testing** - Popup with full page preview
- **Copy to GitHub** - One-click export to GitHub editor

### Browser Bundle
- **VitePress core** - Compiled to JavaScript module
- **Vue components** - Client-side rendering
- **Markdown processing** - Same as production
- **Theme support** - Matches production styling

## Implementation Steps

### Phase 1: VitePress Setup
1. Initialize VitePress project
2. Configure for GitHub Pages
3. Set up GitHub Actions deployment
4. Create basic content structure

### Phase 2: Browser Bundle
1. Create VitePress browser build
2. Compile Vue components for client-side
3. Bundle markdown processor
4. Create JavaScript module entry point

### Phase 3: Edit Widget
1. Build WYSIWYG interface
2. Integrate browser bundle
3. Add live preview functionality
4. Implement copy-to-GitHub workflow

### Phase 4: Navigation Testing
1. Create popup preview
2. Add navigation simulation
3. Test full page rendering
4. Optimize performance

## File Structure
```
SeaBlock-wiki/
├── .vitepress/                 # VitePress config
├── .devcontainer/              # Development container
│   ├── devcontainer.json       # VS Code devcontainer config
│   └── setup.sh               # Container setup script
├── content/                    # Markdown content
├── assets/
│   ├── js/
│   │   ├── vitepress-browser-bundle.js  # Compiled VitePress
│   │   └── wysiwyg-editor.js           # Edit widget
│   └── css/
│       └── editor.css                  # Editor styles
├── .github/workflows/          # GitHub Actions
├── package.json               # Dependencies
└── dev.sh                     # Development script
```

## Benefits of This Approach

### ✅ **True WYSIWYG**
- Uses actual VitePress renderer in browser
- Exact match with production site
- Real-time preview updates

### ✅ **No Server Required**
- Pure client-side editing
- No authentication complexity
- No hosting costs

### ✅ **GitHub Integration**
- Copy-paste to GitHub editor
- Standard pull request workflow
- Automated deployment

### ✅ **Vue + Vite Ecosystem**
- Modern, fast tooling
- Excellent developer experience
- Active community support

## Development Environment

### VS Code Devcontainer
- **Node.js 18+** - Latest LTS version
- **VitePress** - Pre-installed and configured
- **Vue 3** - Development tools and extensions
- **Git** - Version control
- **GitHub CLI** - Repository management

### Benefits of Devcontainer
- **Consistent environment** - Same setup for all developers
- **No local dependencies** - Everything runs in container
- **VS Code integration** - Full IDE experience
- **One-click setup** - "Reopen in Container" button
- **Isolated** - No conflicts with local Node.js versions

## Next Steps

1. **Create new branch** - `feature/vitepress-wysiwyg` ✅
2. **Set up devcontainer** - Configure VS Code development environment
3. **Initialize VitePress** - Set up basic project structure
4. **Configure GitHub Pages** - Set up deployment pipeline
5. **Build browser bundle** - Compile VitePress for client-side
6. **Create edit widget** - Build WYSIWYG interface

This approach gives us the best of both worlds: a modern, fast static site generator with true WYSIWYG editing capabilities, all running in a compute-less environment with free hosting.

## Migration from Current Hugo Setup

### What We're Replacing
- **Hugo** → **VitePress** (Vue-based SSG)
- **PaperMod theme** → **VitePress default theme** (customizable)
- **Complex lightweight edit module** → **True WYSIWYG editor**
- **Docker development** → **Node.js devcontainer** (cleaner, more integrated)

### Content Migration
- **Markdown files** - Direct migration (same format)
- **Front matter** - Convert Hugo front matter to VitePress
- **Layouts** - Convert Hugo templates to Vue components
- **Assets** - Migrate CSS/JS to VitePress structure

### Benefits of Migration
- **Simpler development** - Node.js devcontainer instead of Docker
- **Better editing experience** - True WYSIWYG
- **Modern tooling** - Vue 3 + Vite
- **Active ecosystem** - VitePress is actively maintained
- **Integrated development** - VS Code devcontainer with all tools pre-configured
