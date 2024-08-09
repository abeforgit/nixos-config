{ config, lib, pkgs, ... }:

with lib;
let cfg = config.custom.nvim;
    firenvim = pkgs.vimUtils.buildVimPlugin {
      pname = "firenvim";
      version = "0.2.13";
      src = pkgs.fetchFromGitHub {
        owner = "glacambre";
        repo = "firenvim";
        rev = "f679455c294c62eddee86959cfc9f1b1f79fe97d";
        hash = "sha256-86Gr+95yunuNZGn/+XLPg1ws6z4C2VOMKt81a6+sxnI=";
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
    home-manager.users.${config.custom.user} = homeArgs @ { pkgs, home,... }: {

      home.sessionVariables = {
        EDITOR = "nvim";
      };
      home.file.".config/nvim/lua" = {
        source = homeArgs.config.lib.file.mkOutOfStoreSymlink
        "/home/arne/repos/nixos-config/nvim";
        recursive = true;
      };
      programs.neovim = {
        enable = true;
        plugins = with pkgs.vimPlugins; [ vim-nix nerdcommenter firenvim
        nvim-treesitter.withAllGrammars nvim-lspconfig nvim-cmp cmp-nvim-lsp ];
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
          lua require('config')



                  '';
      };
    };
  };

}
