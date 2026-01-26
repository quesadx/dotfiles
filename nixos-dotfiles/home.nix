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
    "hypr".source = ../.config/hypr;
    "kitty".source = ../.config/kitty;
    "waybar".source = ../.config/waybar;
    "swaync".source = ../.config/swaync;
    "fuzzel".source = ../.config/fuzzel;
    "wlogout".source = ../.config/wlogout;
    "fastfetch".source = ../.config/fastfetch;
   # "scripts".source = ../.config/scripts;
  };

  # SSH Agent automático
  services.ssh-agent.enable = true;

  # Deja que Home Manager se instale solo
  programs.home-manager.enable = true;
}
