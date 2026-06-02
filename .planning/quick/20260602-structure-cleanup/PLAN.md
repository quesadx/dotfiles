---
title: NixOS dotfiles structure cleanup
date: 2026-06-02
---

Clean up the dotfiles repo file tree — remove empty/dead directories, fix the darwin `host` bug in `flake.nix`, and remove the needless `hosts/nixos/default.nix` adapter layer.

Changes:
1. Remove empty directories: home/macos home/nixos hosts/macos systems systems/macos systems/nixos config/archive/nixos/home config/archive/nixos/system
2. Fix darwin config: define `darwinHost` in flake.nix and pass `host` to darwin `specialArgs` and `home-manager.extraSpecialArgs` (fixes eval error from `home/darwin/default.nix` referencing `host.flakeTarget`)
3. Remove `hosts/nixos/default.nix` adapter thunk; import `./nixos/hosts.nix` directly in root flake
