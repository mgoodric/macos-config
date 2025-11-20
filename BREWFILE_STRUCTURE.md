# Brewfile Structure

This repository uses multiple Brewfiles to manage packages for different machine types.

## Structure

- **`Brewfile.core`** - Common packages installed on ALL machines (work and personal)
  - Development essentials (git, docker, etc.)
  - Terminal tools (iTerm2, tmux, zsh enhancements)
  - Essential utilities (Alfred, Keka, duti, etc.)
  - Developer fonts

- **`Brewfile.personal`** - Packages only for personal machines
  - Personal apps (Discord, Signal, games, etc.)
  - Creative tools (Adobe Creative Cloud, DaVinci Resolve)
  - Personal productivity tools
  - Home automation tools

- **`Brewfile.work`** - Packages only for work machines
  - Company-approved communication tools
  - Work-specific development tools
  - Corporate VPN/security tools
  - Team collaboration apps

## How It Works

During bootstrap (`bootstrap.sh`), chezmoi prompts you:

```
Computer type (personal/work):
```

Based on your answer, the bootstrap script:
1. Installs **Brewfile.core** (always)
2. Installs **Brewfile.personal** (if you chose "personal")
3. Installs **Brewfile.work** (if you chose "work")

## Managing Packages

### Adding a new package

**For all machines:**
Add to `Brewfile.core`

**For personal machines only:**
Add to `Brewfile.personal`

**For work machines only:**
Add to `Brewfile.work`

### Updating packages

```bash
# Update all packages on current machine
brew update && brew upgrade

# Or use topgrade (installed by default)
topgrade
```

### Re-running Brewfile installation

```bash
# Get chezmoi source directory
CHEZMOI_SOURCE=$(chezmoi source-path)

# Install core packages
brew bundle --file="$CHEZMOI_SOURCE/Brewfile.core"

# Install personal OR work packages
brew bundle --file="$CHEZMOI_SOURCE/Brewfile.personal"
# or
brew bundle --file="$CHEZMOI_SOURCE/Brewfile.work"
```

## Backward Compatibility

The original `Brewfile` is kept for backward compatibility. If `Brewfile.core` doesn't exist, the bootstrap script will fall back to using `Brewfile`.

Once you've migrated to the split structure, you can safely delete the original `Brewfile`.

## Chezmoi Configuration

The computer type is stored in chezmoi's config at `~/.config/chezmoi/chezmoi.toml`:

```toml
[data]
    computerType = "personal"  # or "work"
```

To change the computer type after initial setup:

```bash
# Edit chezmoi config
chezmoi edit-config

# Change computerType value, save, then re-apply
chezmoi apply
```

## Example: Migrating an App

Say you want Slack on both work and personal machines:

1. Remove from `Brewfile.personal`
2. Add to `Brewfile.core`
3. Add to `Brewfile.work` (if not already there)
4. Run `brew bundle --file=$(chezmoi source-path)/Brewfile.core`

## Tips

- **Keep `Brewfile.core` lean** - Only true essentials that you use on every machine
- **Be mindful of work policies** - Don't install personal apps on work machines
- **Document company tools** - Add comments in `Brewfile.work` for team members
- **Use `mas` carefully** - Mac App Store apps require being signed in
- **Consider licensing** - Some apps (like 1Password) work across personal/work, others don't
