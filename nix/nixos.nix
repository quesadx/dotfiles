{
  pkgs,
  shared,
  host,
  inputs,
  ...
}:

let
  isLaptop = host.flakeTarget == "thinkpad" || host.flakeTarget == "macbook-pro";
in
{
  imports = [ ];

  # --- Nix ---
  nix = {
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
    optimise.automatic = true;
    gc = {
      automatic = true;
      options = "--delete-older-than 30d";
    };
  };

  nixpkgs.config.allowUnfree = true;

  # --- Boot ---
  boot = {
    kernelPackages = pkgs.linuxPackages_zen;
    loader.systemd-boot.enable = true;
    loader.timeout = 0;
    loader.efi.canTouchEfiVariables = true;
  };

  # --- System state version ---
  system.stateVersion = "26.11";

  # --- Memory & Swap ---
  zramSwap = {
    enable = true;
    memoryPercent = 25;
    algorithm = "lz4";
  };

  # --- Hardware ---
  hardware = {
    bluetooth.enable = true;
    bluetooth.powerOnBoot = if isLaptop then false else true;
    graphics = {
      enable = true;
      enable32Bit = true;
    };
  };

  # --- User & Groups ---
  users.users.${shared.username} = {
    isNormalUser = true;
    description = shared.userDescription;
    extraGroups = [
      "networkmanager"
      "wheel"
      "video"
      "render"
      "audio"
      "docker"
      "kvm"
      "libvirtd"
      "dialout"
    ];
  };

  # --- System packages ---
  environment.systemPackages = with pkgs; [
    btop
    vim
    wget
    curl
    jq
    yq-go
    ripgrep
    fd
    tree
    pciutils
    usbutils
    steam-run
    appimage-run
    tldr
    libsecret
    dnsmasq
    file-roller
    unzip
    unrar
    p7zip
  ];

  programs.nix-ld = {
    enable = true;

    libraries = with pkgs; [
      stdenv.cc.cc
      gcc.cc.lib
      zlib
      openssl
    ];
  };

  # --- Networking ---
  networking = {
    hostName = host.hostname;
    networkmanager.enable = true;
    firewall.enable = true;
    firewall.allowedTCPPorts = [
      8080
      9999
    ];
  };

  # --- Virtualization ---
  virtualisation = {
    docker.enable = true;
    docker.daemon.settings = {
      bip = "192.168.30.1/24";
      "default-address-pools" = [
        {
          base = "10.10.0.0/16";
          size = 24;
        }
      ];
    };
  };

  # --- Security ---
  security = {
    polkit.enable = true;
    rtkit.enable = true;
    pam.services.login.enableGnomeKeyring = true;
  };

  # --- Services ---
  services = {
    power-profiles-daemon.enable = host.flakeTarget != "macbook-pro";
    gnome.gnome-keyring.enable = true;
    flatpak.enable = true;
    openssh.enable = false;
    dbus.implementation = "broker";
    irqbalance.enable = true;
  };

  # --- systemd stuff ---
  systemd = {
    services.NetworkManager-wait-online.enable = false;
    oomd.enable = true;
  };

  # --- User services ---
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  # --- Fonts ---
  fonts.packages = with pkgs; [
    ibm-plex

    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-color-emoji

    font-awesome
  ];

  # --- Locale ---
  time.timeZone = shared.timeZone;
  i18n = {
    defaultLocale = shared.locale;
    extraLocaleSettings = {
      LC_ADDRESS = shared.regionalLocale;
      LC_IDENTIFICATION = shared.regionalLocale;
      LC_MEASUREMENT = shared.regionalLocale;
      LC_MONETARY = shared.regionalLocale;
      LC_NAME = shared.regionalLocale;
      LC_NUMERIC = shared.regionalLocale;
      LC_PAPER = shared.regionalLocale;
      LC_TELEPHONE = shared.regionalLocale;
      LC_TIME = shared.regionalLocale;
    };
  };

  # --- Home Manager ---
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.extraSpecialArgs = { inherit shared host inputs; };
  home-manager.users.${shared.username} = {
    imports = [ ./home/linux.nix ] ++ (host.home or [ ]);
  };
}
