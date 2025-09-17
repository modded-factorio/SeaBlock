#!/bin/bash

# SeaBlock Wiki Development Script
echo "🚀 Starting SeaBlock Wiki development environment..."

# Check if we're in a devcontainer
if [ -n "$REMOTE_CONTAINERS" ] || [ -n "$CODESPACES" ]; then
    echo "📦 Running in devcontainer/codespace"
    DEV_MODE="container"
else
    echo "💻 Running locally"
    DEV_MODE="local"
fi

# Function to start VitePress dev server
start_vitepress() {
    echo "📚 Starting VitePress development server..."
    npm run dev
}

# Function to start WYSIWYG editor
start_editor() {
    echo "✏️ Starting WYSIWYG editor..."
    npm run dev:editor
}

# Function to build browser bundle
build_browser() {
    echo "🔨 Building browser bundle..."
    npm run build:browser
}

# Function to show help
show_help() {
    echo "SeaBlock Wiki Development Script"
    echo ""
    echo "Usage: ./dev.sh [command]"
    echo ""
    echo "Commands:"
    echo "  vitepress    Start VitePress development server (default)"
    echo "  editor       Start WYSIWYG editor development server"
    echo "  build        Build browser bundle"
    echo "  all          Start both VitePress and editor servers"
    echo "  help         Show this help message"
    echo ""
    echo "Examples:"
    echo "  ./dev.sh              # Start VitePress server"
    echo "  ./dev.sh editor       # Start WYSIWYG editor"
    echo "  ./dev.sh all          # Start both servers"
}

# Main script logic
case "${1:-vitepress}" in
    "vitepress")
        start_vitepress
        ;;
    "editor")
        start_editor
        ;;
    "build")
        build_browser
        ;;
    "all")
        echo "🔄 Starting both servers..."
        echo "VitePress will be available at: http://localhost:5173"
        echo "WYSIWYG Editor will be available at: http://localhost:3000"
        echo ""
        echo "Press Ctrl+C to stop all servers"
        
        # Start both servers in background
        npm run dev &
        VITEPRESS_PID=$!
        
        npm run dev:editor &
        EDITOR_PID=$!
        
        # Wait for both processes
        wait $VITEPRESS_PID $EDITOR_PID
        ;;
    "help"|"-h"|"--help")
        show_help
        ;;
    *)
        echo "❌ Unknown command: $1"
        echo ""
        show_help
        exit 1
        ;;
esac

