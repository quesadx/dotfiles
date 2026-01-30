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

Simply use stow -t .config or link with ln -s.

### Using NixOS

Apply the NixOS configuration:
```bash
sudo nixos-rebuild switch --flake .#hostname
```
