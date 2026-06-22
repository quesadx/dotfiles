{ pkgs, ... }: {
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    elisa
    gwenview
    khelpcenter
    konqueror
  ];

  security.pam.services.sddm = {
    enableKwallet = true;
    enableGnomeKeyring = true;
  };
}
