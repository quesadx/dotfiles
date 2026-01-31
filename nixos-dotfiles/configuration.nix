{ config, pkgs, ... }: {

  imports = [ ./hardware-configuration.nix ];

############
### BOOT ###
############

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

##################
### NETWORKING ###
##################

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

#############
### POWER ###
#############
  services.power-profiles-daemon.enable = true;

#####################
### LOCALE & TIME ###
#####################

  time.timeZone = "America/Costa_Rica";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "es_CR.UTF-8";
    LC_IDENTIFICATION = "es_CR.UTF-8";
    LC_MEASUREMENT = "es_CR.UTF-8";
    LC_MONETARY = "es_CR.UTF-8";
    LC_NAME = "es_CR.UTF-8";
    LC_NUMERIC = "es_CR.UTF-8";
    LC_PAPER = "es_CR.UTF-8";
    LC_TELEPHONE = "es_CR.UTF-8";
    LC_TIME = "es_CR.UTF-8";
  };

################
### KEYBOARD ###
################

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

#############
### USERS ###
#############

  users.users.quesadx = {
    isNormalUser = true;
    description = "Matteo Quesada";
    extraGroups = [ "networkmanager" "wheel" "video" "render" ];
  };

#######################
### SYSTEM PACKAGES ###
#######################

  environment.systemPackages = with pkgs; [
    vim wget git curl
  ];

####################
### NIX SETTINGS ###
####################

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };
  nix.settings.auto-optimise-store = true;

###########
### SSH ###
###########

  services.openssh.enable = true;

#############
### GNOME ###
#############

  hardware.graphics.enable = true;
  # Display/session management layer (actually wayland tho)
  services.xserver.enable = true;
  # GDM = GNOME Display Manager (Wayland-native login screen)
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.displayManager.gdm.wayland = true;  # Explicitly prefer Wayland (default)
  # GNOME desktop environment (runs on Wayland by default)
  services.xserver.desktopManager.gnome.enable = true;
  # Required for GNOME settings/extensions to persist
  programs.dconf.enable = true;

#############
### FONTS ###
#############
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    noto-fonts
    noto-fonts-color-emoji
  ];

#############
### AUDIO ###
#############
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  system.stateVersion = "25.11";
}
