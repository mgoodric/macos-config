# Post-Installation Manual Steps

After running `bootstrap.sh`, complete these manual steps:

## 1. Sign into Accounts

> **Note:** iCloud should already be configured during macOS setup. iCloud Desktop & Documents sync is automatically enabled by the bootstrap script.

### App Store
1. Open App Store
2. Sign in with your Apple ID
3. Install Mac App Store apps:
   ```bash
   brew bundle --file=$(chezmoi source-path)/Brewfile
   ```
   This will install apps like Magnet and any other Mac App Store apps you've added to your Brewfile.

## 2. Application-Specific Setup

### 1Password
1. Open 1Password
2. Sign in to your account
3. Enable browser extensions
4. Enable SSH agent (Settings → Developer → Use SSH Agent)
5. Verify SSH agent integration:
   ```bash
   echo $SSH_AUTH_SOCK
   # Should show: /Users/username/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock
   ```

### iTerm2
1. Open iTerm2
2. The MesloLGM Nerd Font has been installed by the bootstrap script
3. Configure the font manually:
   - Press `Cmd + ,` to open Preferences
   - Go to Profiles → Default (or your active profile)
   - Click the Text tab
   - Under Font, click "Change Font"
   - Search for "MesloLGM Nerd Font" or "MesloLGM-NF"
   - Select it and set size to 13
   - Close Preferences
4. If you see duplicate "Default" profiles, delete one:
   - Preferences → Profiles
   - Select the duplicate profile
   - Click the `-` button at the bottom to delete it

### tmux
1. Open tmux: `tmux`
2. Install TPM plugins: Press `Ctrl-b + I` (capital I)
3. Wait for plugins to install
4. Sessions will now auto-save and restore

### Hazel
1. Open Hazel
2. Grant Full Disk Access when prompted:
   - System Settings → Privacy & Security → Full Disk Access
   - Enable Hazel
3. Import rules: File → Import Rules
   - Select rules from: `$(chezmoi source-path)/hazel-rules/`

### Alfred
1. Open Alfred
2. Grant necessary permissions (Accessibility, Full Disk Access)
3. Set up Powerpack license (if you have one)
4. Configure hotkey (recommend: Cmd+Space)
5. Sync settings (if you use Dropbox/iCloud sync)

### Vivaldi
1. Open Vivaldi (settings are pre-configured via chezmoi)
2. Sign in to sync account:
   - Click the Vivaldi menu → Tools → Sync
   - Sign in with your Vivaldi account
   - Choose what to sync (bookmarks, passwords, etc.)
3. Import bookmarks if needed (File → Import Bookmarks and Settings)

### JetBrains Toolbox
1. Open JetBrains Toolbox
2. Sign in to JetBrains account
3. Install IDEs you need (IntelliJ IDEA, PyCharm, etc.)
4. Configure settings sync in each IDE

### Adobe Creative Cloud
1. Open Adobe Creative Cloud
2. Sign in to Adobe account
3. Install applications you need

### Parallels Desktop
**Note:** Parallels must be installed manually (not via Homebrew) due to macOS 26.0 security restrictions.

1. Download Parallels Desktop:
   - Visit: https://www.parallels.com/products/desktop/download/
   - Download the installer
2. Open the downloaded DMG and run the installer
3. Follow the installation wizard
4. Sign in to your Parallels account
5. Activate your license key
6. Grant required permissions when prompted:
   - System Settings → Privacy & Security → System Extensions
   - Allow Parallels extensions
7. **Restart your Mac** to complete kernel extension installation
8. After restart, configure Parallels:
   - Set up virtual machines
   - Configure shared folders
   - Adjust performance settings

### Private Internet Access
**Note:** Private Internet Access must be installed manually (not via Homebrew) due to macOS 26.0 security restrictions.

1. Download Private Internet Access:
   - Visit: https://www.privateinternetaccess.com/pages/download
   - Download the macOS installer
2. Open the downloaded DMG file
3. Run the installer
4. Sign in with your PIA account credentials
5. Configure VPN settings as needed

### CalDigit Thunderbolt Station (Optional)
**Note:** Only install if you own a CalDigit Thunderbolt Station dock. This requires Rosetta 2 and kernel extension approval.

1. Install Rosetta 2 (required for Intel-based driver):
   ```bash
   sudo softwareupdate --install-rosetta --agree-to-license
   ```
   Note: Rosetta 2 is difficult to remove once installed. Only proceed if you need this driver.

2. Download CalDigit drivers:
   - Visit: https://www.caldigit.com/thunderbolt-station/
   - Download the macOS driver package

3. Install the driver:
   ```bash
   brew install --cask caldigit-thunderbolt-charging
   ```
   Or manually open the downloaded package

4. Approve kernel extension:
   - System Settings → Privacy & Security → Security
   - Click "Allow" next to the blocked CalDigit extension
   - See: https://developer.apple.com/library/content/technotes/tn2459/_index.html

5. **Restart your Mac** to complete installation

### DaVinci Resolve Studio
1. Download DaVinci Resolve Studio:
   - Visit: https://www.blackmagicdesign.com/products/davinciresolve
   - Click "Download" button
   - Fill out registration form (if required)
   - Download the Studio version (not the free version)
