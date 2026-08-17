{
  pkgs,
  lib,
  host,
  ...
}:
let
  shellAliases = {
    rebuild-test = "cd ~/dotfiles/nix && home-manager build --flake .#${host.flakeTarget}";
    rebuild = "cd ~/dotfiles/nix && git add . && home-manager switch --flake .#${host.flakeTarget}";
  };
in
{
  # --- Standalone home-manager on Fedora Asahi (no NixOS/nix-darwin module) ---
  # ./home/linux.nix is imported by the flake, so only host overrides live here.

  # --- Rebuild aliases: override the NixOS ones from home/linux.nix ---
  programs.zsh.shellAliases = lib.mapAttrs (name: value: lib.mkForce value) shellAliases;
  programs.bash.shellAliases = lib.mapAttrs (name: value: lib.mkForce value) shellAliases;

  # --- Host-specific packages ---
  home.packages = with pkgs; [
    # M1 Pro / Asahi specific packages here
  ];
}
