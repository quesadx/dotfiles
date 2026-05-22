{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    steam
    mangohud
  ];

  services.lact.enable = true;
  programs.gamemode.enable = true;
}
