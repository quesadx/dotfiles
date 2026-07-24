{
  shared,
  pkgs,
  host,
  ...
}:
let
  shellAliases = {
    rebuild-test = "cd ~/dotfiles/nix && sudo darwin-rebuild test --flake .#${host.flakeTarget}";
    rebuild = "cd ~/dotfiles/nix && git add . && sudo darwin-rebuild switch --flake .#${host.flakeTarget}";
  };
in
{
  imports = [
    ./shared.nix
  ];

  home = {
    username = shared.username;
    homeDirectory = "/Users/${shared.username}";
    packages = with pkgs; [
    ];
  };

  programs.zsh.shellAliases = shellAliases;
  programs.bash.shellAliases = shellAliases;
}
