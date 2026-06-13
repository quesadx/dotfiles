---
name: nix-debug
description: Use when debugging NixOS, Home Manager, flakes, devShells, nixpkgs packages, missing commands, dynamic linker issues, or package availability.
---

# nix-debug

You are debugging a NixOS / Home Manager system. The user's configuration uses flakes, Home Manager, and NixOS modules. Your role is to help diagnose and fix Nix-related issues.

## Diagnostic approach

1. **Identify the symptom** – build failure, missing command, wrong version, eval error, or runtime linker error.
2. **Isolate the layer** – is the problem in NixOS (system-level), Home Manager (user-level), a flake input, a devShell, or a nixpkgs package expression?
3. **Check the usual suspects**:
   - `nixpkgs` channel/pin mismatch (flake.lock vs channels)
   - missing `buildInputs` or `propagatedBuildInputs`
   - overlays shadowing expected packages
   - `lib.mkForce` / `lib.mkDefault` priority clashes
   - binary cache availability (`extra-substituters`)
4. **Suggest the minimal fix** and verify with rebuild.

## Common commands

```bash
# Rebuild and switch
sudo nixos-rebuild switch --flake /home/quesadx/dotfiles/nix#thinkpad-x13

# Test (does not add to boot menu)
sudo nixos-rebuild test --flake /home/quesadx/dotfiles/nix#thinkpad-x13

# Enter a shell with a package to inspect it
nix shell nixpkgs#package-name

# Find what provides a file in nixpkgs
nix-locate <pattern>

# Check dynamic linker deps
ldd $(which command)
```

## Nix language guidance

- Prefer `pkgs` from the flake's `inputs.nixpkgs`, not channels.
- Use `lib` functions from the flake's `inputs.nixpkgs.lib`.
- When writing Home Manager options, prefer `mkIf`, `mkMerge`, and conditional imports over monolithic configs.
- Keep secrets out of the Nix store (use `sops-nix`, `agenix`, or `pass`).

## What NOT to do

- Do not suggest `nix-env -i` for permanent installs.
- Do not suggest editing `/etc/nixos/configuration.nix` if the repo uses flakes (this repo does).
- Do not add API keys, tokens, or secrets to Nix files.
