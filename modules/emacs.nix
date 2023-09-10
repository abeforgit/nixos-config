{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.custom.emacs;
  emacsPkg = with pkgs;
    ((emacsPackagesFor emacs29).emacsWithPackages (epkgs: [
      epkgs.treesit-grammars.with-all-grammars
      # epkgs.all-the-icons
      # epkgs.treemacs-all-the-icons
      # epkgs.all-the-icons-completion
      # epkgs.octicons
      # epkgs.fontawesome
      # epkgs.mode-icons
      # # epkgs.major-mode-icons
      # epkgs.spaceline-all-the-icons
      # epkgs.all-the-icons-ibuffer
      # epkgs.all-the-icons-dired
      # epkgs.nerd-icons
      # epkgs.nerd-icons-completion
      # epkgs.nerd-icons-dired
      # epkgs.nerd-icons-ibuffer
      # epkgs.treemacs-nerd-icons
      #      epkgs.all-the-icons-ivy
      #      epkgs.all-the-icons-ivy-rich
      #      epkgs.all-the-icons-gnus
      epkgs.shfmt

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
        nodePackages.yaml-language-server
        elixir-ls
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
        material-design-icons
        material-icons
        font-awesome
        nerdfonts
        weather-icons
        shfmt
        wkhtmltopdf-bin
        texlive.combined.scheme-full
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
