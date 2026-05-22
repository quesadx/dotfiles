{ pkgs, ... }:

{
  # --- GNOME Services ---
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;
  services.gnome.core-apps.enable = false;
  services.gnome.core-developer-tools.enable = false;
  services.gnome.games.enable = false;

  # --- GNOME Extensions ---
  environment.systemPackages = with pkgs.gnomeExtensions; [
    caffeine
    luminus-desktop
    appindicator
    touchpad-gesture-customization
  ];

  # --- Excluded packages ---
  environment.gnome.excludePackages = with pkgs; [
    gnome-tour
    gnome-user-docs
  ];
}
