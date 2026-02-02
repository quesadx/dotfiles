{ config, pkgs, ... }:

let
  ############################################################
  # USER ACCOUNT CONFIGURATION
  ############################################################
  userName = "quesadx";
  userDescription = "Matteo Quesada";
  # System groups for hardware access and privileges
  userGroups = [
    "networkmanager"  # Network management
    "wheel"           # sudo privileges
    "video"           # GPU access
    "render"          # Hardware rendering
    "audio"           # Audio devices
    "scanner"         # Scanner access
    "lp"              # Printing subsystem
    "docker"          # Docker container management
    "kvm"             # Kernel-based Virtual Machine
    "libvirtd"        # Libvirt virtualization daemon
  ];


  ############################################################
  # LOCALIZATION & REGIONAL SETTINGS
  ############################################################
  timeZone = "America/Costa_Rica";
  locale = "en_US.UTF-8";
  regionalLocale = "es_CR.UTF-8";


  ############################################################
  # SYSTEM PACKAGE SELECTION
  ############################################################
  corePackages = with pkgs; [
    vim                     # Text editor
    wget                    # Download utility
    git                     # Version control
    curl                    # Data transfer tool
    qemu_full               # Full QEMU virtualization suite
    virtio-win              # Windows virtio drivers for VMs
    virt-manager            # GUI for virtual machine management
    bluez                   # Bluetooth protocol stack
    pulsemixer              # CLI audio mixer for PipeWire/PulseAudio
    networkmanagerapplet    # System tray applet for NetworkManager
  ];


  ############################################################
  # FONT CONFIGURATION
  ############################################################
  systemFonts = with pkgs; [
    nerd-fonts.jetbrains-mono   # Programming font with glyphs/icons
    noto-fonts                  # Google's universal font family
    noto-fonts-color-emoji      # Color emoji support
    jetbrains-mono              # Official JetBrains Mono font
    font-awesome                # Icon font set
  ];

in {


  ############################################################
  # IMPORTS & HARDWARE DETECTION <><><><><>><><><><><><><><><>
  ############################################################
  imports = [ ./hardware-configuration.nix ];


  ############################################################
  # BOOTLOADER & SYSTEM INITIALIZATION
  ############################################################
  boot = {
    loader = {
      systemd-boot.enable = true;         # Use systemd-boot instead of GRUB
      efi.canTouchEfiVariables = true;    # Allow EFI variable modification
    };
  };


  ############################################################
  # NETWORKING CONFIGURATION
  ############################################################
  networking = {
    hostName = "nixos";                  # System hostname
    networkmanager.enable = true;        # Enable NetworkManager daemon
    firewall.enable = true;              # Uncomment to enable firewall
  };


  ############################################################
  # USER ACCOUNTS & AUTHENTICATION
  ############################################################
  users.users.${userName} = {
    isNormalUser = true;                 # Regular user (not root)
    description = userDescription;       # Full name/GECOS field
    extraGroups = userGroups;            # Hardware/peripheral access groups
  };


  ############################################################
  # LOCALIZATION & INTERNATIONALIZATION
  ############################################################
  time.timeZone = timeZone;

  
  i18n = {
    defaultLocale = locale;
    # Regional formatting for Costa Rica (dates, currency, measurements)
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


  ############################################################
  # INPUT DEVICES & KEYBOARD LAYOUT
  ############################################################
  services.xserver = {
    xkb = {
      layout = "us";                       # US English keyboard layout
      variant = "alt-intl";                # International variant
    };
  };


  ############################################################
  # DESKTOP ENVIRONMENT & DISPLAY SERVER
  ############################################################
  programs.hyprland = {
    enable = true;                       # Enable Hyprland compositor
    xwayland.enable = true;              # X11 compatibility layer for legacy apps
  };


  ############################################################
  # AUDIO & VIDEO SUBSYSTEMS
  ############################################################
  services.pipewire = {
    enable = true;                        # Modern audio/video server (replaces PulseAudio)
    alsa.enable = true;                   # ALSA compatibility
    alsa.support32Bit = true;             # 32-bit ALSA support (for Steam/gaming)
    pulse.enable = true;                  # PulseAudio compatibility layer
    wireplumber.enable = true;            # Session manager for PipeWire
  };


  ############################################################
  # HARDWARE SUPPORT
  ############################################################
  hardware = {
    # Bluetooth stack configuration
    bluetooth = {
      enable = true;
      powerOnBoot = true;                  # Auto-enable Bluetooth on boot
    };
    # Graphics drivers and acceleration
    graphics.enable = true;                # Enable OpenGL/Vulkan drivers
  };


  ############################################################
  # VIRTUALIZATION & CONTAINERIZATION
  ############################################################
  virtualisation = {
    docker.enable = true;                # Docker container runtime
    libvirtd.enable = true;              # Libvirt virtualization API
  };


  ############################################################
  # SYSTEM SERVICES
  ############################################################
  services = {
    # Power management profiles (performance/balanced/power-saver)
    power-profiles-daemon.enable = true;
    # SSH server for remote access
    openssh.enable = true;
    # Flatpak application support
    flatpak.enable = true;
  };
    # Polkit for privilege authorization dialogs
    security.polkit.enable = true;

  ############################################################
  # PACKAGE MANAGEMENT & SYSTEM PACKAGES
  ############################################################
  environment.systemPackages = corePackages;


  ############################################################
  # NIX PACKAGE MANAGER CONFIGURATION
  ############################################################
  nix = {
    # Enable modern Nix features
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;       # Automatic store optimization (disk space savings)
    };
    # Automatic garbage collection to reclaim disk space
    gc = {
      automatic = true;                    # Run GC automatically
      dates = "weekly";                    # Schedule: weekly
      options = "--delete-older-than 7d";  # Keep only last 7 days of old generations
    };
  };
  # Allow installation of unfree (proprietary) packages
  nixpkgs.config.allowUnfree = true;


  ############################################################
  # FONT RENDERING
  ############################################################
  fonts.packages = systemFonts;


  ############################################################
  # SYSTEM STATE VERSION (CRITICAL)
  ############################################################
  # WARNING: Changing this value can break your system!
  # Represents the NixOS version your configuration was initially created for.
  system.stateVersion = "25.11";


  ############################################################
  # SECURITY HARDENING (OPTIONAL ENHANCEMENTS)
  ############################################################
  # Consider adding these for improved security:
  #
  security.sudo.wheelNeedsPassword = false;  # Allow wheel group passwordless sudo
  
}