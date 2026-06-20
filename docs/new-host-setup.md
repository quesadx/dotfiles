# Multi-Host NixOS Configuration

This setup supports managing multiple NixOS machines from a single repository.

## Architecture

### Layer model (bottom-up)

| Layer | File(s) | Purpose |
|-------|---------|---------|
| Constants | `shared.nix` | username, timezone, locale |
| Base system | `nixos.nix` / `darwin.nix` | kernel, networking, users, services, Nix daemon |
| Hardware | `hardware/<host>.nix` | Generated filesystem/mounts, CPU, initrd |
| Host-specific | `hosts/<host>/` | Per-machine overrides (power, audio, gaming) |
| Desktop | `desktop/<de>.nix` | DE config (system + user in one module) |
| User base | `home/` | Home-manager profiles (shared, linux, darwin) |
| Host registry | `hosts.nix` | Maps each host to its modules |
| Orchestrator | `flake.nix` | Reads registry, builds `nixosConfigurations` |

### Key design decisions

- **Desktop selection per host**: each host entry declares `desktop` and `home`. Omit both for headless/server hosts.
- **Host-specific modules isolated**: MacBook Pro has its own directory (`hosts/macbook-pro/`) with separate power/thermal and audio modules.
- **No DE imports in shared config**: `nixos.nix` and `home/` contain no desktop-specific imports.
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
cd ~/dotfiles/nix
sudo nixos-rebuild test --flake .#desktop
sudo nixos-rebuild switch --flake .#desktop
```

### On ThinkPad X13

```bash
cd ~/dotfiles/nix
sudo nixos-rebuild switch --flake .#thinkpad
```

### On MacBook Pro

```bash
cd ~/dotfiles/nix
sudo nixos-rebuild switch --flake .#macbook-pro
```

## Adding a New Darwin Host

1. Add an entry to `hosts.nix` under the `darwin` section with `flakeTarget` and `hostname`.
2. Set `system` to `aarch64-darwin` (Apple Silicon) or `x86_64-darwin` (Intel).
3. Optionally add `hostModules` and `home` for custom modules.

Example rebuild command:

```bash
cd ~/dotfiles/nix
darwin-rebuild switch --flake .#macbook-air
```

## Adding a New NixOS Host

1. Generate hardware config on the target machine:

   ```bash
   sudo nixos-generate-config --root /mnt
   cp /mnt/etc/nixos/hardware-configuration.nix hardware/my-machine.nix
   ```

2. Add entry to `hosts.nix`:

   ```nix
   nixos.my-machine = {
     flakeTarget = "my-machine";
     hostname = "my-machine";
     hardware = ./hardware/my-machine.nix;
     hostModules = [];         # nixos-hardware modules if applicable
     desktop = [];             # omit for headless
     home = [];                # omit for headless
   };
   ```

3. (Optional) Create `hosts/my-machine/default.nix` for host-specific overrides and add to `hostModules`.

4. Commit and rebuild:

   ```bash
   git add hosts.nix hardware/my-machine.nix
   git commit -m "Add my-machine host"
   sudo nixos-rebuild switch --flake .#my-machine
   ```

## Hardware Module Support

`nixos-hardware` modules are loaded via `hosts.nix` → `hostModules`. To find modules:

```bash
nix flake show github:NixOS/nixos-hardware
```

## Host-Specific Configuration

Instead of conditional logic in `nixos.nix`, add host-specific modules to `hosts/<host>/` and list them in `hosts.nix` under `hostModules`. This keeps base config clean and host logic isolated.
