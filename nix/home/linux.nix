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
    nrt = "cd ~/dotfiles/nix && sudo nixos-rebuild test --flake .#${host.flakeTarget}";
    nrs = "cd ~/dotfiles/nix && git add . && sudo nixos-rebuild switch --flake .#${host.flakeTarget}";
  };
in
{
  imports = [
    ./shared.nix
  ];

  home = {
    username = shared.username;
    homeDirectory = "/home/${shared.username}";
    packages = with pkgs; [
      adwaita-icon-theme
      glib
      gtk3
      onlyoffice-desktopeditors
      dconf-editor
      wl-clipboard
      xournalpp
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
