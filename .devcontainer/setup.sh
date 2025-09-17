#!/bin/bash

# SeaBlock Wiki Development Environment Setup
echo "🚀 Setting up SeaBlock Wiki development environment..."

# Update npm to latest version
npm install -g npm@latest

# Install VitePress globally for CLI access
npm install -g vitepress@latest

# Install project dependencies
echo "📦 Installing project dependencies..."
npm install

# Create necessary directories
echo "📁 Creating project structure..."
mkdir -p content
mkdir -p assets/js
mkdir -p assets/css
mkdir -p .github/workflows

# Set up git hooks (optional)
echo "🔧 Setting up development tools..."

# Make scripts executable
chmod +x dev.sh 2>/dev/null || true

echo "✅ Development environment setup complete!"
echo ""
echo "Next steps:"
echo "1. Run 'npm run dev' to start the VitePress development server"
echo "2. Run 'npm run build:browser' to build the browser bundle"
echo "3. Run 'npm run dev:editor' to start the WYSIWYG editor"
echo ""
echo "Happy coding! 🎉"

