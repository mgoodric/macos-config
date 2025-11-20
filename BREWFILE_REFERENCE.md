# Brewfile Quick Reference

## Apps organized by Brewfile

### Brewfile.core (All Machines)
**Development:**
- Git, Colima, Docker tools, jq, Hugo

**Terminal:**
- iTerm2, tmux, Oh My Posh, zsh enhancements, Atuin

**Utilities:**
- Alfred, AppCleaner, Keka, duti, dockutil, mas, Amphetamine, topgrade

**Fonts:**
- 14 developer fonts (JetBrains Mono, Fira Code, Hack Nerd Font, etc.)

---

### Brewfile.personal (Personal Only)
**AI:**
- Claude, Ollama

**Browsers:**
- Vivaldi

**Security:**
- 1Password + CLI

**Chat:**
- Slack, Discord, Signal

**Creative:**
- Adobe Creative Cloud, mInstaller
- DaVinci Resolve (manual install)

**Development:**
- JetBrains Toolbox, Claude Code
- Parallels (manual install)

**Network/VPN:**
- Private Internet Access (manual install), WiFiman

**Utilities:**
- CleanShot, Clop, Elgato Stream Deck, Google Drive, Hazel

**Mac App Store:**
- Magnet, RapidDMG, NEEWER Control Center

**Productivity:**
- OpenAudible, Obsidian, Quicken

---

### Brewfile.work (Work Only)
**Browsers:**
- Google Chrome
- Vivaldi

**Security:**
- 1Password + CLI

**Communication:**
- Slack

**Development:**
- JetBrains Toolbox

**Utilities (duplicated for future policy changes):**
- CleanShot, Clop, Elgato Stream Deck, Hazel

**Additional Work Tools (commented out, uncomment as needed):**
- Microsoft Teams
- Zoom
- Company CLI tools
- Company VPN

---

## Intentional Duplicates

These apps appear in BOTH personal and work Brewfiles to protect against future work policy restrictions:

- ✅ 1Password + CLI
- ✅ Slack
- ✅ Vivaldi
- ✅ JetBrains Toolbox
- ✅ CleanShot
- ✅ Clop
- ✅ Elgato Stream Deck
- ✅ Hazel

**Why?** If work policies become more restrictive, having these in both files means:
- Personal machine: Gets them from `Brewfile.personal`
- Work machine: Gets them from `Brewfile.work`
- No cross-contamination between personal and work package lists
- Each Brewfile is completely self-contained

---

## Installation Summary

### Personal Machine
```bash
bootstrap.sh → installs:
  - Brewfile.core (dev tools, terminal, utilities, fonts)
  - Brewfile.personal (1Password, Slack, personal apps, duplicates)
```

### Work Machine
```bash
bootstrap.sh → installs:
  - Brewfile.core (dev tools, terminal, utilities, fonts)
  - Brewfile.work (1Password, Slack, Chrome, work apps, duplicates)
```

**Key insight:** Personal and work machines share NO apps except those in Brewfile.core. All other apps are duplicated between personal/work files for complete isolation.

---

## Adding New Apps

**Q: Should this be on all machines?**
- Yes → Add to `Brewfile.core`
- No → Continue below

**Q: Is this a personal app?**
- Yes → Add to `Brewfile.personal`

**Q: Is this a work app?**
- Yes → Add to `Brewfile.work`

**Q: Should it be on both, but kept separate for future policy reasons?**
- Yes → Add to BOTH `Brewfile.personal` AND `Brewfile.work`
