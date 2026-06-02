# Multi-Host NixOS Configuration

This setup supports managing multiple NixOS machines from a single repository.

## Architecture

### Layer model (bottom-up)

| Layer | File(s) | Purpose |
|-------|---------|---------|
| Constants | `lib/shared.nix` | username, timezone, locale — shared by all hosts |
| Base system | `configuration.nix` | kernel, networking, users, fonts, PipeWire, Docker, Nix — host-neutral |
| Hardware | `hardware/<host>.nix` | Generated filesystem/mounts, CPU, initrd — per machine |
| Host-specific | `hosts/<host>/` | Per-machine overrides (sleep, power, audio, udev) |
| Desktop (system) | `modules/system/desktop-<de>.nix` | NixOS DE services (GDM, GNOME, COSMIC, Sway) |
| Desktop (user) | `modules/home/desktop-<de>.nix` | Home Manager DE settings (dconf, keybindings) |
| User base | `home/quesadx.nix` | Shared shell, git, editors, packages — all hosts |
| Host registry | `hosts.nix` | Maps each host to its modules |
| Orchestrator | `flake.nix` | Reads registry, builds `nixosConfigurations` |

### Key design decisions

- **Desktop selection per host**: each host entry declares `desktopModules` and `homeModules` explicitly. Omit both for headless/server hosts.
- **Host-specific modules isolated**: MacBook Pro has its own directory (`hosts/macbook-pro/`) with separate power/thermal and audio modules.
- **No DE imports in shared config**: `configuration.nix` and `home/quesadx.nix` contain no desktop-specific imports.
- **Hardware configs renamed**: `hardware/<host>.nix` (dropped `hardware-configuration.` prefix).
- **`hosts.nix` is single source of truth**: all per-host variation declared in one place.

## Available Hosts

```
desktop      (i5-9400 desktop, Intel)     — GNOME
thinkpad     (ThinkPad X13 Gen 2, Intel)  — GNOME
macbook-pro  (MacBook Pro 14,1, Intel)    — GNOME
```

## How to Use

### On Desktop

```bash
sudo nixos-rebuild test --flake .#desktop
sudo nixos-rebuild switch --flake .#desktop
```

### On ThinkPad X13

Generate hardware config on the ThinkPad:

```bash
sudo nixos-generate-config --root /mnt
cp /mnt/etc/nixos/hardware-configuration.nix \
   ~/linux-dotfiles/nixos/hardware/thinkpad.nix
git add hardware/thinkpad.nix && git commit -m "Add ThinkPad hardware config"
```

Then rebuild:

```bash
sudo nixos-rebuild switch --flake .#thinkpad
```

### On MacBook Pro

Generate hardware config on the MacBook Pro:

```bash
sudo nixos-generate-config --root /mnt
cp /mnt/etc/nixos/hardware-configuration.nix \
   ~/linux-dotfiles/nixos/hardware/macbook-pro.nix
git add hardware/macbook-pro.nix && git commit -m "Add MacBook Pro hardware config"
```

Then rebuild:

```bash
sudo nixos-rebuild switch --flake .#macbook-pro
```

## Adding a New Darwin Host

1. Create a host module under `hosts/darwin/<host>/default.nix`.
2. Set the hostname to match the flake output name exactly.
3. Use `aarch64-darwin` for Apple Silicon machines.
4. Add the host to the root flake as `darwinConfigurations.<host>`.

Example rebuild command:

```bash
darwin-rebuild switch --flake .#macbook-air
```

## Adding a New Host

1. Add entry to `hosts.nix`:

   ```nix
   my-machine = {
     flakeTarget = "my-machine";
     hostname = "my-machine";  # $HOSTNAME on the machine
     hardwareConfig = ./hardware/my-machine.nix;
     hardwareModules = [];  # nixos-hardware modules if applicable
     desktopModules = [ ./modules/system/desktop-gnome.nix ];  # omit for headless
     homeModules = [ ./modules/home/desktop-gnome.nix ];       # omit for headless
   };
   ```

2. Create `hardware/my-machine.nix`:

   ```bash
   # Run on the target machine
   sudo nixos-generate-config --root /mnt
   cp /mnt/etc/nixos/hardware-configuration.nix ~/linux-dotfiles/nixos/hardware/my-machine.nix
   ```

3. (Optional) Create `hosts/my-machine/default.nix` for host-specific overrides and add to `hardwareModules`.

4. Commit and rebuild:

   ```bash
   git add hosts.nix hardware/my-machine.nix
   git commit -m "Add my-machine host"
   sudo nixos-rebuild switch --flake .#my-machine
   ```

## Hardware Module Support

`nixos-hardware` modules are loaded via `hosts.nix` → `hardwareModules`. To find modules:

```bash
nix flake show github:NixOS/nixos-hardware
```

## Host-Specific Configuration

Instead of conditional logic in `configuration.nix`, add host-specific modules to `hosts/<host>/` and list them in `hosts.nix` under `hardwareModules`. This keeps base config clean and host logic isolated.

## Verify Setup

```bash
nix flake show

# Expected output:
# └───nixosConfigurations
#     ├───desktop: NixOS configuration
#     ├───thinkpad: NixOS configuration
#     └───macbook-pro: NixOS configuration

# Dry-run build test
nix build .#nixosConfigurations.desktop.config.system.build.toplevel --dry-run
nix build .#nixosConfigurations.thinkpad.config.system.build.toplevel --dry-run
nix build .#nixosConfigurations.macbook-pro.config.system.build.toplevel --dry-run
```
