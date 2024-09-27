{
  config,
  lib,
  pkgs,
  ...
}:

with lib;
let
  cfg = config.custom.nvim;
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
  workspaces = pkgs.vimUtils.buildVimPlugin {
    pname = "workspaces.nvim";
    version = "1.0.0";
    src = pkgs.fetchFromGitHub {
      owner = "natecraddock";
      repo = "workspaces.nvim";
      rev = "447306604259619618cd84c15b68f2ffdbc702ae";
      hash = "sha256-YIu6Wtzb79itoilv6g/AJyqORJz14UYwTPq9kW0D8ck=";
    };
  };
  treesitterWithGrammars = (
    pkgs.vimPlugins.nvim-treesitter.withPlugins (p: [
      p.bash
      p.comment
      p.css
      p.dockerfile
      p.fish
      p.gitattributes
      p.gitignore
      p.go
      p.gomod
      p.gowork
      p.hcl
      p.javascript
      p.jq
      p.json5
      p.json
      p.lua
      p.make
      p.markdown
      p.nix
      p.python
      p.rust
      p.toml
      p.typescript
      p.glimmer
      p.glimmer-javascript
      p.glimmer-typescript
      p.query
      p.vimdoc
      p.vue
      p.yaml
    ])
  );
  treesitter-parsers = pkgs.symlinkJoin {
    name = "treesitter-parsers";
    paths = treesitterWithGrammars.dependencies;
  };
in
{
  options = {
    custom.nvim.enable = mkOption {

      example = true;
      default = false;
    };
  };
  config = mkIf cfg.enable {
    home-manager.users.${config.custom.user} =
      homeArgs@{ pkgs, home, ... }:
      {

        home.sessionVariables = {
          EDITOR = "nvim";
          MYVIMRC = ".config/nvim/init.lua";
        };
        home.file.".config/nvim/lua" = {
          source = homeArgs.config.lib.file.mkOutOfStoreSymlink "/home/arne/repos/nixos-config/nvim";
          recursive = true;
        };
        home.file."./.local/share/nvim/nix/nvim-treesitter/" = {
          recursive = true;
          source = treesitterWithGrammars;
        };
        programs.neovim = {
          enable = true;
          plugins = [
            treesitterWithGrammars
            {
              plugin = pkgs.vimPlugins.sqlite-lua;
              config = "let g:sqlite_clib_path = '${pkgs.sqlite.out}/lib/libsqlite3.so'";
            }
          ];
          coc.enable = false;
          withNodeJs = true;
          extraPackages = with pkgs; [
            nodePackages.vscode-langservers-extracted
            typescript-language-server
            fd
            ripgrep
            nil
            nixfmt-rfc-style
            gh
            yaml-language-server
            glow
          ];
          extraConfig = ''
            lua require('config')
          '';
          extraLuaConfig = ''
            vim.opt.runtimepath:append("${treesitter-parsers}")
          '';

        };
      };
  };

}