2. Open the downloaded DMG file
3. Run the DaVinci Resolve installer
4. Follow installation wizard:
   - Accept license agreement
   - Choose installation components (Resolve, Fusion, etc.)
   - Complete installation
5. Launch DaVinci Resolve Studio
6. Activate your license:
   - Enter license key, or
   - Connect DaVinci Resolve Speed Editor/Advanced Panel (hardware dongle)
7. Configure preferences:
   - Set scratch disks location
   - Configure GPU settings
   - Set up project libraries

### CleanShot X
1. Open CleanShot X (preferences are pre-configured via chezmoi)
2. Settings are already configured:
   - Save location: ~/Downloads/Screenshots
   - Format: PNG
   - Copy to clipboard AND save to disk
   - Hide desktop icons in captures
   - Mouse cursor excluded
   - Auto-updates enabled
3. Replace macOS default screenshot shortcuts:
   - Open CleanShot X → Preferences → Keyboard Shortcuts
   - Click "Replace system shortcuts" button
   - This will capture Cmd+Shift+3, Cmd+Shift+4, and Cmd+Shift+5
4. Grant Screen Recording permission when prompted:
   - System Settings → Privacy & Security → Screen Recording
   - Enable CleanShot X

### Keka
1. Open Keka → Preferences → General
2. Click "Install command line tool"

### CleanShot X
1. Open CleanShot X (preferences are pre-configured via chezmoi)
2. Settings are already configured:
   - Launch at login enabled
   - Hide desktop icons in captures
   - Auto-updates enabled
3. Activate license if needed

### Clop
1. Open Clop (preferences are pre-configured via chezmoi)
2. Settings are already configured:
   - Launch at login enabled
   - CLI tool installed
   - Auto-updates enabled
   - Watches ~/Downloads for images
   - Format conversions: HEIC/AVIF/WebP → JPEG, TIFF → PNG
3. Manual configuration needed:
   - Enable clipboard optimization for images (Preferences → Clipboard)
   - Configure to exclude removable media if available in settings
4. Grant necessary permissions when prompted

### Discord, Slack, Signal
Sign in to each application

## 3. Enable System Features

### Apple Watch Unlock
1. System Settings → Touch ID & Password
2. Enable "Apple Watch" (requires Apple Watch to be paired)

### Touch ID
1. System Settings → Touch ID & Password
2. Add fingerprints
3. Enable for: Unlocking Mac, Apple Pay, iTunes & App Store
4. Touch ID for sudo should already be configured by setup scripts

### FileVault
1. System Settings → Privacy & Security → FileVault
2. Turn On FileVault (if not already enabled)
3. Save recovery key securely in 1Password

## 4. Developer Setup

### SSH Keys
Generate SSH key (if you don't use 1Password SSH agent):
```bash
ssh-keygen -t ed25519 -C "your_email@example.com"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
```

Add to GitHub/GitLab:
```bash
# Copy public key
cat ~/.ssh/id_ed25519.pub | pbcopy
# Then add to GitHub: Settings → SSH and GPG keys → New SSH key
```

### Atuin
Set up sync (optional):
```bash
# Register for sync
atuin register -u <username> -e <email>
# Or login to existing account
atuin login -u <username>
# Start syncing
atuin sync
```

### Git Configuration
Verify git configuration:
```bash
git config --global --list
```

### Colima (Docker Alternative)
Start Colima:
```bash
colima start
```

## 5. Privacy & Security Grants

Grant Full Disk Access to:
- iTerm2
- Claude Code
- Hazel
- Alfred (if needed)

Grant Accessibility access to:
- Alfred
- Any window management tools

Location: System Settings → Privacy & Security

## 6. Dock Configuration

The Dock is automatically configured by the bootstrap script with your preferred apps:
- ✅ Default macOS apps removed (Safari, Mail, Photos, etc.)
- ✅ Your apps added: Vivaldi, iTerm2, Obsidian, Slack, Discord, Signal
- ✅ JetBrains Toolbox added
- ✅ System Settings and App Store kept for convenience

If you want to customize further, you can edit the Dock configuration in `setup-app-configs.sh` (search for "Setup the dock").

## 7. Verify Installations

Run these commands to verify key tools:
```bash
# Shell tools
which zsh git tmux atuin

# Homebrew
brew doctor

# Git
git --version

# Docker (via Colima)
docker --version

# Oh My Posh
oh-my-posh --version

# Chezmoi
chezmoi --version
```

## 8. Final Cleanup

1. Restart your Mac to ensure all settings take effect
2. Open each application to complete first-run setup
3. Review System Settings for any additional preferences
4. Set up Time Machine backup (System Settings → General → Time Machine)

## Notes

- Some changes require logout/restart to take full effect
- Check for macOS updates: System Settings → General → Software Update
- Run `topgrade` periodically to keep everything updated
- Use `chezmoi apply` to sync dotfile changes from your repository

## Troubleshooting

### Touch ID for sudo not working
Ensure `/etc/pam.d/sudo_local` exists and contains:
```
auth       sufficient     pam_tid.so
```

### tmux plugins not loading
Press `Ctrl-b + I` inside tmux to install plugins

### Atuin not working
Ensure the init line is in your `.zshrc`:
```bash
eval "$(atuin init zsh)"
```

### Homebrew issues
```bash
brew doctor
brew update
```
