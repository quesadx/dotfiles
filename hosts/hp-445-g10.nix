{
  config,
  lib,
  modulesPath,
  ...
}:

{
  imports = [
    ../modules/desktop.nix
    ../modules/development.nix
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  networking.hostName = "hp-445-g10";

  # --- Hardware ---
  boot.initrd.availableKernelModules = [
    "xhci_pci_renesas"
    "nvme"
    "xhci_pci"
    "usb_storage"
    "sd_mod"
  ];

  boot.kernelModules = [ "kvm-amd" ];

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
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  # --- Laptop ---
  hardware.bluetooth.powerOnBoot = true;

  services = {
    fstrim.enable = true;
    libinput.enable = true;
    power-profiles-daemon.enable = true;
  };
}
