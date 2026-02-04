# dotfiles repo

Minimal configuration files for my Linux setup. Mainy focused on NixOS.

## Environment

- **OS:** NixOS / CachyOS (VM & fallback hardware)
- **DE:** GNOME (Wayland)
- **Shell:** Zsh / Bash (as fallback)
- **Terminal:** gnome-console (kgx)

## Installation

### Using .config directly

Simply use stow -t .config or link with ln -s.

### Using NixOS

Apply the NixOS configuration:
```bash
sudo nixos-rebuild switch --flake .#hostname
```
