{ pkgs, lib, ... }:

{
  # --- TTY only, no DE/WM ---
  services.displayManager.enable = false;

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
