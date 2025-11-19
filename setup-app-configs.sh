#!/usr/bin/env bash
# setup-app-configs.sh

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
    python3 -m pip install --upgrade pip --break-system-packages
    # Add any global Python packages you always want
fi

# Configure Git (if not in .gitconfig)
git config --global init.defaultBranch main

# Atuin configuration
atuin import zsh

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

echo "✅ App configurations complete"

