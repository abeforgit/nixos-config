{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.custom.emacs;
  emacsPkg = with pkgs;
    ((emacsPackagesFor emacs).emacsWithPackages (epkgs: [
      (epkgs.treesit-grammars.with-grammars
        (grammars: [ grammars.tree-sitter-bash ]))
      epkgs.all-the-icons
      epkgs.treemacs-all-the-icons
      epkgs.spaceline-all-the-icons
      epkgs.all-the-icons-ibuffer
      epkgs.all-the-icons-ivy
      epkgs.all-the-icons-ivy-rich
      epkgs.all-the-icons-gnus
      epkgs.all-the-icons-dired
      epkgs.all-the-icons-completion

      epkgs.vterm
      epkgs.magit
    ]));
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
        xdotool
        xorg.xprop
        xorg.xwininfo
        shellcheck
        html-tidy
        nodePackages.bash-language-server
        nodePackages.js-beautify
        nodePackages.stylelint
        nodePackages.typescript-language-server
        graphviz
        sbcl
        lispPackages.quicklisp
        editorconfig-core-c
        maim
        pandoc
        nodejs
        python3
        google-chrome
        sumneko-lua-language-server
        emacs-all-the-icons-fonts
      ];
      home.file.lua-ls = {
        source = "${pkgs.sumneko-lua-language-server}";
        target = ".emacs.d/.local/etc/lsp/lua-language-server";
      };
      programs.emacs = {
        enable = true;
        package = emacsPkg;
      };
      services.emacs = {
        enable = true;
        package = emacsPkg;
        socketActivation.enable = true;
        client = {
          enable = true;
          arguments = [ "-c" ];
        };
      };
    };
  };
}
