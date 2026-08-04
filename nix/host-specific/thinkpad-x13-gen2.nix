{ pkgs, lib, ... }:

{
  # --- TTY only, no DE/WM ---
  services.displayManager.enable = false;

  # --- Headless server: never suspend on lid close ---
  services.logind.lidSwitch = "ignore";
  services.logind.lidSwitchExternalPower = "ignore";

  # --- No desktop, so no flatpak/portals ---
  services.flatpak.enable = lib.mkForce false;

  # --- Docker & compose ---
  environment.systemPackages = with pkgs; [
    docker-compose
  ];

  virtualisation.docker.autoPrune = {
    enable = true;
    dates = "weekly";
  };
}
