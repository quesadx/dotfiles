{
  pkgs,
  host,
  shared,
  ...
}:

let
  shellAliases = {
    ll = "eza -la --icons --group-directories-first";
    l = "eza -1 --icons --group-directories-first";
    ls = "l";
    lh = "eza -lah --icons --group-directories-first";
    lt = "eza -la --icons --group-directories-first --tree --level=2";
    cat = "bat --paging=never --style=plain";
    grep = "rg";
    find = "fd";

    gs = "git status";
    ga = "git add .";
    gc = "git commit -m";
    gf = "git fetch";
    gp = "git push";

    dcu = "docker compose up";
    dcud = "docker compose up -d";
    dcub = "docker compose up --build";
    dcd = "docker compose down";
    dcdv = "docker compose down -v";

    dotfiles = "cd ~/dotfiles";
    rebuild-test = "cd ~/dotfiles && sudo nixos-rebuild test --flake .#${host}";
    rebuild = "cd ~/dotfiles && git add . && sudo nixos-rebuild switch --flake .#${host}";
  };
in
{
  programs.home-manager.enable = true;

  home = {
    username = shared.username;
    homeDirectory = "/home/${shared.username}";
    stateVersion = "26.05";

    sessionVariables.SHELL = "${pkgs.zsh}/bin/zsh";

    packages = with pkgs; [
      fastfetch
      zoxide
      fzf
      bat
      fd
      ripgrep
      eza
      tealdeer
      bottom

      podman
      docker-compose
    ];
  };

  programs.starship.enable = true;

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    defaultCommand = "fd --type f --hidden --follow --exclude .git";
    defaultOptions = [
      "--height 40%"
      "--layout=reverse"
      "--border"
    ];
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
  };

  programs.zsh = {
    enable = true;
    shellAliases = shellAliases;
    autocd = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    enableCompletion = true;

    history = {
      size = 100000;
      save = 100000;
      ignoreDups = true;
      ignoreSpace = true;
      share = true;
      expireDuplicatesFirst = true;
      extended = true;
    };

    historySubstringSearch = {
      enable = true;
      searchUpKey = [ "^[[A" ];
      searchDownKey = [ "^[[B" ];
    };

    initContent = ''
      bindkey '^[[1;5C' forward-word
      bindkey '^[[1;5D' backward-word
      bindkey '^[[3~' delete-char
      bindkey '^H' backward-kill-word
      bindkey '^P' up-line-or-history
      bindkey '^N' down-line-or-history
      ssh-cloudflared() { ssh -o ProxyCommand="cloudflared access ssh --hostname %h" "$@"; }
    '';
  };

  programs.bash = {
    enable = true;
    shellAliases = shellAliases;
  };

  programs.git = {
    enable = true;
    package = pkgs.gitFull;
    settings = {
      user = {
        name = "Matteo Quesada";
        email = "matteo.vargas.quesada@est.una.ac.cr";
      };
      init.defaultBranch = "main";
      pull.rebase = true;
      credential.helper = "libsecret";
    };
  };

  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    nix-direnv.enable = true;
  };
}
