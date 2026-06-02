# dotfiles repo

Multi-platform dotfiles for Linux and macOS.

## Structure

- `flake.nix`: root flake with NixOS and nix-darwin outputs.
- `configuration.nix`: base NixOS system configuration (kernel, networking, users, services).
- `hosts.nix`: host registry mapping each NixOS machine to its hardware config and module stack.
- `hardware/`: generated hardware configs per machine.
- `hosts/`: per-host modules — `desktop.nix`, `thinkpad.nix`, `macbook-pro/`, and `darwin/macbook-air/`.
- `lib/shared.nix`: shared constants (username, locale, timezone) used by all configurations.
- `home/`: Home Manager configs — `shared/` (portable), `linux/` (Linux-only), `darwin/` (macOS-only).
- `modules/`: NixOS and nix-darwin modules.
  - `desktop/`: system-level desktop environment configs (gnome, sway, cosmic).
  - `user/`: user-level desktop configs (dconf, GNOME extensions) loaded into home-manager.
  - `darwin/`: nix-darwin system configuration.
  - `shared/`: cross-platform Nix settings.
- `config/active/`: active app config folders linked into `~/.config` when needed.
- `config/archive/`: archived experimental configs (Sway/Hypr stack).
- `local/`: files intended for `~/.local` (`bin` scripts and `share/wallpapers`).
- `templates/`: reusable `flake.nix` templates for dev environments.
- `wallpapers/`: extra wallpaper assets.

## Rebuild Commands

NixOS hosts from the root flake:

```bash
sudo nixos-rebuild switch --flake .#desktop
sudo nixos-rebuild switch --flake .#thinkpad
sudo nixos-rebuild switch --flake .#macbook-pro
```

macOS host from the root flake:

```bash
nix --extra-experimental-features 'nix-command flakes' run nix-darwin/master#darwin-rebuild -- switch --flake .#macbook-air
``

```bash
darwin-rebuild switch --flake .#macbook-air
```

## Flake Maintenance

```bash
nix flake check
nix flake update
```

## Direct Config Files

If you want to link the folders manually without Nix, for example:

```bash
ln -s ~/dotfiles/config/active/fastfetch ~/.config/fastfetch
ln -s ~/dotfiles/local/bin/* ~/.local/bin/
```
