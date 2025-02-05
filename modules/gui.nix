{ pkgs, lib, config, ... }:
{
  nixpkgs.config.allowUnfree = true;
  home.packages = with pkgs; [
    vscode.fhs
    bitwarden-desktop
    yacreader
    legcord
    spotify
    playerctl
    iosevka
    pinta
    inkscape
    remmina
    brogue-ce
  ];

  programs.imv.enable = true;
  programs.mpv.enable = true;
  programs.zathura.enable = true;

  programs.ghostty = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    settings = {
      window-decoration = false;
      cursor-style = "block";
      font-family = [
        "Berkeley Mono"
        "Iosevka"
      ];
      font-size = 8;
      # Potentially good light themes; (bws) means black and white are swapped in numbered colors
      # - Material
      # - iceberg-light (bws)
      # - nord-light - not enough contrast
      # - ayu_light - very bright, maybe not enough contrast
      # - catppuccin-latte - very grey black and whites might be good
      # - NvimLight
      # - rose-pine-dawn (bws)
      # - seoulbones_light (bws)
      #theme = "light:ayu_light,dark:nord";
      theme = "light:catppuccin-latte,dark:catppuccin-${config.catppuccin.flavor}";
    };
  };

  programs.zed-editor = {
      enable = true;
      extensions = [
        "nix"
        "toml"
        "make"
        "git-firefly"
        "dockerfile"
        "terraform"
        "docker-compose"
      ];
      userSettings = {
        assistant = {
          enabled = true;
          version = "2";
          default_model = {
            provider = "zed.dev";
            model = "claude-3-5-sonnet-latest";
          };
          inline_alternatives = [
            {
              provider = "copilot_chat";
              model = "gpt-4o";
            }
          ];
        };
        node = {
          path = lib.getExe pkgs.nodejs;
          npm_path = lib.getExe' pkgs.nodejs "npm";
        };

        hour_format = "hour24";
        auto_update = false;
        terminal = {
          alternate_scroll = "off";
          blinking = "off";
          dock = "bottom";
          env = {
            TERM = "alacritty";
            EDITOR = "${lib.getExe pkgs.zed-editor} --wait";
          };
          font_family = "Berkeley Mono";
          font_featues = null;
          line_height = "comfortable";
          button = false;
          shell = "system";
          toolbar.title = true;
          working_directory = "current_project_directory";
        };
        lsp = {
          rust-analyzer.binary.path_lookup = true;
          nix.binary.path_lookup = true;
          gopls.binary.path_lookup = true;
        };
        vim_mode = true;
      };
    };

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    #".config/ghostty/config".source = ../dotfiles/ghostty_config;
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };
}
