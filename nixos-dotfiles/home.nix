{ config, pkgs, ... }: {

############
### USER ###
############

  home.username = "quesadx";
  home.homeDirectory = "/home/quesadx";

#####################################
### PACKAGES | INSTALAR COSAS ACÁ ###
#####################################

  home.packages = with pkgs; [
    zoxide fastfetch
    kitty waybar swaynotificationcenter
    grim slurp wl-clipboard cliphist
    stow fuzzel pulsemixer
    swaybg bluetuith hyprmon libnotify
    kdePackages.dolphin chromium 
    adwaita-icon-theme
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

###############
### FIREFOX ###
###############

  programs.firefox = {
    enable = true;
    profiles.quesadx = {
      isDefault = true;
      
      settings = {
        # "browser.startup.homepage" = "https://google.com";
        "browser.search.region" = "CR";
        "browser.search.isUS" = false;
        "distribution.id" = "nixos";
      };
    };

    policies = {
      ExtensionSettings = {
        # uBlock Origin
        "uBlock0@raymondhill.net" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
          installation_mode = "force_installed";
        };
        # Bitwarden
        "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
          installation_mode = "force_installed";
        };
        # Dark Reader
        "addon@darkreader.org" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/darkreader/latest.xpi";
          installation_mode = "force_installed";
        };
      };
    };
  };

#####################
### CURSOR BIBATA ###
#####################

  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.phinger-cursors;
    name = "phinger-cursors-light";
    size = 24;
  };

  gtk = {
    enable = true;
    iconTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
    };
    theme = {
      package = pkgs.adw-gtk3;
      name = "adw-gtk3";
    };
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
      nrs = "cd ~/dotfiles && git add . && cd nixos-dotfiles && sudo nixos-rebuild switch --flake .#nixos";
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

  home.stateVersion = "26.05";

}
