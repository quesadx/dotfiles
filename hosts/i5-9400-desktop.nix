{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:

{
  imports = [
    ../modules/desktop.nix
    ../modules/development.nix
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  networking.hostName = "i5-9400-desktop";

  # --- Hardware ---
  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "ahci"
    "usbhid"
    "usb_storage"
    "sd_mod"
  ];

  boot.kernelModules = [ "kvm-intel" ];

  fileSystems."/" = {
    device = "/dev/disk/by-label/NIXOS";
    fsType = "btrfs";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/BOOT";
    fsType = "vfat";
    options = [
      "fmask=0022"
      "dmask=0022"
    ];
  };

  swapDevices = [
    { device = "/dev/disk/by-label/SWAP"; }
  ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  # --- Desktop tuning ---
  boot.kernelParams = [
    "mitigations=off"
    "nowatchdog"
    "split_lock_detect=off"
    "transparent_hugepage=madvise"
  ];

  boot.kernel.sysctl."vm.max_map_count" = 2147483642;

  hardware = {
    bluetooth.powerOnBoot = true;
    graphics.enable32Bit = true;
  };

  services.power-profiles-daemon.enable = true;
  programs.fuse.userAllowOther = true;

  services.scx = {
    enable = true;
    scheduler = "scx_lavd";
  };

  services.ananicy = {
    enable = true;
    package = pkgs.ananicy-cpp;
    rulesProvider = pkgs.ananicy-rules-cachyos;
  };

  environment.systemPackages = with pkgs; [
    # Gaming
    mangohud
    protonup-qt
    goverlay
    vkbasalt
    gamescope
    gpu-screen-recorder-gtk
    steam-run
    appimage-run
    fuse3
    nss
    nspr
    file-roller
  ];

  programs.steam = {
    enable = true;
    extraCompatPackages = with pkgs; [ proton-ge-bin ];
  };

  services.lact.enable = true;
  programs.gamemode.enable = true;

  # --- Remote streaming (disabled for now) ---
  services.sunshine.enable = false;
}
