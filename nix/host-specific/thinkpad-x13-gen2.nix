{ pkgs, lib, ... }:

{
  # --- TTY only, no DE/WM ---
  services.displayManager.enable = false;

  # --- Headless server: never suspend on lid close ---
  services.logind.lidSwitch = "ignore";
  services.logind.lidSwitchExternalPower = "ignore";

  # --- Battery: cap charge at 65% to extend lifespan ---
  systemd.services.thinkpad-battery-limit = {
    description = "Cap ThinkPad battery charge at 65%";
    wantedBy = [ "multi-user.target" ];
    after = [ "sys-module-thinkpad_acpi.device" ];
    serviceConfig.Type = "oneshot";
    script = ''
      echo 65 > /sys/class/power_supply/BAT0/charge_control_end_threshold
    '';
  };

  # --- No desktop, so no flatpak/portals ---
  services.flatpak.enable = lib.mkForce false;

  # --- Docker & compose ---
  environment.systemPackages = with pkgs; [
    docker-compose
    util-linux
  ];

  virtualisation.docker.autoPrune = {
    enable = true;
    dates = "weekly";
  };
}
