{ config, lib, pkgs, ... }:

with lib;
let cfg = config.custom.vscode;
in {
  options = {
    custom.vscode.enable = mkOption {
      example = true;
      default = false;
    };

  };
  config = mkIf cfg.enable {
    home-manager.users.${config.custom.user} = { pkgs, home, ... }: {
      programs.vscode = {
        enable = true;
#      extensions = with pkgs.vscode-extensions; [
#        vscodevim.vim
#      ];
      };
    };

  };

}
