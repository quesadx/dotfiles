{ pkgs, shared, ... }:
{
  networking.hostName = "macbook-air";

  system.primaryUser = shared.username;
  system.stateVersion = 5;

  users.users.${shared.username} = {
    home = "/Users/${shared.username}";
    description = shared.userDescription;
    shell = pkgs.zsh;
  };
}
