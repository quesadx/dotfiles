---
status: complete
---

# Structure Cleanup

## Done
- Removed empty directories: home/macos, home/nixos, hosts/macos, systems/, config/archive/nixos/
- Fixed darwin `host` bug: defined `darwinHost` in flake.nix and passed `host` to darwin specialArgs and home-manager.extraSpecialArgs
- Removed `hosts/nixos/default.nix` adapter; root flake now imports `nixos/hosts.nix` directly

## Files Changed
- `flake.nix` — import path change + darwinHost addition
- `hosts/nixos/default.nix` — deleted
- Various empty directories — deleted
