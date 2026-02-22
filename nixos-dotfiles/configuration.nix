{ config, pkgs, ... }:

let
  userName = "quesadx";
  userDescription = "Matteo Quesada";
  timeZone = "America/Costa_Rica";
  locale = "en_US.UTF-8";
  regionalLocale = "es_CR.UTF-8";
  userGroups = [
    "networkmanager" "wheel" "video" "render" "audio" "scanner" "docker" "kvm" "libvirtd"
  ];

  corePackages = with pkgs; [
    vim
    wget
    git
    curl
    qemu_full               
    virtio-win              
    virt-manager            
  ];

  gnomeExtensions = with pkgs.gnomeExtensions; [
    alphabetical-app-grid
    auto-accent-colour
    caffeine
    coverflow-alt-tab
    clipboard-history
    grand-theft-focus
    hide-top-bar
    impatience
    luminus-desktop
    top-bar-organizer
    appindicator
  ];

  systemFonts = with pkgs; [
    nerd-fonts.jetbrains-mono   
    noto-fonts
    noto-fonts-color-emoji
    jetbrains-mono
    font-awesome                 
  ];

in {
  imports = [ ./hardware-configuration.nix ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
    firewall = {
      enable = true;
      allowedTCPPorts = [ 24800 ]; # 24800 -> input-leap
    };
  };

  users.users.${userName} = {
    isNormalUser = true; # (non-root)
    description = userDescription;
    extraGroups = userGroups;
  };

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

  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
    graphics.enable = true;
  };

  virtualisation = {
    docker.enable = true;
    libvirtd.enable = true;
  };

  security = {
    polkit.enable = true;
    sudo.wheelNeedsPassword = false; 
  };

  services = {
    power-profiles-daemon.enable = true;

    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
    gnome.core-apps.enable = false;
    gnome.core-developer-tools.enable = false;
    gnome.games.enable = false;

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      wireplumber.enable = true;
    };

    flatpak.enable = true;
    openssh.enable = true;
  };

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc.lib
    zlib
  ];

  environment.systemPackages = corePackages ++ gnomeExtensions;
  environment.gnome.excludePackages = with pkgs; [ gnome-tour gnome-user-docs ];

  nixpkgs.config.allowUnfree = true;
  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 5d";
    };
  };

  fonts.packages = systemFonts;

  system.stateVersion = "25.11";

}
