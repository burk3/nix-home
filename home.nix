{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "burke";
  home.homeDirectory = "/home/burke";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    dig
    nil
  ];

  programs.git = {
    enable = true;
    userName = "Burke Cates";
    userEmail = "burke.cates@gmail.com";
    extraConfig.init.defaultBranch = "master";
    aliases.co = "checkout";
    aliases.st = "status";
    aliases.lg = "log --graph --decorate --oneline";
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    vimdiffAlias = true;
    plugins = [
      pkgs.vimPlugins.vim-nix
      pkgs.vimPlugins.gundo-vim
      pkgs.vimPlugins.vim-surround
      pkgs.vimPlugins.vim-airline
      pkgs.vimPlugins.vim-markdown
      {
        plugin = pkgs.vimPlugins.nvim-lspconfig;
        config = ''
          lua require'lspconfig'.nil_ls.setup{}
        '';
      }
      {
        plugin = pkgs.vimPlugins.vim-airline-themes;
        config = "let g:airline_theme='nord_minimal'";
      }
      {
        plugin = pkgs.vimPlugins.nord-nvim;
        config = "colorscheme nord";
      }
      pkgs.vimPlugins.nvim-treesitter.withAllGrammars
    ];
    extraConfig = ''
      " sane backspaces
      set backspace=2
      " sane tabs/indentation
      set ts=2
      set sw=2
      set expandtab
      set smartindent
      set autoindent
      " show all that whitespace by default
      set listchars=trail:·,precedes:«,extends:»,eol:↲,tab:⇥\ 
      " set list
      " i mostly use marker folds
      set foldmethod=marker
    '';
  };

  home.sessionPath = [
    "$HOME/.local/bin"
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
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

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
