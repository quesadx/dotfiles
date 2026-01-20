{ config, pkgs, ... }:

{
  home.username = "quesadx";
  home.homeDirectory = "/home/quesadx";

  imports = [ ./modules/git.nix ./modules/bash.nix ];

  home.stateVersion = "23.11"; 

  home.packages = with pkgs; [
    htop
    btop
    fetchutils
    ripgrep
    fzf
    tmux
    neovim
  ];

  # SSH Agent automático
  services.ssh-agent.enable = true;

  # Deja que Home Manager se instale solo
  programs.home-manager.enable = true;
}
