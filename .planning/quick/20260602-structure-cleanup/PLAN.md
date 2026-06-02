---
title: NixOS dotfiles structure cleanup
date: 2026-06-02
---

Clean up the dotfiles repo file tree — remove `nixos/` subtree, unify all modules under root, single flake for both NixOS and darwin.

Changes:
1. Remove empty directories: home/macos home/nixos hosts/macos systems systems/macos systems/nixos config/archive/nixos
2. Remove `nixos/flake.nix` (second flake) and `nixos/home/quesadx.nix` (thunk, inlined into root flake)
3. Move `nixos/` contents to root: hardware/, lib/, configuration.nix, hosts.nix
4. Unify module tree: nixos/modules/* → root modules/* (hosts/, desktop/, home/)
5. Shorten desktop module names (desktop-gnome.nix → gnome.nix etc)
6. Fix darwin host bug: define `darwinHost` and pass `host` to darwin specialArgs
7. Update all import paths
