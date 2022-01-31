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
      imports = [ nix-doom-emacs.hmModule ];
      home.packages = with pkgs; [
        hasklig
        nixfmt
        ripgrep
        sqlite
        git
        nodePackages.bash-language-server
        wakatime
      ];
      programs.doom-emacs = {
        enable = true;
        doomPrivateDir = ./.doom.d;
      };
    };
  };
}
