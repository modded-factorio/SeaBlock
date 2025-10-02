#!/bin/bash

# Cross-platform Factorio Data Extraction Script
# Compatible with both Windows (Git Bash/WSL) and Linux
# Extracts Factorio data dumps for mod development and analysis

set -e  # Exit on any error

# Colors for output (works in most terminals)
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to detect OS
detect_os() {
    case "$(uname -s)" in
        Linux*)     OS="linux";;
        Darwin*)    OS="macos";;
        CYGWIN*)    OS="windows";;
        MINGW*)     OS="windows";;
        MSYS*)      OS="windows";;
        *)          OS="unknown";;
    esac
    echo "$OS"
}

# Function to find Factorio executable
find_factorio_executable() {
    local factorio_path="$1"
    local os=$(detect_os)
    
    if [ -n "$factorio_path" ]; then
        # User provided path, validate it
        if [ -f "$factorio_path" ]; then
            echo "$factorio_path"
            return 0
        else
            print_error "Provided Factorio path does not exist: $factorio_path"
            return 1
        fi
    fi
    
    # Auto-detect based on OS
    case "$os" in
        "linux")
            # Common Linux locations
            local paths=(
                "/usr/games/factorio"
                "/usr/local/games/factorio"
                "/opt/factorio/bin/x64/factorio"
                "$HOME/.local/share/Steam/steamapps/common/Factorio/bin/x64/factorio"
                "$HOME/.steam/steam/steamapps/common/Factorio/bin/x64/factorio"
            )
            ;;
        "macos")
            # Common macOS locations
            local paths=(
                "/Applications/Factorio.app/Contents/MacOS/factorio"
                "$HOME/Applications/Factorio.app/Contents/MacOS/factorio"
                "$HOME/Library/Application Support/Steam/steamapps/common/Factorio/bin/x64/factorio"
            )
            ;;
        *)
            print_error "Unsupported operating system: $os"
            return 1
            ;;
    esac
    
    # Check each path
    for path in "${paths[@]}"; do
        if [ -f "$path" ]; then
            echo "$path"
            return 0
        fi
    done
    
    print_error "Could not find Factorio executable. Please provide the path manually."
    return 1
}

# Function to get user input
get_user_input() {
    local prompt="$1"
    local default="$2"
    local input
    
    if [ -n "$default" ]; then
        read -p "$prompt [$default]: " input
        echo "${input:-$default}"
    else
        read -p "$prompt: " input
        echo "$input"
    fi
}

# Function to validate language codes
validate_language_codes() {
    local codes="$1"
    
    # Basic validation - should be comma-separated codes
    if [[ ! "$codes" =~ ^[a-z]{2}(,[a-z]{2})*$ ]]; then
        print_error "Invalid language codes format. Use comma-separated 2-letter codes (e.g., 'en,de,fr')"
        return 1
    fi
    
    return 0
}

