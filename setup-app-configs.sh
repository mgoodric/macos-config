#!/usr/bin/env bash
# setup-app-configs.sh

# Initialize Homebrew environment (needed for duti, oh-my-posh, etc.)
if [[ -f "/opt/homebrew/bin/brew" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -f "/usr/local/bin/brew" ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
fi

# Get computer type from chezmoi data
COMPUTER_TYPE=$(chezmoi data 2>/dev/null | grep -o '"computerType": "[^"]*"' | cut -d'"' -f4)
if [[ -z "$COMPUTER_TYPE" ]]; then
    echo "⚠️  Could not determine computer type, defaulting to 'personal'"
    COMPUTER_TYPE="personal"
fi
echo "🖥️  Configuring for: $COMPUTER_TYPE machine"

# Import Hazel rules if they exist
if [[ -d "$(chezmoi source-path)/hazel-rules" ]]; then
    echo "📋 Hazel rules available in $(chezmoi source-path)/hazel-rules/"
    echo "   Import manually from Hazel > File > Import Rules"
fi

# Install Oh My Zsh
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    echo "Installing Oh My Zsh..."
    # KEEP_ZSHRC=yes prevents the installer from overwriting our custom .zshrc
    KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    echo "✅ Oh My Zsh installed (custom .zshrc preserved)"
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

# Set default browser based on computer type
if [[ "$COMPUTER_TYPE" == "work" ]]; then
    # Work machine: prefer Chrome if available, fallback to Vivaldi
    if [[ -d "/Applications/Google Chrome.app" ]]; then
        echo "Setting Chrome as default browser (work machine)..."
        duti -s com.google.Chrome http
        duti -s com.google.Chrome https
        duti -s com.google.Chrome html
        duti -s com.google.Chrome htm
        echo "✅ Chrome configured as default browser"
    elif [[ -d "/Applications/Vivaldi.app" ]]; then
        echo "Setting Vivaldi as default browser (Chrome not found)..."
        duti -s com.vivaldi.Vivaldi http
        duti -s com.vivaldi.Vivaldi https
        duti -s com.vivaldi.Vivaldi html
        duti -s com.vivaldi.Vivaldi htm
        echo "✅ Vivaldi configured as default browser"
    fi
else
    # Personal machine: prefer Vivaldi
    if [[ -d "/Applications/Vivaldi.app" ]]; then
        echo "Setting Vivaldi as default browser (personal machine)..."
        duti -s com.vivaldi.Vivaldi http
        duti -s com.vivaldi.Vivaldi https
        duti -s com.vivaldi.Vivaldi html
        duti -s com.vivaldi.Vivaldi htm
        echo "✅ Vivaldi configured as default browser"
    fi
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

## Setup the dock
if command -v dockutil &> /dev/null; then
    echo "Configuring Dock for $COMPUTER_TYPE machine..."

    # Remove default macOS apps (same for all machines)
    dockutil --remove 'Apps' --no-restart 2>/dev/null || true
    dockutil --remove 'Games' --no-restart 2>/dev/null || true
    dockutil --remove 'Safari' --no-restart 2>/dev/null || true
    dockutil --remove 'Mail' --no-restart 2>/dev/null || true
    dockutil --remove 'Maps' --no-restart 2>/dev/null || true
    dockutil --remove 'Photos' --no-restart 2>/dev/null || true
    dockutil --remove 'FaceTime' --no-restart 2>/dev/null || true
    dockutil --remove 'Messages' --no-restart 2>/dev/null || true
    dockutil --remove 'Phone' --no-restart 2>/dev/null || true
    dockutil --remove 'Calendar' --no-restart 2>/dev/null || true
    dockutil --remove 'Contacts' --no-restart 2>/dev/null || true
    dockutil --remove 'Reminders' --no-restart 2>/dev/null || true
    dockutil --remove 'Notes' --no-restart 2>/dev/null || true
    dockutil --remove 'TV' --no-restart 2>/dev/null || true
    dockutil --remove 'Music' --no-restart 2>/dev/null || true
    dockutil --remove 'Podcasts' --no-restart 2>/dev/null || true
    dockutil --remove 'News' --no-restart 2>/dev/null || true
    dockutil --remove 'App Store' --no-restart 2>/dev/null || true
    dockutil --remove 'System Settings' --no-restart 2>/dev/null || true
    dockutil --remove 'iPhone Mirroring' --no-restart 2>/dev/null || true

    if [[ "$COMPUTER_TYPE" == "work" ]]; then
        # Work Dock configuration
        [[ -d "/Applications/Google Chrome.app" ]] && dockutil --add "/Applications/Google Chrome.app" --no-restart 2>/dev/null || true
        [[ -d "/Applications/Vivaldi.app" ]] && dockutil --add "/Applications/Vivaldi.app" --no-restart 2>/dev/null || true
        [[ -d "/Applications/iTerm.app" ]] && dockutil --add "/Applications/iTerm.app" --no-restart 2>/dev/null || true
        [[ -d "/Applications/Obsidian.app" ]] && dockutil --add "/Applications/Obsidian.app" --no-restart 2>/dev/null || true
        [[ -d "/System/Applications/Messages.app" ]] && dockutil --add "/System/Applications/Messages.app" --no-restart 2>/dev/null || true
        [[ -d "/Applications/Slack.app" ]] && dockutil --add "/Applications/Slack.app" --no-restart 2>/dev/null || true
        [[ -d "/Applications/Microsoft Teams.app" ]] && dockutil --add "/Applications/Microsoft Teams.app" --no-restart 2>/dev/null || true
        [[ -d "/Applications/ChatGPT.app" ]] && dockutil --add "/Applications/ChatGPT.app" --no-restart 2>/dev/null || true
        # Add more work apps as needed
        # [[ -d "/Applications/Zoom.app" ]] && dockutil --add "/Applications/Zoom.app" --no-restart 2>/dev/null || true
        # [[ -d "/Applications/Microsoft Outlook.app" ]] && dockutil --add "/Applications/Microsoft Outlook.app" --no-restart 2>/dev/null || true
    else
        # Personal Dock configuration
        [[ -d "/Applications/Vivaldi.app" ]] && dockutil --add "/Applications/Vivaldi.app" --no-restart 2>/dev/null || true
        [[ -d "/Applications/iTerm.app" ]] && dockutil --add "/Applications/iTerm.app" --no-restart 2>/dev/null || true
        [[ -d "/Applications/Obsidian.app" ]] && dockutil --add "/Applications/Obsidian.app" --no-restart 2>/dev/null || true
        [[ -d "/System/Applications/Messages.app" ]] && dockutil --add "/System/Applications/Messages.app" --no-restart 2>/dev/null || true
        [[ -d "/Applications/Slack.app" ]] && dockutil --add "/Applications/Slack.app" --no-restart 2>/dev/null || true
        [[ -d "/Applications/Discord.app" ]] && dockutil --add "/Applications/Discord.app" --no-restart 2>/dev/null || true
        [[ -d "/Applications/Signal.app" ]] && dockutil --add "/Applications/Signal.app" --no-restart 2>/dev/null || true
        [[ -d "/Applications/Quicken.app" ]] && dockutil --add "/Applications/Quicken.app" --no-restart 2>/dev/null || true
        [[ -d "/Applications/Adobe Lightroom Classic/Adobe Lightroom Classic.app" ]] && dockutil --add "/Applications/Adobe Lightroom Classic/Adobe Lightroom Classic.app" --no-restart 2>/dev/null || true
        [[ -d "/Applications/DaVinci Resolve/DaVinci Resolve.app" ]] && dockutil --add "/Applications/DaVinci Resolve/DaVinci Resolve.app" --no-restart 2>/dev/null || true
        [[ -d "/Applications/Fileside.app" ]] && dockutil --add "/Applications/Fileside.app" --no-restart 2>/dev/null || true
        [[ -d "/Applications/Original Prusa Slicer/PrusaSlicer.app" ]] && dockutil --add "/Applications/Original Prusa Slicer/PrusaSlicer.app" --no-restart 2>/dev/null || true
        [[ -d "/Applications/Shapr3D.app" ]] && dockutil --add "/Applications/Shapr3D.app" --no-restart 2>/dev/null || true
    fi

    # Add System Settings and App Store back (useful to keep on all machines)
    dockutil --add "/System/Applications/System Settings.app" --no-restart 2>/dev/null || true
    dockutil --add "/System/Applications/App Store.app" --no-restart 2>/dev/null || true

    # Restart Dock to apply changes
    killall Dock

    echo "✅ Dock configured for $COMPUTER_TYPE machine"
else
    echo "⏭️  dockutil not installed, skipping Dock configuration"
fi

###############################################################################
# Autofs - Mount Unraid shares automatically (personal only)                  #
###############################################################################

if [[ "$COMPUTER_TYPE" == "personal" ]]; then
    echo "Configuring autofs for Unraid shares..."

    UNRAID_IP="192.168.1.246"
    MOUNT_POINT="/Volumes/unraid"

    # Create the autofs map file for SMB shares
    sudo tee /etc/auto_smb > /dev/null <<EOF
# Unraid SMB shares - credentials from macOS keychain
Photography -fstype=smbfs ://${UNRAID_IP}/Photography
Videography -fstype=smbfs ://${UNRAID_IP}/Videography
EOF

    # Check if auto_master already has our entry
    if ! grep -q "auto_smb" /etc/auto_master; then
        echo "Adding autofs entry to auto_master..."
        # Add our map before the +auto_master line (or at end if not found)
        if grep -q "+auto_master" /etc/auto_master; then
            sudo sed -i '' '/+auto_master/i\
'"${MOUNT_POINT}"'    auto_smb    -nosuid,noowners
' /etc/auto_master
        else
            echo "${MOUNT_POINT}    auto_smb    -nosuid,noowners" | sudo tee -a /etc/auto_master > /dev/null
        fi
    fi

    # Create mount point directory
    sudo mkdir -p "$MOUNT_POINT"

    # Restart autofs to apply changes
    sudo automount -vc

    echo "✅ Autofs configured for Unraid shares"
    echo "   Shares will be available at:"
    echo "   - ${MOUNT_POINT}/Photography"
    echo "   - ${MOUNT_POINT}/Videography"
    echo ""
    echo "   Note: Ensure credentials are stored in Keychain Access:"
    echo "   - Add a new password item for '${UNRAID_IP}'"
    echo "   - Account: your Unraid username"
    echo "   - Password: your Unraid password"
fi

echo "✅ App configurations complete"

