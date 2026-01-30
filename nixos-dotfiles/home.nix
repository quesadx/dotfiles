{ config, pkgs, ... }: {

############
### USER ###
############

  home.username = "quesadx";
  home.homeDirectory = "/home/quesadx";

#################################
### PACKAGES | LO RICO VA ACA ###
#################################

  home.packages = with pkgs; [
    btop ripgrep zoxide fastfetch
    kitty waybar swaynotificationcenter
    grim slurp wl-clipboard cliphist
    stow fuzzel pulsemixer
    swaybg
  ];

###########################
### CONFIGURATION FILES ###
###########################

  xdg.configFile = {
    "hypr".source = ../.config/hypr;
    "kitty".source = ../.config/kitty;
    "waybar".source = ../.config/waybar;
    "swaync".source = ../.config/swaync;
    "fuzzel".source = ../.config/fuzzel;
    "fastfetch".source = ../.config/fastfetch;
  };

################
### CHROMIUM ###
################

  programs.chromium = {
    enable = true;
    extensions = [
      # Bitwarden
      { id = "nngceckbapebfimnlniiiahkandclblb"; }
      # uBlock Origin Lite
      { id = "ddkjiahejlhfcafbddmgiahcphecmpfh"; }
    ];
  };

############
### BASH ###
############

  programs.bash = {
    enable = true;
    shellAliases = {
      ll = "ls -l";
      gs = "git status";
      ga = "git add .";
      gc = "git commit -m";
      gp = "git push";
    };
  };

###########
### GIT ###
###########

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Matteo Quesada";
        email = "matteo.vargas.quesada@est.una.ac.cr";
      };
    };
  };

###########
### SSH ###
###########

  programs.ssh = {
    enable = true;
    addKeysToAgent = "yes";
  };
  services.ssh-agent.enable = true;

####################
### HOME MANAGER ###
####################

  programs.home-manager.enable = true;

##################################
### HOME MANAGER STATE VERSION ###
##################################

  home.stateVersion = "25.11";

}
