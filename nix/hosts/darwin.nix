{ pkgs, shared, host, ... }:
{
  networking.hostName = host.hostname;

  system.primaryUser = shared.username;
  system.stateVersion = 6;

  users.users.${shared.username} = {
    home = "/Users/${shared.username}";
    description = shared.userDescription;
    shell = pkgs.zsh;
  };
}
