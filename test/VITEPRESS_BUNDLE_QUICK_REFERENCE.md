# VitePress Browser Bundle - Quick Reference

## 🚀 Quick Commands

### Build the Bundle

```bash
# Extract VitePress components
./scripts/extract-vitepress-browser-bundle.sh

# Build browser bundle
npx vite build --config vite.extracted.config.js

# Test the bundle
open test-extracted-bundle.html
```

### Update VitePress Version

```bash
# 1. Update package.json
npm update vitepress

# 2. Re-extract components
./scripts/extract-vitepress-browser-bundle.sh

# 3. Rebuild bundle
npx vite build --config vite.extracted.config.js
```

## 📁 Key Files

| File                                                             | Purpose                    |
| ---------------------------------------------------------------- | -------------------------- |
| `scripts/extract-vitepress-browser-bundle.sh`                    | Extracts VitePress package |
| `vite.extracted.config.js`                                       | Vite build configuration   |
| `src/browser-bundle/vitepress-theme/client/vitepress-exports.js` | Central exports            |
| `src/browser-bundle/VitePressExtractedRenderer.js`               | Main renderer class        |
| `test-extracted-bundle.html`                                     | Test page                  |

## 🔧 Configuration

### Vite Config Key Settings

```javascript
resolve: {
  alias: {
    '!vitepress': resolve(__dirname, 'src/browser-bundle/vitepress-theme/client/vitepress-exports.js')
  }
}
```

### Bundle Output

- **ES Module**: `assets/js/vitepress-extracted-renderer.es.js`
- **UMD Module**: `assets/js/vitepress-extracted-renderer.umd.js`
- **Size**: ~533KB (194KB gzipped)

## 🐛 Troubleshooting

### Common Issues

**Import Error**: `"X" is not exported by "!vitepress"`

- **Fix**: Add export to `vitepress-exports.js`

**Node.js Error**: `Module "node:fs" has been externalized`

- **Fix**: Re-run extraction script to remove Node.js imports

**Build Fails**: `Could not resolve "!vitepress"`

- **Fix**: Check alias path in `vite.extracted.config.js`

### Debug Steps

1. Check browser console for errors
2. Verify `!vitepress` alias resolves
3. Ensure all exports in `vitepress-exports.js`
4. Test with `test-extracted-bundle.html`

## 📖 Usage Example

```javascript
// Import the renderer
import { VitePressExtractedRenderer } from './assets/js/vitepress-extracted-renderer.es.js'

// Create renderer
const renderer = new VitePressExtractedRenderer({
  base: '/my-app/'
})

// Render components
const app = renderer.renderToApp('#app', {
  // component props
})
```

## 🔄 Maintenance

### Adding New Components

1. Add to `vitepress-exports.js`:
   ```javascript
   export { NewComponent } from './path/to/NewComponent.js'
   ```
2. Import in renderer:
   ```javascript
   import { NewComponent } from '!vitepress'
   ```

### Updating Dependencies

- VitePress: Re-run extraction script
- Vue/VueUse: Update in package.json and rebuild
- Markdown-it: Update in package.json and rebuild

---

**📚 Full Documentation**: [VitePress Browser Bundle Guide](VITEPRESS_BROWSER_BUNDLE_GUIDE.md)
