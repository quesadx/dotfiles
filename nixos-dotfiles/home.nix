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
    ripgrep fastfetch
    discord desktop-file-utils

     # GNOME extensions
    gnomeExtensions.alphabetical-app-grid
    gnomeExtensions.clipboard-history
    gnomeExtensions.coverflow-alt-tab
    gnomeExtensions.hide-top-bar
    gnomeExtensions.luminus-desktop
    gnomeExtensions.top-bar-organizer
    gnomeExtensions.appindicator
    gnomeExtensions.dash-to-panel
    gnomeExtensions.caffeine
    gnomeExtensions.auto-accent-colour
  ];
  
###############
### FIREFOX ###
###############

  programs.firefox = {
    enable = true;
  };

#############
### GNOME ###
#############

dconf.settings = {
  # Atajos de ventana
  "org/gnome/desktop/wm/keybindings" = {
    close = [ "<Super>q" ];
    maximize = [ "<Super>f" ];
    switch-to-workspace-left = [ "<Super>h" ];
    switch-to-workspace-right = [ "<Super>l" ];
    move-to-workspace-left = [ "<Super><Shift>h" ];
    move-to-workspace-right = [ "<Super><Shift>l" ];
  };

  # Lista de atajos personalizados (¡OBLIGATORIO!)
  "org/grome/settings-daemon/plugins/media-keys" = {
    custom-keybindings = [
      "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
      "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
    ];
  };

  # Definición de atajos personalizados
  "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
    name = "Terminal";
    command = "kgx";
    binding = "<Super>t";
  };
  "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
    name = "Archivos";
    command = "nautilus";
    binding = "<Super>e";
  };

  # Navegador predeterminado (estructura plana)
  "org/gnome/desktop/default-applications/web-browser" = {
    exec = "firefox";
    name = "Firefox";
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
      nrs = "cd ~/dotfiles/nixos-dotfiles && sudo nixos-rebuild switch --flake .#nixos";
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
    enableDefaultConfig = false;
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
