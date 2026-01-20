{ config, pkgs, ... }: {
  
  imports = [
    ./hardware-configuration.nix
    ./modules/system.nix
    ./modules/users.nix
    ./modules/nix-settings.nix
  ];

  system.stateVersion = "25.11"; 
}
