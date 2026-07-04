# dotfiles

Nix flake managing NixOS and nix-darwin systems via home-manager.

## structure

```
nix/
├── flake.nix              entry point
├── constants.nix           shared values (user, locale, timezone)
├── hosts-registry.nix      all hosts declared here
├── nixos-base.nix          NixOS system module
├── darwin-base.nix         nix-darwin system module
├── hardware/               auto-generated hardware-config per host
├── host-specific/          per-machine overrides
├── desktop/                DE modules (gnome, plasma, cosmic, sway)
├── home/                   home-manager profiles (shared, linux, darwin)
└── templates/              dev shell flakes (python, cpp, java, web, etc.)

config/                     non-nix dotfiles → ~/.config
local/bin/                  scripts → ~/.local/bin
```

## hosts

| host | system | DE |
|---|---|---|
| `i5-9400-desktop` | NixOS x86_64 | GNOME |
| `thinkpad-x13-gen2` | NixOS x86_64 | Plasma |
| `macbook-pro-2017` | NixOS x86_64 | Plasma |
| `macbook-air` | darwin aarch64 | — |
| `macbook-pro-m1-pro` | darwin aarch64 | — |

## rebuild

```bash
# NixOS
sudo nixos-rebuild switch --flake .#thinkpad-x13-gen2

# darwin
sudo darwin-rebuild switch --flake .#macbook-air

# or use aliases (available in shell):
rebuild-test   # test build
rebuild        # switch (git add + rebuild)
```
