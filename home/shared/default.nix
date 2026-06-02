{ pkgs, ... }:
let
  commonShellAliases = {
    ll = "ls -l";
    ls = "ls -a";
    gs = "git status";
    ga = "git add .";
    gc = "git commit -m";
    gp = "git push";
    dcu = "docker compose up";
    dcud = "docker compose up -d";
    dcd = "docker compose down";
    dcdv = "docker compose down -v";
    dotfiles = "cd ~/dotfiles";
  };
in
{
  programs.home-manager.enable = true;

  home = {
    stateVersion = "26.05";
    sessionVariables = {
      SHELL = "${pkgs.zsh}/bin/zsh";
    };
    packages = with pkgs; [
      fastfetch
      ghostty-bin
    ];
  };

  services.ssh-agent.enable = false;

  programs.starship.enable = true;

  programs.zsh = {
    enable = true;
    shellAliases = commonShellAliases;
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
    settings."*".addKeysToAgent = "yes";
  };

  programs.zed-editor = {
    enable = true;
    enableMcpIntegration = true;
    userSettings = {
      auto_save = "on_focus_change";
      theme = {
        mode = "system";
        light = "Zedokai Light";
        dark = "Zedokai Dark";
      };
    };
    extensions = [
      "github-copilot-cli"
      "claude-acp"
      "gemini"
      "qwen-code"
      "java"
      "dockerfile"
      "sql"
      "nix"
      "prisma"
      "docker-compose"
      "opencode"
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