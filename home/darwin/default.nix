{ shared, ... }:
{
  imports = [
    ../shared/default.nix
  ];

  home = {
    username = shared.username;
    homeDirectory = "/Users/${shared.username}";
  };
}