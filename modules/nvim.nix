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
    cd-project = pkgs.vimUtils.buildVimPlugin {
      pname = "cd-project.nvim";
      version = "0.8.0";
      src = pkgs.fetchFromGitHub {
        owner = "LintaoAmons";
        repo = "cd-project.nvim";
        rev = "d18efcb42a39bcbc12d4dd5544da0524696d3379";
        hash = "sha256-/YHOb0QeNkjHuJKVzPCWOExKlh84zJqsUTbWlyr1zOc=";
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
        MYVIMRC = ".config/nvim/init.lua";
      };
      home.file.".config/nvim/lua" = {
        source = homeArgs.config.lib.file.mkOutOfStoreSymlink
        "/home/arne/repos/nixos-config/nvim";
        recursive = true;
      };
      programs.neovim = {
        enable = true;
        plugins = with pkgs.vimPlugins; [ 
          lazy-nvim


        ];
        extraPackages = with pkgs; [
          nodePackages.vscode-langservers-extracted
          fd
          ripgrep
	  stylua
        ];
        extraConfig = ''
          lua require('config')
                  '';
        extraLuaConfig = 
        let 
          plugins = with pkgs.vimPlugins; [

            vim-nix 
            nerdcommenter 
            firenvim 
            nvim-treesitter.withAllGrammars 
            nvim-lspconfig 
            nvim-cmp 
            cmp-nvim-lsp 
            cmp-nvim-lua 
            conform-nvim
            bamboo-nvim
            telescope-nvim
            telescope-fzf-native-nvim
            plenary-nvim
            cd-project
            neo-tree-nvim
            nvim-web-devicons
            nui-nvim
            nvim-window-picker
          ]; 
          mkEntryFromDrv = drv: 
          if lib.isDerivation drv then 
          { name = "${lib.getName drv}"; path = drv; } 
          else drv;
        lazyPath = pkgs.linkFarm "lazy-plugins" (builtins.map mkEntryFromDrv plugins);
        in
        ''
          require("lazy").setup({
            dev = {
              path = "${lazyPath}",
              patterns = { "." },
              fallback = true,
              },
            spec = {
	      { "nvim-telescope/telescope-fzf-native.nvim", enabled = true },
	       { "williamboman/mason-lspconfig.nvim", enabled = false },
	      { "williamboman/mason.nvim", enabled = false },
              { import = "config.plugins" },
            }
          });
        '';

      };
    };
  };

}
