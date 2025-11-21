# Conditional Configuration (Work vs Personal)

The `setup-app-configs.sh` script automatically detects whether the machine is **work** or **personal** and configures it accordingly.

## How Detection Works

1. Script reads `computerType` from chezmoi data (set during initial bootstrap prompt)
2. Applies conditional configurations based on the answer
3. Falls back to "personal" if unable to detect

## Conditional Configurations

### 1. Default Browser

**Personal Machine:**
- Sets Vivaldi as default browser

**Work Machine:**
- Prefers Chrome if installed
- Falls back to Vivaldi if Chrome not found

### 2. Dock Configuration

**Personal Machine Dock:**
1. Vivaldi
2. iTerm2
3. Obsidian
4. Slack
5. Discord
6. Signal
7. Quicken
8. System Settings
9. App Store

**Work Machine Dock:**
1. Google Chrome
2. Vivaldi (secondary browser)
3. iTerm2
4. Obsidian
5. Slack
6. Microsoft Teams
7. ChatGPT
8. System Settings
9. App Store

*Microsoft Office apps (Word, Excel, PowerPoint, Outlook, OneNote) are installed but not in Dock - launch from Applications or Spotlight*

### 3. App-Specific Configurations

These run conditionally based on **app existence** (not computer type):

- **Hazel** - Only if `/Applications/Hazel.app` exists
- **CleanShot** - Only if `/Applications/CleanShot.app` exists
- **Clop** - Only if `/Applications/Clop.app` exists
- **Keka** - Only if `/Applications/Keka.app` exists

This allows both work and personal machines to have these apps without duplication.

## Customizing for Your Work Environment

### Adding Work-Only Apps to Dock

Edit `setup-app-configs.sh` in the work section:

```bash
if [[ "$COMPUTER_TYPE" == "work" ]]; then
    # Existing work apps...

    # Uncomment or add your work apps:
    [[ -d "/Applications/Microsoft Teams.app" ]] && dockutil --add "/Applications/Microsoft Teams.app" --no-restart 2>/dev/null || true
    [[ -d "/Applications/Zoom.app" ]] && dockutil --add "/Applications/Zoom.app" --no-restart 2>/dev/null || true
    [[ -d "/Applications/Your Company VPN.app" ]] && dockutil --add "/Applications/Your Company VPN.app" --no-restart 2>/dev/null || true
fi
```

### Adding Personal-Only Apps to Dock

Edit `setup-app-configs.sh` in the personal section:

```bash
else
    # Personal Dock configuration
    # Existing personal apps...

    # Add your personal apps:
    [[ -d "/Applications/Spotify.app" ]] && dockutil --add "/Applications/Spotify.app" --no-restart 2>/dev/null || true
    [[ -d "/Applications/Games.app" ]] && dockutil --add "/Applications/Games.app" --no-restart 2>/dev/null || true
fi
```

### Changing Default Browser Preference

To change which browser is default on work machines, edit the browser section:

```bash
if [[ "$COMPUTER_TYPE" == "work" ]]; then
    # Option 1: Always use Chrome
    if [[ -d "/Applications/Google Chrome.app" ]]; then
        duti -s com.google.Chrome http https html htm
    fi

    # Option 2: Use Vivaldi even at work
    if [[ -d "/Applications/Vivaldi.app" ]]; then
        duti -s com.vivaldi.Vivaldi http https html htm
    fi
fi
```

## Testing Configuration

### Check Computer Type

```bash
# See what type is configured
chezmoi data | grep computerType

# Or
COMPUTER_TYPE=$(chezmoi data 2>/dev/null | grep -o '"computerType": "[^"]*"' | cut -d'"' -f4)
echo $COMPUTER_TYPE
```

### Change Computer Type

If you need to reconfigure after initial setup:

```bash
# Edit chezmoi config
chezmoi edit-config

# Change computerType value from "personal" to "work" (or vice versa)

# Re-run app configs
bash $(chezmoi source-path)/setup-app-configs.sh
```

### Manually Run Conditional Sections

```bash
# Test work configuration
COMPUTER_TYPE="work" bash setup-app-configs.sh

# Test personal configuration
COMPUTER_TYPE="personal" bash setup-app-configs.sh
```

## Benefits

✅ **Single script for both environments** - No need to maintain separate scripts

✅ **Automatic detection** - No manual intervention needed during bootstrap

✅ **Easy customization** - Edit one file to change work/personal behavior

✅ **Safe defaults** - Falls back to personal if detection fails

✅ **Flexible** - Can be overridden manually if needed

## Example Scenarios

### Scenario 1: New Personal Mac
```
bootstrap.sh prompts → answer "personal"
↓
Installs Brewfile.core + Brewfile.personal
↓
setup-app-configs.sh detects "personal"
↓
Sets Vivaldi as default browser
↓
Configures Dock with Obsidian, Discord, Signal, Quicken
```

### Scenario 2: New Work Mac
```
bootstrap.sh prompts → answer "work"
↓
Installs Brewfile.core + Brewfile.work
↓
Installs: Microsoft Teams, ChatGPT, Microsoft Office suite
↓
setup-app-configs.sh detects "work"
↓
Sets Chrome as default browser (with Vivaldi fallback)
↓
Configures Dock with Chrome, Obsidian, Teams, ChatGPT
↓
Skips personal-only apps (Discord, Signal, Quicken not installed)
```

### Scenario 3: Switching Work Policies
```
Company policy changes → blocks personal apps
↓
No changes needed! Work Brewfile already isolated
↓
Personal apps only in Brewfile.personal
↓
Work machine continues working perfectly
```
