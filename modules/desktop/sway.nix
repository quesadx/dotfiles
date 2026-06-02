# ─── SWAY DESKTOP CONFIGURATION ───────────────────────────────────────────
# System-level configuration for Sway Desktop Environment
# Can be replaced with alternative desktop environments (KDE, etc.)

{ ... }:

{
  # ─── SWAY SERVICES ────────────────────────────────────────────────────────
  programs.sway.enable = true;
  programs.sway.wrapperFeatures.gtk = true; # Enable XWayland for legacy apps

}
