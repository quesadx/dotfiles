{
  shared,
  lib,
  host,
  ...
}:
let
  shellAliases = {
    ls = lib.mkForce "ls -a --color=auto";
    nrt = "cd ~/dotfiles/nixos && sudo darwin-rebuild test --flake .#${host.flakeTarget}";
    nrs = "cd ~/dotfiles && git add . && cd nixos && sudo darwin-rebuild switch --flake .#${host.flakeTarget}";
  };
in
{
  imports = [
    ../shared/default.nix
  ];

  home = {
    username = shared.username;
    homeDirectory = "/Users/${shared.username}";
  };

  programs.zsh.shellAliases = shellAliases;
  programs.bash.shellAliases = shellAliases;
}
