---
phase: nix
fixed_at: 2026-06-02T21:20:00Z
review_path: /home/quesadx/dotfiles/nix-REVIEW.md
iteration: 1
findings_in_scope: 5
fixed: 5
skipped: 0
status: all_fixed
---

# Phase nix: Code Review Fix Report

**Fixed at:** 2026-06-02T21:20:00Z
**Source review:** /home/quesadx/dotfiles/nix-REVIEW.md
**Iteration:** 1

**Summary:**
- Findings in scope: 5
- Fixed: 5
- Skipped: 0

## Fixed Issues

### WR-01: Hardcoded gnome-user import prevents desktop switching

**Files modified:** `nix/home/linux.nix`
**Commit:** `b750e77`
**Applied fix:** Removed the hardcoded `../desktop/gnome-user.nix` import from `nix/home/linux.nix` line 18. The per-host `homeModules` in `hosts.nix` already handles this for all three NixOS hosts. Desktop switching is now controlled purely through `hosts.nix`.

### WR-02: sudo passwordless for wheel group

**Files modified:** `nix/nixos.nix`
**Commit:** `8dcdb57`
**Applied fix:** Removed `security.sudo.wheelNeedsPassword = false;` from line 121. Sudo now requires password authentication for wheel group members, improving security against session-hijacking attacks.

### WR-03: Dash-to-Dock settings are dead configuration

**Files modified:** `nix/desktop/gnome-user.nix`
**Commit:** `b92b14f`
**Applied fix:** Removed the dead `org/gnome/shell/extensions/dash-to-dock` dconf settings block (lines 69-78). The dash-to-dock extension is not installed nor enabled, making these settings inert.

### WR-04: Duplicate gnome-user module import

**Files modified:** None (verification only)
**Commit:** N/A
**Applied fix:** Verified that after WR-01 (removing the hardcoded import), all three NixOS hosts in `hosts.nix` still list `homeModules = [ ./desktop/gnome-user.nix ]` on lines 12, 24, and 37. The duplication is resolved — each host receives exactly one copy of the gnome-user module via the per-host mechanism. No code change needed.

### WR-05: SSH settings configured but SSH module disabled

**Files modified:** `nix/home/shared.nix`
**Commit:** `42f3e4e`
**Applied fix:** Removed the dead `settings."*".addKeysToAgent = "yes";` line from the `programs.ssh` block. Since `programs.ssh.enable = false`, this setting had no effect and could mislead readers.

---

_Fixed: 2026-06-02T21:20:00Z_
_Fixer: OpenCode (gsd-code-fixer)_
_Iteration: 1_
