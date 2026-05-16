{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    steam
  ];

  services.lact.enable = true; # Used for having a GUI on GPU stuff
  programs.gamemode.enable = true; # Used for gaming performance improvements
}
