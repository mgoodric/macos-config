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
6. Check Integration with 1Password CLI
7. Check Check for Developer Credentials on Disk

### iTerm2
1. Open iTerm2
2. The MesloLGM Nerd Font has been installed by the bootstrap script
3. Configure the font manually:
   - Press `Cmd + ,` to open Preferences
   - Go to Profiles → Default (or your active profile)
   - Click the Text tab
   - Under Font, click "Change Font"
   - Search for "MesloLGM Nerd Font" or "MesloLGM-NF"
4. Configure font rendering (still in Text tab):
   - ✅ Enable "Anti-aliased" (for smooth text)
   - ⬜ Disable "Use ligatures" (if you don't want ligatures)
   - ✅ Enable "Draw Powerline glyphs" (required for Oh My Posh icons)
5. Enable mouse reporting for tmux (in Profiles → Terminal):
   - ✅ Enable "Enable mouse reporting" (required for tmux mouse support)
6. If you see duplicate "Default" profiles, delete one:
   - Preferences → Profiles
   - Select the duplicate profile
   - Click the `-` button at the bottom to delete it
7. Make iTerm2 the Default Term

### Obdidian
1. Open Obsidian
2. Open G$ Vault

### tmux
1. Open tmux: `tmux`
2. Install TPM plugins: Press `Ctrl-b + I` (capital I)
3. Wait for plugins to install
4. Sessions will now auto-save and restore

### Alfred
1. Open Alfred
2. Grant necessary permissions (Accessibility, Full Disk Access)
3. Set up Powerpack license (if you have one)
4. Configure hotkey (recommend: Cmd+Space)
   - Unmap Spotlight Keyboard Shortcut first
5.
6. Sync settings (if you use Dropbox/iCloud sync)

### Vivaldi
1. Open Vivaldi (settings are pre-configured via chezmoi)
2. Sign in to sync account:
   - Click the Vivaldi menu → Tools → Sync
   - Sign in with your Vivaldi account
   - Choose what to sync (bookmarks, passwords, etc.)
3. Import bookmarks if needed (File → Import Bookmarks and Settings)
4. Cleanup Right Side Toolbar Shortcuts
5. Change Default Search Engine

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

### DaVinci Resolve Studio
1. Download DaVinci Resolve Studio:
   - Visit: https://www.blackmagicdesign.com/support/
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

### mInstaller
1. Open
2. Login
3. Install all Plugins

### Ice
1. Open Ice
2. Grant Permissions
3. Quit & Reopen
4. Set Settings
   - Launch at Login
   -

### CleanShot X
1. Open CleanShot X (preferences are pre-configured via chezmoi)
2. Settings are already configured:
   - Launch at login enabled
   - Hide desktop icons in captures
   - Auto-updates enabled
3. Activate license if needed
4. Settings are already configured:
   - Save location: ~/Downloads/Screenshots
   - Format: PNG
   - Copy to clipboard AND save to disk
   - Hide desktop icons in captures
   - Mouse cursor excluded
   - Auto-updates enabled
5. Replace macOS default screenshot shortcuts:
   - Open CleanShot X → Preferences → Keyboard Shortcuts
   - Click "Replace system shortcuts" button
   - This will capture Cmd+Shift+3, Cmd+Shift+4, and Cmd+Shift+5
6. Grant Screen Recording permission when prompted:
   - System Settings → Privacy & Security → Screen Recording
   - Enable CleanShot X

### Menu Bar Spacing
1. Open
2. Set to 10

### Keka
1. Enable the Finder Extension
2. Set Keka as the default uncompressor
3. Automatically check for updates
4. File Access -> Enable home folder access, Enable External volume access

### Clop
1. Open Clop (preferences are pre-configured via chezmoi)
2. Settings are already configured:
   - Launch at login enabled
   - CLI tool installed
   - Auto-updates enabled
   - Watches ~/Downloads for images
   - Format conversions: HEIC/AVIF/WebP → JPEG, TIFF → PNG
3. Grant necessary permissions when prompted

### Little Snitch
1. Open Little Snitch
2. Walk through installation/setup
3. Put in License Key

### Dato
1. Open Dato
2. Walk through setup
3. Launch at Startup

### Supercharge
1. Download from your Gumroad library: https://gumroad.com/library
2. Extract and move to Applications
3. Grant permissions when prompted:
   - Accessibility access
   - Screen Recording (for text capture features)

### Shortcutie
1. Download from your Gumroad library: https://gumroad.com/library
2. Extract and move to Applications
3. Open Shortcutie - extra actions will appear in the Shortcuts app

### Default Browser
1. Download from your Gumroad library: https://gumroad.com/library
2. Extract and move to Applications
3. Configure which browsers appear in the menu

### Quicken
1. Open Quicken
2. Login
3. Open Quicken File

### Claude
1. Open Claude
2. Login
3. Open iTerm
4. Launch claude via the `claude` command
5. Authenticate
6. Settings -> Run at Startup

### BetterDisplay
1. Open BetterDisplay
2. Grant Permissions
3. Activate Pro License

### BetterTouchTool
1. Open BetterTouchTool
2. Grant Accessibility permissions when prompted:
   - System Settings → Privacy & Security → Accessibility
   - Enable BetterTouchTool
3. Activate license
4. Configure gestures and shortcuts as needed
5. Enable "Launch BetterTouchTool on startup" in preferences

### OBS
1. Open OBS
2. Grant permissions when prompted:
   - System Settings → Privacy & Security → Screen Recording → Enable OBS
   - System Settings → Privacy & Security → Microphone → Enable OBS
   - System Settings → Privacy & Security → Camera → Enable OBS (if using webcam)
3. Run the Auto-Configuration Wizard for optimal settings
4. Configure scenes and sources as needed

### RODECaster App
1. Download the RODECaster App:
   - Visit: https://rode.com/en-us/apps/rodecaster-app
   - Or direct download: https://update.rode.com/rc-app/RODECaster_App_MACOS.zip
2. Extract the ZIP file
3. Move the app to Applications folder
4. Open RODECaster App
5. Grant any required permissions when prompted
6. Use to configure RØDECaster or Streamer X devices and update firmware

### NeewerLite
**Note:** NeewerLite must be installed manually from DMG (open-source Neewer light control app).

1. Download NeewerLite:
   - Visit: https://github.com/keefo/NeewerLite/releases
   - Download the latest DMG file (e.g., `NeewerLite.dmg`)
2. Open the downloaded DMG file
3. Drag NeewerLite to Applications folder
4. Open NeewerLite
5. Grant Bluetooth permissions when prompted:
   - System Settings → Privacy & Security → Bluetooth
   - Enable NeewerLite
6. Connect to your Neewer lights via Bluetooth

### Discord
1. Open Discord
2. Grant Permissions
3. Login

### Google Drive
1. Open Google Drive
2. Autnenticate
3. Make Scanned Folder Available Offline (for Hazel)

### App Store Apps
1. Open Mac App Store
2. Ensure all expected items were downloaded
3. Open each one individually
   - Hyperduck
      - Launch at Login
      - History
   - Camera Preview
      - Show in Menu Bar
      - Launch at Login
   - Shortery
      - Grant Permissions
      - Setup Hourly Schedule to Run the Shortcut 'Internet Speed in Menu Bar'
   - One Thing
      - Launch at Login
   - Speediness
   - Shareful
      - Follow Instructions
   -  Magnet
      - Grant Permissions
   - Amphetamine

### Fileside
1. Download from: https://www.fileside.app/download/
2. Move to Applications folder
3. Open Fileside
4. Grant necessary permissions when prompted
5. Validate License

### Shapr3d
1. Open
2. Login

### Private Internet Access
**Note:** Private Internet Access must be installed manually (not via Homebrew) due to macOS 26.0 security restrictions.

1. Download Private Internet Access:
   - Visit: https://www.privateinternetaccess.com/pages/download
   - Download the macOS installer
2. Open the downloaded DMG file
3. Run the installer
4. Sign in with your PIA account credentials
5. Configure VPN settings as needed

### Hazel
1. Open Hazel
2. Grant Full Disk Access when prompted:
   - System Settings → Privacy & Security → Full Disk Access
   - Enable Hazel
3. Import rules: File → Import Rules
   - Select rules from: `$(chezmoi source-path)/hazel-rules/`







### Ivanky Ethernet Driver (Personal Only)
**Note:** Only install if you have an Ivanky docking station with Ethernet.

1. Download the macOS Ethernet driver:
   - Visit: https://ivanky.com/blogs/news/ivanky-ethernet-driver-download-guide
   - Download the macOS driver package
2. Open the downloaded installer
3. Follow the installation wizard
4. Grant any required permissions when prompted
5. Restart your Mac if required

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







### Fileside
1. Download from: https://www.fileside.app/download/
2. Extract and move to Applications
3. Open Fileside and grant necessary permissions

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

## 5. Menu Bar Customization
- Spotlight -> Disable
- Bluetooth -> Enable
- Sound -> Always Show
- Time Machine -> Enable
- Creative Cloud -> Disable
- mInstaller -> Disable

## 6. Dock Configuration

The Dock is **automatically configured** based on whether this is a work or personal machine:

**Personal Machine Dock:**
- ✅ Vivaldi, iTerm2, Obsidian, Slack, Discord, Signal, Quicken
- ✅ System Settings and App Store

**Work Machine Dock:**
- ✅ Chrome, Vivaldi, iTerm2, Obsidian, Slack, Microsoft Teams, ChatGPT
- ✅ System Settings and App Store
- ✅ Microsoft Office apps available (Word, Excel, PowerPoint, Outlook, OneNote)
- ✅ No personal-only apps (Discord, Signal, Quicken)

All default macOS apps (Safari, Mail, Photos, etc.) are removed automatically.

**To customize:** Edit `setup-app-configs.sh` and search for "Setup the dock". See `CONDITIONAL_CONFIG.md` for details.

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
5. Remove Desktop Widgets
6. Change Wallpaper

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
