{ config, pkgs, ... }:

let
  # User Configuration
  userName = "quesadx";
  userDescription = "Matteo Quesada";
  userGroups = [ "networkmanager" "wheel" "video" "render" "audio" "scanner" "lp" ];

  # Locale Settings
  timeZone = "America/Costa_Rica";
  locale = "en_US.UTF-8";
  regionalLocale = "es_CR.UTF-8";

  # System Packages
  corePackages = with pkgs; [
    vim
    wget
    git
    curl
  ];

  # Font Packages
  systemFonts = with pkgs; [
    nerd-fonts.jetbrains-mono
    noto-fonts
    noto-fonts-color-emoji
    jetbrains-mono
    font-awesome
  ];

in {
  imports = [ ./hardware-configuration.nix ];

  # Boot Configuration
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  # Networking
  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
  };

  # Power Management
  services.power-profiles-daemon.enable = true;

  # Locale & Time
  time.timeZone = timeZone;
  i18n = {
    defaultLocale = locale;
    extraLocaleSettings = {
      LC_ADDRESS = regionalLocale;
      LC_IDENTIFICATION = regionalLocale;
      LC_MEASUREMENT = regionalLocale;
      LC_MONETARY = regionalLocale;
      LC_NAME = regionalLocale;
      LC_NUMERIC = regionalLocale;
      LC_PAPER = regionalLocale;
      LC_TELEPHONE = regionalLocale;
      LC_TIME = regionalLocale;
    };
  };

  # Keyboard Layout
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # User Account
  users.users.${userName} = {
    isNormalUser = true;
    description = userDescription;
    extraGroups = userGroups;
  };

  # System Packages
  environment.systemPackages = corePackages;

  # Hardware
  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
    graphics.enable = true;
  };

  # Nix Settings
  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  nixpkgs.config.allowUnfree = true;

  # Services
  services = {
    openssh.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
      wireplumber.enable = true;
    };
  };

  # Hyprland
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # Fonts
  fonts.packages = systemFonts;

  system.stateVersion = "25.11";
}
