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

# Install chezmoi
echo "📝 Installing chezmoi..."
brew install chezmoi

# Initialize and apply dotfiles
echo "🔗 Applying dotfiles from mgoodric/macos-config..."
chezmoi init --apply mgoodric/macos-config

# Get the chezmoi source directory
CHEZMOI_SOURCE=$(chezmoi source-path)

# Install Homebrew packages
echo "📦 Installing Homebrew packages..."
brew bundle --file="$CHEZMOI_SOURCE/Brewfile" || echo "⚠️  Some Homebrew packages failed to install, continuing..."

# Run macOS defaults
if [[ -f "$CHEZMOI_SOURCE/setup-macos-defaults.sh" ]]; then
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