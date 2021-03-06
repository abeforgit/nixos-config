{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.custom.emacs;
  emacsPkg = with pkgs;
    ((emacsPackagesFor emacsNativeComp).emacsWithPackages
      (epkgs: [ epkgs.vterm ]));
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
        nodePackages.typescript-language-server
        graphviz
        sbcl
        editorconfig-core-c
        maim
        pandoc
        nodejs
        python3
        google-chrome
      ];
      programs.emacs = {

        enable = true;
        package = emacsPkg;

      };
      services.emacs = {
        enable = true;
        package = emacsPkg;
        socketActivation.enable = true;
        client = { enable = true;
                   arguments = ["-c"];
                 };
      };
    };
  };
}
