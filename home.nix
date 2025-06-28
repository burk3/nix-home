{ pkgs, ... }:
{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  # NOTE: this should be populated by the regular home-manager config I think.
  #home.username = "burke";
  #home.homeDirectory = "/home/burke";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  # NOTE from burk3: I'm setting this in the normal home-manager config since this is going to be imported.
  #                  It is probably worth keeping track of here tho.
  # home.stateVersion = "24.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    dig
    nil
    neofetch
    eternal-terminal
    nixd
    nh
  ];

  catppuccin.flavor = "frappe";
  catppuccin.accent = "teal";
  catppuccin.enable = true;

  programs.btop.enable = true;
  programs.bottom.enable = true;
  programs.bat.enable = true;

  programs.git = {
    enable = true;
    delta.enable = true;
    ignores = [
      ".envrc"
      ".direnv"
      ".venv"
    ];
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
    plugins = with pkgs.vimPlugins; [
      vim-nix
      gundo-vim
      nerdtree
      vim-surround
      {
        plugin = lightline-vim;
        config = "let g:lightline = {'colorscheme': 'catppuccin'}";
      }
      #{
      #  plugin = vim-airline;
      #  config = "let g:airline_theme = 'catppuccin'";
      #}
      vim-markdown
      {
        plugin = nvim-lspconfig;
        config = ''
          lua require'lspconfig'.nil_ls.setup{}
        '';
      }
      #{
      #  plugin = vim-airline-themes;
      #  config = "let g:airline_theme='nord_minimal'";
      #}
      #{
      #  plugin = nord-nvim;
      #  config = "colorscheme nord";
      #}
      nvim-treesitter.withAllGrammars
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

}
