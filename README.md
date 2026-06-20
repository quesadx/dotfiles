# dotfiles

Multi-platform Nix configs for Linux (NixOS) and macOS (nix-darwin).

One `flake.nix`, one `hosts.nix`, one module tree.

## Fresh Install

### macOS (Apple Silicon)

```bash
# 1. Install Nix
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install

# 2. Clone
git clone git@github.com:quesadx/dotfiles.git ~/dotfiles

# 3. First build (darwin-rebuild doesn't exist yet)
nix run nix-darwin -- switch --flake ~/dotfiles/nix#macbook-air

# 4. Reboot, then daily use
darwin-rebuild switch --flake ~/dotfiles/nix#macbook-air
```

### NixOS

```bash
# 1. Install NixOS normally (any DE or headless)

# 2. Clone
git clone git@github.com:quesadx/dotfiles.git ~/dotfiles

# 3. Generate hardware config for this machine
sudo nixos-generate-config --root /mnt
cp /mnt/etc/nixos/hardware-configuration.nix nix/hardware/<hostname>.nix

# 4. Register the host in hosts.nix (nixos.<hostname> = { ... })
#    Then rebuild
sudo nixos-rebuild switch --flake ~/dotfiles/nix#<hostname>
```

## Daily Use

```bash
cd ~/dotfiles/nix

# Linux
sudo nixos-rebuild switch --flake .#desktop

# macOS
darwin-rebuild switch --flake .#macbook-air
```

After the first build, `nrt` (`nixos-rebuild test`) and `nrs` (`nixos-rebuild switch` with `git add .`) are available as shell aliases (run from `~/dotfiles/nix`).

## Structure

```
nix/
├── flake.nix          Entry point
├── hosts.nix          Registry — all machines in one place
├── shared.nix         Constants (username, locale)
├── nixos.nix          Base NixOS system (kernel, users, services)
├── darwin.nix         Base nix-darwin system (homebrew, defaults)
├── hardware/          Auto-generated per-machine (from nixos-generate-config)
├── hosts/             Per-machine tweaks (gaming, power, audio)
├── desktop/           Desktop environment modules (gnome, cosmic, sway)
├── home/              Home-manager profiles (shared, linux, darwin)
└── templates/         Standalone dev shell flakes

config/active/         Dotfiles symlinked to ~/.config (fastfetch, foot, kitty, waybar)
local/                 Scripts, binaries, wallpapers symlinked to ~/.local
```

Each host picks its stack in `hosts.nix`. No `if hostname ==` anywhere.

## Maintenance

```bash
nix flake check            # validate everything
nix flake update           # bump all inputs
nix flake update nixpkgs   # bump just nixpkgs
```

## Direct Config Files

Some configs live outside Nix (`config/active/`, `local/`):

```bash
ln -s ~/dotfiles/config/active/* ~/.config/
ln -s ~/dotfiles/config/active/fastfetch/thinkpad.txt ~/.config/fastfetch/
ln -s ~/dotfiles/local/bin/* ~/.local/bin/
ln -s ~/dotfiles/local/share/wallpapers ~/.local/share/
```

## Flake Templates

Standalone dev shell templates live in `nix/templates/`. Copy one into your project:

```bash
cp -r ~/dotfiles/nix/templates/python ~/my-project/flake.nix
cd ~/my-project && nix develop
```
