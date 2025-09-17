# SeaBlock Wiki

A comprehensive wiki for the SeaBlock mod for Factorio, built with VitePress and featuring a browser-based WYSIWYG editor.

## 🚀 Features

- **True WYSIWYG Editing** - Edit content with our browser-based editor that shows exactly how your changes will appear
- **VitePress Powered** - Modern, fast static site generation with Vue.js
- **GitHub Pages Ready** - Automatic deployment to GitHub Pages
- **Mobile Friendly** - Responsive design that works on all devices
- **Community Driven** - Open source and community-maintained

## 🏗️ Architecture

This project uses a dual SSG approach:

1. **Node.js VitePress** - Generates the static site for GitHub Pages
2. **Browser Bundle** - VitePress compiled to JavaScript for client-side rendering
3. **WYSIWYG Editor** - Browser-based editor with live preview

### 📚 Documentation

- **[VitePress Browser Bundle Guide](VITEPRESS_BROWSER_BUNDLE_GUIDE.md)** - Complete guide to the custom VitePress browser bundle solution
- **[Vite Dependencies Guide](VITE_DEPENDENCIES_GUIDE.md)** - Analysis of VitePress browser compatibility challenges

## 🛠️ Development

### Prerequisites

- Node.js 18+
- npm or yarn

### Quick Start

1. **Clone the repository**

   ```bash
   git clone https://github.com/SeaBlock/SeaBlock.git
   cd SeaBlock-wiki
   ```

2. **Install dependencies**

   ```bash
   npm install
   ```

3. **Start development**

   ```bash
   # Start VitePress development server
   npm run dev

   # Or start the WYSIWYG editor
   npm run dev:editor

   # Or start both servers
   ./dev.sh all
   ```

### Development Scripts

- `npm run dev` - Start VitePress development server (port 5173)
- `npm run dev:editor` - Start WYSIWYG editor (port 3000)
- `npm run build` - Build VitePress site for production
- `npm run build:browser` - Build browser bundle for client-side rendering
- `npm run build:editor` - Build WYSIWYG editor for production
- `npm run preview` - Preview production build locally

### VS Code Devcontainer

For the best development experience, use the included devcontainer:

1. Open the project in VS Code
2. Click "Reopen in Container" when prompted
3. The container will automatically set up Node.js, VitePress, and all dependencies

## 📁 Project Structure

```
SeaBlock-wiki/
├── .devcontainer/              # VS Code devcontainer configuration
├── .github/workflows/          # GitHub Actions for deployment
├── .vitepress/                 # VitePress configuration
│   ├── config.js              # Main VitePress config
│   └── theme/                 # Custom theme files
├── content/                    # Markdown content
├── src/                        # Source code
│   ├── browser-bundle/        # VitePress browser bundle
│   └── editor/                # WYSIWYG editor
├── assets/                     # Static assets
├── package.json               # Dependencies and scripts
└── README.md                  # This file
```

## 🎨 WYSIWYG Editor

The WYSIWYG editor provides a true "What You See Is What You Get" experience:

- **Split-pane interface** - Markdown source on the left, live preview on the right
- **Real-time rendering** - Uses the actual VitePress renderer
- **Copy to GitHub** - One-click export to GitHub editor
- **Fullscreen preview** - Test navigation and full-page rendering
- **Dark/Light themes** - Choose your preferred theme

### Using the Editor

1. Navigate to `/editor/` on your local development server
2. Edit markdown in the left pane
3. See live preview in the right pane
4. Use "Copy to GitHub" to publish your changes

## 🚀 Deployment

The site is automatically deployed to GitHub Pages when changes are pushed to the `main` branch.

### Manual Deployment

```bash
# Build the site
npm run build

# The dist/ folder contains the built site
# Deploy dist/ to your hosting provider
```

## 🤝 Contributing

We welcome contributions! Here's how to get started:

1. **Fork the repository**
2. **Create a feature branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```
3. **Make your changes**
4. **Test your changes**
   ```bash
   npm run dev
   ```
5. **Submit a pull request**

### Content Contributions

- Use the WYSIWYG editor to create and edit content
- Follow the existing content structure and style
- Test your changes locally before submitting

### Code Contributions

- Follow the existing code style
- Add tests for new features
- Update documentation as needed

## 📚 Content Guidelines

### Writing Style

- Use clear, concise language
- Include code examples where helpful
- Add screenshots for complex concepts
- Keep content up-to-date with mod versions

### Markdown Guidelines

- Use proper heading hierarchy (H1 → H2 → H3)
- Include front matter for page metadata
- Use code blocks with language specification
- Link to related pages and external resources

## 🐛 Issues and Support

- **Bug Reports** - Use GitHub Issues
- **Feature Requests** - Use GitHub Discussions
- **Questions** - Join our Discord server
- **Documentation** - Check the wiki itself

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **VitePress Team** - For the amazing static site generator
- **Vue.js Team** - For the reactive framework
- **SeaBlock Community** - For the mod and community support
- **Contributors** - Everyone who helps improve this wiki

---

**Happy building! 🏗️**

_Built with ❤️ for the SeaBlock community_

