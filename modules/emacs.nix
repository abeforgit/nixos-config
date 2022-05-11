{ pkgs, config, lib, nix-doom-emacs, ... }:
with lib;
let cfg = config.custom.emacs;
in {
  options.custom.emacs = {
    enable = mkOption {
      example = true;
      default = false;
    };
  };
  config = mkIf cfg.enable {
    home-manager.users.${config.custom.user} = { pkgs, ... }: {
      home.sessionPath = [ "$HOME/.emacs.d/bin" ];
      home.packages = with pkgs; [
        hasklig
        nixfmt
        ripgrep
        git
        coreutils
        wakatime
        fd
        clang
        xclip
        shellcheck
        html-tidy
        nodePackages.bash-language-server
        nodePackages.js-beautify
        nodePackages.stylelint
        graphviz
        sbcl
        editorconfig-core-c
        maim
        pandoc
      ];
      programs.emacs = {

        enable = true;
        package = pkgs.emacsNativeComp;

      };
      services.emacs = {
        enable = true;
        package = pkgs.emacsNativeComp;

      };
    };
  };
}
