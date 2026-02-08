{ config, pkgs, ... }:

let
  userName = "quesadx";
  userDescription = "Matteo Quesada";
  userGroups = [ "networkmanager" "wheel" "video" "render" "audio" "scanner" "lp" "docker" "kvm" "libvirtd" ];

  timeZone = "America/Costa_Rica";
  locale = "en_US.UTF-8";
  regionalLocale = "es_CR.UTF-8";

  corePackages = with pkgs; [
    vim wget git curl qemu_full virtio-win virt-manager
    kdePackages.discover kdePackages.kcalc kdePackages.kcharselect kdePackages.kclock kdePackages.kcolorchooser
    kdePackages.kolourpaint kdePackages.ksystemlog kdePackages.sddm-kcm kdiff3 kdePackages.isoimagewriter kdePackages.partitionmanager
    hardinfo2 wayland-utils wl-clipboard
  ];

  systemFonts = with pkgs; [ nerd-fonts.jetbrains-mono noto-fonts noto-fonts-color-emoji jetbrains-mono font-awesome ];

in {
  imports = [ ./hardware-configuration.nix ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;
  networking.firewall.enable = true;

  users.users.${userName} = { isNormalUser = true; description = userDescription; extraGroups = userGroups; };

  time.timeZone = timeZone;
  i18n = { defaultLocale = locale; extraLocaleSettings = {
    LC_ADDRESS = regionalLocale; LC_IDENTIFICATION = regionalLocale; LC_MEASUREMENT = regionalLocale; LC_MONETARY = regionalLocale;
    LC_NAME = regionalLocale; LC_NUMERIC = regionalLocale; LC_PAPER = regionalLocale; LC_TELEPHONE = regionalLocale; LC_TIME = regionalLocale; }; };

  services.pipewire = { enable = true; alsa.enable = true; alsa.support32Bit = true; pulse.enable = true; wireplumber.enable = true; };

  hardware.bluetooth = { enable = true; powerOnBoot = true; };
  hardware.graphics.enable = true;

  virtualisation = { docker.enable = true; libvirtd.enable = true; };

  services = {
    power-profiles-daemon.enable = true;
    openssh.enable = true;
    flatpak.enable = true;
    desktopManager.plasma6.enable = true;
    displayManager.sddm.enable = true;
    displayManager.sddm.wayland.enable = true;
  };
  security.polkit.enable = true;

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [ stdenv.cc.cc.lib zlib ];

  environment.systemPackages = corePackages;

  nix.settings = { experimental-features = [ "nix-command" "flakes" ]; auto-optimise-store = true; };
  nix.gc = { automatic = true; dates = "weekly"; options = "--delete-older-than 7d"; };
  nixpkgs.config.allowUnfree = true;

  environment.plasma6.excludePackages = with pkgs; [ kdePackages.elisa kdePackages.kdepim-runtime kdePackages.kmahjongg kdePackages.kmines kdePackages.konversation kdePackages.kpat kdePackages.ksudoku kdePackages.ktorrent mpv ];

  fonts.packages = systemFonts;
  system.stateVersion = "25.11";
  security.sudo.wheelNeedsPassword = false;
}
