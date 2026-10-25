{ lib, ... }:

{
  # --- COSMIC Services ---
  services.displayManager.cosmic-greeter.enable = true;
  services.desktopManager.cosmic.enable = true;

  # Boot to TTY; GUI on demand: sudo systemctl start display-manager
  systemd.defaultUnit = lib.mkForce "multi-user.target";

  # --- COSMIC Optimization ---
  services.system76-scheduler.enable = true;
}
