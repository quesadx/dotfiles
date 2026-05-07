# ─── COSMIC DESKTOP CONFIGURATION (User-level) ───────────────────────────
# Home Manager configuration for COSMIC Desktop Environment
# Note: COSMIC is still in beta, configuration options may evolve

{ config, pkgs, lib, ... }:

{
  # ─── COSMIC USES GSETTINGS ────────────────────────────────────────────────
  # COSMIC is built with cosmic-config (not dconf), but gsettings may provide
  # some compatibility. Enable dconf for potential shared settings.
  dconf.enable = true;

  # Placeholder for COSMIC-specific user configuration
  # As COSMIC matures, more configuration options will become available
  # Currently, most COSMIC settings are configured through the GUI
}
