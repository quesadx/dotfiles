{
  pkgs,
  shared,
  host,
  inputs,
  ...
}:

let
  isLaptop = host.flakeTarget == "thinkpad-x13-gen2" || host.flakeTarget == "macbook-pro-2017";
in
{
  imports = [ ];

  # --- Nix ---
  nix = {
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
    optimise = {
      automatic = true;
      dates = [ "03:00" ];
    };
    gc = {
      automatic = false;
      options = "--delete-older-than 30d";
    };
  };

  # Trynna save my shit
  # services.usbmuxd.enable = true;

  nixpkgs.config.allowUnfree = true;

  # --- Home Manager ---
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;

    extraSpecialArgs = {
      inherit shared host inputs;
      inherit (inputs) plasma-manager;
    };

    backupFileExtension = "hm-backup";

    users.${shared.username} = {
      imports = [ ./home/linux.nix ] ++ (host.home or [ ]);
    };
  };

  # --- Boot ---
  boot = {
    kernelPackages = pkgs.linuxPackages_zen;
    loader.systemd-boot.enable = true;
    loader.timeout = 4;
    loader.efi.canTouchEfiVariables = true;
    plymouth.enable = true;
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
    tealdeer
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
      24800
    ];
  };

  # --- Virtualization ---
  virtualisation = {
    docker.enable = false;
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
    sudo.wheelNeedsPassword = false;
  };

  # --- Services ---
  services = {
    power-profiles-daemon.enable = host.flakeTarget != "macbook-pro-2017";
    gnome.gnome-keyring.enable = true;
    flatpak.enable = true;
    fwupd.enable = true;
    openssh.enable = false;
    dbus.implementation = "broker";
    irqbalance.enable = true;
  };

  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 30d --keep 5";
  };

  # --- systemd stuff ---
  systemd = {
    services.NetworkManager-wait-online.enable = false;
    oomd.enable = true;
    services.flatpak-add-flathub = {
      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      serviceConfig.Type = "oneshot";
      script = "${pkgs.flatpak}/bin/flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo";
    };
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
}
