#!/usr/bin/env bash
set -e  # Exit on error

echo "🚀 Starting macOS setup..."

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until script has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Install Homebrew if not present
if ! command -v brew &> /dev/null; then
    echo "📦 Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add Homebrew to PATH for Apple Silicon Macs
    if [[ $(uname -m) == 'arm64' ]]; then
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
else
    echo "✅ Homebrew already installed"
fi

# Initialize Homebrew environment (ensure brew is in PATH)
if [[ -f "/opt/homebrew/bin/brew" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -f "/usr/local/bin/brew" ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
fi

# Install chezmoi
echo "📝 Installing chezmoi..."
brew install chezmoi

# Verify chezmoi is available
if ! command -v chezmoi &> /dev/null; then
    echo "❌ ERROR: chezmoi not found in PATH after installation"
    exit 1
fi

# Initialize and apply dotfiles
echo "🔗 Applying dotfiles from mgoodric/macos-config..."
chezmoi init --apply mgoodric/macos-config

# Get the chezmoi source directory
CHEZMOI_SOURCE=$(chezmoi source-path)
echo "📁 Chezmoi source: $CHEZMOI_SOURCE"

# Install Homebrew packages
echo "📦 Installing Homebrew packages..."

# Install core packages (common to all machines)
if [[ -f "$CHEZMOI_SOURCE/Brewfile.core" ]]; then
    echo "📦 Installing core packages..."
    brew bundle --file="$CHEZMOI_SOURCE/Brewfile.core" || echo "⚠️  Some core packages failed to install, continuing..."
fi

# Get computer type from chezmoi data
COMPUTER_TYPE=$(chezmoi data | grep -o '"computerType": "[^"]*"' | cut -d'"' -f4)
echo "🖥️  Computer type detected: '$COMPUTER_TYPE'"

# Install computer-type-specific packages
if [[ "$COMPUTER_TYPE" == "work" ]] && [[ -f "$CHEZMOI_SOURCE/Brewfile.work" ]]; then
    echo "📦 Installing work-specific packages..."
    brew bundle --file="$CHEZMOI_SOURCE/Brewfile.work" || echo "⚠️  Some work packages failed to install, continuing..."
elif [[ "$COMPUTER_TYPE" == "personal" ]] && [[ -f "$CHEZMOI_SOURCE/Brewfile.personal" ]]; then
    echo "📦 Installing personal packages..."
    brew bundle --file="$CHEZMOI_SOURCE/Brewfile.personal" || echo "⚠️  Some personal packages failed to install, continuing..."
fi

# Fallback to main Brewfile if it exists (for backwards compatibility)
if [[ -f "$CHEZMOI_SOURCE/Brewfile" ]]; then
    echo "📦 Installing packages from main Brewfile..."
    brew bundle --file="$CHEZMOI_SOURCE/Brewfile" || echo "⚠️  Some Homebrew packages failed to install, continuing..."
fi

# Install direct-download apps (not available via Homebrew or Mac App Store)
install_zip_app() {
    local url="$1"
    local app_name="$2"

    echo "  → Checking $app_name..."

    if [[ -d "/Applications/$app_name.app" ]]; then
        echo "  ✅ $app_name already installed"
        return 0
    fi

    echo "  📥 Downloading $app_name from: $url"
    local temp_dir=$(mktemp -d)
    echo "  📁 Using temp directory: $temp_dir"

    if ! curl -fsSL -o "$temp_dir/app.zip" "$url"; then
        echo "  ⚠️  Failed to download $app_name"
        rm -rf "$temp_dir"
        return 1
    fi
    echo "  ✓ Download complete"

    if ! unzip -q "$temp_dir/app.zip" -d "$temp_dir"; then
        echo "  ⚠️  Failed to unzip $app_name"
        rm -rf "$temp_dir"
        return 1
    fi
    echo "  ✓ Extraction complete"

    if [[ ! -d "$temp_dir/$app_name.app" ]]; then
        echo "  ⚠️  $app_name.app not found in archive. Contents:"
        ls -la "$temp_dir"
        rm -rf "$temp_dir"
        return 1
    fi

    if ! cp -R "$temp_dir/$app_name.app" /Applications/; then
        echo "  ⚠️  Failed to copy $app_name to /Applications"
        rm -rf "$temp_dir"
        return 1
    fi

    rm -rf "$temp_dir"
    echo "  ✅ $app_name installed successfully"
}

# Install direct-download apps based on computer type
echo "📥 Installing direct-download apps..."
echo "🖥️  Computer type for app selection: '$COMPUTER_TYPE'"

# Profile-specific apps (add here if needed)
if [[ "$COMPUTER_TYPE" == "work" ]]; then
    echo "📦 Installing work-specific direct-download apps..."
    install_zip_app "https://github.com/sindresorhus/app-buddy-meta/releases/latest/download/App.Buddy.zip" "App Buddy"
    install_zip_app "https://github.com/sindresorhus/menu-bar-spacing-meta/releases/latest/download/Menu.Bar.Spacing.zip" "Menu Bar Spacing"
elif [[ "$COMPUTER_TYPE" == "personal" ]]; then
    echo "📦 Installing personal direct-download apps..."
    install_zip_app "https://github.com/sindresorhus/app-buddy-meta/releases/latest/download/App.Buddy.zip" "App Buddy"
    install_zip_app "https://github.com/sindresorhus/menu-bar-spacing-meta/releases/latest/download/Menu.Bar.Spacing.zip" "Menu Bar Spacing"
else
    echo "⚠️  Unknown computer type: '$COMPUTER_TYPE' - skipping direct-download apps"
    echo "    Expected 'work' or 'personal'"
fi

# Run macOS defaults
if [[ -f "$CHEZMOI_SOURCE/setup-macos-defaults.sh.tmpl" ]]; then
    echo "⚙️  Configuring macOS defaults..."
    # Use chezmoi to process the template and execute it
    chezmoi execute-template < "$CHEZMOI_SOURCE/setup-macos-defaults.sh.tmpl" | bash
elif [[ -f "$CHEZMOI_SOURCE/setup-macos-defaults.sh" ]]; then
    echo "⚙️  Configuring macOS defaults..."
    bash "$CHEZMOI_SOURCE/setup-macos-defaults.sh"
fi

# Run additional app configs
if [[ -f "$CHEZMOI_SOURCE/setup-app-configs.sh" ]]; then
    echo "🔧 Configuring applications..."
    bash "$CHEZMOI_SOURCE/setup-app-configs.sh"
fi

echo ""
echo "✅ Automated setup complete!"
echo ""
echo "⚠️  Manual steps remaining - see POST_INSTALL.md:"
echo "   - Sign into App Store"
echo "   - Enable Apple Watch unlock"
echo "   - Grant privacy permissions (Hazel, etc.)"
echo "   - Import Hazel rules from hazel-rules/"
echo ""