#!/bin/bash
# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install chezmoi and apply dotfiles
brew install chezmoi
chezmoi init --apply mgoodric/macos-config

# Run Brewfile
brew bundle --file="$(chezmoi source-path)/Brewfile"

# Post-install scripts
./setup-macos-defaults.sh
./setup-app-configs.sh
