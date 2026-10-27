# dotfiles

Minimal NixOS flake for three machines.

| host | role | desktop |
|---|---|---|
| `i5-9400-desktop` | development + gaming | GNOME |
| `hp-445-g10` | development | GNOME |
| `thinkpad-x13-gen2` | headless server | none |

## Rebuild

```bash
sudo nixos-rebuild switch --flake ~/dotfiles#i5-9400-desktop
sudo nixos-rebuild switch --flake ~/dotfiles#hp-445-g10
sudo nixos-rebuild switch --flake ~/dotfiles#thinkpad-x13-gen2
```

`rebuild-test` and `rebuild` aliases are available in zsh/bash.

## Layout

```
flake.nix              hosts and inputs
modules/system.nix     shared NixOS configuration
modules/home.nix       shared home-manager configuration
modules/desktop.nix    desktop GUI, GNOME and user settings
modules/development.nix shared development toolchain
hosts/<host>.nix       hardware and host-specific settings
legacy/                old machines, desktops, configs and templates (not evaluated)
```

Host-specific settings belong in `hosts/<host>.nix`; add a new host by creating
one file and registering it in `flake.nix`.
