# Deployment Notes

All commands run from `~/dotfiles/nix/`.

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

## Manual Linking

If you want to link files manually without Nix:

```bash
mkdir -p ~/.config ~/.local/bin ~/.local/share/wallpapers
ln -s ~/dotfiles/config/active/* ~/.config/
ln -s ~/dotfiles/config/active/fastfetch/thinkpad.txt ~/.config/fastfetch/
ln -s ~/dotfiles/local/bin/* ~/.local/bin/
ln -s ~/dotfiles/local/share/wallpapers ~/.local/share/
```

## Template Usage

Copy a template from `nix/templates/` into your project:

```bash
cp ~/dotfiles/nix/templates/python/flake.nix ./flake.nix
nix develop
```
