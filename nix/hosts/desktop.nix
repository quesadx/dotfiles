{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    mangohud
    protonup-qt
  ];

  programs.steam = {
    enable = true;

    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
  };

  services.lact.enable = true;
  programs.gamemode.enable = true;
}
