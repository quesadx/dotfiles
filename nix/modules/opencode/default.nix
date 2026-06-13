{ pkgs, ... }:

{
  programs.opencode = {
    enable = true;
    package = pkgs.opencode;

    extraPackages = with pkgs; [
      git
      ripgrep
      fd
      jq
      nodejs
      pnpm
      uv
      gsd
    ];

    context = ''
      # Host Context

      This machine uses NixOS with Home Manager.

      When a command is missing, use:
      - `nix shell nixpkgs#package`
      - `nix-shell -p package`

      Prefer declarative Nix/Home Manager changes over global npm, pip, curl, or manual binary installs.
    '';

    skills = if builtins.pathExists ./skills then ./skills else { };
  };
}
