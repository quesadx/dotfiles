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
cd ~/dotfiles

# 3. First build (darwin-rebuild doesn't exist yet)
nix run nix-darwin -- switch --flake .#macbook-air

# 4. Reboot, then daily use
darwin-rebuild switch --flake .#macbook-air
```

### NixOS

```bash
# 1. Install NixOS normally (any DE or headless)

# 2. Clone
git clone git@github.com:quesadx/dotfiles.git ~/dotfiles
cd ~/dotfiles

# 3. Generate hardware config for this machine
sudo nixos-generate-config --root /mnt
cp /mnt/etc/nixos/hardware-configuration.nix hardware/<hostname>.nix

# 4. Register the host in hosts.nix (nixos.<hostname> = { ... })
#    Then rebuild
sudo nixos-rebuild switch --flake .#<hostname>
```

## Daily Use

```bash
# Linux
sudo nixos-rebuild switch --flake .#desktop

# macOS
darwin-rebuild switch --flake .#macbook-air
```

After the first build, `nrt` (`nixos-rebuild test`) and `nrs` (`nixos-rebuild switch` with `git add .`) are available as shell aliases.

## How It Works

```
hosts.nix                  One registry, all machines
├── nixos.desktop          selects: hardware/desktop.nix
├── nixos.thinkpad         + hosts/thinkpad.nix
├── nixos.macbook-pro      + modules/desktop/gnome.nix
└── darwin.macbook-air     + modules/user/gnome.nix

modules/
├── desktop/gnome.nix      system-level DE (GDM, GNOME services)
├── user/gnome.nix          user-level DE  (dconf, extensions)
├── hosts/                  per-machine tweaks (power, audio, udev)
├── darwin/default.nix      darwin system config (homebrew, nix settings)
└── shared/nix.nix          cross-platform (flakes, GC, unfree)

home/                       home-manager profiles
├── shared/                 shell, git, editors, direnv
├── linux/                  linux extras (GNOME packages, chromium)
└── darwin/                 macOS paths
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
ln -s ~/dotfiles/config/active/fastfetch ~/.config/fastfetch
ln -s ~/dotfiles/local/bin/* ~/.local/bin/
```