# Function to extract raw graphics from Factorio installation and mods
extract_raw_graphics() {
    local factorio_path="$1"
    local factorio_dir="$(dirname "$factorio_path")"
    local base_dir="$(dirname "$(dirname "$factorio_dir")")"
    local base_graphics_dir="$base_dir/data/base/graphics"
    local mods_dir="$base_dir/mods"
    local output_dir="../data-dumps/raw-graphics"
    
    print_info "Looking for base graphics in: $base_graphics_dir"
    print_info "Looking for mods in: $mods_dir"
    
    # Create output directory
    mkdir -p "$output_dir"
    
    # Extract base game graphics
    if [ -d "$base_graphics_dir" ]; then
        print_info "Extracting base game graphics..."
        
        # Copy entity graphics (assembling machines, furnaces, etc.)
        if [ -d "$base_graphics_dir/entity" ]; then
            print_info "Copying base entity graphics..."
            cp -r "$base_graphics_dir/entity" "$output_dir/"
        fi
        
        # Copy equipment graphics
        if [ -d "$base_graphics_dir/equipment" ]; then
            print_info "Copying base equipment graphics..."
            cp -r "$base_graphics_dir/equipment" "$output_dir/"
        fi
        
        # Copy technology graphics
        if [ -d "$base_graphics_dir/technology" ]; then
            print_info "Copying base technology graphics..."
            cp -r "$base_graphics_dir/technology" "$output_dir/"
        fi
        
        # Copy item graphics
        if [ -d "$base_graphics_dir/icons" ]; then
            print_info "Copying base icon graphics..."
            cp -r "$base_graphics_dir/icons" "$output_dir/"
        fi
        
        # Copy item-group graphics
        if [ -d "$base_graphics_dir/item-group" ]; then
            print_info "Copying base item-group graphics..."
            cp -r "$base_graphics_dir/item-group" "$output_dir/"
        fi
    else
        print_error "Base graphics directory not found: $base_graphics_dir"
    fi
    
    # Extract mod graphics
    local mod_locations=(
        "$mods_dir"
        "$base_dir/mods"
        "$(dirname "$base_dir")/mods"
        "$HOME/.factorio/mods"
        "$HOME/Library/Application Support/factorio/mods"
        "$APPDATA/Factorio/mods"
    )
    
    # Handle 2.0 built-in mods (elevated-rails, space-age, quality, etc.)
    # These are stored in the main data directory, not in mods folder
    local data_dir="$base_dir/data"
    if [ -d "$data_dir" ]; then
        print_info "Checking for 2.0 built-in mods in: $data_dir"
        
        # Look for elevated-rails
        if [ -d "$data_dir/elevated-rails" ]; then
            print_info "Found elevated-rails mod, extracting graphics..."
            if [ -d "$data_dir/elevated-rails/graphics" ]; then
                mkdir -p "$output_dir/elevated-rails"
                cp -r "$data_dir/elevated-rails/graphics"/* "$output_dir/elevated-rails/" 2>/dev/null || true
                print_success "Extracted elevated-rails graphics"
            fi
        fi
        
        # Look for space-age
        if [ -d "$data_dir/space-age" ]; then
            print_info "Found space-age mod, extracting graphics..."
            if [ -d "$data_dir/space-age/graphics" ]; then
                mkdir -p "$output_dir/space-age"
                cp -r "$data_dir/space-age/graphics"/* "$output_dir/space-age/" 2>/dev/null || true
                print_success "Extracted space-age graphics"
            fi
        fi
        
        # Look for quality
        if [ -d "$data_dir/quality" ]; then
            print_info "Found quality mod, extracting graphics..."
            if [ -d "$data_dir/quality/graphics" ]; then
                mkdir -p "$output_dir/quality"
                cp -r "$data_dir/quality/graphics"/* "$output_dir/quality/" 2>/dev/null || true
                print_success "Extracted quality graphics"
            fi
        fi
        
        # Look for any other 2.0 mods
        for mod_dir in "$data_dir"/*; do
            if [ -d "$mod_dir" ] && [ -d "$mod_dir/graphics" ]; then
                local mod_name=$(basename "$mod_dir")
                if [[ "$mod_name" != "base" && "$mod_name" != "core" ]]; then
                    print_info "Found 2.0 mod: $mod_name, extracting graphics..."
                    mkdir -p "$output_dir/$mod_name"
                    cp -r "$mod_dir/graphics"/* "$output_dir/$mod_name/" 2>/dev/null || true
                    print_success "Extracted $mod_name graphics"
                fi
            fi
        done
    fi
    
    local mods_found=false
    for mod_location in "${mod_locations[@]}"; do
        if [ -d "$mod_location" ]; then
            print_info "Found mods directory: $mod_location"
            mods_found=true
            
            # Process each mod file/directory
            for mod_item in "$mod_location"/*; do
                if [ -e "$mod_item" ]; then
                    local mod_name=$(basename "$mod_item")
                    print_info "Processing mod: $mod_name"
                    
                    # Check if it's a zip file
                    if [[ "$mod_name" == *.zip ]]; then
                        print_info "Extracting graphics from mod zip: $mod_name"
                        # Create temporary directory for extraction
                        local temp_dir=$(mktemp -d)
                        if unzip -q "$mod_item" -d "$temp_dir" 2>/dev/null; then
                            print_info "Successfully extracted $mod_name"
                            
                            # Look for graphics in the extracted content
                            # Some mods have graphics at the root, others in subdirectories
                            local graphics_found=false
                            
                            # Extract mod name without .zip extension for directory naming
                            local clean_mod_name="${mod_name%.zip}"
                            
                            # Check root level graphics
                            if [ -d "$temp_dir/graphics" ]; then
                                print_info "Found graphics in $mod_name, copying to mod directory..."
                                mkdir -p "$output_dir/$clean_mod_name"
                                cp -r "$temp_dir/graphics"/* "$output_dir/$clean_mod_name/" 2>/dev/null || true
                                graphics_found=true
                            fi
                            
                            # Check for graphics in subdirectories (some mods have nested structure)
                            for subdir in "$temp_dir"/*; do
                                if [ -d "$subdir" ] && [ -d "$subdir/graphics" ]; then
                                    print_info "Found graphics in $mod_name subdirectory, copying to mod directory..."
                                    mkdir -p "$output_dir/$clean_mod_name"
                                    cp -r "$subdir/graphics"/* "$output_dir/$clean_mod_name/" 2>/dev/null || true
                                    graphics_found=true
                                fi
                            done
                            
                            if [ "$graphics_found" = false ]; then
                                print_info "No graphics directory found in $mod_name"
                                # List contents for debugging
                                print_info "Contents of $mod_name:"
                                ls -la "$temp_dir" 2>/dev/null | head -10
                            fi
                        else
                            print_warning "Failed to extract $mod_name"
                        fi
                        
                        # Clean up
                        rm -rf "$temp_dir"
                    elif [ -d "$mod_item" ]; then
                        # Regular directory
                        if [ -d "$mod_item/graphics" ]; then
                            print_info "Copying graphics from mod directory: $mod_name"
                            mkdir -p "$output_dir/$mod_name"
                            cp -r "$mod_item/graphics"/* "$output_dir/$mod_name/" 2>/dev/null || true
                        else
                            print_info "No graphics directory found in $mod_name"
                        fi
                    fi
                fi
            done
            break  # Use the first found mods directory
        fi
    done
    
    if [ "$mods_found" = false ]; then
        print_warning "No mods directory found in common locations"
        print_info "This is normal if no mods are installed"
    fi
    
    print_success "Raw graphics extracted to: $output_dir"
    
    # Show summary of what was extracted
    if [ -d "$output_dir" ]; then
        print_info "Extraction summary:"
        find "$output_dir" -type d -maxdepth 2 | sort
        print_info "Total graphics files: $(find "$output_dir" -name "*.png" | wc -l)"
    fi
    
    return 0
}

# Main function
main() {
    print_info "Factorio Data Extraction Script"
    print_info "================================"
    
    # Parse command line arguments
    FACTORIO_PATH=""
    LANGUAGE_CODES="en"
    
    while [[ $# -gt 0 ]]; do
        case $1 in
            -p|--path)
                FACTORIO_PATH="$2"
                shift 2
                ;;
            -l|--languages)
                LANGUAGE_CODES="$2"
                shift 2
                ;;
            -h|--help)
                echo "Usage: $0 [OPTIONS]"
                echo ""
                echo "Options:"
                echo "  -p, --path PATH        Path to Factorio executable"
                echo "  -l, --languages CODES  Comma-separated language codes (default: en)"
                echo "  -h, --help            Show this help message"
                echo ""
                echo "Examples:"
                echo "  $0"
                echo "  $0 -p /usr/games/factorio -l en,de,fr"
                echo "  $0 --path \"C:/Program Files/Factorio/bin/x64/factorio.exe\" --languages en"
                exit 0
                ;;
            *)
                print_error "Unknown option: $1"
                echo "Use -h or --help for usage information"
                exit 1
                ;;
        esac
    done
    
    # Get Factorio path if not provided
    if [ -z "$FACTORIO_PATH" ]; then
        print_info "Attempting to auto-detect Factorio installation..."
        FACTORIO_PATH=$(find_factorio_executable "")
        
        if [ $? -ne 0 ]; then
            print_info "Please provide the path to your Factorio executable:"
            FACTORIO_PATH=$(get_user_input "Factorio executable path")
            
            if [ -z "$FACTORIO_PATH" ]; then
                print_error "No Factorio path provided. Exiting."
                exit 1
            fi
        fi
    else
        # Validate provided path
        if ! find_factorio_executable "$FACTORIO_PATH" > /dev/null; then
            exit 1
        fi
    fi
    
    # Get language codes if not provided
    if [ "$LANGUAGE_CODES" = "en" ] && [ -z "$2" ]; then
        print_info "Language codes not specified. Using default: en"
        print_info "You can specify multiple languages separated by commas (e.g., 'en,de,fr')"
        read -p "Enter language codes [en]: " user_languages
        if [ -n "$user_languages" ]; then
            LANGUAGE_CODES="$user_languages"
        fi
    fi
    
    # Validate language codes
    if ! validate_language_codes "$LANGUAGE_CODES"; then
        exit 1
    fi
    
    print_success "Using Factorio executable: $FACTORIO_PATH"
    print_success "Using language codes: $LANGUAGE_CODES"
    
    # Run Factorio with data-dump parameters sequentially
    print_info "Starting Factorio data extraction..."
    print_info "This may take a few minutes depending on your system..."
    print_info "Note: Factorio will output to its script output folder."
    
    # Run the extractions sequentially (each command must be run separately)
    print_info "Running --dump-data..."
    if ! "$FACTORIO_PATH" --dump-data; then
        print_error "Factorio --dump-data failed!"
        exit 1
    fi
    
    print_info "Running --dump-prototype-locale..."
    if ! "$FACTORIO_PATH" --dump-prototype-locale; then
        print_error "Factorio --dump-prototype-locale failed!"
        exit 1
    fi
    
    print_info "Running --dump-icon-sprites..."
    if ! "$FACTORIO_PATH" --dump-icon-sprites; then
        print_error "Factorio --dump-icon-sprites failed!"
        exit 1
    fi
    
    print_info "Extracting raw graphics from Factorio installation..."
    if ! extract_raw_graphics "$FACTORIO_PATH"; then
        print_error "Raw graphics extraction failed!"
        exit 1
    fi
    
    print_success "All Factorio data extractions completed successfully!"
    
    # Find Factorio's script output folder (usually in the same directory as the executable)
    local factorio_dir="$(dirname "$FACTORIO_PATH")"
    local script_output_dir="$(dirname "$(dirname "$factorio_dir")")/script-output"
    
    # Alternative locations to check
    local alt_locations=(
        "$(dirname "$factorio_dir")/script-output"
        "$HOME/.factorio/script-output"
        "$HOME/Documents/My Games/Factorio/script-output"
    )
    
    # Check if script-output exists in the factorio directory
    if [ ! -d "$script_output_dir" ]; then
        for alt_dir in "${alt_locations[@]}"; do
            if [ -d "$alt_dir" ]; then
                script_output_dir="$alt_dir"
                break
            fi
        done
    fi
    
    if [ -d "$script_output_dir" ]; then
        print_info "Found Factorio script output directory: $script_output_dir"
        
        # Create data-dumps directory if it doesn't exist
        local script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
        local project_root="$(dirname "$script_dir")"
        local data_dumps_dir="$project_root/data-dumps"
        
        if [ ! -d "$data_dumps_dir" ]; then
            print_info "Creating data-dumps directory: $data_dumps_dir"
            mkdir -p "$data_dumps_dir"
        fi
        
        # Copy files from script output to our organized directory
        print_info "Copying extracted files to: $data_dumps_dir"
        cp -r "$script_output_dir"/* "$data_dumps_dir/" 2>/dev/null || true
        
        # List extracted files
        print_info "Extracted files:"
        ls -la "$data_dumps_dir"
        
        # Show file sizes
        print_info "Total size: $(du -sh "$data_dumps_dir" | cut -f1)"
        
        print_success "Data extraction completed successfully!"
        print_success "Output directory: $data_dumps_dir"
    else
        print_warning "Could not find Factorio script output directory."
        print_info "Please check the following locations manually:"
        print_info "  - $factorio_dir/script-output"
        for alt_dir in "${alt_locations[@]}"; do
            print_info "  - $alt_dir"
        done
    fi
    
    print_success "Script completed successfully!"
    print_info "You can now use the extracted data for mod development or analysis."
}

# Run main function
main "$@"
