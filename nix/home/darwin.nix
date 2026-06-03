{
  shared,
  lib,
  host,
  ...
}:
let
  shellAliases = {
    ls = lib.mkForce "ls -a --color=auto";
    nrt = "cd ~/dotfiles && sudo darwin-rebuild test --flake .#${host.flakeTarget}";
    nrs = "cd ~/dotfiles && git add . && sudo darwin-rebuild switch --flake .#${host.flakeTarget}";
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
