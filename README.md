# dotfiles

Multi-platform Nix configs — NixOS (Linux) and nix-darwin (macOS).

Flake at `nix/flake.nix`. Hosts registered in `nix/hosts.nix`. Everything else is per-platform modules.

| Host | Platform | DE |
|------|----------|----|
| `desktop` | NixOS x86_64 | GNOME |
| `thinkpad` | NixOS x86_64 | GNOME |
| `macbook-pro` | NixOS x86_64 | GNOME |
| `macbook-air` | darwin aarch64 | — |
| `macbook-pro` | darwin x86_64 | — |

## Fresh Install

```bash
git clone git@github.com:quesadx/dotfiles.git ~/dotfiles
cd ~/dotfiles/nix
```

**NixOS** — generate hardware config, register in hosts.nix, rebuild:
```bash
sudo nixos-generate-config --root /mnt
cp /mnt/etc/nixos/hardware-configuration.nix hardware/<host>.nix
sudo nixos-rebuild switch --flake .#<host>
```

**macOS** — install Nix, first build with nix-darwin, then daily:
```bash
curl -sSf -L https://install.determinate.systems/nix | sh -s -- install
nix run nix-darwin -- switch --flake .#<host>
```

## Daily Use

```bash
cd ~/dotfiles/nix

nrs   # alias: nixos-rebuild test --flake .#<host>
nrt   # alias: nixos-rebuild switch --flake .#<host> (with git add .)

# Or manually:
sudo nixos-rebuild switch --flake .#desktop
darwin-rebuild switch --flake .#macbook-air
```

Shell aliases (`nrt`/`nrs`) are available after the first build.

## Structure

```
nix/
├── flake.nix              Entry point, 44 lines
├── hosts.nix              Host registry — single source of truth
├── shared.nix             Shared constants (user, locale)
├── nixos.nix              NixOS base (kernel, users, services, home-manager)
├── darwin.nix             nix-darwin base (homebrew, defaults, home-manager)
├── hardware/              Auto-generated per-host (nixos-generate-config)
├── hosts/                 Per-machine tweaks (gaming, power, audio)
│   ├── desktop.nix
│   └── macbook-pro/
├── desktop/               Desktop environment modules
│   ├── gnome.nix + gnome-user.nix
│   ├── cosmic.nix + cosmic-user.nix
│   └── sway.nix
├── home/                  Home-manager profiles
│   ├── shared.nix         Shell, git, editors, direnv
│   ├── linux.nix          GNOME apps, chromium, rebuild aliases
│   └── darwin.nix         ghostty, rebuild aliases
└── templates/             Standalone dev shell flakes (python, cpp, web, …)

config/active/             Dotfiles symlinked to ~/.config
local/                     Scripts, wallpapers symlinked to ~/.local
```

No `if hostname == ...` anywhere. Each host declares its own stack in `hosts.nix`.

## Maintenance

```bash
cd ~/dotfiles/nix
nix flake check          # validate all hosts
nix flake update         # bump all inputs
```

## Config & Templates

```bash
# Link non-Nix configs manually
ln -s ~/dotfiles/config/active/* ~/.config/
ln -s ~/dotfiles/local/bin/* ~/.local/bin/
ln -s ~/dotfiles/local/share/wallpapers ~/.local/share/

# Use a dev shell template
cp ~/dotfiles/nix/templates/python/flake.nix ./flake.nix
nix develop
```
