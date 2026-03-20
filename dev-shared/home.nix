{ config, lib, pkgs, ... }:

{
  home.username = "dschana";
  home.homeDirectory = lib.mkDefault "/home/dschana";

  home.stateVersion = "25.11";

  home.packages = with pkgs; [
    (btop.override { cudaSupport = true; })
    cargo
    claude-code
    clippy
    cmake
    gcc
    gh
    git
    gnumake
    go
    gopls
    golangci-lint
    neovim
    pgcli
    postgresql
    protobuf
    protoc-gen-go
    protoc-gen-go-grpc
    rustc
    rustfmt
    rust-analyzer
    vim
    wget
  ];

  ### zsh ###
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;

    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [
        "git"
      ];
    };

    shellAliases = {
      vim = "nvim";
    };

    sessionVariables = {
      DISABLE_AUTO_TITLE = "true";
      CASE_SENSITIVE = "true";
      DISABLE_TELEMETRY = "true";
      DISABLE_ERROR_REPORTING = "true";
      DISABLE_BUG_COMMAND = "true";
    };

    envExtra = ''
      export NVM_DIR="$HOME/.nvm"
      [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
      [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
      export PATH="$HOME/.local/bin:$PATH"
      export PATH="$PATH:/usr/local/go/bin"
    '';

  };

  ### ssh config ###
  programs.ssh = {                                                                                                                                    
    enable = true;
    enableDefaultConfig = false;                                                                                                                      
    matchBlocks = {                                                                                                                                 
      "*" = {
        extraOptions = {
          "IdentityAgent" = "~/.1password/agent.sock";
        };
      };
    };
  };

  ### starship ###
  programs.starship = {
    enable = true;
    settings = {
      format = "$username$hostname$directory\${custom.jj}$cmd_duration$status$line_break$conda$character";
      command_timeout = 1000;
      hostname.ssh_symbol = "";
      directory = {
        read_only = " ro";
        style = "blue";
      };
      custom.jj = {
        when = "jj-starship detect";
        shell = [ "jj-starship" ];
        format = "$output ";
      };
      git_branch.disabled = true;
      git_state.disabled = true;
      git_status.disabled = true;
      cmd_duration = {
        format = "[$duration]($style) ";
        style = "yellow";
      };
      status = {
        style = "red";
        symbol = "↵ ";
        disabled = false;
      };
      character = {
        success_symbol = "[>](bold purple)";
        error_symbol = "[>](bold red)";
      };
      python = {
        symbol = "py ";
        python_binary = [
          "./venv/bin/python"
          "python"
          "python3"
          "python2"
        ];
      };
    };
  };

  ### tmux ###
  programs.tmux = {
    enable = true;
    mouse = true;
    keyMode = "vi";
    plugins = with pkgs.tmuxPlugins; [
      sensible
      resurrect
    ];
    extraConfig = ''
      # Style status bar
      set -g status-style fg=white,bg=black
      set -g window-status-current-style fg=green,bg=black
      set -g pane-active-border-style fg=green,bg=black
      set -g window-status-format " #I:#W#F "
      set -g window-status-current-format " #I:#W#F "
      set -g window-status-current-style bg=green,fg=black
      set -g window-status-activity-style bg=black,fg=yellow
      set -g window-status-separator ""
      set -g status-justify centre

      # Mouse scrolling
      bind -n WheelUpPane if-shell -F -t = "#{mouse_any_flag}" "send-keys -M" "if -Ft= '#{pane_in_mode}' 'send-keys -M' 'select-pane -t=; copy-mode -e; send-keys -M'"
      bind -n WheelDownPane select-pane -t= \; send-keys -M
      bind -n C-WheelUpPane select-pane -t= \; copy-mode -e \; send-keys -M
      bind -T copy-mode-vi    C-WheelUpPane   send-keys -X halfpage-up
      bind -T copy-mode-vi    C-WheelDownPane send-keys -X halfpage-down
      bind -T copy-mode-emacs C-WheelUpPane   send-keys -X halfpage-up
      bind -T copy-mode-emacs C-WheelDownPane send-keys -X halfpage-down

      # Copy mode bindings
      unbind -T copy-mode-vi Enter
      bind-key -T copy-mode-vi Enter send-keys -X copy-pipe-and-cancel "wl-copy"
      bind-key -T copy-mode-vi MouseDragEnd1Pane send-keys -X copy-pipe-and-cancel "wl-copy"
    '';
  };

  ### jujutsu ###
  programs.jujutsu = {
    enable = true;
    settings = {
      user = {
        name = "Dilpreet";
        email = "dschana6@pm.me";
      };
      ui = {
        editor = "nvim";
      };
    };
  };

  ### vscodium ###
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    profiles.default.extensions = with pkgs.vscode-extensions; [
      jnoortheen.nix-ide
      vscodevim.vim
      visualjj.visualjj
    ];
  };

  programs.home-manager.enable = true;
}
