{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.custom.emacs;
in {
  options.custom.emacs = {
    enable = mkOption {
      example = true;
      default = false;
    };
    package = mkOption {
      example = pkgs.emacs29-pgtk;
      default = pkgs.emacs29-pgtk;
    };
  };
  config = mkIf cfg.enable {
    home-manager.users.${config.custom.user} = { pkgs, ... }: {
      home.sessionPath = [ "$HOME/.emacs.d/bin" ];
      home.packages = with pkgs; [
        hasklig
        nixfmt-rfc-style
        ripgrep
        git
        coreutils
        wakatime
        fd
        clang
        xclip
        xdotool
        xorg.xprop
        xorg.xwininfo
        shellcheck
        html-tidy
        nodePackages.bash-language-server
        nodePackages.js-beautify
        nodePackages.stylelint
        nodePackages.typescript-language-server
        nodePackages.yaml-language-server
        elixir-ls
        graphviz
        sbcl
        editorconfig-core-c
        maim
        pandoc
        nodejs
        python3
        google-chrome
        sumneko-lua-language-server
        emacs-all-the-icons-fonts
        material-design-icons
        material-icons
        font-awesome
        nerdfonts
        weather-icons
        shfmt
        wkhtmltopdf-bin
        dockfmt
        dockerfile-language-server-nodejs
        eslint_d
        # texlive.combined.scheme-full
      ];
      home.file.lua-ls = {
        source = "${pkgs.sumneko-lua-language-server}";
        target = ".emacs.d/.local/etc/lsp/lua-language-server";
      };
      programs.emacs = {
        enable = true;
        package = cfg.package;
        extraPackages = (epkgs: [

          epkgs.shfmt
          epkgs.treesit-grammars.with-all-grammars

          epkgs.vterm
          epkgs.magit

        ]);
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
