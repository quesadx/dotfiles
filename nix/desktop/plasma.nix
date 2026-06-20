{ pkgs, ... }: {
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    elisa
    gwenview
    okular
    oxygen
    khelpcenter
    konqueror
  ];

  # KDE Wallet — auto-unlock at SDDM login
  # Provides Secret Service API that libsecret uses for git credentials
  security.pam.services.sddm.enableKwallet = true;
}
