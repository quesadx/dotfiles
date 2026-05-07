# ─── COSMIC DESKTOP CONFIGURATION ────────────────────────────────────────
# System-level configuration for COSMIC Desktop Environment
# COSMIC is System76's modern desktop environment built with Rust

{ config, pkgs, ... }:

{
  # ─── COSMIC SERVICES ──────────────────────────────────────────────────────
  services.displayManager.cosmic-greeter.enable = true;
  services.desktopManager.cosmic.enable = true;

  # ─── COSMIC OPTIMIZATION ──────────────────────────────────────────────────
  # System76's scheduler improves performance on COSMIC
  services.system76-scheduler.enable = true;

  # ─── COSMIC EXCLUSIONS ────────────────────────────────────────────────────
  # Exclude certain COSMIC applications if not needed
  # Uncomment to use (only available in 25.11+)
  # environment.cosmic.excludePackages = with pkgs; [
  #   cosmic-edit
  # ];
}
