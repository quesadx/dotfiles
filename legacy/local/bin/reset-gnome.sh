#!/usr/bin/env bash
#
# reset-gnome.sh — clean up leftover COSMIC/Plasma contamination from the
# i5-9400-desktop transition to GNOME (config, state, theming, caches).
# Run AFTER the switch, from a GNOME session or TTY. Nothing is deleted
# blindly: files are moved to ~/.gnome-switch-backup/<timestamp>/, caches
# are removed.
#
# usage: reset-gnome.sh [--dry-run] [--force]
#   --dry-run  print what would be done without touching anything
#   --force    also kill running COSMIC processes

set -euo pipefail

DRY_RUN=0
FORCE=0
for arg in "$@"; do
  case "$arg" in
    --dry-run) DRY_RUN=1 ;;
    --force) FORCE=1 ;;
    *) printf 'unknown argument: %s\n' "$arg" >&2; exit 1 ;;
  esac
done

BACKUP_DIR="$HOME/.gnome-switch-backup/$(date +%Y%m%d-%H%M%S)"

say() { printf '%s\n' "$*"; }
warn() { printf 'WARN: %s\n' "$*" >&2; }

move_to_backup() {
  # move existing paths into the backup dir, preserving relative layout
  for path in "$@"; do
    [ -e "$path" ] || continue
    dest="$BACKUP_DIR${path#$HOME}"
    if [ "$DRY_RUN" = 1 ]; then
      say "[dry-run] would move $path"
    else
      mkdir -p "$(dirname "$dest")"
      mv "$path" "$dest"
      say "moved $path"
    fi
  done
}

if [ "$DRY_RUN" = 1 ]; then
  say "== dry run, nothing will be changed =="
else
  mkdir -p "$BACKUP_DIR"
  say "backup dir: $BACKUP_DIR"
fi
say ""

# --- COSMIC flatpak app (CosmicTweaks) ---
if flatpak list --app 2>/dev/null | grep -q 'dev.edfloreshz.CosmicTweaks'; then
  if [ "$DRY_RUN" = 1 ]; then
    say "[dry-run] would uninstall flatpak dev.edfloreshz.CosmicTweaks"
  else
    flatpak uninstall -y dev.edfloreshz.CosmicTweaks >/dev/null 2>&1 || true
    say "uninstalled flatpak dev.edfloreshz.CosmicTweaks"
  fi
fi

# --- systemd user units shipped by the COSMIC system profile ---
# (linked-runtime/generated units disappear on reboot anyway; disable defensively)
for unit in \
  com.system76.CosmicStatusNotifierWatcher.service \
  org.freedesktop.impl.portal.desktop.cosmic.service \
  cosmic-session.target
do
  if [ "$DRY_RUN" = 1 ]; then
    systemctl --user list-unit-files "$unit" >/dev/null 2>&1 && say "[dry-run] would disable $unit"
  else
    systemctl --user disable --now "$unit" >/dev/null 2>&1 || true
    say "disabled $unit (if present)"
  fi
done
if [ "$DRY_RUN" = 0 ]; then
  systemctl --user daemon-reload 2>/dev/null || true
fi

# --- running COSMIC processes ---
if pgrep -x cosmic-comp >/dev/null 2>&1 || pgrep -f 'cosmic-workspaces' >/dev/null 2>&1; then
  if [ "$FORCE" = 1 ] && [ "$DRY_RUN" = 0 ]; then
    pkill -x cosmic-comp 2>/dev/null || true
    pkill -f 'cosmic-applet|cosmic-workspaces|cosmic-launcher|cosmic-notifications' 2>/dev/null || true
    say "killed running COSMIC processes"
  else
    warn "COSMIC is still running; file cleanup continues, process cleanup will finish after reboot (or re-run with --force)"
  fi
fi

# --- COSMIC config ---
move_to_backup \
  "$HOME/.config/cosmic" \
  "$HOME/.config/cosmic-initial-setup-done" \
  "$HOME/.config/cosmic-mimeapps.list" \
  "$HOME/.config/com.system76."* \
  "$HOME/.config/systemd/user/com.system76"* \
  "$HOME/.config/systemd/user/cosmic"* \
  "$HOME/.config/autostart/cosmic"* \
  "$HOME/.config/autostart/com.system76"*

# --- Qt/KDE theme leftovers (kdeglobals, qt5ct/qt6ct) ---
move_to_backup \
  "$HOME/.config/kdeglobals" \
  "$HOME/.config/kde.org" \
  "$HOME/.config/qt5ct" \
  "$HOME/.config/qt6ct"

# --- GTK theme overrides pointing at COSMIC/Kyanite themes ---
for f in "$HOME/.config/gtk-3.0/settings.ini" "$HOME/.config/gtk-4.0/settings.ini"; do
  if [ -f "$f" ] && grep -qiE 'cosmic|system76|kyanite' "$f"; then
    move_to_backup "$f"
  fi
done

# --- COSMIC state ---
move_to_backup \
  "$HOME/.local/state/cosmic" \
  "$HOME/.local/state/cosmic-comp" \
  "$HOME/.local/state/pop-launcher"

# --- KDE color schemes leftover from the Plasma era ---
move_to_backup "$HOME/.local/share/color-schemes"

# --- COSMIC caches (expendable) ---
for c in "$HOME"/.cache/cosmic*; do
  [ -e "$c" ] || continue
  if [ "$DRY_RUN" = 1 ]; then
    say "[dry-run] would delete $c"
  else
    rm -rf "$c"
    say "deleted $c"
  fi
done

say ""
say "== done =="
if [ "$DRY_RUN" = 1 ]; then
  say "re-run without --dry-run to apply."
else
  say "files you might want later are in: $BACKUP_DIR"
  say ""
  say "next steps:"
  say "  reboot into the new GNOME system (sudo reboot)"
  say "  after first login, store your SSH key in the keyring once:"
  say "    ssh-add ~/.ssh/id_ed25519"
  say "  verify: ssh -T git@github.com"
fi
