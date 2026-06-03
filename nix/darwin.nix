{ pkgs, shared, ... }:
{
  imports = [
    ./nix-daemon.nix
  ];

  nix = {
    enable = true;
    settings.trusted-users = [
      "root"
      shared.username
    ];
  };

  homebrew = {
    enable = true;
    brews = [ ];
    casks = [ ];
  };

  environment.systemPackages = with pkgs; [
    git
    fd
    jq
    wget
    curl
  ];
}
