{ config, pkgs, ... }: {
  
  imports = [
    ./hardware-configuration.nix
    ./modules/system.nix
    ./modules/users.nix
    ./modules/nix-settings.nix
    ./modules/gui.nix
  ];

  system.stateVersion = "25.11"; 
}
