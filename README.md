# dotfiles

Minimal configuration files for my Linux setup.

## Environment

- **OS:** CachyOS / NixOS
- **WM:** Hyprland (Wayland)
- **Bar:** Waybar
- **Shell:** Bash / Fish
- **Terminal:** Kitty
- **Launcher:** Fuzzel / Rofi
- **Notifications:** SwayNC
- **Editor:** Neovim

## Structure

```text
dotfiles/
├── .config/          # Application configs (universal)
│   ├── hypr/
│   ├── waybar/
│   ├── kitty/
│   ├── nvim/
│   └── ...
├── nixos/            # NixOS system configurations
└── scripts/          # Utility scripts
```

## Installation

### Using .config directly

Simply copy the `.config` directory contents:
```bash
git clone https://github.com/quesadx/dotfiles.git
cp -r dotfiles/.config/* ~/.config/
```

### Using NixOS

Apply the NixOS configuration:
```bash
sudo nixos-rebuild switch --flake .#hostname
```

## Theme Switching

Switch themes with:
```bash
switch-theme.sh
```

Automatically updates colors across all applications and reloads the desktop environment.

## License

Free to use and modify.