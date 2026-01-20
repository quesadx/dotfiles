{ config, pkgs, ... }:

{
  home.username = "quesadx";
  home.homeDirectory = "/home/quesadx";

  imports = [ ./modules/git.nix ./modules/bash.nix ];

  home.stateVersion = "23.11"; 

  home.packages = with pkgs; [
    btop
    ripgrep
    zoxide
    fastfetch

    # Hyprland-specific stuff
    kitty
    waybar
    swaynotificationcenter
    fuzzel
    wlogout
    # Hyprland misc tools
    grim slurp wl-clipboard
  ];

  # Vinculación de archivos de configuración
  xdg.configFile = {
    "hypr".source = ./dots/hypr;
    "kitty".source = ./dots/kitty;
    "waybar".source = ./dots/waybar;
    "swaync".source = ./dots/swaync;
    "fuzzel".source = ./dots/fuzzel;
    "wlogout".source = ./dots/wlogout;
    "fastfetch".source = ./dots/fastfetch;
    "scripts".source = ./dots/scripts;
  };

  # SSH Agent automático
  services.ssh-agent.enable = true;

  # Deja que Home Manager se instale solo
  programs.home-manager.enable = true;
}
