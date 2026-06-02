# Deployment Notes

## Root Flake

The root `flake.nix` now exposes both NixOS and nix-darwin outputs.

## NixOS Host Rebuild

```bash
sudo nixos-rebuild switch --flake .#desktop
sudo nixos-rebuild switch --flake .#thinkpad
sudo nixos-rebuild switch --flake .#macbook-pro
```

## macOS Host Rebuild

```bash
darwin-rebuild switch --flake .#macbook-air
```

## Home Manager Layout

- `home/shared/default.nix`: portable shell, git, editor, and tooling settings.
- `home/linux/default.nix`: Linux-only packages and GNOME integration.
- `home/darwin/default.nix`: macOS-only Home Manager settings.

## Manual Linking

If you want to link files manually without Nix:

```bash
mkdir -p ~/.config ~/.local/bin ~/.local/share/wallpapers
ln -s ~/dotfiles/config/active/fastfetch ~/.config/fastfetch
ln -s ~/dotfiles/local/bin/* ~/.local/bin/
ln -s ~/dotfiles/local/share/wallpapers/* ~/.local/share/wallpapers/
```

## Template Usage

Copy a template from `templates/` into your project root as `flake.nix`, then run:

```bash
nix develop
```
