{ pkgs, ... }:
let
  commonShellAliases = {
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
    init-flake = "cp ~/dotfiles/nix/templates/placeholder-flake.nix ./flake.nix && echo 'use flake' > .envrc";
  };
in
{
  imports = [
  ];

  programs.home-manager.enable = true;

  home = {
    stateVersion = "26.05";
    sessionVariables = {
      SHELL = "${pkgs.zsh}/bin/zsh";
    };
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
    ];
  };

  services.ssh-agent.enable = false;

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
    shellAliases = commonShellAliases;
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
    '';
  };

  programs.bash = {
    enable = true;
    shellAliases = commonShellAliases;
  };

  programs.git = {
    enable = true;
    package = pkgs.gitFull;
    settings.user = {
      name = "Matteo Quesada";
      email = "matteo.vargas.quesada@est.una.ac.cr";
    };
    settings = {
      init.defaultBranch = "main";
      pull.rebase = true;
    };
  };

  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    nix-direnv.enable = true;
  };

  programs.ssh = {
    enable = false;
    enableDefaultConfig = false;
  };

  programs.zed-editor = {
    enable = true;
    enableMcpIntegration = true;

    userSettings = {
      auto_save = "on_focus_change";
      project_panel = {
        flatten_directories = false;
      };
      theme = {
        mode = "system";
      };
    };
    extensions = [
      "java"
      "dockerfile"
      "sql"
      "nix"
      "prisma"
      "docker-compose"
      "ini"
      "pylsp"
      "xml"
      "zedokai"
      "codebook"
      "colored-zed-icons-theme"
    ];
    extraPackages = with pkgs; [
      nixd
      nil
    ];
  };

  programs.vscode = {
    enable = true;
    profiles.default = {
      extensions = with pkgs.vscode-extensions; [
        esbenp.prettier-vscode
        ecmel.vscode-html-css
        humao.rest-client
        vscjava.vscode-java-pack
        james-yu.latex-workshop
        bbenoist.nix
        ms-vscode.live-server
        christian-kohler.path-intellisense
        christian-kohler.npm-intellisense
        mikestead.dotenv
        formulahendry.auto-rename-tag
        formulahendry.auto-close-tag
        shardulm94.trailing-spaces
        prisma.prisma
        pkief.material-icon-theme
        rust-lang.rust-analyzer
        tauri-apps.tauri-vscode
      ];
      userSettings = {
        "workbench.activityBar.location" = "top";
        "workbench.sideBar.location" = "right";
        "workbench.iconTheme" = "material-icon-theme";
        "editor.minimap.enabled" = false;
        "window.commandCenter" = false;
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
        "files.autoSave" = "onFocusChange";
        "editor.linkedEditing" = true;
        "workbench.editor.scrollToSwitchTabs" = true;
        "workbench.editor.wrapTabs" = true;
        "explorer.confirmDelete" = false;
        "explorer.confirmDragAndDrop" = false;
        "workbench.startupEditor" = "none";
        "git.openRepositoryInParentFolders" = "always";
        "git.enableSmartCommit" = true;
        "git.autofetch" = true;
        "chat.viewSessions.orientation" = "stacked";
        "editor.fontFamily" = "'IBM Plex Mono', monospace";
        "sqldeveloper.telemetry.enabled" = false;
      };
    };
  };
}
