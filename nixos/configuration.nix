{
  pkgs,
  shared,
  host,
  ...
}:

let
  isLaptop = host.flakeTarget == "thinkpad" || host.flakeTarget == "macbook-pro";
in
{

  # --- Boot ---
  boot.kernelPackages = if isLaptop then pkgs.linuxPackages else pkgs.linuxPackages_zen;
  boot.loader.systemd-boot.enable = true;
  boot.loader.timeout = 0;
  boot.loader.efi.canTouchEfiVariables = true;

  # --- Memory & Swap ---
  zramSwap.enable = true;
  zramSwap.memoryPercent = 25;
  zramSwap.algorithm = "lz4";
  systemd.oomd.enable = true;

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
    tldr
    libsecret
    dnsmasq
    file-roller
    unzip
    unrar
    p7zip
  ];

  # --- Fonts ---
  fonts.packages = with pkgs; [
    ibm-plex
    noto-fonts
    noto-fonts-color-emoji
    font-awesome
  ];

  # --- Networking ---
  networking = {
    hostName = host.hostname;
    networkmanager.enable = true;
  };
  networking.firewall.enable = true;

  # --- User & Groups
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

  # --- Hardware ---
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = if isLaptop then false else true;
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # --- Virtualization ---
  virtualisation.docker.enable = true;
  virtualisation.docker.daemon.settings = {
    bip = "192.168.30.1/24";
    "default-address-pools" = [
      {
        base = "10.10.0.0/16";
        size = 24;
      }
    ];
  };
  # virtualisation.libvirtd.enable = true;
  # programs.virt-manager.enable = true;
  # [ Note ]: Gotta run these commands to set up libvirt default network:
  # sudo virsh net-start default
  # sudo virsh net-autostart default

  # --- Security ---
  security.polkit.enable = true;
  security.rtkit.enable = true;
  security.sudo.wheelNeedsPassword = false;

  services.power-profiles-daemon.enable = host.flakeTarget != "macbook-pro";

  services.gnome.gnome-keyring.enable = true;
  services.flatpak.enable = true;
  services.openssh.enable = false;

  services.dbus.implementation = "broker";
  services.irqbalance.enable = true;
  systemd.services.NetworkManager-wait-online.enable = false;

  services.pipewire.enable = true;
  services.pipewire.alsa.enable = true;
  services.pipewire.alsa.support32Bit = true;
  services.pipewire.pulse.enable = true;
  services.pipewire.wireplumber.enable = true;

  # --- Nix & nixpkgs ---
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nix.optimise.automatic = true;
  nix.optimise.dates = [ "03:45" ];
  nix.gc.automatic = true;
  nix.gc.dates = "weekly";
  nix.gc.options = "--delete-older-than 30d";
  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "26.05";
}
