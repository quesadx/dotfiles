{ pkgs, ... }: {
  programs.bash = {
    enable = true;
    shellAliases = {
      ll = "ls -l";
      update = "sudo nixos-rebuild switch --flake ~/nixos-config";
      conf = "cd ~/nixos-config && nvim home.nix";
    };
  };
}

