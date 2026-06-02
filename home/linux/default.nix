{
  lib,
  pkgs,
  host,
  shared,
  ...
}:
let
  shellAliases = {
    ls = lib.mkForce "ls -a --color=auto";
    nrt = "cd ~/linux-dotfiles/nixos && sudo nixos-rebuild test --flake .#${host.flakeTarget}";
    nrs = "cd ~/linux-dotfiles && git add . && cd nixos && sudo nixos-rebuild switch --flake .#${host.flakeTarget}";
  };
in
{
  imports = [
    ../shared/default.nix
    ../../modules/home/gnome.nix
  ];

  home = {
    username = shared.username;
    homeDirectory = "/home/${shared.username}";
    packages = with pkgs; [
      gnome-tweaks
      gnome-software
      gnome-music
      gnome-calendar
      gnome-calculator
      gnome-text-editor
      gnome-console
      gnome-font-viewer
      showtime
      nautilus
      papers
      loupe
      adwaita-icon-theme
      glib
      gtk3
      onlyoffice-desktopeditors
      dconf-editor
      wl-clipboard
      xournalpp
      rnote
    ];
  };

  programs.chromium = {
    enable = true;
    extensions = [
      { id = "ddkjiahejlhfcafbddmgiahcphecmpfh"; }
      { id = "nngceckbapebfimnlniiiahkandclblb"; }
    ];
  };

  programs.git.settings.credential.helper = "libsecret";

  programs.zsh.shellAliases = shellAliases;
  programs.bash.shellAliases = shellAliases;
}
