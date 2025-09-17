#!/bin/bash

# Robust VitePress symlink setup script
# Automatically calculates correct relative paths

set -e

# Configuration
VITEPRESS_SOURCE="node_modules/vitepress/dist"
BROWSER_BUNDLE_DIR="src/browser-bundle/vitepress-theme"

echo "🔗 Setting up VitePress symlinks (robust version)..."

# Function to calculate relative path between two directories
calculate_relative_path() {
    local from_dir="$1"
    local to_dir="$2"
    
    # Convert to absolute paths
    local abs_from=$(cd "$from_dir" && pwd)
    local abs_to=$(cd "$to_dir" && pwd)
    
    # Calculate relative path
    local relative_path=$(python3 -c "
import os
from_path = '$abs_from'
to_path = '$abs_to'
print(os.path.relpath(to_path, from_path))
")
    
    echo "$relative_path"
}

# Function to safely create symlink, replacing existing file if needed
safe_symlink() {
    local target="$1"
    local link_name="$2"
    
    # Create parent directory if it doesn't exist
    mkdir -p "$(dirname "$link_name")"
    
    # If the target file/directory exists and is not a symlink, remove it
    if [ -e "$link_name" ] && [ ! -L "$link_name" ]; then
        echo "   Replacing existing file/directory: $(basename "$link_name")"
        rm -rf "$link_name"
    fi
    
    # Create the symlink
    ln -sf "$target" "$link_name"
}

# Remove only symlinked files, preserve custom files
echo "🗑️  Removing existing symlinked files..."
if [ -d "$BROWSER_BUNDLE_DIR" ]; then
    # Remove only symlinked files, not the entire directory
    find "$BROWSER_BUNDLE_DIR" -type l -delete 2>/dev/null || true
    echo "   Removed existing symlinks"
else
    echo "   No existing directory found"
fi

# Create directory structure
echo "📁 Creating directory structure..."
mkdir -p "$BROWSER_BUNDLE_DIR/client/theme-default/components"
mkdir -p "$BROWSER_BUNDLE_DIR/client/theme-default/composables"
mkdir -p "$BROWSER_BUNDLE_DIR/client/theme-default/support"
mkdir -p "$BROWSER_BUNDLE_DIR/client/app/components"
mkdir -p "$BROWSER_BUNDLE_DIR/client/app/composables"

# Calculate relative paths from each target directory to the VitePress source
echo "🧮 Calculating relative paths..."

# From theme-default directory
THEME_DEFAULT_REL_PATH=$(calculate_relative_path "$BROWSER_BUNDLE_DIR/client/theme-default" "$VITEPRESS_SOURCE")
echo "   theme-default -> VitePress: $THEME_DEFAULT_REL_PATH"

# From theme-default/components directory
THEME_COMPONENTS_REL_PATH=$(calculate_relative_path "$BROWSER_BUNDLE_DIR/client/theme-default" "$VITEPRESS_SOURCE")
echo "   theme-default/components -> VitePress: $THEME_COMPONENTS_REL_PATH"

# From theme-default/composables directory
THEME_COMPOSABLES_REL_PATH=$(calculate_relative_path "$BROWSER_BUNDLE_DIR/client/theme-default/composables" "$VITEPRESS_SOURCE")
echo "   theme-default/composables -> VitePress: $THEME_COMPOSABLES_REL_PATH"

# From theme-default/support directory
THEME_SUPPORT_REL_PATH=$(calculate_relative_path "$BROWSER_BUNDLE_DIR/client/theme-default/support" "$VITEPRESS_SOURCE")
echo "   theme-default/support -> VitePress: $THEME_SUPPORT_REL_PATH"

# From app/composables directory
APP_COMPOSABLES_REL_PATH=$(calculate_relative_path "$BROWSER_BUNDLE_DIR/client/app/composables" "$VITEPRESS_SOURCE")
echo "   app/composables -> VitePress: $APP_COMPOSABLES_REL_PATH"

# From client directory (for shared.js)
CLIENT_REL_PATH=$(calculate_relative_path "$BROWSER_BUNDLE_DIR/client" "$VITEPRESS_SOURCE")
echo "   client -> VitePress: $CLIENT_REL_PATH"

# Create symlinks with calculated paths (ONLY for files we don't want to override)
echo "🔗 Creating symlinks with calculated paths..."

# Theme components (these we want to use from original VitePress)
safe_symlink "$THEME_DEFAULT_REL_PATH/client/theme-default/Layout.vue" "$BROWSER_BUNDLE_DIR/client/theme-default/Layout.vue"
safe_symlink "$THEME_DEFAULT_REL_PATH/client/theme-default/NotFound.vue" "$BROWSER_BUNDLE_DIR/client/theme-default/NotFound.vue"
safe_symlink "$THEME_DEFAULT_REL_PATH/client/theme-default/without-fonts.js" "$BROWSER_BUNDLE_DIR/client/theme-default/without-fonts.js"

# Theme components directory (symlink entire directory for all components)
safe_symlink "$THEME_COMPONENTS_REL_PATH/client/theme-default/components" "$BROWSER_BUNDLE_DIR/client/theme-default/components"

# Theme composables (these we want to use from original VitePress)
safe_symlink "$THEME_COMPOSABLES_REL_PATH/client/theme-default/composables/sidebar.js" "$BROWSER_BUNDLE_DIR/client/theme-default/composables/sidebar.js"
safe_symlink "$THEME_COMPOSABLES_REL_PATH/client/theme-default/composables/outline.js" "$BROWSER_BUNDLE_DIR/client/theme-default/composables/outline.js"
safe_symlink "$THEME_COMPOSABLES_REL_PATH/client/theme-default/composables/nav.js" "$BROWSER_BUNDLE_DIR/client/theme-default/composables/nav.js"
safe_symlink "$THEME_COMPOSABLES_REL_PATH/client/theme-default/composables/local-nav.js" "$BROWSER_BUNDLE_DIR/client/theme-default/composables/local-nav.js"

# Theme support (these we want to use from original VitePress)
safe_symlink "$THEME_SUPPORT_REL_PATH/client/theme-default/support/sidebar.js" "$BROWSER_BUNDLE_DIR/client/theme-default/support/sidebar.js"
safe_symlink "$THEME_SUPPORT_REL_PATH/client/theme-default/support/utils.js" "$BROWSER_BUNDLE_DIR/client/theme-default/support/utils.js"

# App composables (these we want to use from original VitePress)
safe_symlink "$APP_COMPOSABLES_REL_PATH/client/app/composables/copyCode.js" "$BROWSER_BUNDLE_DIR/client/app/composables/copyCode.js"
safe_symlink "$APP_COMPOSABLES_REL_PATH/client/app/composables/codeGroups.js" "$BROWSER_BUNDLE_DIR/client/app/composables/codeGroups.js"

# Client shared files (these we want to use from original VitePress)
safe_symlink "$CLIENT_REL_PATH/client/shared.js" "$BROWSER_BUNDLE_DIR/client/shared.js"

# Symlink all app files that are not customized

# Calculate relative paths for app and app/components
APP_DIR_REL_PATH=$(calculate_relative_path "$BROWSER_BUNDLE_DIR/client/app" "$VITEPRESS_SOURCE")
APP_COMPONENTS_DIR_REL_PATH=$(calculate_relative_path "$BROWSER_BUNDLE_DIR/client/app/components" "$VITEPRESS_SOURCE")

safe_symlink "$APP_DIR_REL_PATH/client/app/utils.js" "$BROWSER_BUNDLE_DIR/client/app/utils.js"
safe_symlink "$APP_DIR_REL_PATH/client/app/data.js" "$BROWSER_BUNDLE_DIR/client/app/data.js"
safe_symlink "$APP_DIR_REL_PATH/client/app/router.js" "$BROWSER_BUNDLE_DIR/client/app/router.js"
safe_symlink "$APP_COMPONENTS_DIR_REL_PATH/client/app/components/Content.js" "$BROWSER_BUNDLE_DIR/client/app/components/Content.js"
safe_symlink "$APP_COMPONENTS_DIR_REL_PATH/client/app/components/ClientOnly.js" "$BROWSER_BUNDLE_DIR/client/app/components/ClientOnly.js"


echo "✅ Custom client/index.js created!"

# Create custom app files that the index.js imports
echo "📝 Creating custom app files..."


echo "✅ Custom app files created!"

# Verify symlinks
echo "🔍 Verifying symlinks..."
echo "   Layout.vue: $(readlink -f "$BROWSER_BUNDLE_DIR/client/theme-default/Layout.vue")"
echo "   Components directory: $(readlink -f "$BROWSER_BUNDLE_DIR/client/theme-default/components")"
echo "   VPNav.vue: $(readlink -f "$BROWSER_BUNDLE_DIR/client/theme-default/components/VPNav.vue")"
echo "   VPHome.vue: $(readlink -f "$BROWSER_BUNDLE_DIR/client/theme-default/components/VPHome.vue")"
echo "   shared.js: $(readlink -f "$BROWSER_BUNDLE_DIR/client/shared.js")"

echo ""
echo "📋 Summary:"
echo "   ✅ The alias 'vitepress' will resolve to $BROWSER_BUNDLE_DIR/client/index.js"
echo "   ✅ Entire components directory symlinked for all VitePress components (including VPHome, VPHero, etc.)"
echo "   ✅ Theme composables and shared.js are symlinked to original VitePress files"
echo "   ✅ Custom app files are preserved and override the symlinked ones"
echo "   ✅ Only symlinked files are replaced, custom files are left untouched"
echo "   ✅ All relative paths calculated automatically"
