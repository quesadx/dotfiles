# dotfiles repo

Multi-platform dotfiles for Linux and macOS.

## Structure

- `flake.nix`: root flake with NixOS and nix-darwin outputs.
- `nixos/`: legacy Linux-only NixOS entrypoint kept separate.
- `hosts/nixos/`: root flake wrapper around the existing NixOS host registry.
- `hosts/darwin/macbook-air/`: nix-darwin host definition for the M1 MacBook Air.
- `home/shared/`: portable Home Manager config for shell, git, editors, and tooling.
- `home/linux/`: Linux-only Home Manager layer for GNOME, Chromium, and NixOS rebuild aliases.
- `home/darwin/`: macOS-only Home Manager layer for shell integration and Git credentials.
- `modules/shared/`: cross-platform Nix settings shared by NixOS and nix-darwin.
- `modules/linux/`: Linux system wrapper.
- `modules/darwin/`: nix-darwin system configuration.
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
ln -s ~/linux-dotfiles/config/active/fastfetch ~/.config/fastfetch
ln -s ~/linux-dotfiles/local/bin/* ~/.local/bin/
```
