{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.custom.emacs;
in
{
  options.custom.emacs = {
    enable = mkOption {
      example = true;
      default = false;
    };
    package = mkOption {
      example = pkgs.emacs30-pgtk;
      default = pkgs.emacs30-pgtk;
    };
  };
  config = mkIf cfg.enable {
    home-manager.users.${config.custom.user} =
      { pkgs, ... }:
      {
        home.sessionPath = [ "$HOME/.emacs.d/bin" ];
        home.packages = with pkgs; [
          hasklig
          nixfmt
          ripgrep
          git
          coreutils
          fd
          clang
          xclip
          xdotool
          xprop
          xwininfo
          shellcheck
          html-tidy
          nodePackages.bash-language-server
          nodePackages.js-beautify
          nodePackages.stylelint
          nodePackages.typescript-language-server
          nodePackages.yaml-language-server
          graphviz
          sbcl
          editorconfig-core-c
          pandoc
          nodejs
          python3
          google-chrome
          lua-language-server
          emacs-all-the-icons-fonts
          material-design-icons
          material-icons
          weather-icons
          shfmt
          wkhtmltopdf
          dockfmt
          dockerfile-language-server
          eslint_d
          # texlive.combined.scheme-full
        ];
        home.file.lua-ls = {
          source = "${pkgs.lua-language-server}";
          target = ".emacs.d/.local/etc/lsp/lua-language-server";
        };
        programs.emacs = {
          enable = true;
          package = cfg.package;
          extraPackages = (
            epkgs: [

              epkgs.shfmt

              epkgs.vterm
              epkgs.magit

            ]
          );
        };
        services.emacs = {
          enable = true;
          package = cfg.package;
          socketActivation.enable = true;
          client = {
            enable = true;
            arguments = [ "-c" ];
          };
        };
      };
  };
}
