{
  shared,
  lib,
  host,
  ...
}:
let
  shellAliases = {
    ls = lib.mkForce "ls -a -G";
    nrt = "cd ~/dotfiles/nix && sudo darwin-rebuild test --flake .#${host.flakeTarget}";
    nrs = "cd ~/dotfiles/nix && git add . && sudo darwin-rebuild switch --flake .#${host.flakeTarget}";
  };
in
{
  imports = [
    ./shared.nix
  ];

  home = {
    username = shared.username;
    homeDirectory = "/Users/${shared.username}";
  };

  programs.zsh.shellAliases = shellAliases;
  programs.bash.shellAliases = shellAliases;
}
