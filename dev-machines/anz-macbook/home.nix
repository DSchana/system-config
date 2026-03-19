{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [ ../../dev-shared/home.nix ];

  home.homeDirectory = "/Users/dschana";

  home.packages = with pkgs; [
    nodejs
  ];

  # Disable nix vscode because it causes build issues on darwin
  programs.vscode.enable = lib.mkForce false;

  programs.ssh.matchBlocks."*".extraOptions."IdentityAgent" = lib.mkForce
    "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock";

  programs.tmux.extraConfig = lib.mkAfter ''
    # macOS clipboard
    unbind -T copy-mode-vi Enter
    bind-key -T copy-mode-vi Enter send-keys -X copy-pipe-and-cancel "pbcopy"
    bind-key -T copy-mode-vi MouseDragEnd1Pane send-keys -X copy-pipe-and-cancel "pbcopy"
  '';

  programs.zsh.shellAliases = {
    golint = "golangci-lint run";
    gotest = "go test -v --trimpath ./";
  };

  programs.zsh.sessionVariables = {
    GOPATH = "$HOME/go";
  };

  programs.zsh.envExtra = lib.mkAfter ''
    eval "$(/opt/homebrew/bin/brew shellenv)"
    export PATH="$HOME/go/bin:$PATH"
    export PATH="$HOME/bin:$PATH"
    export PATH="$GOPATH/bin:$PATH"

    # Google Cloud SDK
    if [ -f '/Users/dschana/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/dschana/google-cloud-sdk/path.zsh.inc'; fi
    if [ -f '/Users/dschana/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/dschana/google-cloud-sdk/completion.zsh.inc'; fi

    . "$HOME/.local/bin/env"

    # Work-specific aliases and env vars
    [ -f "$HOME/.work-env" ] && . "$HOME/.work-env"
  '';

  ### jujutsu ###
  programs.jujutsu.settings.user.email = lib.mkForce "dilpreet@anzenna.ai";
}
