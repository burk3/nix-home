{ pkgs, ghostty, config, ... }:
{
  nixpkgs.config.allowUnfree = true;
  home.packages = with pkgs; [
    vscode.fhs
    bitwarden-desktop
    yacreader
    legcord
    mpv
    spotify
    playerctl
    iosevka
    pinta
    inkscape
    remmina
    brogue-ce
  ];

  programs.ghostty = {
    enable = true;
    package = ghostty.packages.x86_64-linux.default;
    shellIntegration.enable = true;
    settings = {
      window-decoration = false;
      cursor-style = "block";
      font-family = [
        "Berkeley Mono"
        "Iosevka"
      ];
      font-size = 10;
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
