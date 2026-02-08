{ config, pkgs, lib, ... }:

let
  username = "quesadx";
  homeDir = "/home/quesadx";

  gitUser = { name = "Matteo Quesada"; email = "matteo.vargas.quesada@est.una.ac.cr"; };

  firefoxExtensions = {
    "uBlock0@raymondhill.net" = {
      install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
      installation_mode = "force_installed";
    };
    "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
      install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
      installation_mode = "force_installed";
    };
  };

  userPackages = with pkgs; [
    fastfetch adwaita-icon-theme
    nautilus file-roller unzip unrar p7zip
    papers onlyoffice-desktopeditors
    google-chrome obsidian github-copilot-cli thunderbird spotify
    vscode jetbrains.clion
    direnv nix-direnv
  ];

  bashAliases = {
    ll = "ls -l"; gs = "git status"; ga = "git add ."; gc = "git commit -m"; gp = "git push";
    nrt = "cd ~/dotfiles/nixos-dotfiles && sudo nixos-rebuild test --flake .#nixos";
    nrs = "cd ~/dotfiles && git add . && cd nixos-dotfiles && sudo nixos-rebuild switch --flake .#nixos";
  };

  configSources = {
    "fastfetch".source = ../.config/fastfetch;
  };

in {
  home = {
    username = username;
    homeDirectory = homeDir;
    stateVersion = "26.05";
    packages = userPackages;
  };

  xdg.configFile = configSources;

  programs = {
    home-manager.enable = true;

    bash = {
      enable = true;
      shellAliases = bashAliases;
    };

    git = {
      enable = true;
      settings = {
        user = gitUser;
        init.defaultBranch = "main";
        pull.rebase = true;
      };
    };

    direnv = {
      enable = true;
      enableBashIntegration = true;
      nix-direnv.enable = true;
    };

    ssh = {
      enable = true;
      enableDefaultConfig = false;
      matchBlocks."*" = {
        addKeysToAgent = "yes";
      };
    };

    firefox = {
      enable = true;
      profiles.${username} = {
        isDefault = true;
        settings = {
          "browser.search.region" = "CR";
          "browser.search.isUS" = false;
          "distribution.id" = "nixos";
        };
      };
      policies.ExtensionSettings = firefoxExtensions;
    };

    # java = {
      # enable = true;
      # package = pkgs.jdk21.override {
        # enableJavaFX = true;
      # };
    # };
  };

  services.ssh-agent.enable = true;
  programs.starship.enable = true;
  programs.zsh.enable = true;

}
