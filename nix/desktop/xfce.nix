{ pkgs, ... }:

{
  services.xserver = {
    enable = true;
    desktopManager = {
      xterm.enable = false;
      xfce.enable = true;
    };
  };
  services.displayManager.defaultSession = "xfce";

  # Required by home-manager's xfconf module
  programs.xfconf.enable = true;

  services.displayManager.lightdm = {
    enable = true;
    greeters.slick.enable = true;
  };

  environment.systemPackages = with pkgs; [
    xfce4-whiskermenu-plugin
    xfce4-terminal
    mousepad
    ristretto
    thunar
    thunar-archive-plugin
    thunar-volman
    pavucontrol
    networkmanagerapplet
    ghostty
  ];
}
