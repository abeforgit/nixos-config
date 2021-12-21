{ config, lib, pkgs, ... }:
with lib;
let cfg = config.custom.wacom;
in
{
  options.custom.wacom = {
    enable = mkOption {
      example = true;
      default = false;
    };

  };
  config = mkIf cfg.enable {
    home-manager.users.${config.custom.user} = { pkgs, ... }: {
      home.packages = with pkgs; [
        wacomtablet
        xf86_input_wacom
      ];
    };

  };

}
