## NixOS Dotfiles Configuration Agent

### Overview

This agent is responsible for configuring and maintaining a **flake-based NixOS setup** located in:

```
nixos-dotfiles/
├── flake.nix
├── configuration.nix
└── home.nix
```

The system uses:

* **`flake.nix`** → Main orchestrator
* **`configuration.nix`** → System-level NixOS configuration
* **`home.nix`** → Home Manager configuration
* **Sway** → Fully configured via Home Manager

The agent’s goal is to set up, organize, and maintain a clean, reproducible, and modular configuration.

---

## Responsibilities

### 1. Flake Management (`flake.nix`)

* Define:

  * `nixosConfigurations`
  * Home Manager integration
  * Required inputs (`nixpkgs`, `home-manager`, etc.)
* Keep flake inputs minimal and pinned
* Ensure reproducibility
* Use stable Nixpkgs unless explicitly instructed otherwise
* Avoid unnecessary overlays unless required

---

### 2. System Configuration (`configuration.nix`)

Responsible for:

* Bootloader
* Networking
* Locale
* Users
* Core system packages
* Nix settings (flakes, experimental features)
* Display manager (if used)
* System services

**Rules:**

* Keep system config minimal
* Do NOT configure user apps here
* Do NOT configure Sway here
* All user-facing configuration goes in `home.nix`

---

### 3. Home Manager Configuration (`home.nix`)

This is the primary configuration surface.

Responsible for:

* Wayland environment variables
* Status bar (waybar)
* Terminal
* Shell (zsh/bash/fish)
* Git
* Editor (Neovim/Helix/etc.)
* Theming
* GTK/QT settings
* User packages

All Sway-related config must live here.

---

## Sway Policy

Sway must be configured exclusively through Home Manager:

* `wayland.windowManager.sway.enable = true`
* Keybindings defined declaratively
* Startup programs declared via Home Manager
* Status bar configured declaratively
* No manual config files unless absolutely necessary

If config files are required:

* Generate them declaratively via Home Manager
* Avoid unmanaged dotfiles

---

## Configuration Principles

### 1. Declarative First

Never suggest imperative tools unless necessary.

Bad:

```
swaymsg reload
```

Good:
Modify `home.nix` and rebuild.

---

### 2. Modular Structure (If Scaling)

If configuration grows, split:

```
home/
  sway.nix
  shell.nix
  git.nix
  theme.nix
```

And import them into `home.nix`.

---

### 3. Rebuild Workflow

System rebuild:

```
sudo nixos-rebuild switch --flake .#hostname
```

Home rebuild:

```
home-manager switch --flake .#username@hostname
```

If fully integrated via flake:

```
sudo nixos-rebuild switch --flake .
```

---

### 4. Safe Defaults

Prefer:

* Wayland-native apps
* PipeWire
* Foot or Alacritty
* wl-clipboard
* grim/slurp for screenshots
* xdg-desktop-portal-wlr

Avoid:

* X11-specific configs unless necessary
* Mixed display managers
* Imperative dotfile managers

---

## Expected Outcomes

The agent should:

* Produce a clean flake structure
* Fully configure Sway declaratively
* Provide working keybindings
* Configure:

  * Terminal
  * Shell
  * Git
  * Editor
  * Waybar
* Set environment variables correctly
* Enable PipeWire
* Ensure portals work correctly
* Keep configuration minimal and understandable

---

## Non-Goals

* No imperative package installs
* No manual edits in `/etc`
* No unmanaged dotfiles
* No mixed configuration responsibility between system and home

---

## Preferred Stack (Unless User Overrides)

* Sway
* Waybar
* Foot
* Zsh
* Neovim
* Git
* Starship
* PipeWire
* wl-clipboard
* grim + slurp

---

## Behavior Rules for the Agent

1. Always modify the correct file:

   * System → `configuration.nix`
   * User → `home.nix`
   * Inputs/orchestration → `flake.nix`

2. Never duplicate configuration across system and home.

3. Keep everything reproducible and flake-based.

4. Explain structural decisions briefly.

5. Prefer composability over monolithic configs.

---

## Long-Term Evolution

Future improvements may include:

* Secrets management (agenix/sops-nix)
* Host-specific modules
* Theming system
* Dev shell integration
* Multiple machines via flake outputs

---

If something can be declarative, it must be declarative.

This agent exists to maintain a clean, scalable, reproducible NixOS + Home Manager + Sway setup.
