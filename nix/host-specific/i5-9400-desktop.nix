{ pkgs, ... }:

{
  boot.kernelParams = [
    "mitigations=off"
    "nowatchdog"
    "split_lock_detect=off"
    "transparent_hugepage=madvise"
  ];

  boot.kernel.sysctl."vm.max_map_count" = 2147483642;

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
    mangohud
    protonup-qt
    goverlay
    vkbasalt
    gamescope
    gpu-screen-recorder-gtk
    fuse3
    nss
    nspr
  ];

  programs.steam = {
    enable = true;

    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
  };

  services.lact.enable = true;
  programs.gamemode.enable = true;

  # sunshine --creds sunshine somepassword
  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true;
    openFirewall = true;
  };
}
