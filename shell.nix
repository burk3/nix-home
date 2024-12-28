{
  config,
  pkgs,
  lib,
  ...
}:
{
  home.packages = with pkgs; [
    zsh-completions
  ];

  programs.bash.enable = true;

  programs.zsh = {
    enable = true;
    history.size = 10000;
    enableCompletion = true;
    autosuggestion = {
      enable = true;
      strategy = [
        "completion"
        "match_prev_cmd"
      ];
    };
    # oh-my-zsh = {
    #   enable = true;
    #   plugins = [ "git" ];
    # };
    # {{{ zsh.plugins
    plugins = [
      # {
      #   name = "pure";
      #   src = pkgs.fetchFromGitHub {
      #     owner = "sindresorhus";
      #     repo = "pure";
      #     rev = "v1.23.0";
      #     sha256 = "sha256-BmQO4xqd/3QnpLUitD2obVxL0UulpboT8jGNEh4ri8k=";
      #   };
      # }
    ];
    # }}} zsh.plugins
  };

  programs.starship = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    settings = {
      add_newline = true;
      format = lib.concatStrings [
        "$username"
        "$hostname"
        "$nix_shell"
        "$directory"
        "$git_branch"
        "$git_state"
        "$git_status"
        "$cmd_duration"
        "$line_break"
        "$python"
        "$rust"
        "$character"
      ];
      character = {
        error_symbol = "[❯](red)";
        success_symbol = "[❯](purple)";
        vimcmd_symbol = "[❮](green)";
      };
      cmd_duration = {
        format = "[$duration]($style) ";
        style = "yellow";
      };
      directory = {
        style = "blue";
      };
      git_state = {
        format = "\\([$state( $progress_current/$progress_total)]($style)\\) ";
        style = "bright-black";
      };
      python = {
        format = "[$virtualenv]($style) ";
      };
      rust = {
        format = "[$symbol($version )]($style)";
      };
    };
  };
}
