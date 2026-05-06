{
  config,
  pkgs,
  shared,
  host,
  ...
}:

# ============================================================================
# VARIABLES - Centralized configuration values for easy maintenance
# ============================================================================

let
  inherit (shared)
    username
    userDescription
    timeZone
    locale
    regionalLocale;

  # ─── USER GROUPS ──────────────────────────────────────────────────────────
  userGroups = [
    "networkmanager" # Networking
    "wheel" # Sudo access
    "video"
    "render" # GPU access
    "audio" # Audio access
    "docker"
    "kvm" # Virtualization
    "dialout"
    "libvirtd"
  ];

  isLaptop = host.flakeTarget == "thinkpad" || host.flakeTarget == "macbook-pro";
  isThinkpad = host.flakeTarget == "thinkpad";

  # ─── CORE PACKAGES ────────────────────────────────────────────────────────
  corePackages = with pkgs; [
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
    libsecret # For GNOME Keyring integration
    dnsmasq
    file-roller
    unzip
    unrar
    p7zip
  ];

  # ─── SYSTEM FONTS ────────────────────────────────────────────────────────
  systemFonts = with pkgs; [
    ibm-plex # Professional sans-serif
    noto-fonts
    noto-fonts-color-emoji # Unicode coverage
    font-awesome # Icon font
    nerd-fonts.jetbrains-mono # Monospace with ligatures
  ];

in

# ─── SYSTEM CONFIGURATION ────────────────────────────────────────────────
{
  imports = [
    host.hardwareConfig
    ./modules/system/desktop-gnome.nix
    ./modules/system/macbook-pro-cirrus-audio.nix
  ];

  # ─── BOOT & KERNEL ────────────────────────────────────────────────────────
  boot.kernelPackages = pkgs.linuxPackages_zen;

  boot.loader.systemd-boot.enable = true;
  boot.loader.timeout = 4;
  boot.loader.efi.canTouchEfiVariables = true;

  # ─── MEMORY & SWAP ────────────────────────────────────────────────────────
  zramSwap.enable = true;
  zramSwap.memoryPercent = 25; # Use 25% of RAM for swap
  zramSwap.algorithm = "lz4";
  systemd.oomd.enable = true;

  # ─── NETWORKING ───────────────────────────────────────────────────────────
  networking = {
    hostName = host.hostname;
    networkmanager.enable = true;
  };

  systemd.services.NetworkManager-wait-online.enable = false;

  # Firewall configuration
  networking.firewall.enable = true;
  networking.firewall.trustedInterfaces = [ "virbr0" ]; # KVM bridge
  networking.firewall.allowedTCPPorts = [ 24800 ]; # Synergy port

  # ─── USERS & GROUPS ───────────────────────────────────────────────────────
  users.users.${username} = {
    isNormalUser = true;
    description = userDescription;
    extraGroups = userGroups;
  };

  # ─── LOCALIZATION ────────────────────────────────────────────────────────
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

  # ─── HARDWARE ─────────────────────────────────────────────────────────────
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = if isLaptop then false else true;
  hardware.graphics.enable = true;

  # ─── VIRTUALIZATION ───────────────────────────────────────────────────────
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

  # ─── SECURITY ────────────────────────────────────────────────────────────
  security.polkit.enable = true;
  security.rtkit.enable = true;
  security.sudo.wheelNeedsPassword = false;

  # ─── POWER SERVICES ──────────────────────────────────────────────────────
  # Enable power-profiles-daemon on non-MacBook systems.
  # MacBook uses TLP for better performance control.
  services.power-profiles-daemon.enable = host.flakeTarget != "macbook-pro";

  # ─── CORE SERVICES ───────────────────────────────────────────────────────
  # Firmware updates: disable for cleaner boot, uncomment if needed
  # services.fwupd.enable = true;

  services.flatpak.enable = true;
  services.openssh.enable = false;
  services.gnome.gnome-keyring.enable = true;

  # LLM inference service: disable by default to reduce overhead
  # Enable with: sudo nixos-rebuild switch --flake .#<host> && systemctl start ollama
  # services.ollama.enable = true;

  # ─── AUDIO (PipeWire) ─────────────────────────────────────────────────────
  services.pipewire.enable = true;
  services.pipewire.alsa.enable = true;
  services.pipewire.alsa.support32Bit = true;
  services.pipewire.pulse.enable = true;
  services.pipewire.wireplumber.enable = true;

  # ─── HARDWARE-SPECIFIC UDEV RULES ───────────────────────────────────────

  # ─── ENVIRONMENT ────────────────────────────────────────────────────────
  environment.systemPackages = corePackages;
  nixpkgs.config.allowUnfree = true;

  # ─── NIX SETTINGS ────────────────────────────────────────────────────────
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nix.optimise.automatic = true;
  nix.optimise.dates = [ "03:45" ];
  nix.gc.automatic = true; # Automatic garbage collection
  nix.gc.dates = "weekly";
  nix.gc.options = "--delete-older-than 30d";

  nixpkgs.config.permittedInsecurePackages = [
    "openclaw-2026.4.11"
  ];

  # ---------- SYSTEM ----------
  fonts.packages = systemFonts; # Install system fonts
  system.stateVersion = "26.05"; # NixOS version (don't change lightly)

}
