# dotfiles

Minimal and clean configuration files for my CachyOS + Hyprland setup.

## Environment

- **OS:** CachyOS (Arch-based)
- **WM:** [Hyprland](https://hyprland.org/) (Wayland)
- **Bar:** [Waybar](https://github.com/Alexays/Waybar)
- **Shell:** [Bash](https://www.gnu.org/software/bash/) / [Fish](https://fishshell.com/)
- **Terminal:** [Kitty](https://sw.kovidgoyal.net/kitty/)
- **Launcher:** [Fuzzel](https://codeberg.org/dnkl/fuzzel) / [Rofi](https://github.com/davatorium/rofi)
- **Notifications:** [SwayNC](https://github.com/ErikReider/SwayNotificationCenter)
- **Editor:** [Nvim](https://neovim.io/)
- **Font:** JetBrains Mono & Fira Code

## Structure

This repository uses [GNU Stow](https://www.gnu.org/software/stow/) for managing symlinks.

```text
dotfiles/
├── hyprland/         # Hyprland window manager configs
│   └── .config/hypr/
├── waybar/           # Status bar styling (CSS/JSON)
│   └── .config/waybar/
├── scripts/          # Custom utility scripts
│   └── .local/bin/
├── themes/           # UI/UX themes (includes configs for all apps)
│   └── .config/themes/
│       ├── cyan/
│       ├── orange/
│       └── current-theme.txt
├── wallpapers/       # Wallpaper collection
│   └── .local/share/wallpapers/
└── nixos-dotfiles/   # NixOS configurations (archived)
```

**Note:** Configs for kitty, rofi, fuzzel, swaync, wlogout, and fastfetch are managed by the theme switcher, which creates symlinks from `~/.config/themes/{theme-name}/` to the respective app config locations.

## Installation

### Prerequisites

Make sure you have GNU Stow installed:
```bash
sudo pacman -S stow
```

### Quick Install

1. **Clone the repository:**
   ```bash
   git clone https://github.com/quesadx/dotfiles.git ~/dotfiles
   ```

2. **Run the installation script:**
   ```bash
   cd ~/dotfiles
   ./install.sh
   ```

   This will create symlinks for all configuration files to their appropriate locations:
   - `~/.config/hypr/` → Hyprland configs
   - `~/.config/waybar/` → Waybar configs
   - `~/.local/bin/` → Utility scripts
   - `~/.config/themes/` → Theme files
   - `~/.local/share/wallpapers/` → Wallpapers

3. **Initialize theme configs:**
   ```bash
   # Make scripts executable
   chmod +x ~/.local/bin/*
   
   # Run theme switcher to create initial symlinks
   switch-theme.sh
   ```

### Manual Installation

If you prefer to install packages selectively:

```bash
cd ~/dotfiles

# Install specific packages
stow hyprland
stow waybar
stow scripts
stow themes
stow wallpapers
```

## Theme Switching

Switch between themes using:
```bash
switch-theme.sh
```

The script cycles between available themes (orange, cyan) and automatically:
- Creates symlinks from `~/.config/themes/{theme}/` to each app's config location
- Updates configs for: hyprland, waybar, kitty, rofi, fuzzel, swaync, wlogout, fastfetch
- Reloads Hyprland
- Restarts Waybar
- Applies new color schemes system-wide

## Uninstallation

To remove all symlinks:
```bash
cd ~/dotfiles
./uninstall.sh
```

Or manually:
```bash
cd ~/dotfiles
stow -D hyprland waybar scripts themes wallpapers
```

## NixOS

Previous NixOS configurations are archived in the `nixos-dotfiles/` directory for reference.

## Dependencies

Core packages required:
- hyprland
- waybar
- kitty
- fuzzel / rofi
- swaync
- wlogout
- fastfetch
- GNU stow

Refer to your distribution's package manager for installation.
