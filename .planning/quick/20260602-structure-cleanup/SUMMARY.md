---
status: complete
---

# Structure Cleanup

## Done
- Removed empty directories: home/macos, home/nixos, hosts/macos, systems/, config/archive/nixos/
- Fixed darwin `host` bug: defined `darwinHost` in flake.nix and passed `host` to darwin specialArgs and home-manager.extraSpecialArgs
- Removed `hosts/nixos/default.nix` adapter; root flake now imports `hosts.nix` directly
- Removed `nixos/flake.nix` — single flake for both NixOS and darwin
- Unified module tree: moved `nixos/` contents to root level
  - `nixos/hardware/` → `hardware/`
  - `nixos/lib/` → `lib/`
  - `nixos/configuration.nix` → root `configuration.nix`
  - `nixos/hosts.nix` → root `hosts.nix`
  - `nixos/modules/hosts/` → `modules/hosts/`
  - `nixos/modules/system/` → `modules/desktop/` (with shortened names)
  - `nixos/modules/home/` → `modules/home/` (with shortened names)
  - `nixos/home/quesadx.nix` → inlined into `flake.nix`
- Updated all import paths across flake.nix, configuration.nix, hosts.nix, home/linux/default.nix, modules/linux/default.nix

## Files Changed
- `nixos/` subtree — deleted entirely
- `flake.nix` — import paths + darwinHost + inlined home thunk
- `configuration.nix` — import path fix
- `hosts.nix` — updated module paths
- `home/linux/default.nix` — updated gnome module path
- `modules/linux/default.nix` — updated configuration.nix path
- Various empty directories — deleted
