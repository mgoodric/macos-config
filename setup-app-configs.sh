#!/usr/bin/env bash
# setup-app-configs.sh

# Initialize Homebrew environment (needed for duti, oh-my-posh, etc.)
if [[ -f "/opt/homebrew/bin/brew" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -f "/usr/local/bin/brew" ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
fi

# Import Hazel rules if they exist
if [[ -d "$(chezmoi source-path)/hazel-rules" ]]; then
    echo "📋 Hazel rules available in $(chezmoi source-path)/hazel-rules/"
    echo "   Import manually from Hazel > File > Import Rules"
fi

# Install Oh My Zsh
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    echo "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    echo "✅ Oh My Zsh installed"

    # Oh My Zsh overwrites .zshrc, so re-apply chezmoi to restore our custom config
    if command -v chezmoi &> /dev/null; then
        echo "Restoring custom .zshrc from chezmoi..."
        chezmoi apply ~/.zshrc
        echo "✅ Custom .zshrc restored"
    fi
else
    echo "⏭️  Oh My Zsh already installed"
fi

# Install tmux Plugin Manager (TPM)
if [[ ! -d "$HOME/.tmux/plugins/tpm" ]]; then
    echo "Installing tmux Plugin Manager..."
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    echo "✅ TPM installed"
else
    echo "⏭️  TPM already installed"
fi

# Set up Python environment
if command -v python3 &> /dev/null; then
    # Try to upgrade pip (--break-system-packages flag only works on Python 3.11+)
    python3 -m pip install --upgrade pip --break-system-packages 2>/dev/null || \
    python3 -m pip install --upgrade pip 2>/dev/null || \
    echo "⏭️  Skipping pip upgrade"
    # Add any global Python packages you always want
fi

# Configure Git (if not in .gitconfig)
git config --global init.defaultBranch main

# Install Oh My Posh Meslo font
if command -v oh-my-posh &> /dev/null; then
    echo "Installing MesloLGM Nerd Font for Oh My Posh..."
    oh-my-posh font install meslo
    echo "✅ MesloLGM Nerd Font installed"
else
    echo "⏭️  Oh My Posh not found, skipping font installation"
fi

# Note: iTerm2 font configuration is done manually (see POST_INSTALL.md)
# Programmatic font changes via defaults write can create duplicate profiles
echo "⚠️  iTerm2 font must be configured manually - see POST_INSTALL.md"

# Atuin configuration - import existing zsh history if it exists
if [[ -f "$HOME/.zsh_history" ]]; then
    atuin import zsh || true
fi

###############################################################################
# Enable Touch ID for sudo                                                   #
###############################################################################

echo "Enabling Touch ID for sudo..."

# Use sudo_local instead of editing sudo directly (survives macOS updates)
if [[ ! -f /etc/pam.d/sudo_local ]]; then
    sudo tee /etc/pam.d/sudo_local > /dev/null <<EOF
# sudo_local: local config file which survives system update and is included for sudo
auth       sufficient     pam_tid.so
EOF
    echo "✅ Touch ID enabled for sudo"
else
    echo "✅ Touch ID already configured for sudo"
fi

# Set Keka as default archive handler
if [[ -d "/Applications/Keka.app" ]]; then
    echo "Setting Keka as default archive handler..."
    duti -s com.aone.keka .zip all
    duti -s com.aone.keka .7z all
    duti -s com.aone.keka .rar all
    duti -s com.aone.keka .tar all
    duti -s com.aone.keka .gz all
    duti -s com.aone.keka .bz2 all
    echo "✅ Keka configured as default"
fi

# Set Vivaldi as default browser
if [[ -d "/Applications/Vivaldi.app" ]]; then
    echo "Setting Vivaldi as default browser..."
    duti -s com.vivaldi.Vivaldi http
    duti -s com.vivaldi.Vivaldi https
    duti -s com.vivaldi.Vivaldi html
    duti -s com.vivaldi.Vivaldi htm
    echo "✅ Vivaldi configured as default browser"
fi

# Set iTerm2 as default terminal
if [[ -d "/Applications/iTerm.app" ]]; then
    echo "Setting iTerm2 as default terminal..."
    duti -s com.googlecode.iterm2 .command all
    duti -s com.googlecode.iterm2 .sh all
    duti -s com.googlecode.iterm2 public.shell-script all
    echo "✅ iTerm2 configured as default terminal"
fi

# Create Screenshots folder
mkdir -p "$HOME/Downloads/Screenshots"
echo "✅ Screenshots folder created"

# Install Clop CLI and set launch at login
if [[ -d "/Applications/Clop.app" ]]; then
    echo "Configuring Clop..."

    # Install CLI tool
    if [[ ! -f /usr/local/bin/clop ]]; then
        # Run Clop CLI install in background (Clop may launch GUI)
        /Applications/Clop.app/Contents/MacOS/Clop --install-cli &>/dev/null &
        CLOP_PID=$!
        # Wait 3 seconds then kill if still running
        sleep 3
        kill $CLOP_PID &>/dev/null || true
        killall Clop &>/dev/null || true
        echo "✅ Clop CLI install attempted"
    else
        echo "⏭️  Clop CLI already installed"
    fi

    # Enable launch at login using osascript
    osascript -e 'tell application "System Events" to make login item at end with properties {path:"/Applications/Clop.app", hidden:false}' 2>/dev/null || true
    echo "✅ Clop configured to launch at login"
else
    echo "⏭️  Clop not installed yet"
fi

echo "✅ App configurations complete"

