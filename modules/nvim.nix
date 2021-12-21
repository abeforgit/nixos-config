{ config, lib, pkgs, ... }:

with lib;
let cfg = config.custom.nvim;
    firenvim = pkgs.vimUtils.buildVimPlugin {
      name = "firenvim";
      src = pkgs.fetchFromGitHub {
        owner = "glacambre";
        repo = "firenvim";
        rev = "7320a805f51b4cf03de4e3b30088838d3f84adda";
        hash = "sha256-BtnCgnrpwo+ziOyufyv1kmnwdzA4La5d3Cu5BLZU0k8=";
      };

    };
in {
  options = {
    custom.nvim.enable = mkOption {

      example = true;
      default = false;
    };
  };
  config = mkIf cfg.enable {
    home-manager.users.${config.custom.user} = { pkgs, home, ... }: {

      home.sessionVariables = {
        EDITOR = "nvim";
      };
      programs.neovim = {
        enable = true;
        plugins = with pkgs.vimPlugins; [ vim-nix nerdcommenter firenvim ];
        extraConfig = ''
          set number
          set textwidth=80
          set showmatch
          set visualbell

          set smartcase
          set incsearch
          set hlsearch

          set autoindent
          set shiftwidth=4
          set smartindent
          set smarttab
          set softtabstop=4
          set ruler
          set undolevels=1000
          set backspace=indent,eol,start
          set clipboard+=unnamedplus
          filetype plugin on
          let mapleader = " "
          let g:firenvim_config = {
              \ 'globalSettings': {
                  \ 'alt': 'all',
              \  },
              \ 'localSettings': {
                  \ '.*': {
                      \ 'cmdline': 'neovim',
                      \ 'priority': 0,
                      \ 'selector': 'textarea',
                      \ 'takeover': 'always',
                  \ },
              \ }
          \ }
          let fc = g:firenvim_config['localSettings']
          let fc['.*'] = { 'takeover': 'never' }



                  '';
      };
    };
  };

}
