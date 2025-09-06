# Dotfiles

Personal configuration files managed with Git branches for different environments.

## Branch Strategy

- **main**: Common configurations and documentation
- **macos**: macOS-specific configurations (karabiner, aerospace, etc.)
- **linux**: Linux-specific configurations (i3, sway, waybar, etc.)

## Setup

### macOS
```bash
git checkout macos
```

### Linux
```bash
git checkout linux
```

## Directory Structure

### Common (main branch)
- Git configurations
- Shell aliases and functions
- This README

### macOS-specific (macos branch)
- `aerospace/` - Window manager
- `karabiner/` - Keyboard customization
- `alacritty/` - Terminal emulator (TOML format)
- `zsh/` - macOS-specific shell configs

### Linux-specific (linux branch)
- `i3/` - i3 window manager
- `sway/` - Wayland compositor
- `waybar/` - Status bar
- `wofi/` - Application launcher
- `alacritty/` - Terminal emulator (YAML format)

## Syncing Changes

When making changes that should be available across environments:

1. Make changes in the appropriate branch
2. Cherry-pick common changes to main branch
3. Merge or cherry-pick from main to other environment branches as needed

## Remote Repository

Origin: `github.com:chiyonn/dotty` (to be updated)