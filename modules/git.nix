{ config, lib, pkgs, ... }:
with lib;
let cfg = config.custom.git;
in

{
  imports = [ ./nvim.nix ];
  options =  {
    enable = mkOption {
      example = true;
      default = false;
    };
  };
  config = mkIf cfg.enable {
    home-manager.users.${config.custom.user} = { pkgs, home, ... }: {
      custom.nvim.enable = true;
      programs.git = {
        enable = true;
        userName = "abeforgit";
        userEmail = "arnebertrand@gmail.com";
        delta.enable = true;
        lfs.enable = true;
      };
    };

  };

}
